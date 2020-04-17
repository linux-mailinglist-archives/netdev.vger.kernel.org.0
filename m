Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4EA1ADEEB
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 16:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgDQOB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 10:01:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:17012 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730563AbgDQOB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 10:01:26 -0400
IronPort-SDR: 9G5Y4n+m+tA+3V/ar4rIO5XZI6Yb6RI7j8XrjHT+4sPh9x9DXqb28r4DM5LGQvpv8KH5D2q2dd
 BZ/bAv7CJvHw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 07:01:25 -0700
IronPort-SDR: xEz2/0SJGhLBRYrVu2I7Ws34KqqK5pqUSvSLjjTEr/7tqRLaMzE2OaYX4cGlmmJzKLKuMfyUU7
 r5HAKpcCqDyA==
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="428234168"
Received: from mcintra-mobl.ger.corp.intel.com (HELO localhost) ([10.249.44.191])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 07:01:20 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, leon@kernel.org,
        kieran.bingham+renesas@ideasonboard.com, jonas@kwiboo.se,
        airlied@linux.ie, jernej.skrabec@siol.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <20200417122827.GD5100@ziepe.ca>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20200417011146.83973-1-saeedm@mellanox.com> <87v9ly3a0w.fsf@intel.com> <20200417122827.GD5100@ziepe.ca>
Date:   Fri, 17 Apr 2020 17:01:18 +0300
Message-ID: <87h7xi2oup.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Apr 2020, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Fri, Apr 17, 2020 at 09:23:59AM +0300, Jani Nikula wrote:
>
>> Which means that would have to split up to two. Not ideal, but
>> doable.
>
> Why is this not ideal?
>
> I think the one per line is easier to maintain (eg for merge
> conflicts) and easier to read than a giant && expression.
>
> I would not complicate things further by extending the boolean
> language..

Fair enough. I only found one instance where the patch at hand does not
cut it:

drivers/hwmon/Kconfig:  depends on !OF || IIO=n || IIO

That can of course be left as it is.

As to the bikeshedding topic, I think I'm now leaning towards Andrzej's
suggestion:

	optionally depends on FOO

in [1]. But I reserve my right to change my mind. ;)

BR,
Jani.


[1] http://lore.kernel.org/r/01f964ae-9c32-7531-1f07-2687616b6a71@samsung.com

-- 
Jani Nikula, Intel Open Source Graphics Center

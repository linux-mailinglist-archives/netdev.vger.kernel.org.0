Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313C166A84
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 11:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfGLJ5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 05:57:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:23447 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbfGLJ5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 05:57:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 02:57:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,482,1557212400"; 
   d="scan'208";a="189792493"
Received: from epronina-mobl.ccr.corp.intel.com ([10.252.5.80])
  by fmsmga004.fm.intel.com with ESMTP; 12 Jul 2019 02:57:11 -0700
Message-ID: <ea73cd31cc634a1aec9fce8c5629c609f30d7d26.camel@intel.com>
Subject: Re: iwl_mvm_add_new_dqa_stream_wk BUG in lib/list_debug.c:56
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Marc Haber <mh+netdev@zugschlus.de>, Yussuf Khalil <dev@pp3345.net>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date:   Fri, 12 Jul 2019 12:57:10 +0300
In-Reply-To: <20190607204421.GK31088@torres.zugschlus.de>
References: <20190530081257.GA26133@torres.zugschlus.de>
         <20190602134842.GC3249@torres.zugschlus.de>
         <29401822-d7e9-430b-d284-706bf68acb8a@pp3345.net>
         <20190607204421.GK31088@torres.zugschlus.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-06-07 at 22:44 +0200, Marc Haber wrote:
> On Fri, Jun 07, 2019 at 10:20:56PM +0200, Yussuf Khalil wrote:
> > CC'ing iwlwifi maintainers to get some attention for this issue.
> > 
> > I am experiencing the very same bug on a ThinkPad T480s running 5.1.6 with
> > Fedora 30. A friend is seeing it on his X1 Carbon 6th Gen, too. Both have an
> > "Intel Corporation Wireless 8265 / 8275" card according to lspci.
> 
> I have an older 04:00.0 Network controller [0280]: Intel Corporation
> Wireless 8260 [8086:24f3] (rev 3a) on a Thinkpad X260.
> 
> > Notably, in all cases I've observed it occurred right after roaming from one
> > AP to another (though I can't guarantee this isn't a coincidence).
> 
> I also have multiple Access Points broadcasting the same SSID in my
> house, and yes, I experience those issues often when I move from one
> part of the hose to another. I have, however, also experienced it in a
> hotel when I was using the mobile hotspot offered by my mobile, so that
> was clearly not a roaming situation.

Hi,

Sorry this got under the radar for a while.  Yesterday someone created
a bugzilla entry with the same error:

https://bugzilla.kernel.org/show_bug.cgi?id=204141

I'm going to file an internal bug report and then have someone look
further into it.

Any additional comments/reproductions/etc. please use that bugzilla
entry.

Thanks for reporting!

--
Cheers,
Luca.


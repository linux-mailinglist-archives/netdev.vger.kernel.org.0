Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C852735EA
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgIUWmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:42:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:33667 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgIUWmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:42:24 -0400
IronPort-SDR: MUH/9fzlvGak3ug3ss2bLbX5cFdyk8TKZoMOZm9Qj03jJc4vn4W2cGDuzcDEKpXAfmBKxoaUFB
 oOQEQs5VAehw==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148245709"
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="148245709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 15:42:24 -0700
IronPort-SDR: 0u3Mncp7wT5rIngf9ZML5Yv3DiY+zKxN2HMOqg4hc+WHahvPBctwljw/WYfHzx1qdNCDbPbxgy
 0aL+1tDIrMgg==
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="485691204"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.52]) ([134.134.177.52])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 15:42:23 -0700
Subject: Re: [net-next v8 0/5] devlink flash update overwrite mask
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>,
        Shannon Nelson <snelson@pensando.io>
References: <20200921223128.1204467-1-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <9f363bc5-ae2d-619c-03fc-abf6c21b4614@intel.com>
Date:   Mon, 21 Sep 2020 15:42:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200921223128.1204467-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/2020 3:31 PM, Jacob Keller wrote:
> (This is essentially a resend of v7 because some of the patches didn't hit
> the netdev list last Friday due to an SMTP server issue here)
> 

Heh. Apparently it's not fixed yet. I am sorry for those on the CC list
for this spam.

Thanks,
Jake

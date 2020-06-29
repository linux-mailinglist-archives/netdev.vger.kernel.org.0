Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DEE20D607
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731891AbgF2TQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:16:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:63720 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731807AbgF2TQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:16:52 -0400
IronPort-SDR: /awpK8vauA1UY5MpEZ/YTnuYaQaZ4sDgei+W1TMRpYQL7dQwcjJ2isBadoMAnfC5R01SflKf/7
 LdcjrdMZm54Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="163998934"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="163998934"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 08:10:46 -0700
IronPort-SDR: mw6GdldLIMHUg1p42ZqiigUai0KEvZPO4JmOhxUKKwkLU1eWIPjoi4leEGe+trp6TiAwM03dva
 0x/VdwNad0nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="313073307"
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.252.54.90])
  by fmsmga002.fm.intel.com with ESMTP; 29 Jun 2020 08:10:43 -0700
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Christoph Hellwig <hch@lst.de>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        konrad.wilk@oracle.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        maximmi@mellanox.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
 <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
 <20200627070406.GB11854@lst.de>
 <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
 <e879bcc8-5f7d-b1b3-9b66-1032dec6245d@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <81aec200-c1a0-6d57-e3b6-26dad30790b8@intel.com>
Date:   Mon, 29 Jun 2020 17:10:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e879bcc8-5f7d-b1b3-9b66-1032dec6245d@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-29 15:52, Daniel Borkmann wrote:
> 
> Ok, fair enough, please work with DMA folks to get this properly 
> integrated and
> restored then. Applied, thanks!

Daniel, you were too quick! Please revert this one; Christoph just 
submitted a 4-patch-series that addresses both the DMA API, and the perf 
regression!


Björn

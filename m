Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241B84617CF
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243464AbhK2OUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:20:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:3893 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243532AbhK2OSP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 09:18:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="299367832"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="299367832"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 06:10:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="459160226"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 29 Nov 2021 06:10:56 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ATEAsZo026826;
        Mon, 29 Nov 2021 14:10:55 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH net-next 0/2] igc: driver change to support XDP metadata
Date:   Mon, 29 Nov 2021 15:10:47 +0100
Message-Id: <20211129141047.8939-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <163700856423.565980.10162564921347693758.stgit@firesoul>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 15 Nov 2021 21:36:20 +0100

> Changes to fix and enable XDP metadata to a specific Intel driver igc.
> Tested with hardware i225 that uses driver igc, while testing AF_XDP
> access to metadata area.

Would you mind if I take this your series into my bigger one that
takes care of it throughout all the Intel drivers?

> ---
> 
> Jesper Dangaard Brouer (2):
>       igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
>       igc: enable XDP metadata in driver
> 
> 
>  drivers/net/ethernet/intel/igc/igc_main.c |   33 +++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> --

Thanks,
Al

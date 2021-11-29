Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F36B461A6C
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhK2O6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:58:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:1321 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238818AbhK2O4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 09:56:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="235913998"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="235913998"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 06:41:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="594695339"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Nov 2021 06:41:56 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ATEfsWP002801;
        Mon, 29 Nov 2021 14:41:54 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>, brouer@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 0/2] igc: driver change to support XDP metadata
Date:   Mon, 29 Nov 2021 15:41:47 +0100
Message-Id: <20211129144147.10242-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <de14fefc-a8c1-ff6c-5354-8cce4a3f66f9@redhat.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul> <20211129141047.8939-1-alexandr.lobakin@intel.com> <de14fefc-a8c1-ff6c-5354-8cce4a3f66f9@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Mon, 29 Nov 2021 15:29:07 +0100

> On 29/11/2021 15.10, Alexander Lobakin wrote:
> > From: Jesper Dangaard Brouer <brouer@redhat.com>
> > Date: Mon, 15 Nov 2021 21:36:20 +0100
> > 
> >> Changes to fix and enable XDP metadata to a specific Intel driver igc.
> >> Tested with hardware i225 that uses driver igc, while testing AF_XDP
> >> access to metadata area.
> > 
> > Would you mind if I take this your series into my bigger one that
> > takes care of it throughout all the Intel drivers?
> 
> I have a customer that depend on this fix.  They will have to do the 
> backport anyway (to v5.13), but it would bring confidence on their side 
> if the commits appear in an official git-tree before doing the backport 
> (and optimally with a SHA they can refer to).

Yeah, sure, it's totally fine to get them accepted separately, I'll
just refer to them in my series.

> Tony Nguyen have these landed in your git-tree?

Doesn't seem like. The reason might be that you responded to my
patch 2/2 comments only now.

> --JEsper

Al

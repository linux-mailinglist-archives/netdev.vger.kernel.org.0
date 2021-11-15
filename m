Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8D45046F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 13:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhKOMap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 07:30:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:7390 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhKOMao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 07:30:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233370670"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233370670"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:27:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="671489596"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 04:27:46 -0800
Received: from alobakin-mobl.ger.corp.intel.com (npiatkow-mobl2.ger.corp.intel.com [10.213.19.48])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AFCRiet013596;
        Mon, 15 Nov 2021 12:27:44 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] skbuff: Add helper function for head_frag and pfmemalloc
Date:   Mon, 15 Nov 2021 13:27:43 +0100
Message-Id: <20211115122743.2659-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115085708.13901-1-yajun.deng@linux.dev>
References: <20211115085708.13901-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>
Date: Mon, 15 Nov 2021 16:57:08 +0800

> This series of build_skb() has the same code, add skb_set_head_frag_pfmemalloc()
> for it, at the same time, in-line skb_propagate_pfmemalloc().
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/linux/skbuff.h | 19 ++++++++++++-------
>  net/core/skbuff.c      | 19 +++++--------------
>  2 files changed, 17 insertions(+), 21 deletions(-)

build_skb(), build_skb_around() and napi_build_skb() are 3-liners,
and all of their code is here in linux/skbuff.h. Would it make
sense to make them static inlines, and export their "__"
counterparts instead?

Thanks,
Al

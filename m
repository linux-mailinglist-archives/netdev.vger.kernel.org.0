Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0983649D07E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 18:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243603AbiAZROf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 12:14:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:37341 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243625AbiAZROd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 12:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643217273; x=1674753273;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=llaQFUUuZ8EtpCdtP8Jc9ig6Oa7wwb9bbrBClnyPQ2g=;
  b=kLHM25acvWOEdi7Xi8Anp74AXBS06oOUulUAXEex3rVh50t/2akFohZI
   r48hFfzHKDJJyYaWzF2M+0Hx8AzFtvP41mwp6GLTzHJwHsTvMhUjmUOkk
   Hf6noLB1gL1uQrweQVg70AtJUJcp5lns+KH5ePdTeV4GHHsfsL1KSeUTH
   gnp1ybyRXpJ/FJ1oD1C7AD2/tas+wl10GbaXkMrEFihRAZd2yYHU5PytK
   /UIynC32U+pafVBoEvXr2Ly7BIB6m1EQgMF5U2Gx0Ek/qGAG+5nxZesGj
   xY8v57d2e5gQySko9Uqr0ziriGV86MYoyvLD+El+iThAfVtMG3gXTNbEV
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="226576116"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="226576116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 09:14:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="581167637"
Received: from dglazex-mobl3.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.16.112])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 09:14:10 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Corinna Vinschen <vinschen@redhat.com>, intel-wired-lan@osuosl.org,
        netdev@vger.kernel.org
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 2/2 net-next v6] igb: refactor XDP registration
In-Reply-To: <20220119145259.1790015-3-vinschen@redhat.com>
References: <20220119145259.1790015-1-vinschen@redhat.com>
 <20220119145259.1790015-3-vinschen@redhat.com>
Date:   Wed, 26 Jan 2022 09:14:09 -0800
Message-ID: <87v8y6mnby.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corinna Vinschen <vinschen@redhat.com> writes:

> On changing the RX ring parameters igb uses a hack to avoid a warning
> when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
> clears the struct xdp_rxq_info content.
>
> Instead, change this to unregister if we're already registered.  Align
> code to the igc code.
>
> Fixes: 9cbc948b5a20c ("igb: add XDP support")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

-- 
Vinicius

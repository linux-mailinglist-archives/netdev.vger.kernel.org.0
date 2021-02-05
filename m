Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C767F3119B3
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhBFDQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:16:18 -0500
Received: from mga17.intel.com ([192.55.52.151]:24857 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhBFC5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 21:57:39 -0500
IronPort-SDR: U/+N79u++vnZ8VUhF0+Q6RnItyO6gEkpnFnHS5V6YXHQ9qv3Yr5ku6e3Ps5zaJLJhbdL3zygxm
 Mqj9paEwndng==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="161251109"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="161251109"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 14:39:15 -0800
IronPort-SDR: KFM8S8tiDOmPq7MD68erqsL7cRkFyJbtugSKuT6jXOfB2SS0Ua3XNKA6uUnESEWmyhRTtrCDFC
 AGacYmQyPwAA==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="373541870"
Received: from iayoung-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.100.97])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 14:39:14 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: set TxQ mode back to DCB after
 disabling CBS
In-Reply-To: <1612447396-20351-1-git-send-email-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
References: <1612447396-20351-1-git-send-email-yoong.siang.song@intel.com>
Date:   Fri, 05 Feb 2021 14:38:57 -0800
Message-ID: <8735yap2bi.fsf@vcostago-mobl2.amr.corp.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Yoong Siang <yoong.siang.song@intel.com> writes:

> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
>
> When disable CBS, mode_to_use parameter is not updated even the operation
> mode of Tx Queue is changed to Data Centre Bridging (DCB). Therefore,
> when tc_setup_cbs() function is called to re-enable CBS, the operation
> mode of Tx Queue remains at DCB, which causing CBS fails to work.
>
> This patch updates the value of mode_to_use parameter to MTL_QUEUE_DCB
> after operation mode of Tx Queue is changed to DCB in stmmac_dma_qmode()
> callback function.
>
> Fixes: 1f705bc61aee ("net: stmmac: Add support for CBS QDISC")
> Suggested-by: Gomes, Vinicius <vinicius.gomes@intel.com>

Just a nitpick/formality, I would prefer if you used:

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> Signed-off-by: Song, Yoong Siang <yoong.siang.song@intel.com>

Patch looks good.

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Cheers,
-- 
Vinicius

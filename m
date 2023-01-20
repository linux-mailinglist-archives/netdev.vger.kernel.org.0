Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E127674A91
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjATE2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjATE2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:28:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBF1B1ECC;
        Thu, 19 Jan 2023 20:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07FB5B82812;
        Fri, 20 Jan 2023 03:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F006C433D2;
        Fri, 20 Jan 2023 03:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674186732;
        bh=MC1ENP+CPVPn+1arFstG4AqmfHtgPeKoFZHEIfXNfBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fd6a2F+2dwaIRbyZ2hydGSBCCfBkRYByrCSBY4+EWztnRHHwawx5KTdS9x2PwHL3/
         NRymhnOUZeo95z8cq8S0FnVhQhBr/AOX5rS0GGcDrmcob7gwLmumYWLXwzLcoiyPS1
         7tNQfDLyCtoro9Heom9UiKuU4fLKcKi+7/UtUhGCgGxOuL1P/hn+3nSDutccPvkSnZ
         tcgvgwTvANSMbUjYJfr/v1mXLwJ8CS8oxBaadiXrTU/yH1nLumjzd4fC8HUryzERBQ
         KQ5TfbnuVnrLLwll/BFT7+61sjIp1StTV8o4CG5co/UmYGgFF1it6BJhPIKrghBKf/
         CBqQl39GhMSqQ==
Date:   Thu, 19 Jan 2023 19:52:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yanchao Yang <yanchao.yang@mediatek.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>,
        Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: Re: [PATCH net-next v2 08/12] net: wwan: tmi: Add data plane
 transaction layer
Message-ID: <20230119195210.03537a93@kernel.org>
In-Reply-To: <20230118113859.175836-9-yanchao.yang@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
        <20230118113859.175836-9-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Jan 2023 19:38:55 +0800 Yanchao Yang wrote:
>  drivers/net/wwan/mediatek/mtk_dpmaif.c     | 4005 ++++++++++++++++++++

clang detects out-of-bound memcpy/strcpy or such somewhere in this file.
Please fix that.

Please try to make the series smaller than 17,770 :/
Strip stuff down to minimal working version.
I don't think anyone can review 17kLoC in one sitting :/

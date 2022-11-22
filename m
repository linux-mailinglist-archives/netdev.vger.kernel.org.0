Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87361633EEC
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiKVO3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiKVO3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:29:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81BF682BA;
        Tue, 22 Nov 2022 06:29:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D803B81B7E;
        Tue, 22 Nov 2022 14:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1344EC433B5;
        Tue, 22 Nov 2022 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669127352;
        bh=UBcHS3VCg4uRpxjAZY8+t6NA0BKBZWz6tTw6f0PgiKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aePwc+RuP1PDa5b8dSM0cuWR7QxcUAUMLFOxaq5bGQ+dkUoJiidtxzLNk2/iS+VcA
         ivZtkSuxm6SKRFBC0scNgnRMyYNqQjkso6KPhOls9//r+dWp/DNYsYeZxd2jhcEqwh
         bcBQqamIq3vy57+EavKkfL3pCNaHkmpOrFOu/ilMY5hxXlbI+1r/dzC7fcky63M4g9
         zdBupJehOuDbZYmhcg2QfaMJR5Igr+dLuMPnRiSW/WXygAtc3QVpkDa0AxAgEHFkox
         O926a5BSc+Niq4NeF6BfX1Tw7aj/QN7RizsS+X0Zhoy5GpZU5lo7uFYa5YYY1Brwad
         f8y7lshywVWGA==
Date:   Tue, 22 Nov 2022 16:29:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yanchao Yang <yanchao.yang@mediatek.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>,
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
        Haozhe Chang <haozhe.chang@mediatek.com>,
        MediaTek Corporation <linuxwwan@mediatek.com>
Subject: Re: [PATCH net-next v1 13/13] net: wwan: tmi: Add maintainers and
 documentation
Message-ID: <Y3zctKXWaVuGvGhP@unreal>
References: <20221122112710.161020-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122112710.161020-1-yanchao.yang@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 07:27:10PM +0800, Yanchao Yang wrote:
> From: MediaTek Corporation <linuxwwan@mediatek.com>
> 
> Adds maintainers and documentation for MediaTek TMI 5G WWAN modem
> device driver.
> 
> Signed-off-by: Felix Chen <felix.chen@mediatek.com>
> Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>

Author and SOB should have real names and can't be company.

Thanks

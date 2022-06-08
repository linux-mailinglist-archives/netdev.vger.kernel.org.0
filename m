Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53161543ADA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbiFHRyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiFHRyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:54:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311FB2CDC4;
        Wed,  8 Jun 2022 10:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8682361B5C;
        Wed,  8 Jun 2022 17:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD09C34116;
        Wed,  8 Jun 2022 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654710886;
        bh=joa25S6k9i7tTrj0S2JqhbnuflBDsoS1LuwLIiJsIc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b2g08SPfLwcYx0f83deLHU0Grduadd5VXyRAtOiIGM2WmHGZ1fn2h2PQMy3regGFn
         /pnBfPPXX1+ZDM9uyaAH80MRbpq++7VHOXw63EfelmT1vLA7yk6+7faxdfQ9sLC8r5
         GcqWwLiL0ijyKy9XPTiq/mbnMqPjAOwRxwyGIVzBHHZDJhkA7mcJDXIgNQi3yXxe9P
         aXXxSASkY692065iV8bXfWtkqRzUxwbjEEJQcNT5QP6CaT4xl/8XwFnK/B6h9aPkE9
         fWbEdcU4p+cbHULSVGhGE0mtW70UPZHK+xcdY5+cZobz5g3+QheK2gj3IvsA3Owlwl
         gKcaB3/s8iI8g==
Date:   Wed, 8 Jun 2022 10:54:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Frank Wunderlich <linux@fw-web.de>
Subject: Re: [PATCH v3 0/6] Support mt7531 on BPI-R2 Pro
Message-ID: <20220608105444.62e93f07@kernel.org>
In-Reply-To: <trinity-c7b8fdfa-11b4-4e5c-90d6-6dd96da1e2d2-1654709910860@3c-app-gmx-bap09>
References: <20220507170440.64005-1-linux@fw-web.de>
        <trinity-c7b8fdfa-11b4-4e5c-90d6-6dd96da1e2d2-1654709910860@3c-app-gmx-bap09>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jun 2022 19:38:30 +0200 Frank Wunderlich wrote:
> just a gentle ping, is anything missing/wrong?

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#how-can-i-tell-the-status-of-a-patch-i-ve-sent

In your case:

https://patchwork.kernel.org/project/netdevbpf/list/?series=639420&state=*

I haven't double checked but even if the feedback you received was
waved the patch didn't apply when it was posted, so you gotta repost.

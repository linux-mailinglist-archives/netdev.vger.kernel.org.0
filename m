Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA38F5B42E8
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 01:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiIIXMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 19:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiIIXMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 19:12:33 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580E812E1AD;
        Fri,  9 Sep 2022 16:11:56 -0700 (PDT)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1oWn9K-0000Qa-1p; Sat, 10 Sep 2022 01:11:02 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Johan Jonker <jbx6244@gmail.com>
Cc:     Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rockchip@lists.infradead.org, edumazet@google.com,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Subject: Re: (subset) [PATCH v2 1/3] dt-bindings: net: convert emac_rockchip.txt to YAML
Date:   Sat, 10 Sep 2022 01:10:56 +0200
Message-Id: <166276502653.27767.6801437957827321608.b4-ty@sntech.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220603163539.537-1-jbx6244@gmail.com>
References: <20220603163539.537-1-jbx6244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jun 2022 18:35:37 +0200, Johan Jonker wrote:
> Convert emac_rockchip.txt to YAML.
> 
> Changes against original bindings:
>   Add mdio sub node.
>   Add extra clock for rk3036

Applied, thanks!

[2/3] ARM: dts: rockchip: fix rk3036 emac node compatible string
      commit: d28b680a34948d7634b824b1fc7546e9dc8422fb
[3/3] ARM: dts: rockchip: restyle emac nodes
      commit: 1dabb74971b38d966ecef566bafddc4a34f4db9d

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>

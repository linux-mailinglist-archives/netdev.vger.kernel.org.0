Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14578655A51
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 15:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiLXO3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 09:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLXO3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 09:29:44 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF167DF71
        for <netdev@vger.kernel.org>; Sat, 24 Dec 2022 06:29:41 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id g4so7903416ybg.7
        for <netdev@vger.kernel.org>; Sat, 24 Dec 2022 06:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mbcutGH6OL7LuSP42at3fK5Z1YIFoEUC0KBJRJ/ehLg=;
        b=o/D+RD6UfC13biE/yqQzwpWU6ouvKMvajgU41qpaL3psqSD8JDUscjZXrZxO75n0Wy
         hHDMfTyQRqxZ0BSElRccT1toOMAUwjS2Wjzg7k2hWdbXQNYFm0aZBlQyI/s0tG+Ks64z
         YYBk6AUAhmOpuww5ky43AGCmJ2WYt1kiwaUr7eBuwzKhEywzPno/1KaHKys80LbyVZVG
         ly4/Xy3RRRXLji1hb0pTaBVkjayPjXWaxlkYnISGy29CNIXUscAG7XGEsvM2h/czLMhs
         dnwf0bnL2xrkYIb0vD7xt1BbfdtHKNeR7oVoLhuJ7QKUq9+zmA4AC7FrNmzt8njD2WmX
         JVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mbcutGH6OL7LuSP42at3fK5Z1YIFoEUC0KBJRJ/ehLg=;
        b=s8Qvyq3ucLtBfP4xlnxd5Y9MIE4OtqhVEUPWDE6sHbOWMK3lJz7oPi7sSqn3HzCs51
         WPdo722z7hZo9dyc4AwU91nBO0RekKrODcAnNCauMdEs3Jn+pgp3+qYGsSw8W/tSfvml
         6yknV0xbml9Aiv+bI7hRsuMSAZdzQrvudtspZSARCw46vPoo+683ybOG26sXndwL43Ii
         2UJHjZ4VwIho2dsIhHTbLcmdxmNbzGiKoM+C/nWmSkDtJypxOX3m4fyNs26eE2xYnoYV
         YElPlNAZTy+B1Tn8r/VkUyMidEei1DMTTLj8teoIpNJj5ZMYovJiyXKq1j3QNL0KfJjW
         Agmw==
X-Gm-Message-State: AFqh2kpHnrtB3tPXEeoXmH/nClsdZiQSYJ038gif3gfmr3T8okU1bI+D
        26sE0Ngwbep5XUCqRlnCuOSuwC6voBB/DaJRTPqZKw==
X-Google-Smtp-Source: AMrXdXuAv8OyH+cafe6ZRM/QujXFFE6/O1p5c35GQydmuCBIMhPqc0FHSLHxWlN2i8ZOcK6L+qZ5K5UtAV6gJh8mDtw=
X-Received: by 2002:a25:d496:0:b0:70c:4fa3:2cce with SMTP id
 m144-20020a25d496000000b0070c4fa32ccemr1816768ybf.539.1671892180573; Sat, 24
 Dec 2022 06:29:40 -0800 (PST)
MIME-Version: 1.0
References: <20221223132235.16149-1-anand@edgeble.ai>
In-Reply-To: <20221223132235.16149-1-anand@edgeble.ai>
From:   Jagan Teki <jagan@edgeble.ai>
Date:   Sat, 24 Dec 2022 19:59:28 +0530
Message-ID: <CA+VMnFz8nQ2DnD6L9cPmoRqk+uohRqTEpak9g=WGJnSBoONmrA@mail.gmail.com>
Subject: Re: [PATCHv1 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix
 rv1126 compatible warning
To:     Anand Moon <anand@edgeble.ai>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Dec 2022 at 18:55, Anand Moon <anand@edgeble.ai> wrote:
>
> Fix compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
>
> fix below warning
> arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
>                  compatible: 'oneOf' conditional failed, one must be fixed:
>         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
>         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
>
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> ---

Please add Fixes above SoB.

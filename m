Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BD75E5C7C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiIVHdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiIVHdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:33:13 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A88B9DF9F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:33:08 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 130so11484786ybz.9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vznxy9xqdRmX/+c1xfDYAdYiNLfodMVytirKxQVlqvU=;
        b=19h0p9PeYDDwrzqyam5VPOXf99gXbD0aK5k8BfPEJenh2Jv/WjdzknPH0tUHmgiRHX
         pggTcESbyFCz5wjPpmJSkcd/NQRRrZZiBSfJaMhq7Myfc7diCyDqoIkbuwR+vpE+NSyR
         4tcuq0xXpQnSX0V8U1+heBDJXgld0tSC2LqBM4z3VUSaqRkZ06YHK7IIfBYqUtBTnOpH
         8g3j2HwH0C6U9V4Dw6woPkeBBq7Y38GohOYuh8QKlknbOt7Pa+3U8VR0EHsy5/voiIZb
         V9qFOtQMx6p07AjQGpO7hX3d+YsO1Jyuw006ghhAYb0bZNJ0/92AxLL4Vef3bOqkZOU6
         FV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vznxy9xqdRmX/+c1xfDYAdYiNLfodMVytirKxQVlqvU=;
        b=kVv31wMTP+i4ug03nA60t4H8eKjt0u5dI/T4UdHbbsabJh0enjpnWq9PRLy+98mm7V
         egQ94BupU90552qxRBW0vj9bQTmg+uCb4PqsgiZWkHvZTldRvr8y1JtaI//EcI2fEhc2
         3wUMpRzwc3vVjTdNomdJ71FyZyFXCeiUAdErRyF1eJNxhJjugRVro5InrB/NVIXTzGxW
         s9XC+cSUjNAXVRzs6R/ctjkEPytll0B7as0mPNU9osqjvvtPptAu6y75SlvK/STFvNku
         SvZ1WeDGkdhV9PdZDIVy4V9UTiw1Doo1rjvxackSNUS7aiAF7mIB8wCIWAIKT/pyvt8+
         XKFQ==
X-Gm-Message-State: ACrzQf1vYE/WcmqLQA/bwG3vcn7xpcGJ9kTgB+BUVV822G9ndlx4PNGD
        Qnfa9bwzBBwrGDbnxrYG7XLY8ZFh1dyIz4ioXNTJww==
X-Google-Smtp-Source: AMsMyM68mBRWPzgSHinmacDlTcXL0xgy38F9UZIPw2GA0HUhSgygjrtVbr+Xf6Xo2IYCzPizO8zkXxrLXkUa8C1413c=
X-Received: by 2002:a05:6902:1146:b0:6ae:72f2:62cb with SMTP id
 p6-20020a056902114600b006ae72f262cbmr2487652ybu.615.1663831987619; Thu, 22
 Sep 2022 00:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220907210649.12447-1-anand@edgeble.ai> <20220919115812.6cc61a8e@kernel.org>
In-Reply-To: <20220919115812.6cc61a8e@kernel.org>
From:   Anand Moon <anand@edgeble.ai>
Date:   Thu, 22 Sep 2022 13:02:58 +0530
Message-ID: <CACF1qnd0Nq7Fzi83emR=-cDscCprt2h4gwquecLRyyrbSNsm5g@mail.gmail.com>
Subject: Re: [v2 1/2] dt-bindings: net: rockchip-dwmac: add rv1126 compatible
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, 20 Sept 2022 at 00:28, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  7 Sep 2022 21:06:45 +0000 Anand Moon wrote:
> > Add compatible string for RV1126 gmac, and constrain it to
> > be compatible with Synopsys dwmac 4.20a.
>
> Hi, these patches don't seem to apply cleanly to net-next, a 3-way
> merge is needed. Please rebase and repost. Please put [PATCH net-next
> v3] in the subject as you expect them to be applied to the networking
> trees.

Thanks I have send the patches rebased on net-next,
Please find the link below

[0] https://lore.kernel.org/all/20220920140944.2535-1-anand@edgeble.ai/

Beat Regards

-Anand

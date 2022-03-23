Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0483A4E53D1
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 15:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244581AbiCWOCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 10:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiCWOCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 10:02:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51437DE27;
        Wed, 23 Mar 2022 07:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5EFD616CC;
        Wed, 23 Mar 2022 14:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350A9C340F3;
        Wed, 23 Mar 2022 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648044043;
        bh=0iSclD+CWJo049DAjnNmpJPmyTaLxoM33bJuF/qUYIU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jZ+K6QtSrHhnIoImw542na484JXIO49e49FdbBKfgDnU5cncgJ2q8UUGU82ue/Xbi
         KAB+CmdOZ1X58l9kDuVnAV9HtUnKQWpMdvJdL4MVp26ta3q7x+dYSIxNv75EuUBIfF
         cVZxZT/djEZBclgGulDEdZz5nxnPV0ScYwTcKmYB5egJ+ACg2iQobgStpUYixiggOT
         /bqOkJBeAEEnn1gxH8JkMFC+PaRxdRLS/mjB5t3vsKKtQ8rNQIeiiA8hyUCDzA8Z5H
         R3KyQFS7jNouiuGR3lC1pit1u7VdnnNzQ9MzIylbB/nKj2JazUYeCK28O2WomIamp9
         m0qjKUg8PACOg==
Received: by mail-ej1-f45.google.com with SMTP id bi12so3051224ejb.3;
        Wed, 23 Mar 2022 07:00:43 -0700 (PDT)
X-Gm-Message-State: AOAM533qFgNHYhwYACkcGvj9NbPZg1reJSgLkqT0WM9NWg76p3mGnHj6
        ByvpNj37Rh5tZQqeylqOjMe44QuDP78EEGcf6Q==
X-Google-Smtp-Source: ABdhPJzJCX1fd6x6XUQvELujRx+GXFcimDLm2YbxSHA7op+nKKjo5EIzA07JjYkwARfwQ/qJhXNGyMd50X5K9s9lP8M=
X-Received: by 2002:a17:907:1c1b:b0:6e0:6618:8ac with SMTP id
 nc27-20020a1709071c1b00b006e0661808acmr109252ejc.82.1648044041365; Wed, 23
 Mar 2022 07:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220314075713.29140-1-biao.huang@mediatek.com> <20220314075713.29140-6-biao.huang@mediatek.com>
In-Reply-To: <20220314075713.29140-6-biao.huang@mediatek.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 23 Mar 2022 09:00:29 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+6XKvS5RcE6j9vRd3JL-Wbi-O6BrcoGQ5xV0Q2ZG8EMw@mail.gmail.com>
Message-ID: <CAL_Jsq+6XKvS5RcE6j9vRd3JL-Wbi-O6BrcoGQ5xV0Q2ZG8EMw@mail.gmail.com>
Subject: Re: [PATCH net-next v13 5/7] net: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>, dkirjanov@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 2:57 AM Biao Huang <biao.huang@mediatek.com> wrote:
>
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> And there are some changes in .yaml than .txt, others almost keep the same:
>   1. compatible "const: snps,dwmac-4.20".
>   2. delete "snps,reset-active-low;" in example, since driver remove this
>      property long ago.
>   3. add "snps,reset-delay-us = <0 10000 10000>" in example.
>   4. the example is for rgmii interface, keep related properties only.
>
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/net/mediatek-dwmac.txt           |  91 ----------
>  .../bindings/net/mediatek-dwmac.yaml          | 155 ++++++++++++++++++
>  2 files changed, 155 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

Now failing in linux-next:

/builds/robherring/linux-dt/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb:
ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
 From schema: /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
/builds/robherring/linux-dt/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb:
ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
 From schema: /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml


Rob

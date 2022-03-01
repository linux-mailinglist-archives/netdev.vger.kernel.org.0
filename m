Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D967C4C9454
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiCATcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiCATcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:32:42 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FD86A059
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 11:31:59 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id y15-20020a4a650f000000b0031c19e9fe9dso23507402ooc.12
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 11:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OhkKbjXQRtr8cgG2YtwNCXV0fM/H/tNTVmzFq7kxqEs=;
        b=rsq0gRFmRYXhijTGz6DmP0W3Fl50LFrhfxPhGW5/J2n324ApNP84JmyO2FXFv/pKKt
         hKaoZ3lVzP5KVhl6JieJVJkxnBtbVVpeV2rsjar0hijIZjLEjQpUjZrvOMwM+kAX711U
         miIhetocVb6BLwE62lHjzVvBGeGgUixUD3tLSZ4su8TJtPlyKz8B/fCogV236DVvdYLO
         BDBNii4S2qn/eF55CELY1cbueNrKCWUH2Ht77SFpd71xI9DWwmU8qucSop61abB185ke
         VlwOGEeDV7mvsmMmaUlNE0fKFNVlCdpPnokx8Rlbvld0PFwwleqFdVDjXNF8LokCPMVX
         XLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OhkKbjXQRtr8cgG2YtwNCXV0fM/H/tNTVmzFq7kxqEs=;
        b=VTR0rvUy7QpxdUvt7NY8hwq56IsOYQx0NQQPKiHMhIF1eUCha9TL3DYJzKRAMnokOX
         rDoKVm85eFWOH++x/iDsiOMl+R/k9nOZoIgnrDGnpnvpBM5PYu2xwzgkBH2yZO2+7Z66
         Ea6T2ys9X2cigxRYw7d/VWcGiw87GomXhVVxQjQMsDM3YWmGtQFUmDLrs50YtgMDEIIX
         CsXo6CBzTNFy8h8Tq+JAMMhjQZkJcCK0ldTeY7nogbEvBlsRCpJBfVetzey0iq9NS2cw
         k2IN1J7UZrtBv1Vj2UWLWBbJizoPBMuW8XiQHkGu8YTCSyQWprnj00jfAEUM2TsILJGS
         5n4Q==
X-Gm-Message-State: AOAM532jUAoYj3jeej6waz+38xgdpvkXoa/AtYjmAfhVIC8o7uVYANkU
        Ve3ChpkafG5dJufyvtKFbnjFsn49478cIAO6KZf59A==
X-Google-Smtp-Source: ABdhPJwnaa8BzyVfV18C2z53t5huHKOd/h4d/Z8gv3zm7mUkkA1bDOpI74xw0xVSz19DWMVQ7pSoGE/8vD/vOidmloE=
X-Received: by 2002:a05:6870:4508:b0:d7:162f:6682 with SMTP id
 e8-20020a056870450800b000d7162f6682mr8058828oao.126.1646163118705; Tue, 01
 Mar 2022 11:31:58 -0800 (PST)
MIME-Version: 1.0
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-3-bhupesh.sharma@linaro.org> <Yfh5qrT2dAMpFk2s@builder.lan>
In-Reply-To: <Yfh5qrT2dAMpFk2s@builder.lan>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Wed, 2 Mar 2022 01:01:47 +0530
Message-ID: <CAH=2Ntz837KwreQX4JBf1E6J0SWnV0v-YqtRAn2nU-Dse+f3Gw@mail.gmail.com>
Subject: Re: [PATCH 2/8] net: stmmac: Add support for SM8150
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

Sorry for the late reply.

On Tue, 1 Feb 2022 at 05:37, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>
> On Wed 26 Jan 16:17 CST 2022, Bhupesh Sharma wrote:
>
> > From: Vinod Koul <vkoul@kernel.org>
> >
> > This adds compatible, POR config & driver data for ethernet controller
> > found in SM8150 SoC.
> >
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> > [bhsharma: Massage the commit log and other cosmetic changes]
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>
> The series can be picked up by 3 different maintainers and e.g. the
> network patches seems ready to be merged.
>
> Please facilitate this by sending it in 3 different series (you may
> combine clock and dts in one series, as I merge both).

Sure, I will send 3 different series in v2.

Regards,
Bhupesh

> > ---
> >  .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c   | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > index 2ffa0a11eea5..8cdba9d521ec 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
> > @@ -183,6 +183,20 @@ static const struct ethqos_emac_driver_data emac_v2_3_0_data = {
> >       .num_por = ARRAY_SIZE(emac_v2_3_0_por),
> >  };
> >
> > +static const struct ethqos_emac_por emac_v2_1_0_por[] = {
> > +     { .offset = RGMII_IO_MACRO_CONFIG,      .value = 0x40C01343 },
> > +     { .offset = SDCC_HC_REG_DLL_CONFIG,     .value = 0x2004642C },
> > +     { .offset = SDCC_HC_REG_DDR_CONFIG,     .value = 0x00000000 },
> > +     { .offset = SDCC_HC_REG_DLL_CONFIG2,    .value = 0x00200000 },
> > +     { .offset = SDCC_USR_CTL,               .value = 0x00010800 },
> > +     { .offset = RGMII_IO_MACRO_CONFIG2,     .value = 0x00002060 },
> > +};
> > +
> > +static const struct ethqos_emac_driver_data emac_v2_1_0_data = {
> > +     .por = emac_v2_1_0_por,
> > +     .num_por = ARRAY_SIZE(emac_v2_1_0_por),
> > +};
> > +
> >  static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
> >  {
> >       unsigned int val;
> > @@ -558,6 +572,7 @@ static int qcom_ethqos_remove(struct platform_device *pdev)
> >
> >  static const struct of_device_id qcom_ethqos_match[] = {
> >       { .compatible = "qcom,qcs404-ethqos", .data = &emac_v2_3_0_data},
> > +     { .compatible = "qcom,sm8150-ethqos", .data = &emac_v2_1_0_data},
> >       { }
> >  };
> >  MODULE_DEVICE_TABLE(of, qcom_ethqos_match);
> > --
> > 2.34.1
> >

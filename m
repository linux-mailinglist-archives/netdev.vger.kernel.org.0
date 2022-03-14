Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF54D8052
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbiCNLDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbiCNLDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:03:45 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6377143EFB
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:02:36 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v130so29868771ybe.13
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Io/bO0B9639Ob/rp5GDNN+3V3J2bkzKdpA+20hYRw7A=;
        b=MdzlLj16x9LqL8EnvisYaDIf27FnoatAWsgqYyksKuFBURFejYE3GaWYLzV0JwhCnk
         Q3Ozf/b9+laz7cwoTI99tSWQKdnoZgFQMQF6o+uswQQZZ8PV7D9oc7P0JUM9XNzGXCw+
         hC6FI+70FdbEQznMYLI1y8LymD2K24KqdHk8vC5vWHfEtxNTMeFefpzuLi1pU0Lmpb9t
         KhRjcYtPQv3gFl1ros4Q08/buCMonhA/Kz3/Ud9uB+8GseVugKlYlDqzfeuh4f2GNNwm
         nLl/KrPXSIQrE6wG3sOn9gpZ56MNEIz3/8y793/nKU4eChZNvztjAd+kfHlo3GxyTFqc
         n2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Io/bO0B9639Ob/rp5GDNN+3V3J2bkzKdpA+20hYRw7A=;
        b=SuAmcp4z98w2OD+pLohZrbMyFZOErfYpFqtPUBdrBoCyEMqyWZ884qYX0sFpJB5mkR
         uoswA52aR6hhp+TaRhme/WKxG0Q75q5GRvVhc3c1fNXVNsvMZKQU7Va8n/O+8STJgA+/
         hI6QuVcyfygUZ3IJmhWqE6U3251ww0BH3l6vNtRLJNaboQKVFo0e45qP6MivfHwkUwf/
         X1C/0mRbyIu2iMrCy/xi9Esm7lqoYJnEuq4JBpxBsbAk3noDnBagF50uv4v9/ou02Ltx
         KP0CNexCv8PNB8vrDWnYRPCprNlo99m7RxRq6la047Yj866O+Ls0tHV1Gv2RpLgK5LwT
         0zoA==
X-Gm-Message-State: AOAM531qMIc2Ij14NWQByEhoujunKvxFwDk8rxC6TkT3NPuQHvCk3dnX
        bmBniB5k2qFfAh2DWRExLOzeTqpG//jrA0kmtDmJiHENUo2kiA==
X-Google-Smtp-Source: ABdhPJzcP0C1ENhCQo+43rxMha9SlaOklopk6jyJg6iMpJTyrse/5ISGFX12EgPO/VUNrzmd9QS71SE5NTy56hUNgq0=
X-Received: by 2002:a25:f505:0:b0:624:f6f9:7bf3 with SMTP id
 a5-20020a25f505000000b00624f6f97bf3mr16621771ybe.465.1647255755635; Mon, 14
 Mar 2022 04:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220310101744.1053425-1-anders.roxell@linaro.org> <YioNV4G/OJmeEt0Z@lunn.ch>
In-Reply-To: <YioNV4G/OJmeEt0Z@lunn.ch>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Mon, 14 Mar 2022 12:02:25 +0100
Message-ID: <CADYN=9+Th933YcRdjk51KJsTMGn2f8MdKBx515FcHrs5=H497w@mail.gmail.com>
Subject: Re: [PATCH] net: phy: Kconfig: micrel_phy: fix dependency issue
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 at 15:38, Andrew Lunn <andrew@lunn.ch> wrote:
>
> The description says:
>
> > Rework Kconfig for MICREL_PHY to depend on 'PTP_1588_CLOCK_OPTIONAL ||
> > !NETWORK_PHY_TIMESTAMPING'.
>
> >  config MICREL_PHY
> >       tristate "Micrel PHYs"
> > +     depends on PTP_1588_CLOCK_OPTIONAL
>
> But you actually added only a subset?

You are correct, I will send a updated version shortly.

Cheers,
Anders

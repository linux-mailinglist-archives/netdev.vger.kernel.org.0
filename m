Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912F84840E9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiADLdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiADLdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:33:20 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99300C061761;
        Tue,  4 Jan 2022 03:33:19 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id i22so75522337wrb.13;
        Tue, 04 Jan 2022 03:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=K1B3s/Iyg8kOfoQT3YZHQpq29FuzQTyUhgevv3DY7WE=;
        b=QCuzwYMyCxw27llSQlhw08xuDEpypnKLsXZcy24BNHON+BE1JcTmPp5u1iYNcxBJ3h
         EZ5W2QEd7Qg3JTbVo0S2CBPMG/13XXNYMgtTsGUngU/3QDlCPdB5nq7iSpLFANVjE/Bq
         oYnuE/3BqOW+TXIMOTeO0+tW7QltgoSUziB5YSvll5tO8O6Jqtk5leCCnCuHkVWUJgZg
         /B2vXA6LAI3kal7FdtrN/f3uwqSeVmNNyXa1/CI6TnM0Lg3DVJnjp1PJIyqqh9ClM2zS
         kg6Oc7NS1jz60afuzQKImB2bqL3O88Z2eVpgkYKQg5Bxtj7k4LDJdd/izkRx58tI61cb
         aing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=K1B3s/Iyg8kOfoQT3YZHQpq29FuzQTyUhgevv3DY7WE=;
        b=wOk+5ZAynrINVyv/e5Ug9QIYJ70TvSEsIRJWilDef+dWVBrar56sMDSAxgtQvS4w3E
         QQAjjnOLWXN1Z5gbWDKocqo3FRY9b3jmMovPB+kuhAzFV44IMSnL5/RKd6TOuycaDTPf
         ymmkTR20O+OKfYmQILn9kkExoj9JZsL7WkEmQKR206EV7u2MvoxomRhZ569m3EUNLyHs
         8EsS6Fe/34hldH20s0xGxt3PYFYxmNobQmwAqDwjov/sPDzuMuhypc0Srv0okpXcl+wh
         uG69jCQSgT4azLGvBNbafaXlpGrdrNw4fXGzlOA18AJiIMl57KQUpTvTGKLapfoQ3Lu2
         qBuQ==
X-Gm-Message-State: AOAM5329A5Sr3MniowEe+MFY7IYGzOAQdFm31bFT1Luqt2b8Uqn8JBKC
        3cJsNx0ZVXtw0kvwtIXm1d0=
X-Google-Smtp-Source: ABdhPJzmlL3Q0kCPhxEMRvMnViX7ZIBziNKLzBM51UKace5jcFsIknnh+g2IzyPkDHuJMEgWAXIeIw==
X-Received: by 2002:a05:6000:137a:: with SMTP id q26mr18236641wrz.634.1641295998291;
        Tue, 04 Jan 2022 03:33:18 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id x20sm11436482wmi.43.2022.01.04.03.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 03:33:18 -0800 (PST)
Date:   Tue, 4 Jan 2022 12:33:15 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdQwexJVfrdzEfZK@Red>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, Jan 04, 2022 at 11:14:46AM +0000, Russell King (Oracle) a écrit :
> On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> > Hello
> > 
> > I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> > Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> > So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> > Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> > By not working, I mean kernel started with ip=dhcp cannot get an IP.
> 
> How is the PHY connected to the host (which interface mode?) If it's
> RGMII, it could be that the wrong RGMII interface mode is specified in
> DT.
> 

The PHY is set as RGMII in DT (arch/arm/boot/dts/gemini-ssi1328.dts)
The only change to the mainline dtb is removing the max-speed.

Regards

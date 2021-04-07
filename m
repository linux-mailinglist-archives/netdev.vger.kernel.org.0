Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC543357489
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355432AbhDGSuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355401AbhDGSt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:49:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A8EC06175F;
        Wed,  7 Apr 2021 11:49:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w23so10857588edx.7;
        Wed, 07 Apr 2021 11:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCTcZ/9GQSf/Ljck8Jws7/donXio0A+2sc6pD50GSNA=;
        b=XP/AqdezzDG31JGPQzW3CkebCLWh3Y+APZUHlyVf9kXuhFDZEJKoAtx+kz4ueYuGpz
         HdWEw7QPLhETea36Riuy6ezER8WM43zLYbohIYC3hldh08uA986tHVL0RNLhFOTIYASk
         KJwD+gl+U5EGBDBo/lvwVXwNzY0Zb0haAkcNgVebNHkxzcTRDL48VBnu5rDRboZOL9dJ
         TAwHSCWmyk5wT5tsXQCGpCTpt1M4rTY7OeoUPZL+zBXGoriUxqFT+jXPZyxdLvmAZawH
         wokJrk/kNRFNVWstBkE8x7TZ0NXkDHjBEQhIzkf5XPnqHQmX5loIuMccXNU/NUL9Ayc9
         8tMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCTcZ/9GQSf/Ljck8Jws7/donXio0A+2sc6pD50GSNA=;
        b=ZEqYMNsH+5JjtzpoARRy1O3btIRJqIQARMkcx8L4vRzk729qdhCcViN39oIdnXg8rK
         bKR2DnqOMUvYpYYzw5eGjQnaxKw+ZzSGtqnPVqMhAza1PblaugSdquiamsy2ncLOD3HG
         ugeDXshg+nG/JV2r/WeCTwXBdv/RpbwxdNzp7zo0p37Iq+gpNoCGCwqtR3efaMZz3Mza
         ogE7YXLI+cCxdUOzsyxkk1i5Zo/Rd9neufxUQ0lFYtQSPk6ws21R2YsN1JH6laE5iqrl
         rLu/90kU6Q+ZB51uXu3QZ/z2joKrWV02NRzfsqTkZT4lgw8zVp56V4QBAEdXZF9KfY1P
         g8Fw==
X-Gm-Message-State: AOAM531aUQDNojp2nSISikba9hisQzSpGPf+azC6zAxZ84KyOzW/fEQr
        pZcEWX4UGBRVmA4pOMyQJt0CKPopzhSytY2if7U=
X-Google-Smtp-Source: ABdhPJzeUL/tk90gRs0bfMM7xCgePouT8xjiA55DrmKw+kHCLVKQNbJY2kqB7zNVJgG6s8BD5RIlqA5EYHueyb1TEBI=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr6282012edx.365.1617821384781;
 Wed, 07 Apr 2021 11:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
 <YGz9hMcgZ1sUkgLO@lunn.ch> <98ef4831-27eb-48d4-1421-c6496b174659@gmail.com>
In-Reply-To: <98ef4831-27eb-48d4-1421-c6496b174659@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 7 Apr 2021 20:49:33 +0200
Message-ID: <CAFBinCCv7vSf1H1ONZYU+fo3kRvShYxzemE3-8DqKUzsFFOUPA@mail.gmail.com>
Subject: Re: [PATCH RFC net 2/2] net: dsa: lantiq_gswip: Configure all
 remaining GSWIP_MII_CFG bits
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Apr 7, 2021 at 6:47 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 4/6/2021 5:32 PM, Andrew Lunn wrote:
> >>      case PHY_INTERFACE_MODE_RGMII:
> >>      case PHY_INTERFACE_MODE_RGMII_ID:
> >>      case PHY_INTERFACE_MODE_RGMII_RXID:
> >>      case PHY_INTERFACE_MODE_RGMII_TXID:
> >>              miicfg |= GSWIP_MII_CFG_MODE_RGMII;
> >> +
> >> +            if (phylink_autoneg_inband(mode))
> >> +                    miicfg |= GSWIP_MII_CFG_RGMII_IBS;
> >
> > Is there any other MAC driver doing this? Are there any boards
> > actually enabling it? Since it is so odd, if there is nothing using
> > it, i would be tempted to leave this out.
>
> Some PHYs (Broadcom namely) support suppressing the RGMII in-band
> signaling towards the MAC, so if the MAC relies on that signaling to
> configure itself based on what the PHY reports this may not work.
point taken. in v2 we'll not set GSWIP_MII_CFG_RGMII_IBS unless
there's someone who can actually test this.
so far I don't know any hardware with Lantiq SoC that uses it


Best regards,
Martin

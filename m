Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A10F213558
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGCHoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCHoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:44:55 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7C1C08C5DE
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:44:55 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 18so26062795otv.6
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJUNruquod8lCt683yVuejQKs29C8gyjwm0S1vFEk6s=;
        b=vTgyNyGltANNMjyV9zloyYEpXRui/NLWoErlduHYuRfTYlazFCHpjEUH8VQ6mOnqYm
         xPa+NnsXnRxCyVrn5ZYIXn5i7latFLgISDnwIY12U90Iu1YezLv/Rs1Bzlyje1wnEp5d
         SuSYeZniNaiusn8NTGjusIXW0+SzAp199udfY+ULMO0mg+uB8N2pPaZg9vZa8IooDVaH
         iTAAzZVDjikeXb9t39JBxJJ1q50LiAAD2YkwCtV1yYjf5Jj8VGhZLrj0XLnzsix6qb8r
         ixuErhqWl78OboHWxuxueeRafcGG4/hibXwI7AKgkeXVtIIjLurASfH4jTQvMe+Xpu+4
         N0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJUNruquod8lCt683yVuejQKs29C8gyjwm0S1vFEk6s=;
        b=LYGGUEUjZK5ruBEkcnzUXtDwGInO3xSgWPNm2STJ3ismsf2qvz0xQWMQgK2iHcXFLf
         kDXgxlO1AQ1BiPTCme7WoUDJIQPv7eLrzpYIAPt3bAUDWEBlQRCeO5o6HEG302veRoE4
         P5S47/Aclg096tesk3fNARMfQvql8fEWZqHMfbCJzlhK6UMsJhfG5kcb87uNO/cdV5eQ
         b+TBhLnC8VBBVT3km6bYO5V1T8x8UATEXpfN62BPmnTD27ZM7sWCmn6sz3oT69XoLwaS
         yMnUm3i6faeKGa1vNXgmQlKRORNL3gkO3GFy09gB9YKBJs6r66xPYfUyNPrRxGic4ZP9
         5PLQ==
X-Gm-Message-State: AOAM533hBmQ1/S7KW2UgKg9mTwUgUFfE09cZ0IkV7WDkdF3wwkFDSsZr
        QNyyJZWy1MZ6vD8n6t+WdXX5tqyGpjr0Y2uFwshMxQ==
X-Google-Smtp-Source: ABdhPJySQQvEITt77PfQTvma2h+w6OARamY7QXSVOHO45DRH0thjyzyMVpq6po+6kGkzMh5DG8x5CuuIBmxC/9AuhQs=
X-Received: by 2002:a05:6830:18f6:: with SMTP id d22mr13105205otf.243.1593762294473;
 Fri, 03 Jul 2020 00:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-5-robert.marko@sartura.hr> <20200702133842.GK730739@lunn.ch>
 <CA+HBbNGcV0H4L4gzWOUs8GDkiMEOaGdeVhAbtfcT5-PGmVJjfA@mail.gmail.com> <42ebc500-35ba-48f6-c4d1-3743abde1852@gmail.com>
In-Reply-To: <42ebc500-35ba-48f6-c4d1-3743abde1852@gmail.com>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Fri, 3 Jul 2020 09:44:43 +0200
Message-ID: <CA+HBbNGfELm9hYZgJ3KDghE4gDdr3g8Df3oqsTefEL2NvBRdYA@mail.gmail.com>
Subject: Re: [net-next,PATCH 4/4] dt-bindings: mdio-ipq4019: add clock support
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 10:04 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 7/2/2020 12:18 PM, Robert Marko wrote:
> > On Thu, Jul 2, 2020 at 3:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >>> +  clock-frequency:
> >>> +    default: 100000000
> >>
> >> IEEE 802.3 says the default should be 2.5MHz. Some PHYs will go
> >> faster, but 100MHz seems unlikely!
> > This MDIO controller has an internal divider, by default its set for
> > 100MHz clock.
> > In IPQ4019 MDIO clock is not controllable but in IPQ6018 etc it's controllable.
> > That is the only combination I have currently seen used by Qualcomm.
>
> Not sure I understand here, the 'clock-frequency' is supposed to denote
> the MDIO bus output clock frequency, that is the frequency at which all
> MDIO devices are going to operate at. Is this 100MHz a clock that feeds
> into the MDIO block and get internally divided by a programmable
> register to obtain an output MDIO clock?
Yes, in this case that 100MHz comes from the GCC clock controller and
is then internally divided by the MDIO.
I do not know what is the actual output MDIO bus frequency as
datasheet only denotes that MDC divide
bits in the mode register are set for 100MHz incoming clock.
> --
> Florian

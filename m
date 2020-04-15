Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCEC1A978D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505555AbgDOIwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2895133AbgDOIv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:51:57 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFD8C061A0E
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 01:51:57 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id x11so2641534otp.6
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 01:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZ8PEt8ilO1F7s0PZB2jEBFLypOtSGmLv+9HjFoznC8=;
        b=kOKoxbSySQFWV4DTsd8hMXuUPciY0YdJjmtqavGBNtg6fmNgGRASTGJqeImXO941zR
         i1ioZxDpnblsfXu/NTRnbq1hVPlN8Y8FI480+4TFTWPRH7dfkOIDCzMk7lt076WbZPqt
         5wxioDQYlIOyq6EGcFZL7xQyuz7wtOotPGfIv0VTg1MyRrWMWFubIoc38+chQ05Zxtqh
         8Ni72FCrRzrVxYw0tUSc73VaFeqsgCg4bIEV01XtO2N8/38ozd/AX979JOcZLH3WzrxR
         tS71hzw1aGgyWSZDMKu9jyzo0tjsKGvGEG1j+zOF8bmZJPnE0/BUPC6ljQfSV4Y/eg6f
         cwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZ8PEt8ilO1F7s0PZB2jEBFLypOtSGmLv+9HjFoznC8=;
        b=lpQqJoxX0ZfJgBco4AUhi+iSQ4cA0Qel8+9lUkoqegf2TAio33xI0WRmmgUEJVSwxy
         crns/B+vRWUAfYSsPixaVkmB/3hDpOxo8iH1xxT+SZc131ZKCUg1+G5LopEXcknEUzcs
         Xtj3ZsI6wjqZDxl3Kc3ew6oJwsjWHrhBPhtL3wddt/zxPzlULmRq+pH6u3v4BSYpwzyR
         Jxe/8+PGw09kUUpV5vwUhRmTSRwaIQki2RMtqHlAYqHoxYcDqNtpgIobua1mF6YR3VN9
         6TUuo0Qm19icUQLqFww14TDnpOmAWGSkWKCHQPN2JWxkVNAJKLe2obsvOAr6KaDLwHR6
         PvvA==
X-Gm-Message-State: AGi0Pub9bS08+fFk//arbAvrlgJ9kVd4ecK/gDg6IVnG8GqTmlEZ4haw
        UKo8F/dXd8UGOSYLtJyuwOuxcdwcs0+fds4KDx4U1Q==
X-Google-Smtp-Source: APiQypJv9QyoDLeyzwLnHZJawTduDHOVTKjxTKzUFB3jLIOo6iaZRWcW/QaOxtRbC16DF6GTDfN9Pm4nKSu8DpTh2bg=
X-Received: by 2002:a9d:ef8:: with SMTP id 111mr21981983otj.94.1586940716871;
 Wed, 15 Apr 2020 01:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200414181012.114905-1-robert.marko@sartura.hr>
 <20200414181012.114905-3-robert.marko@sartura.hr> <076e0e54-ad3a-8cb7-d96d-8a83fc315b28@gmail.com>
In-Reply-To: <076e0e54-ad3a-8cb7-d96d-8a83fc315b28@gmail.com>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Wed, 15 Apr 2020 10:51:45 +0200
Message-ID: <CA+HBbNFm8PG87dBicYjfrvXjdBEyPzoy5vhrQuzSCsZL3o57Gw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] dts: ipq4019: add MDIO node
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 11:13 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 4/14/2020 11:10 AM, Robert Marko wrote:
> > This patch adds the necessary MDIO interface node
> > to the Qualcomm IPQ4019 DTSI.
> >
> > Built-in QCA8337N switch is managed using it,
> > and since we have a driver for it lets add it.
> >
> > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > Cc: Luka Perkov <luka.perkov@sartura.hr>
> > ---
> >  arch/arm/boot/dts/qcom-ipq4019.dtsi | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
>
> Earlier contributions to that file seem to suggest that the preferred
> subject is:
>
> ARM: dts: qcom: <subject>
Will be changed in v3.
Thanks
> --
> Florian

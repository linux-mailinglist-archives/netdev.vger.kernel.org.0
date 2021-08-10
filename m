Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86393E59D0
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhHJMXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhHJMXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:23:19 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BF2C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 05:22:57 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id d20so9540437vso.8
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 05:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oZoJVjBidnvPVFvMpPWZppXKGeyyaDUB3Ugu5JUsoak=;
        b=qIQDlA/gUyoRPh3kgWXZkiUaIb3qcyb8TOW9CKWJmmvFsvyfJMbRJp97WbmjhiyjOC
         mnkqXMdci14i5YX4fThGwDaNhtdgPMl8QQ8GLzA5/V9qqqAzJ2NLeBpHSjhBA1ooWd55
         WeVyQrZ2PJ7RGF/EEuO1LLzR/VQDKZVroky6UJ61cynK0Eo94rDW747aK3HA0LXMhHGU
         xhOtH2jUuSvyZ83LKIVMrj/75HQaoJekDOmAqRJ3FdZhxc01OFjIoZ01kJzqwRlczBQg
         n/Y8yYRcIL3K9gNw4KexSGWkiGY0LAmH3clUKgzisOPSOWaG8GJ5gml2PjPymIK6vVN1
         1g+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=oZoJVjBidnvPVFvMpPWZppXKGeyyaDUB3Ugu5JUsoak=;
        b=rmbPAQ3mSDOgqYmFw2bVzjE1hxIThgTATfiQWjmI+csmO8PvuKfUv0Nxl9iRRnsz98
         /x1xjBZZys5jm8P/lrsqDUwktq8Ek/HSBoz+4UxYgQJbmf5gSjyFF00hVz0CWKuMv6I8
         Om2s5kBw4KiLpgQstQ6wfv2odvsQhKR8Qt52jXmlRyUXE/4rI9zBAfoDuNdjWXsqcL8S
         C5+6PDxJTt8J1ritVm/Hn7OtzN1f1/Wiz5C1/J9VdaWIpkzv+Dr2SOZLzdo3WwoEXJyE
         K58t2gsJFslVNwMbXkEsl1xqYIbOqPBbJLkLKjRCc14GABZEfdiOlVsv+pLzhFlktSzT
         e1EQ==
X-Gm-Message-State: AOAM530w+Y6g0IHpsIS4zlMbQQzeknWNOttHk/NNe05NUjGQdpi7IZvp
        W/ie+jxlIbvoBIR4q0miHbYvgSA1sMbUjyvK6js=
X-Google-Smtp-Source: ABdhPJyBu8sk/AoiYFwRL1z/MPSFVE4uHzMzZwuiKkbEBHa2/PyMxqxCeR62vN3HESRqSgro6T+hSWYJlKWrblPZj/E=
X-Received: by 2002:a05:6102:3047:: with SMTP id w7mr20462751vsa.6.1628598176633;
 Tue, 10 Aug 2021 05:22:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrsdaniella.kyle@yandex.com
Sender: munasalemmustapha@gmail.com
Received: by 2002:ab0:279a:0:0:0:0:0 with HTTP; Tue, 10 Aug 2021 05:22:55
 -0700 (PDT)
From:   Mrs Daniella Kyle <mrsdaniellakyle6@gmail.com>
Date:   Tue, 10 Aug 2021 05:22:55 -0700
X-Google-Sender-Auth: zMAEyhPwkCthbLxT_cHTxvFLOJo
Message-ID: <CAKASgyKUQ9Zzy5G8kQFVmpKm12k20z6zUOHM-2qN3oxC3VP9-A@mail.gmail.com>
Subject: ATM Visa card compensation, Thanks for your past effort
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Good Day, This message may actually come to you as surprises today, To
be very honest with you, It is a joyful moment for me and my family
right now, so therefore am using this opportunity to inform you that
have successfully move to Vietnam where am currently living with my
business partner who assisted me to complete the transfer, but due to
the willingness and acceptance you showed during my pain have decided
to willingly compensated you and show my gratitude to you with these
sum of $950,000.00 Nine Hundred and fifty Thousand US Dollars).

I want you to accept this amount it=E2=80=99s from the bottom of my heart,
have issued the check and instructed the bank to roll the fund on a
master card for security reasons, you can use the card to withdraw
money from any ATM machine worldwide with a maximum of US$10,000 per
day.

My bank account manager said you can receive the card and use it
anywhere in this global world. Go ahead contact the Global ATM
Alliance directly with this below information. Email Address: .....
maastercarddeptme20@yahoo.com

 Name: ........... ....... Global Alliance Burkina Faso
Office Address; ...... 01BP 23 Rue Des Grands Moulins.Ouagadougou, Burkina =
Faso
Email Address: ..... [maastercarddeptme20@yahoo.com]
Name of Manager In charge: Mrs Zoure Gueratou

Presently, I am very busy here in Vietnam because of the investment
projects which I and my new partner are having at hand, I have given
instructions to the ATM Visa card office on your behalf to release the
ATM card which I gave to you as compensation. Therefore feel free and
get in touch with her and she will send the card and the pin code to
you in your location in order for you to start withdrawing the
compensation money without delay.

My family wishes you best of luck in whatever business you shall
invest this money into. Kindly let me know as soon you received the
card together with the pin code.

Thank you
Yours Sincerely
Daniela Angelo Kyle

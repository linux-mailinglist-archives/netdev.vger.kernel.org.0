Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0527741A91B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbhI1GzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbhI1GzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 02:55:21 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A07C061604
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 23:53:41 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i4so88110791lfv.4
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 23:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=RkjMpeIuQ6aVWCs6FPMVIVUmVZwq7aWhwwHDvLPHoTA=;
        b=SLi+XioDaqQmTbd630gCbmYjBtTXmeNWxear1oZVVOrDzXw485dutYdbXHdz3DwhhS
         DFl7QLLqs0pOVMouWddiTvjlKMSJR/sgvGcxvsFLC7krX2zyYVYmUYTxBDBS9hxCz5JF
         r+YUpLNU8JsswOVSZTX6BcTwyjFXcMg6pSMFWB/Uq+0vf9vdPDE3qCIwxe5zNzROPQF6
         LnMZAw7gE2JZldtZ/c6rVoZGIttFZQjlltq1ACdnTaNIPn8mEPX3Mx9OZyz8wvcKZl/J
         PiZKfIlXAI1dWvhJF0QKLh102kSv1IOlxArEcJAbvBFJObcSRjr2fbe5DHe+/+gz5XJm
         cC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=RkjMpeIuQ6aVWCs6FPMVIVUmVZwq7aWhwwHDvLPHoTA=;
        b=EHPBnCQq+G7zY1gwUkZqzuduSbQGaRf5E5c1F86gwb7A/+eXL8onv9PI2R16ZbTO7h
         Rojn83tEYPUBIanFJm/wPjwBAm1mJg3q2BUWV4z49aNuGD4Z6iA3KXtJ0fMv5j7uSM43
         SR49iZEpHwunWE998dm7/j71Ivxgx+deehgq8AL7wDUknQh7axMO2Vmj8a7+nUy9Eauz
         O1G2QZqtqk3ohR/1jrQ3oq6QaQVX0/mltg/Lam4693+51216AwjfPp57atUaJTCgXSnl
         1+Hx7kEEUQjmDenPKw8MBdpg/Xi1BKVaeXjWy7W5sTAO6Uqmyflk2zlEu5qJP2BQqYEz
         vdjg==
X-Gm-Message-State: AOAM532MF8kTB352dgXikkq8ufJ+/lOpoVwchQgk7khgVowhA2tBfHxE
        +nMAzBeou2aFKTvNtEjy7JdvR2MuUUY4uXWy02w=
X-Google-Smtp-Source: ABdhPJxmfUqau1QxG28+nbebSaJEsTs13AS5vBA2TVnI644R0xpV3hOVPmfW5Ecy7q6/4kW/fVOTA+oOSuaVTq5+rPc=
X-Received: by 2002:a2e:8603:: with SMTP id a3mr4273692lji.142.1632812020147;
 Mon, 27 Sep 2021 23:53:40 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrsdaniella.kyle@yandex.com
Sender: mrsrachealgoodluck1@gmail.com
Received: by 2002:a9a:6c41:0:b0:147:34b8:29a8 with HTTP; Mon, 27 Sep 2021
 23:53:39 -0700 (PDT)
From:   Mrs Daniella Kyle <mrsdaniellakyle6@gmail.com>
Date:   Mon, 27 Sep 2021 23:53:39 -0700
X-Google-Sender-Auth: Ue4yDyvuqd_Y9_0fcdE4K2iK1Xo
Message-ID: <CAAQ9gCf9-W1fRoEy+zp_XLPiDkaMApbvugXGq8TdY2rkCBW-EQ@mail.gmail.com>
Subject: Re:ATM Visa card compensation, Thanks for your past effort
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

This message may actually come to you as surprises today, To be very
honest with you, It is a joyful moment for me and my family right now,
so therefore am using this opportunity to inform you that have
successfully move to Vietnam where am currently living with my
business partner who assisted me to complete the transfer, but due to
the willingness and acceptance you showed during my pain have decided
to willingly compensated you and show my gratitude to you with these
sum of $950,000.00 Nine Hundred and fifty Thousand US Dollars).

I want you to accept this amount it=E2=80=99s from the bottom of my heart,
have issued the check and instructed the bank to roll the fund on a
master card for security reasons, you can use the card to withdraw
money from any ATM machine worldwide with a maximum of US$10,000 per
day. My bank account manager said you can receive the card and use it
anywhere in this global world.

 Go ahead contact the Global ATM Alliance directly with this below
information. Email Address:   maastercarddeptme20@yahoo.com

The Company Name: ........... ....... Global Alliance Burkina Faso
Company Address; ...... 01BP 23 Rue Des Grands Moulins.Ouagadougou, Burkina=
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

Let me know as soon you received the card together with the pin code.

Thank you
Yours Sincerely
Daniela Angelo Kyle

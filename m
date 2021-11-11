Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE02244DAF9
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 18:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhKKRLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 12:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKKRLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 12:11:35 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1C7C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 09:08:46 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id t30so10918314wra.10
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 09:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=twxFcb4m5IsNstFuz4gRAIVsSyli01pOYmlUziyAASw=;
        b=oeO4JE0QkSMQU/T0aulT1CR31idc3TY0Yf7R1M4mbdtCbBR3Quxw6S819iEKiKANIr
         RMrxCaST4uhEsnXz8qGMQi3ktkk1nR0062q1i53D12tQbAOnMOMpOVo69PVEApJwDQOm
         bewpXtzpNb32tK70jDEfCt15XwmwGEZe51I13gJqE3egMturf+3WCRp9Kn3aML9qzhoR
         KrDbbRL67UhBUdcyHK+vvy/kEwnOuroLWuACRs817tdriXiliEOJhKcFGA/ISK5JNYiQ
         28mDD485zHm+FMqUjcNiQw4IDk/v+Bft3ocBs0jIeL5wllX3aFX2HNN5nD1LOPpZZoqt
         WI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=twxFcb4m5IsNstFuz4gRAIVsSyli01pOYmlUziyAASw=;
        b=Pdjp7xvvN6Q7ClINSxKh5YpfEqqQSvcXiIUu3+RDaO9QeSY4aQaDzXOot1k+2NlynU
         HIJQu1h0sndc4wsysQd8+0ACfxbIplnQYUydTGjUbI0oNluqORC6Z68LHZN+gXLPLpBy
         HFbq9T/3bTXlZTuPum2O8nqJgiEsRFsAp2lo2pG+0j3PByqlC6Du4CT2W0BUh/YwYrwZ
         wCBSLL08HU9VEthVFXhUJ6EiOitdoKGbKuqO8O29pneSGJeRFY3zZPuzUFQBBCoF5pTE
         xxAwCKyGhM5Y1xfepvrl9dhbg7iH/xB/8z1+OEm4p+kQApX6EmfvmgdZt5NG9urYr55A
         7gBQ==
X-Gm-Message-State: AOAM530churIzG6SoAfi7ZIsdOJUUebkUrsyELePuqWFEWzOzEDvingM
        EYcV/4qv5Ecu+ZFmAnGAmFMTuM4e66HFN/WVdtA=
X-Google-Smtp-Source: ABdhPJwln1Y2UXUsdp+Jiqs2+9l2vuio3HOK/ST7Q0vadHVVS0LyjXCDehs+XcwsSbuhtjAgyT+wZHWz6jCJGYYjy0g=
X-Received: by 2002:adf:ce0e:: with SMTP id p14mr10423094wrn.423.1636650524898;
 Thu, 11 Nov 2021 09:08:44 -0800 (PST)
MIME-Version: 1.0
Sender: 1joypeters@gmail.com
Received: by 2002:adf:f60f:0:0:0:0:0 with HTTP; Thu, 11 Nov 2021 09:08:43
 -0800 (PST)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Thu, 11 Nov 2021 17:08:43 +0000
X-Google-Sender-Auth: eUVQqbZKUGepS6zVHlTJDS4FW1Q
Message-ID: <CA+F+MbbDTFhZjErLoeHfxXCd+zyHDsPH6YMxz49MvHVj05GSbA@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear.,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina. Mckenna Howley., a widow. I am
suffering from a long time brain tumor, It has defiled all forms of
medical treatment, and right now I have about a few months to leave,
according to medical experts. The situation has gotten complicated
recently with my inability to hear proper, am communicating with you
with the help of the chief nurse herein the hospital, from all
indication my conditions is really deteriorating and it is quite
obvious that, according to my doctors they have advised me that I may
not live too long, Because this illness has gotten to a very bad
stage. I plead that you will not expose or betray this trust and
confidence that I am about to repose on you for the mutual benefit of
the orphans and the less privilege. I have some funds I inherited from
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars).
Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country  for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die.. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply .

May God Bless you,
Mrs. Dina Mckenna. Howley..

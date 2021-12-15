Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19CF475F5C
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhLORb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbhLORbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:31:05 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A21C08E858
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 09:29:47 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so16492739wmb.0
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 09:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Hp2wuf+GFIgPk2krY9oLPCwUDqecUtCiJ9IkJj6FAwY=;
        b=HSsyNabQ11AdZfZ39OL8dncIkEgiMWOqLHQCtc5jWFUbGD/8yGV3qmRhR5VuepgkyB
         Sv/cLV+kjnSl7mesXDLWIXPu/6MxxLcP6JTpmKbxiaM68YL35JH1usWaFp8aeh7y49QQ
         gKPRV1gx2KaiXRmtN1phbee7wF3hRUfvQ7oYBdU1/RobZSPxG+MaFAZv/GB7job3eG5R
         kZ/WukIMaX6lMjO/xaqZmkMR2+rmREOiyV4ELJpp0oFOIEFZsk6QObM5CEILaUnGKDO1
         ebfnU4fll3NMMLO+tUfaDLH2HFmRvTOqbFEn0xpTNQrKAJWYTLwzpoffDbKcpeLCY0Wu
         nalw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=Hp2wuf+GFIgPk2krY9oLPCwUDqecUtCiJ9IkJj6FAwY=;
        b=Iq7/L/f4wJhq4fa8hD5hUvFeItfnsKuC/HrDOTFq9mQTC+AOx03FMO3bIVoiX85CxY
         //1OpRk275A7Iip8uAB1TcjZmIuBoOJZ5rkCifYGEhIPpOWgVH8AY+IZ5o0LUXHTVfPf
         zqMGkFSws0rjWGsbrlDJyinPRuoO0/SU6bZXcT6MhXgxG4fOBXqu8apXbFF+0lOPkhps
         g5Z7Qro0Bw2tMbQhw9LuDFAihJ+X1yLihQLMo9hhYF4YyuxXGzHRk5CQSiJAdCxHPSqQ
         0cAhpqEH2LflR0HFew0UUU5Iq06zmPNmXA+8X8QlDKepOR9/yzlL+NM199/iccLrn+hJ
         yAKw==
X-Gm-Message-State: AOAM532D28r94JpQaUc/yGK8t/OSZiUXCVeEkUDpVcasPL1KRRy9+Z8W
        dCAAs3Ft9Hv0GQtD3RCFBOfzE9HOSjpY0gdshwY=
X-Google-Smtp-Source: ABdhPJwiup5hHkWiPLztMG5gN6sVWVWviOvQA56/EtYahivK2Uqwa+xX2ZLCzOQjdNNei2m4cV3b0My82SxGcqbKUis=
X-Received: by 2002:a7b:c5cc:: with SMTP id n12mr982215wmk.162.1639589386263;
 Wed, 15 Dec 2021 09:29:46 -0800 (PST)
MIME-Version: 1.0
Sender: donnalouisemchince@gmail.com
Received: by 2002:a5d:674f:0:0:0:0:0 with HTTP; Wed, 15 Dec 2021 09:29:45
 -0800 (PST)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Wed, 15 Dec 2021 17:29:45 +0000
X-Google-Sender-Auth: P68BGXx8MQSOJNGBboYY0Qfujqg
Message-ID: <CA+4RuvubHoTVsJWPQitfsjmbuPn82M47VKt93fYP_hEZNHk3_w@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Howley Mckenna, a widow. I am
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
will be transferred to your bank account.. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply..

May God Bless you,
Mrs. Dina Howley Mckenna.

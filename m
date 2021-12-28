Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239C14809DF
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 15:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhL1OUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 09:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhL1OUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 09:20:37 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C4EC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 06:20:36 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id q14so16244758qtx.10
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 06:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zwa5SmF7AqJ7b8ziq0P2tazEHmZcmrR0jeKQIZMxvV0=;
        b=IC8eXbdNVq2xNtTenhaNZW2mnIxRZ52NNhTrzD+r9HCZ0glW8K5RFczveOAA66PJ+4
         w8b/xS0F3/0HSiCO/bh8uHiFBtZshoK5Tn5vuOjGH5QfhakWlf8qd5CvptM1s66TexQO
         AglvKfUUmOO2Rdhrua3P2LkA0F+6j9xcdm1F050wPfpAa4gXEBXt4yJC55g7+pQynHBn
         z5wGr1cgVSnKAZZj87lWpFtrUtbcN3Xuc5/sGxdn3GVThNDtyCqTi/lgdtJTm7p/DgB9
         po7i1fKmptw1oCxn0G8a/5W075w4tAO2tI6R25guIEuL3MH5sAOumwT8Oss4PSWs7dtk
         VL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=zwa5SmF7AqJ7b8ziq0P2tazEHmZcmrR0jeKQIZMxvV0=;
        b=gD0C6716SNXWHGBTA62ykY1VtokRB7nuorjCPBdMfueiINKI4AFbz9zQx/TTXzY1he
         KbL489DSbpyhnqohLx3M9kxTcCPazC/aEyw1JOYyS1VTEcHYtgV5pE/8YbV7Q9tAvwuL
         ECqm0SThbC/pRg4ewXrIHDTmOfYZ83JMdv8PRyt9g8kr1gcn2bZP8b828SenzBjolzaK
         iwsZo+0JrqIM4DBdso7hBfvgwcCE/k7BSfcuoMhVtLBdXkY8DeCey97y+HdkWy2siK9j
         41/JkOiWKNLfEbhymTEh4mUcKGpQbr5WmNADOh5Fd/DpTKUyVm5xf52HdWxWFqmezYmg
         iRuw==
X-Gm-Message-State: AOAM532cW+STril5f7b/JV8cY8/uP08DwevKUxPSvk+VliQfzYlrRIgb
        8gJHqi+0FmP9lRd455Zr0wmdGHSEw/zRGKbHveU=
X-Google-Smtp-Source: ABdhPJz4TD1+ltSI0guFbADyVa/O4Mz9/t8IJySQNFVZMK4FAxnXbL8wBm1BEezE18HYSP9h0LIj/X1dE/br3aF4amQ=
X-Received: by 2002:ac8:5f93:: with SMTP id j19mr18673507qta.596.1640701235994;
 Tue, 28 Dec 2021 06:20:35 -0800 (PST)
MIME-Version: 1.0
Sender: zaring.kkipkalya@gmail.com
Received: by 2002:ac8:5c8f:0:0:0:0:0 with HTTP; Tue, 28 Dec 2021 06:20:35
 -0800 (PST)
From:   Jackie Fowler <jackiefowler597@gmail.com>
Date:   Tue, 28 Dec 2021 14:20:35 +0000
X-Google-Sender-Auth: 1q_WOpbiJ2YvIKgG04Gh6AOuQIE
Message-ID: <CANmOZ0xV_p-oUVgGVBGVghfncdJwNn=5wpfU2QTRUv=7hQv0EQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gooday my beloved,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs.Fowler,Jackie,a widow and citizen of
Canada. I am suffering from a long time brain tumor, It has defiled
all forms of medical treatment, and right now I have about a few
months to leave, according to medical experts.

 The situation has gotten complicated recently with my inability to
hear proper, am communicating with you with the help of the chief
nurse herein the hospital, from all indication my conditions is really
deteriorating and it is quite obvious that, according to my doctors
they have advised me that I may not live too long, Because this
illness has gotten to a very bad stage. I plead that you will not
expose or betray this trust and confidence that I am about to repose
on you for the mutual benefit of the orphans and the less privilege. I
have some funds I inherited from my late husband, the sum of ($
12,500,000.00 Dollars).Having known my condition, I decided to donate
this fund to you believing that you will utilize it the way i am going
to instruct herein.
 I need you to assist me and reclaim this money and use it for Charity
works, for orphanages and gives justice and help to the poor, needy
and widows says The Lord." Jeremiah 22:15-16.=E2=80=9C and also build schoo=
ls
for less privilege that will be named after my late husband if
possible and to promote the word of God and the effort that the house
of God is maintained. I do not want a situation where this money will
be used in an ungodly manner. That's why I'm taking this decision. I'm
not afraid of death, so I know where I'm going.
 I accept this decision because I do not have any child who will
inherit this money after I die. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.
I'm waiting for your immediate reply.
May God Bless you,
Best Regards.
Mrs.Jackie,Fowler.

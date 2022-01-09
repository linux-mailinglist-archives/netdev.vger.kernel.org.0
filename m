Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2566948883A
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 07:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiAIGak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 01:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiAIGaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 01:30:39 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41642C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 22:30:39 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id f4so99674ilr.9
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 22:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=KHcWV4zSsq2PqN20f8EeHPXMVayTO8KS5bdiyuIRLEE=;
        b=dImYGJXpvwcaQaWKGKc3KQg24cab9IUCrkU4pOOz4kmKEKHQfAinV59hoxqPUM5N+T
         qPCPUVkv612bw+nPHNHVcbs/IH1oqh62n1guCpVdntkvnwKszxJFNezlKwRb81t51HZk
         fD6D33f9hP6w0QPdkrtl+ErCUtngggV4juKPHGoEcf+6P7/ntrQvOJhrVXQ6H/OvpMvY
         5L6RYzgepSgP42INIMj7/EM1RmL1+GJ0VjUhImAvKUxYaVGPd51RiTIP10soxzV298Ud
         sCbFF4eUTAdARoc7eMw8lJWHzLbiiYcKOmqVTfjv1g5yf/SDjL+hh/5a7mT+arBIKw2w
         i0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=KHcWV4zSsq2PqN20f8EeHPXMVayTO8KS5bdiyuIRLEE=;
        b=rfJI2W02pRWZfvxOd/QXzA1icLgD6JJ32l3sr0UVj2kPgVZQzG+3W/JrLVXtkSXe/t
         dAVEPneya6BOYL779QJntuy+I5K1Ca8qfLkxGUS9gvi2DAIpJ0hklWSB/BN04X3GAN4u
         pTnc9Uix8i7beNJTUzZNOugVoZTRc9afwhLdDzcjaM+1AT/an+3CGJ9Uan4vvFwNkjnh
         oT99I5kV7Ctsu9X5I3FV8i3XHiRkJLjdhmXZ7eWNJ6bI5WkoTgj6XxHruikXjw1J38TZ
         2mQUpep9Vt8yNQG3y9hbzo6Y++DolnTlXKSWznMjv4NZ/VghfPxq/hRkWPYHW5SiZorS
         Bd2Q==
X-Gm-Message-State: AOAM532TEYAxqBnD77UM+l+Xfbti1c+q/mq0+7F16/VSoSygxnUU5qn+
        RyZPAxJyL7uS+LtWG4uIcOrgoIYooLv+iSfn4bc=
X-Google-Smtp-Source: ABdhPJweKLzFaV+VLGDjxZHHVgw3SA/3v2LU/29aou1CD5O+WXb6UAVTlNp4V+ViDOIE600u7BazuOowGyWg0H/O0Cc=
X-Received: by 2002:a05:6e02:1c21:: with SMTP id m1mr10414107ilh.150.1641709838001;
 Sat, 08 Jan 2022 22:30:38 -0800 (PST)
MIME-Version: 1.0
Sender: helenkalu21@gmail.com
Received: by 2002:a05:6e02:673:0:0:0:0 with HTTP; Sat, 8 Jan 2022 22:30:37
 -0800 (PST)
From:   Jackie Fowler <jackiefowler597@gmail.com>
Date:   Sun, 9 Jan 2022 06:30:37 +0000
X-Google-Sender-Auth: XNbmDbiEGwPRCmPvO-YBScPOh48
Message-ID: <CAJ+e47zJgUkxFv34Qshkhva99L2rpb2N7+So=Y6y2tO7uL9fjw@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gooday,


 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs.Fowler Jackie.a widow and citizen of
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
Mrs.Jackie Fowler

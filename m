Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208D443B62B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhJZP5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhJZPz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:55:29 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A6BC07978C
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:52:22 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id h4so30051332uaw.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=VyoOlx1f4bY9qJ0WEn854eIaH9saJD/psl6FGa9mBmM=;
        b=YqhB57ZJNt4QjMcoroxQ2G6CkEGKWuuRCm17ytJebXuN/fz2zNRWoyJJPHeOLJopjz
         N2QI7yU7z/xZ1TfAWcLTKnHATF4bUo/sGOXW6xe0V6jd/AS/PzLDRkBF/wC8FCuuRleE
         4LLi8TbTpWr8iFm/OLaO3VWt+w8/na20hwV1tyfmx041mmSfIMzu7fYNGY3Tgy0Qg4pV
         fBKq8vCJtgBT8mY6/+4W4sbB796AKcCMnzVqybLg+AwbOWlFd9qd7p7cwugc3wMtnLtV
         e/e3NhuOTC3jC0J4y5uIFoksljYdS6xnJ7bXjmuyB+87kLZXY8GXNHltQJkCo5Uxm8W8
         kz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=VyoOlx1f4bY9qJ0WEn854eIaH9saJD/psl6FGa9mBmM=;
        b=EpDMhnO/dwfZB9LklqGx1Bp6S2KMQLfoN2AD5tUsXUM41WI7UV5UX9/VOFfYiNBN8S
         I5l3hno9C6FCEPpcWM0wENqkdOMtmvIZYPO534RcIVJl/Ql8B7Dz+x1gj0miM+LmUKLG
         ma7IefxnVlwuSUvya0br5dWpYqqbORIEyKd58fxMi7lh65PcI++ClvJPetgqEryO4hdz
         1dqsXruByte/ZaI3065TX4X7SqgS9oliatv3HkjuDXqbeSENVebp8Y4pnfYtEcARYS93
         k9uvKpCP2ZMIT6JcDSgrEMQ+xV9Pfi/P/bIxTl0wkIqLe+NGwxQioi/X5sLs0VjIFDxV
         hEwQ==
X-Gm-Message-State: AOAM531vZSPQhV2A28yB4JJbkDv0pUfCsUwRgMBPL0bo9503XXA8E8Zp
        O5PTyh80gzXdN5qPkkxEPlHCv4RQaonqNUIIrc8=
X-Google-Smtp-Source: ABdhPJyqOsLrMxo9MULEq2qO3NFs8AwfBi004wv8rRc4m80bh2EKw2m1AYwvBCyVi47CVXU745r2dEmx4BVBpgoVVi8=
X-Received: by 2002:a67:e247:: with SMTP id w7mr3746067vse.7.1635263541152;
 Tue, 26 Oct 2021 08:52:21 -0700 (PDT)
MIME-Version: 1.0
Sender: aishagaddafi1056@gmail.com
Received: by 2002:a59:cf85:0:b0:235:f6e1:247f with HTTP; Tue, 26 Oct 2021
 08:52:20 -0700 (PDT)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Tue, 26 Oct 2021 15:52:20 +0000
X-Google-Sender-Auth: 5JYQVMTM79GZNKWVMYbmu4w_pI4
Message-ID: <CANtwLy2DfDfJiTFB-iSzWW_xk30R4VTjdQFG+fP-2zrLQrft+w@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear ,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Mckenna Howley., a widow. I am
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
Charity works therein your country for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply..

May God Bless you,
Mrs. Dina Mckenna..

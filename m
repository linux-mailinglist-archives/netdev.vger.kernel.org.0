Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98153D5B7D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhGZNju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhGZNjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:39:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0507BC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:20:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso200456pjo.1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=gVyrKYsj+6kqYbVi1zLODep+RgARb5G26Sa4qpHWu50=;
        b=RyXKNXrF+waXbrMIhUWUyUbRem2bS5ejjUlZdYf9xueJf0gSiUqzNegGW6rlrySwPg
         1llaGVAq4TvC3iHfGIxRDv4NfMrWx0YQmXa3W/qd9vbik6uS/VbqgDF2T8e/TOFUdI19
         xkwx6jJ32meUItrrz2s8GyOGSHeqi0IeauIqpDXKT2l6ogeRdVWIkexCZNlUgvTfG3Oa
         tO1Q3g2lBcANnkXQvTtMH+19NE6rZark+tdVopfYYEnQcBzfVemlFR4lCSqovxBaNORY
         dlhe7yAUQYax9ZwYtnsHv9OlHRR4pNn+xxasSJN3yCDV+kR3yBDtfPIJMcI2UaT7e3LR
         xWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=gVyrKYsj+6kqYbVi1zLODep+RgARb5G26Sa4qpHWu50=;
        b=OZ4rJPn7nXklqIvw2O3Ye3i2yKOyqZkx+Sy/zVnHkADt/qKBCLRZ2PmbK4AkrB7yDv
         0BqHwefNLNFBfxXpSuSzKvvsPvOoGur88/VzDTK9jZri5VIWVBe3nH6C45vAJVoO8cJD
         yhLaFQd85MNI1ms0v1NMhnzlAN38AW3ZDL0F9hDBb+0vQifKyGnlJozYwwPGqh3/Li/W
         DkmvOcX1tI+IBKAqpFtaYoJ8qdOfWL6sWLrY3WjkdomO45UxvPU/zOORVTGovHwqXvBW
         fHANrdQAizAYNbCV0vqZyFmekh7mten09q1Pvyo5tNyYgs61GKBvvKSrnZQwVp1qJGf3
         gFlw==
X-Gm-Message-State: AOAM533OtkV1zC7z15wR/FIvewQVLMuaakTWDXOoNAQGdEEzjWoTNZzK
        fLiXK8LODjkmAS0BodhQOK88F9J2xIbL98vv7/E=
X-Google-Smtp-Source: ABdhPJyASfh3vMWY0n1PUpUUepfAa5bIA+Kn81Uqo5yL6YnnGgQgnL6zred+eCy6I0Pp0x4Hv3spFxEmK1KigIx3w9g=
X-Received: by 2002:a17:90a:b28a:: with SMTP id c10mr25725992pjr.59.1627309215099;
 Mon, 26 Jul 2021 07:20:15 -0700 (PDT)
MIME-Version: 1.0
Reply-To: soumailagho54@gmail.com
Sender: dr.bashamaugustin@gmail.com
Received: by 2002:a05:6a10:911b:0:0:0:0 with HTTP; Mon, 26 Jul 2021 07:20:13
 -0700 (PDT)
From:   =?UTF-8?Q?Mr=2E_Souma=C3=AFla_Sorgho?= <soumailagho54@gmail.com>
Date:   Mon, 26 Jul 2021 07:20:13 -0700
X-Google-Sender-Auth: nizCNV6Ta5SxiqcyxE_-Eynh0k4
Message-ID: <CAAkDsN7JVVuQ5bnT=j+2B6aFv35k2R8=4Rbso9VxVkL7tz=QQQ@mail.gmail.com>
Subject: VERY VERY URGENT,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,

I Mr.Souma=C3=AFla Sorgho, With due respect, I have decided to contact you
on a business transaction that will be beneficial to both of us.At the
bank last account and  auditing evaluation, my staff came across an
old account which was being maintained by a foreign client who we
learned was among the deceased passengers of a motor accident on
November.2003, the deceased was unable to run this account since his
death. The Account has  remained dormant without the knowledge of his
family since it was put in a  safe deposit account in the bank for
future investment by the client.

Since his demise, even the members of his family haven't applied for
claims over this fund and it has been in the safe deposit account
until I discovered that it cannot be claimed since our client
isaforeign national and we are sure that he has no next of kin here to
file claims over the money. As the director of the department, this
discovery was brought to my office so as to decide what is to be
done.I decided to seek ways through which to transfer this money out
of the bank and out of the country too.

The total amount in the account is USD $18.6 million with my positions
as staff of the bank,I am handicapped because I cannot operate foreign
accounts and cannot lay a bonafide claim over this money. The client
was a foreign  national and you will only be asked to act as his next
of kin and I will supply you with all the necessary information and
bank data to assist you in being able to transfer this money to any
bank of your  choice where this money could be transferred into.The
total sum will be shared as follows: 50% for me, 50% for you and
expenses incidental occur  during the transfer will be incur by both
of us. The transfer is risk free on both sides hence you are going to
follow my instruction till the fund  transfer to your account. Since I
work in this bank that is why you should  be confident in the success
of this transaction because you will be updated with information as
and when desired.

I will wish you to keep this transaction secret and confidential as I
am hoping to retire with my share of this money at the end of the
transaction  which will be when this money is safe in your account.I
will then come over to your country for sharing according to the
previously agreed percentages. You might even have to advise me on
possibilities of investment in your country or elsewhere of our
choice. May God help you to help me to a restive retirement,Amen,And
You have to  contact me through my private e-mail
at(soumailagho54@gmail.com)Please for further information and
inquiries feel free to contact me back immediately for more
explanation and better understanding I want you to assure me your
capability of handling this  project with trust by providing me your
following information details such as:

(1)NAME..............
(2)AGE:................
(3)SEX:.....................
(4)PHONE NUMBER:.................
(5)OCCUPATION:.....................
(6)YOUR COUNTRY:.....................

Yours sincerely,
Mr.Souma=C3=AFla Sorgho

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BF83F6F70
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbhHYGY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbhHYGY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:24:57 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3200AC061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 23:24:12 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so52780161otf.6
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 23:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=pq8QdcgdNxjJmg61r8dPGvWyeowRsap/Qds2NQHbQZA=;
        b=hwdR15HLF78iOt8ftGoruypK21x2NoFBvStAt308kQ8s3zymWQuNcOEjwyIqEQ90gQ
         m28AUAt/zQSV1LprytR0xUyP8ICiP/Gw5tArY/WzE7CsdctDe6CqrMEZUGyqIFT5vjQr
         3+GEN+1leQR5zvJaMDFyiUYJMdRqf2H7zbW+UgDJ0qS0+y5Q/K3fOQcXYQnnV1BrMTBR
         tBCyRdS5jnYTvBAQbtutGbeSFmC2hOLA9Z3keYLKOKaK8tTJPogfBeXlQvgiH/iI+sOX
         E+W833RaDMXfSLCDkOyEzZyl7CFrQcpFxLYK5/M/ITCwYpHo38bVT4y09KfEtg9I3z+4
         qXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=pq8QdcgdNxjJmg61r8dPGvWyeowRsap/Qds2NQHbQZA=;
        b=psnSeXjeM3WN2K5BGr34fz9sE34lhWDKwZHK79pzCGX4Tm8WQgUFEWC4uu839gDnZM
         s7oklAoYyZZJ/G8UfwnfKrgPLegb9hJjO5Yqh/xyc6HxwMhcJKt841wd1WTmjiaTQNqJ
         Y13ArYwyPMchP6ckF5TEnuyFb2ABoVSm4LcQk3hA2A5P25PVKjETgSOFXar7CS4Z+0lK
         FkA/34m99bLzkzcE72Q9cUQ56J1m9u6E0JRyNe5wfPWaGHyxQaXCCL8k3XCVuFqiiU0I
         aXcBnT6aHaJzSqHYPdJqTiKXcNTluySWRq5RBittZhxNabjMD4xnUJZc7iOInToIOTNL
         snRw==
X-Gm-Message-State: AOAM53225erhqNLwDFpxx5UQHm/NB2Dx7Kli7eThA6nqflDolb4J2yJ5
        04chyyaaKfplaohxWOkUXxQvD96tw+cKhorf3zc=
X-Google-Smtp-Source: ABdhPJzynd5kVMYQgDD7dIWAA8dxJw7CPzTrp+kdqEHvmzK4A5h1pNH94UBgp3T9sRp9a6dfkgWvst41wpi1YOS9eiA=
X-Received: by 2002:a05:6830:442a:: with SMTP id q42mr19954032otv.327.1629872651385;
 Tue, 24 Aug 2021 23:24:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: bouchetb@yandex.com
Sender: cc918561@gmail.com
Received: by 2002:a9d:6854:0:0:0:0:0 with HTTP; Tue, 24 Aug 2021 23:24:10
 -0700 (PDT)
From:   Dr Bryan Bouchet <drbryanbouchet52@gmail.com>
Date:   Wed, 25 Aug 2021 07:24:10 +0100
X-Google-Sender-Auth: JBddB7Oc0KuWKPh9Eiwi7G3-2b4
Message-ID: <CAL5z9Pf-eTxyP1qH4RW6Zg3w63RP8B5FwLhFadZDp5xQ6vzVcg@mail.gmail.com>
Subject: PLEASE RESPOND VERY URGENTLY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,

With due respect, i have decided to contact you on a business
transaction that will be beneficial to both of us. At the bank last
account and auditing evaluation, my staffs came across an old account
which was being maintained by a foreign client who we learn was among
the deceased passengers of motor accident on November.2003, the
deceased was unable to run this account since his death. The account
has remained dormant without the knowledge of his family since it was
put in a safe deposit account in the bank for future investment by the clie=
nt.

Since his demise, even the members of his family haven't applied for
claims over this fund and it has been in the safe deposit account
until i discovered that it cannot be claimed since our client is a
foreign national and we are sure that he has no next of kin here to
file claims over the money. As the director of the department, this
discovery was brought to my office so as to decide what is to be done;
I decided to seek ways through which to transfer this money out of the
bank and out of the country too.

The total amount in the account is (18.6 million) with my positions as
a staff of this bank, i am handicapped because i cannot operate
foreign accounts and cannot lay benefice claim over this money. The
client was a foreign national and you will only be asked to act as his
next of kin and i will supply you with all the necessary information
and bank data to assist you in being able to transfer this money to
any bank of your choice where this money could be transferred into.

The total sum will be shared as follows: 50% for me, 50% for you, and
expenses incidental occur during the transfer will be incur by both of
us. The transfer is risk free on both sides hence you are going to
follow my instruction till the fund transfer to your account. Since I
work in this bank that is why you should be confident in the success
of this transaction because you will be updated with information=E2=80=99s =
as
at when desired.

I will wish you to keep this transaction secret and confidential as I
am hoping to retire with my share of this money at the end of
transaction which will be when this money is safety in your account. I
will then come over to your country for sharing according to the
previously agreed percentages. You might even have to advise me on
possibilities of investment in your country or elsewhere of our
choice. May god help you to help me to a restive retirement?

(1) Your full name..............
(2) Your age:................
(3) Sex:.....................
(4) Your telephone number:.................
(5) Your occupation:.....................
(6) Your country:.....................

Yours sincerely,
Dr Bryan Bouchet

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFFE6DE450
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDKSwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKSwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:52:11 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B516ED
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:52:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o2so8767738plg.4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681239130; x=1683831130;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n4pN0D9VuThWZUSG0wK1df2D171dEbvuMFuz0NllzvM=;
        b=Vs7ENtiSFilGoHj4/8ZDRf442TEIeezBAvS4PRB/+Nzh78kfMyJDavBHIF+LWO0vDs
         zDKjxmVn//oEyYZk0c3WQm8tOAHI94qOXjgBn6BhpU1wYfjJ+D/tYhJ79B+tygDDur8K
         GDFJfJvd7nS9NU7F7B5TxWSTEX8u0CH+EH7BIzaGWiUz8d0K9uSrgS9BzeieWRvEuXFk
         KOzWkTPvtjrme9ufnqwdhh0Z8f07zlmy40X7SiOETNixVaEnu6ZxmOwbXz0pjQcelybO
         E/ZIFNQjIvsuWm2zZBh2pzBFnTYRGbgfVMLPZXEVRexWOgw2zvP0NYot6VNuen34sdIH
         TcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681239130; x=1683831130;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n4pN0D9VuThWZUSG0wK1df2D171dEbvuMFuz0NllzvM=;
        b=u8AUd2f30ntQehhR4vwXsQyQ+qbHd2FSn5j4iuwcSid0AOyngTAGc0LYbi4jOJVKjs
         TvVD3RuRWUxfzlHsgpmZcK5TJi1QKJrtfwrfbqIWGIx3uD1SKt1Yc/1nm+JlMZFMr4K8
         RKk4/INbPvxSVe2LF/ZAW8nHXOgnhbyiJTzq3JpzYaowQdZlDPAkjVmas4bjggX7aWUS
         ggEgMvC3fAkt6wT7RV33CQEzNcSrnMBy5llPh7TISlc9tHE/1oJn8cjuRmRJ5LtUjEc9
         cs2goPTdsKpKsFPZw5t35A9Cc0zRxeaSXTkH3ADPKKwVHT2dLRx13RLM0iMjVFNBpqMw
         yKHQ==
X-Gm-Message-State: AAQBX9cnnbqOIBmNqHW7HDWycSgxSvb14y0dOChV7IuJJZa82xnGedAc
        /udnchQdrKycoZEoZnwJjhOx2hfM2HO30w/bvaY=
X-Google-Smtp-Source: AKy350YUXvfWiLO8Tx8f/tkZ8h/wlIIdMelsMdpBUsP53nrFavTY+AUnRUqZaKp3GJI9Q2nNiTRhMQwIV8+1PHw2f2I=
X-Received: by 2002:a17:902:f80f:b0:1a0:7630:8eed with SMTP id
 ix15-20020a170902f80f00b001a076308eedmr5322826plb.11.1681239130011; Tue, 11
 Apr 2023 11:52:10 -0700 (PDT)
MIME-Version: 1.0
Sender: patriciajohnvan@gmail.com
Received: by 2002:a05:7300:6c15:b0:b2:1f8c:a98a with HTTP; Tue, 11 Apr 2023
 11:52:09 -0700 (PDT)
From:   Dina Mckenna <dinamckenna9@gmail.com>
Date:   Tue, 11 Apr 2023 18:52:09 +0000
X-Google-Sender-Auth: MsV19ReuEN3XaNWxxKV7WdtUc3Y
Message-ID: <CAHqodhRLEmeVcw=UnOYB+cnyE0+4PpD9Zz4vigTH_OAp04-pSA@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.9 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:643 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [patriciajohnvan[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
and glory upon my life. I am Mrs. Dina. mckenna. howley, a widow. I am
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
my late husband, the sum of ( $11,000,000.00, Eleven Million Dollars
).  Having known my condition, I decided to donate this fund to you
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
love and care for..
 .
I'm waiting for your immediate reply..

May God Bless you,
Mrs. Dina. Mckenna Howley.

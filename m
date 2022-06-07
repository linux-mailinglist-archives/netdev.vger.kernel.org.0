Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD71E54033F
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344700AbiFGQBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344690AbiFGQBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:01:36 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A9CBBCDC
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 09:01:35 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id x187so17121196vsb.0
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 09:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=94FE0xqKYNBQJ8bbUNfhKNNPOc38KM25jE5hqWXLeJ4=;
        b=IXIi3pwKmHuSH0YUwLAgS849Kb6tOeQRr2nl72fYIONs8ZItQm7uXnIehyYe+jk89U
         wLIoj8o4hu9qIpXsbCOX6fCKtXZsLRpjNc9fiGgCSjBsmR3FQCq6iifRyxfwInL3wneu
         J1JLekxCa9rKhYwsRP9j6wmq4rxlDbp+usL2OO5wmw7hjTctgpMA7Solto5MXCRBouVn
         UoKZtskF5cQjRyU5vCyVdEe9NEGMV+mXgKI4wdae74nce6nk9ONXwK2ePq9LN7PbNzEX
         1EbnHTSafRLfZgwFbwTootNdMy0eKvfJ1W+qFvr/FtWZzWz+VvYXUn0zBV/LL8Bz9/qI
         pRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=94FE0xqKYNBQJ8bbUNfhKNNPOc38KM25jE5hqWXLeJ4=;
        b=yaKiYtgxgq3SC601TJE8uXOyx7tfGArlRFNTKA7lj3gyuOWUyk4PX7H4k7y4+bt+lP
         zaKtpflvurwpgpHNhO8JucqoY7jkNaltFPIcPMDi1aGqVbxlMSUvhU2Ci5O5AR7uhHXG
         4VwTUtUCoHFgoOhi4CHB99JbQ8apSn3izUXmxYfdvcStjdk+W+QoR0k8W8VWfYkjTT56
         OFWHqhwLZWWEHjn2aoT9nUOki1o+6YBZdlbWq2mR2ufZ94+TNXHCzlp6FsjFazQvFGZ7
         NGIXdGV9oU4JDZzTUtwBJhXdDV57dkwnibWzZLw6rgdlCUJPj5eNYt0AB+MUf9LSb8kq
         lk/g==
X-Gm-Message-State: AOAM5315xY4gXK81Lckk9Wg+rtbPRCFPdAVupm9ugMnv3G6elJPOchi+
        ZbpACopPgSGzUrrSHCpuzCEUsQny4nWwa+zQN/U=
X-Google-Smtp-Source: ABdhPJzVqHVH0oIk66rkjYwkEvVdn7jw9KWZLE+6qVJuXGLzSFHnoWqZ6t8foQxqetPvVFVKupw/nxLyfFyb0Y5QMWg=
X-Received: by 2002:a05:6102:38d4:b0:337:a198:2fe9 with SMTP id
 k20-20020a05610238d400b00337a1982fe9mr13476878vst.83.1654617694271; Tue, 07
 Jun 2022 09:01:34 -0700 (PDT)
MIME-Version: 1.0
Sender: donnamcines@gmail.com
Received: by 2002:a59:1d43:0:b0:2c9:df44:bbb7 with HTTP; Tue, 7 Jun 2022
 09:01:33 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Tue, 7 Jun 2022 16:01:33 +0000
X-Google-Sender-Auth: GYPF1vc7j8vGcW5f6Ux1_MfKWKw
Message-ID: <CADM2P8kbJwxhYi1SwUMO2bD7Q7v6KCvfcNF9x6U2V8M=AWBrVg@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.0 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e41 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8157]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dinamckenna1894[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
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
next day. I bring peace and love to you.. It is by the grace of God, I
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
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for..

I'm waiting for your immediate reply..

May God Bless you.,
Mrs. Dina Howley Mckenna..

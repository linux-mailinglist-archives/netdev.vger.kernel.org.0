Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF05131C0
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiD1LAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiD1K75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 06:59:57 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC2E522F5
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 03:56:43 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id j9so3292746qkg.1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 03:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=wvpxxo3a5bHi1CUU3MwurmZco1iQcN9Goz26mekYyCY=;
        b=CTrAZkwDX4W92O0ykTEsOaTEc2KetdD4RliZq2QPqEVv1ijGAEUO9rnV5nv/FPupxQ
         XSB1W7MbpRnNGHiR8D/+kK9aH0go36wexOFmb/VVezQLYXlVm95oUs97JGCBnO3SLZda
         YSBPnWoF7TPjQaS2US50QJ7dd2p158n6T2UoCNwPXL2Ry+/nHGvxVN1NqPhROs8rkcLZ
         kE6pibqRzqMpx5DSyZBGqgi0czWAkQfVA/wOPGRkTMJ440SyPY3Gy+cqCMyNaojf2puD
         3UjKy8ODF5qP5ScdQl8AWVetm381kLwUl3eYIyVyoB2152k9qpAt7eHzsApcker5NWtm
         FMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=wvpxxo3a5bHi1CUU3MwurmZco1iQcN9Goz26mekYyCY=;
        b=227Tf9SGsy4lDh+QkBf+FeRZOjKCu1RKVGfDtWYdFzWo2V4Zk0pQAIwFVELulqXIgR
         Hj1MtOrhmIkbZdHRkTpiOVgbtG6kpGCaxBbakGAtPz0ZstdVZo+PxXc6Qda2q7r0a5i7
         ETq+C2/Md8ziNt/qZgXE7VM1MWxFaj5TxjHozq8GX+YX/oj4hjC2j5gKtwfD3VyveqV2
         MPA2WUj9SBlKptmi7WTOd15JqIsTaMQPsmZv1Jb7vuzn+jKGxhoEtf7rRnP5Ko+MERRK
         k23smc+rw6ursFpvnNg+X1kkgTeAR0oWBtPBhcyl9lzu22xUQzhV9Aw7w4T8nANwXCJE
         rdvg==
X-Gm-Message-State: AOAM532g59960Tun5vwJnTcJi/1HXRS1rC8G/xs98YJZ7Tabgl5nfOGw
        l3UK7/YF6qS54mFRG94vu2zVNnDxeV4znF3ai5I=
X-Google-Smtp-Source: ABdhPJzTT+s2qwZTxQIzSXYWdxKSXX4tnjY8HJDgLkM8eA8caLonSSzS07GtpQ7cCjtsmeB/CtTH/ghFgyLtFnD3U5k=
X-Received: by 2002:a37:683:0:b0:69f:9bc8:720e with SMTP id
 125-20020a370683000000b0069f9bc8720emr3088081qkg.660.1651143402477; Thu, 28
 Apr 2022 03:56:42 -0700 (PDT)
MIME-Version: 1.0
Sender: dongheiram@gmail.com
Received: by 2002:ac8:7dd3:0:b0:2f0:d4b:d2e6 with HTTP; Thu, 28 Apr 2022
 03:56:41 -0700 (PDT)
From:   Aisha Al-Qaddafi <aisha.gdaff21@gmail.com>
Date:   Thu, 28 Apr 2022 03:56:41 -0700
X-Google-Sender-Auth: ixjO8DIFVMTh6mqE0RdtmT8lAPw
Message-ID: <CAJGwrKGkAbnpVj+9bHHm_PBeuSbeNZu417W__w9ek1nmnpkWZQ@mail.gmail.com>
Subject: Your Urgent Reply Will Be Appreciated
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_99,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MILLION_HUNDRED,MILLION_USD,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:744 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9977]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aisha.gdaff21[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.7 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.6 URG_BIZ Contains urgent matter
        *  2.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I came across your e-mail contact prior a private search while in need
of your assistance. I am Aisha Al-Qaddafi, the only biological
Daughter of Former President of Libya Col. Muammar Al-Qaddafi. Am a
single Mother and a Widow with three Children.

I have investment funds worth Twenty Seven Million Five Hundred
Thousand United State Dollar ($27.500.000.00 ) and i need a trusted
investment Manager/Partner because of my current refugee status,
however, I am interested in you for investment project assistance in
your country, may be from there, we can build business relationship in
the nearest future.

I am willing to negotiate investment/business profit sharing ratio
with you base on the future investment earning profits.
If you are willing to handle this project on my behalf kindly reply
urgent to enable me provide you more information about the investment
funds.

Your Urgent Reply Will Be Appreciated

Best Regards
Mrs Aisha Al-Qaddafi

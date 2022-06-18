Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E45C55050E
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 15:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiFRNVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 09:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRNVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 09:21:11 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E69B13DFB
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 06:21:10 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id k20so995527ljg.2
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 06:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8d0a50vlXPwK/evqvKND5Qkww0VWt34LxBu4KEjcCqk=;
        b=nqxcaNGEJh6YWossbuciAc8s4sqU+wEN4VBnEGztRRhKV4OGbIIE9A7axVgSzBmE+r
         wK1MEEXqGnEALP/4NIlENbCzCmTtz1dlXC2/BRQ7YF9J4B299E62cKHVd+Traq/N6oEE
         CqRTiUhE9NVbsr+zcXgsf31vWPt+PfC00GsqgmH09vpWap+iBhxFM4OFvCynUjIv0lRQ
         VV5pk9eAS0rId6YBDu0N24njhqSW3uKFuQJWjAq+H/wpmqzPN3XPs5Q+NfxID86XghCZ
         3JXRE8x+VU8ZN4PDQ8ScpoXvZHdMidyDMRqbR7QHGBa3SUA7P3l283/vQpAs6ANEAMVH
         QSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=8d0a50vlXPwK/evqvKND5Qkww0VWt34LxBu4KEjcCqk=;
        b=Pg+mpOyqF3PwycLoMmLjPr0IEqBm8/9WqZCGToCJKue6gLFeHbSYcfcqd4ROeu2wk0
         7AG5dLBD3M79qwYuDD1dsBnT6t1fJvvM8oT4h69NdzkbxJOX8JQxTiw38U+ZL/a3Z3nr
         4E5N5ocIOcHdbU/8etALMWBGKJ9xkwtfFhlV/juKEWMrzIAo5MbxTSa8rOLix55sLALZ
         Db5bbd+7LfTq022i2B/cbDJVtNHnFBk3fEQXrueXtaWAF41j/na829G0/25MKNaCgCwc
         cz7dCKzHvBerRWPkjyR4ntZi6zKt/Llbdg6CkWbYG3c92RSS0UpOCfMLk142BZUHnKGX
         D7xQ==
X-Gm-Message-State: AJIora/W2jZIyQcilbLiJpVmCkJ+aUFDUSfz5/1aONN8pg6qwxeZHG3B
        4croSv0pfEKOPCoT2nkeg5x6C0bTw5Qw0NCe9Ug=
X-Google-Smtp-Source: AGRyM1uUgHwLDfvL789fyrv4qqITUJEv6JaewgME+3nYBNgcsiOIbQTaS2lWVX7QLzDr57Y6EAg9tutlhY6F8P9Us5c=
X-Received: by 2002:a2e:9047:0:b0:255:70eb:9634 with SMTP id
 n7-20020a2e9047000000b0025570eb9634mr7353461ljg.521.1655558468195; Sat, 18
 Jun 2022 06:21:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: evelynjecob47@gmail.com
Sender: mr.selatnia.moura@gmail.com
Received: by 2002:a05:6512:318f:0:0:0:0 with HTTP; Sat, 18 Jun 2022 06:21:07
 -0700 (PDT)
From:   Evelyn Jacob <evelynjecob47@gmail.com>
Date:   Sat, 18 Jun 2022 06:21:07 -0700
X-Google-Sender-Auth: fnIIiNyDtBX6w47SXxL3k-X3k-8
Message-ID: <CAMm+SZWdHvsdMpNZCg5ayEo9FGvZb0bF20xvsUTSi=LWT7FKBQ@mail.gmail.com>
Subject: Ms.Evelyn
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FORM_SHORT,MONEY_FRAUD_3,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:244 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6073]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [evelynjecob47[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [evelynjecob47[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.0 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings dearest

I'm a 75 year old woman. I was born an orphan and GOD blessed me
abundantly with riches but no children nor husband which makes me an
unhappy woman. Now I am affected with cancer of the lung and breast
with a partial stroke which has affected my speech. I can no longer
talk well. and half of my body is paralyzed, I sent this email to you
with the help of my private female nurse.

My condition is really deteriorating day by day and it is really
giving me lots to think about.  This has prompted my decision to
donate all I have for charity; I have made numerous donations all over
the world. After going through your profile, I decided to make my last
donation of Ten Million Five Hundred Thousand United Kingdom Pounds
(UK=C2=A310.500, 000, 00) to you as my investment manager. I want you to
build an Orphanage Home With my name (  Ms.Evelyn Jacob) in your
country.

If you are willing and able to do this task for the sake of humanity
then send me below information for more details to receive the funds.

1. Name...................................................

2. Phone number...............................

3. Address.............................................

4. Country of Origin and residence

 Ms.Evelyn Jecob  ,

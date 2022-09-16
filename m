Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3415BB1D7
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 20:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIPSJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 14:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiIPSJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 14:09:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407B713F8D
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 11:09:45 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id s6so25598639lfo.7
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 11:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=sOPh3xdy9STyxBKWDZT4NWqT8k5n5/v6Q6ABGSLdyiI=;
        b=btT0zFqrDzp3BLLuPwVaXNS/iqPncM0zy6FpNE6XU2VlXfJVsYGNxIGRVgkDtuVXox
         AcNSVVvubkG48u4KUaXID8XpiV5iC8j1NTJ+ZPUUu/5+3QFUmlhdxRktBxHY8EKSCTmB
         UyMnM95B5esiTm2118Xd3hrRX1YkE+PJrDvROH4ZHzunWgM805MbBuCrd2TJvbKlklaR
         ZM7v3r1rF9DN7rihSyhP2iAyq3P77jUs21BUZv3TygBgI9EpzaEAPMrCb9fL94WKX7fd
         a36zRKoCtheeVCosqJTYwG7aE4WgYgKMqcRWqN7Q8YEu0RNQuRnIqo2cielYCtuQf7Yy
         0cLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sOPh3xdy9STyxBKWDZT4NWqT8k5n5/v6Q6ABGSLdyiI=;
        b=wuyZ9A1mDYpFIn4CWoYrW4fnJ8YzvONDu/K94ktx3auL8wEfatVtkwNJzuWePqstEJ
         dAA1lPBFkPXkKZjJ70ObPaLgUe3t4S9cAm7s3Iz7VwPCJRFZNSjjrSbiy6zSVB628NXw
         ZhntzUsVASzL/8SqE6OpCNHghFFT7jx9ZxNMFLY+FCCy9KI/C4VGv5Q4SRsYNbNmchY2
         XtfZ7kUJSrlj3VZo60IHoNFpjtY8NC949CWxaYnzlG3KSOYESOXXq1vrxI6Y5ob29hpD
         weeiyNGV4s/ZpGUd6w+IbsOLxb5q1EJQV9bW1jRARhvdE6CJQKvgSny9Y2NUq5E9m8f0
         uvFw==
X-Gm-Message-State: ACrzQf1hudq7PvzljMp5WJ7e+APy8ZuVC9SaNDkmgUJtKhAodPv1NQ1d
        M5O98Y8LQsfu3CN/RIP0R6kVVG1jQ64JL5cRMaM=
X-Google-Smtp-Source: AMsMyM4ipXdeB5M93k4ihSzCpzpQO3oIpP9Epr4V7XoRwZyNAwm55uMZQP4jWSil+mIjqwURGiaEHf2yspWjPIaJzCU=
X-Received: by 2002:a05:6512:10c1:b0:492:a27d:ff44 with SMTP id
 k1-20020a05651210c100b00492a27dff44mr1974627lfg.405.1663351783329; Fri, 16
 Sep 2022 11:09:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:9e8d:0:0:0:0:0 with HTTP; Fri, 16 Sep 2022 11:09:41
 -0700 (PDT)
Reply-To: lindabenson6666@gmail.com
From:   Linda Benson <70573774l@gmail.com>
Date:   Fri, 16 Sep 2022 19:09:41 +0100
Message-ID: <CAOK1pWAYjPO0Qgi1cFvWxMAaSi21H0no4XmiM4A33bd9A+L6nA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12f listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6557]
        *  0.7 FROM_STARTS_WITH_NUMS From: starts with several numbers
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lindabenson6666[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [70573774l[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I wish you health and happiness

I am an orphan child Please I never want to disturb you at all but
I=E2=80=99ll like you to give me your attention I=E2=80=99m looking for a r=
eliable
person in your region to help me out of my present predicament, I need
your help and assistance in the transfer of my inheritance fund to
your bank account I will give you full details on why I want to do
this

Reply soon, it is urgent
From Ms. Linda Benson

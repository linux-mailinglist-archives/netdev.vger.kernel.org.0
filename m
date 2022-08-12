Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A28590BF4
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 08:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbiHLGYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 02:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236418AbiHLGYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 02:24:01 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4E9A50F9
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 23:24:00 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h138so132817iof.12
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 23:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=XD21JD+K+a8oVdMsdQOvvYNmKdGALvhGBN389+nvhDQ=;
        b=EpW5Z5TgciYDdB6xfCcptx1QN4MlIUlFnJBMVXWDlW1a4zQZEMQbvFAGv41yeW49GF
         jyXXMWqu0I10clLPZu3+lHOkW1MJlixk7Z6dw0D2x/nbdtuTzuzFyXKUA7eT8wd+Trrt
         +vBfqFKH9BFP+uC4U9A9lPJ/FaNmrwELvYSq5hR+iD1Rx7xXKe8DKX1ECvWw5g2LkT8+
         enbZINT+q9Xn4BsiJHpj0LNBloShalwpn4/i2YatPSzSy785EAERgeHGmj5XRw7X+dmL
         1+eJb7oIt/l8UD87AWdTiVhDU9Ncl65i2Kx17i50S1RVocLjPREv8IoMtIIyp9mhssSC
         RHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=XD21JD+K+a8oVdMsdQOvvYNmKdGALvhGBN389+nvhDQ=;
        b=22j5XD1fwJl3wC0nSzmDpyKkz+IWCxIwiQeJlRM7CGCP+ml5p/i3Wj24WByU9Yf/pL
         msnizq+GE4fTRbANZC9yw02PyIZExl97YYoxx9BUWU91EcHklg7pXsH24fBdIGMKX67c
         xBShDY8fw03Lv3e9+3FB9FUbyA5zCEQifgMDf1FfzuxMwZMn8CNUYQU53V0qjnYHaKhL
         +aNR5QAbfOYXpOq5txU3tZd23QNR3c6nqaIgBqU+4ie2FigCm+LR2twHOfo4RkOHSbth
         K64FQtHLoMM+Kv6tqe9IdwxIYNfd24kHvEznGHP1I/a3Jqv0w5l4mHaBHnymvgrXIbTV
         +tWA==
X-Gm-Message-State: ACgBeo0qHhcIof2CgKAGdIJdyN8FZfqzATlZ7zG2JloiWIR9xPSBTzCd
        OE+d0e2h/Ue2V8IJFVMuMD15lHDzDP5abKCP1Jk=
X-Google-Smtp-Source: AA6agR6IAWoGWAQ6CxQqGx0K5ZehLPKDALqk6UYkGhSJY0WkV+2S1xH5c1VQAx7jfPi88FK4Do7DdayAk5mLTDxfKL8=
X-Received: by 2002:a05:6638:370d:b0:342:e3cf:5be8 with SMTP id
 k13-20020a056638370d00b00342e3cf5be8mr1250356jav.127.1660285440299; Thu, 11
 Aug 2022 23:24:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6602:2d47:0:0:0:0 with HTTP; Thu, 11 Aug 2022 23:23:59
 -0700 (PDT)
Reply-To: warners@telkomsa.net
From:   Yours Faithfully <99onlinemasters2022@gmail.com>
Date:   Fri, 12 Aug 2022 07:23:59 +0100
Message-ID: <CAJ6qs-y2COUAd-31aLm1XEfWdMO8GFYdJ1x0taLr1CTZ0QKZNQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_4_NEW,BAYES_80,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d43 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8639]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [99onlinemasters2022[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [99onlinemasters2022[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.2 ADVANCE_FEE_4_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
I have a proposition for you, this however is not mandatory nor will I
in any manner compel you to honor against your will. Let me start by
introducing myself. I am Dr. Smith Lee, Director of Operations of the
Hang Seng Bank Ltd, Sai Wan Ho Branch. I have a mutually beneficial
business suggestion for you.

1. Can you handle this project?

2. Can I give you this trust ?

Absolute confidentiality is required from you. Besides, i  will use my
connection to get some documents to back up the fund so that the fund
can not be questioned by any authority.

More information awaits you in my next response to your email message.

Treat as very urgent.

Yours Faithfully,

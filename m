Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D4551E68A
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 12:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383994AbiEGKte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 06:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343737AbiEGKtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 06:49:32 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E1F13EA3
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 03:45:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k2so13170528wrd.5
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 03:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=VKCKWY3pNK4bqqNossvOh9G1q+xPwVvjW+fqomdEuhg=;
        b=U9OorGL4Eu3AsqBKatzYNPhFu7/IQyxn8mSGazjtFEC1Ec7Y2OJ5LGUZ14qMbGJ9nv
         fSdCQJ/wZoTZtH/t25+QNXampkRqqStCj+zUofCU/w/j1BEnMV9+N9nkwt4YbQjbOi26
         dxQYhj38PddmR1HUqxCgOqTWhnEv6RGtiShFk0Kgy2AmUPXj+3FY/a0gw468OTALP4/y
         1WG+cfvN3aL5pH0tDKpRxFPmbR8KxkGxgUh78R4S3pQ18n+rMX41fx9XDL2cxAskXbIC
         9srN/ZXyY1STAdR/DjGIJ+vlMqV9dlK+n9OZY9ZaBVwDSzRz1DzHoeeNGN4ypAtnFq5n
         EQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=VKCKWY3pNK4bqqNossvOh9G1q+xPwVvjW+fqomdEuhg=;
        b=sTI2OiI8vOuDMG27Vnh5VoAK5wEZsyveBKA5SGJvVUwEnKvcSPp7G0idBt23DqLX0U
         AZSKc5nRTqyKM9fPRabfW3z52lmVjzNTC7owyPC3aGFmQZbeJW3POjG3A6b/7jGN2TDj
         7xMUmWJ/3ysVNMI3qtNGYJVXhmyIrHotbAsr9szxBj6qQUTU1EzelYNKJMquCNt9V8W7
         gwTAEcVrNlwFpsLvX/AMI7ThCZu7j8nW+S4yWwo8Kehoqc47f9k33GbWOiWWqYqMeZF9
         jVFyYvptiDbaU+XVGjywi9e8+Yhm5CLJV9lhMd5RslERvdVbGspgAHbu5MSxrH6FG5CL
         qLDg==
X-Gm-Message-State: AOAM531w/QOgCSAs71OPueV+FvNEbWpXRiFj/9tdSSxjY+rHe7l8db2V
        JvBp9zFYsV62fR5A/v7qF+2exjzoTPJcizentow=
X-Google-Smtp-Source: ABdhPJxotd5NmTa/WCE69Rt7j/kEln98RivSLoJzwziUB8NrLgxTgRsjGsXCbhqW7Lyd8/OeoKx40Z0lyq///7Cc+UE=
X-Received: by 2002:a5d:6d0d:0:b0:20c:530c:1683 with SMTP id
 e13-20020a5d6d0d000000b0020c530c1683mr6085234wrq.109.1651920342923; Sat, 07
 May 2022 03:45:42 -0700 (PDT)
MIME-Version: 1.0
Sender: azziz.salim00@gmail.com
Received: by 2002:adf:f646:0:0:0:0:0 with HTTP; Sat, 7 May 2022 03:45:42 -0700 (PDT)
From:   "Mr. Jimmy Moore" <jimmymoore265@gmail.com>
Date:   Sat, 7 May 2022 11:45:42 +0100
X-Google-Sender-Auth: DWmAe8eEOfuZC7vGWTbQd_ZqEWg
Message-ID: <CAOhmN-HwwNOGxj37Pngb=spdivoehGtvfJ8OLr2y+HdR9ZY_mQ@mail.gmail.com>
Subject: YOUR COVID-19 COMPENSATION
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,HK_NAME_FM_MR_MRS,LOTS_OF_MONEY,
        LOTTO_DEPT,MILLION_USD,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [azziz.salim00[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jimmymoore265[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  2.0 LOTTO_DEPT Claims Department
        *  1.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UNITED NATIONS COVID-19 OVERDUE COMPENSATION UNIT.
REFERENCE PAYMENT CODE: 8525595
BAILOUT AMOUNT:$10.5 MILLION USD
ADDRESS: NEW YORK, NY 10017, UNITED STATES

Dear award recipient, Covid-19 Compensation Funds.

You are receiving this correspondence because we have finally reached
a consensus with the UN, IRS, and IMF that your total fund worth $10.5
Million Dollars of Covid-19 Compensation payment shall be delivered to
your nominated mode of receipt, and you are expected to pay the sum of
$12,000 for levies owed to authorities after receiving your funds.

You have a grace period of 2 weeks to pay the $12,000 levy after you
have received your Covid-19 Compensation total sum of $10.5 Million.
We shall proceed with the payment of your bailout grant only if you
agree to the terms and conditions stated.

Contact Dr. Mustafa Ali, for more information by email at:(
mustafaliali180@gmail.com ) Your consent in this regard would be
highly appreciated.

Best Regards,
Mr. Jimmy Moore.
Undersecretary-General United Nations
Office of Internal Oversight-UNIOS
UN making the world a better place
http://www.un.org/sg/

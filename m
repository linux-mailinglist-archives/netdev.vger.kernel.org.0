Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD214B9FA1
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbiBQME0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:04:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiBQMEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:04:24 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0086433
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:04:10 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id m17so9124898edc.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=lY9tt/IhIWv9LzXk1s5BH9xemeCbBCE2YYRK5FOvrNE=;
        b=ahf4tqfrFjuYg7WtzdBkP8qdfAzY9nRTTSNAX/NBKtRbCGvmRjdSXfRPfMoDY+13xM
         QHgIY0vC0r8rwGUGWHAvAOPqs9GdDKtrMsUOxS3z4ToOc1mXWPN23F5+I4Hz/xHgoIZO
         uTGKWlFlvJt7nQRe7/l/tuO+cNjX0Cn0l9v6d3X+Yft8UptY+ont53ZLK8xmLivngM/J
         Xk/J5ZEg7hc+vKG/DlfZacdCVSAZMVeVFRqW4zS7JStct+v14M3FtERMFCbYqytghwSd
         4VkxnVKT4l6xGxBT4qeYsnuIXp5ShDFelFm/BpcKmGxMwyYTKUUkrWbdA2kfB5oa/iKV
         04CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=lY9tt/IhIWv9LzXk1s5BH9xemeCbBCE2YYRK5FOvrNE=;
        b=4wiiN32GO1GO9iZPWe/wkJcbL97i5BtYKja/dU+3IrQXRkc4sw9bbt1GL+Ff3GQuOz
         ZbFfK587oTorReVqFmUv26SWpeZP8aEZo1f2bKAJyg+v/TZfZIT19Ax/MC0nvIyjzVor
         D1zxr/+hfy51hFZU7ZFyRe8zdtFyGtzf0SbG5/yP1UT6OFWUcn6CT1LaT9gBiVDK354y
         p9Xu0Whw0fwjrvM0/O118fZX7FmrWN62euwVre/DX1hiDHj6WC4UIG8Gzcx5YFy8lyFM
         A7/3XtDeqEK/ySyLJwmd0UeyyLE8uMuk2M391rmIpLo1qRzN3RUlSFPW/YfkmklJil/I
         sX5g==
X-Gm-Message-State: AOAM532mZV7cvJABPbrxiDuLxFTI/O/HbNPi5HT4ifi9bSrmYYsh4PUe
        6r1hxgDPhSk/BQz2ba2jyoWC8QCcHY8WvpRRxB0=
X-Google-Smtp-Source: ABdhPJx9WxEs1LfRPUCHM1lsQC/c70qpHAvLPBCjoYLN9OgxTJmOEVQo3raWrzmhnShh3aKsyCNNIYnB2Lqmg09S+8o=
X-Received: by 2002:aa7:d4ca:0:b0:410:d232:6b76 with SMTP id
 t10-20020aa7d4ca000000b00410d2326b76mr2260593edr.370.1645099449416; Thu, 17
 Feb 2022 04:04:09 -0800 (PST)
MIME-Version: 1.0
Sender: wizguy687@gmail.com
Received: by 2002:a17:906:fcd5:0:0:0:0 with HTTP; Thu, 17 Feb 2022 04:04:08
 -0800 (PST)
From:   Aisha Al-Qaddafi <aishagaddafi1894@gmail.com>
Date:   Thu, 17 Feb 2022 12:04:08 +0000
X-Google-Sender-Auth: mI1cGnCYZ211b2K3KFx8BNvZKHg
Message-ID: <CAGNBjBeihodPfcABymy_5=kA4Bhttr6-ws976Ea0YNBpw1VU7w@mail.gmail.com>
Subject: Investment proposal,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:535 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5030]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [wizguy687[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [wizguy687[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear Friend,

With due respect to your person and much sincerity of purpose I wish
to write to you today for our mutual benefit in this investment
transaction..
I'm Mrs. Aisha Al-Gaddafi, presently residing herein Oman the
Southeastern coast of the Arabian Peninsula in Western Asia, I'm a
single Mother and a widow with three Children. I am the only
biological Daughter of the late Libyan President (Late Colonel Muammar
Gaddafi). I have an investment funds worth Twenty Seven Million Five
Hundred Thousand United State Dollars ($27.500.000.00 ) and i need an
investment Manager/Partner and because of my Asylum Status I will
authorize you the ownership of the investment funds, However, I am
interested in you for investment project assistance in your country,
may be from there,. we can build a business relationship in the
nearest future.

I am willing to negotiate an investment/business profit sharing ratio
with you based on the future investment earning profits. If you are
willing to handle this project kindly reply urgently to enable me to
provide you more information about the investment funds..

Your urgent reply will be appreciated if only you are interested in
this investment project.
Best Regards
Mrs. Aisha Al-Gaddafi.

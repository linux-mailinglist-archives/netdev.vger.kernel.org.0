Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE85752C71B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiERXBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiERXA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:00:56 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E9FEE23
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 16:00:54 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2f16645872fso40191997b3.4
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 16:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=m737Nqvc/KIg6gxq4zKsjcACSEPn+xcdgSxVPjita4ziZ+Xh8PgDEoP9rnBTvGzOTk
         z64JSD5gGTA4JOaTz/Lm4HzMQ+hhOr7rvR5o2L04f0ly6joq4F8ShUT5YKvBD5CSa9jx
         qjPACLUncz4281k0vPHtHxJn56k6QNSzC08CSmTju7J0KRM0tXYntMi8z2keA248GDiz
         KruU0ZugdGIanyCL1KIN7CWDV9/R3PoDFh9KaE5/uHUdNhT/S3pT/8U2ilhlAXtOJPHa
         Gihg053sD6ZKxvMPNoxmZFNKqAyv5DO0jzvcFzvblWf/vSTa1LNS64XXExGG34VFSo2R
         4xcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=AMrURYf8OUq4DbDqs9Hd0tMZVr6ALgjaMRgx1m5RqkGEA2Mc+Ng4HBS4plkFv066Vu
         CHXd3mDvgH+dgGLMPsqfA+DkzZtB5oLZy4poDx0Qr6T0jpVon+65TTlUsta291GGjtud
         yMZ9LbgpPQ9X7XLQa1ILTfJpt/h173AbzHftpzVGm6iO3LxnfNhfVEVgujF9RyTDEjmT
         kdnBaJpNxymGEqF6SDYd575jSenUvGhbgRVjrwuWyM2Lts5EEXOm66QBsJOmNyyZuFDs
         UeG5A+ilh6rF3N2orMm30VBC9ZUVZlv3yqpq24Pxo8aZpCK86c5qnK9pgCTl99FyepM8
         /kHw==
X-Gm-Message-State: AOAM533MOmRs1QG7v5yXZUBxVsbneM3no492twXccTtq8xBleE3N7mEK
        98f7sF/fP1iqzmh0n2NNGaVaRYuQRT8zJS00t5Y=
X-Google-Smtp-Source: ABdhPJxNvBBmU64IRJMsNa0tB8WN6c26E7xASM5cp+9eoH629euZwdQpN5agfvXg8Hv859+QtIAylruVf29GfOV0Efg=
X-Received: by 2002:a0d:c0c6:0:b0:2ff:bb2:1065 with SMTP id
 b189-20020a0dc0c6000000b002ff0bb21065mr1966684ywd.512.1652914854112; Wed, 18
 May 2022 16:00:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:7143:0:0:0:0 with HTTP; Wed, 18 May 2022 16:00:53
 -0700 (PDT)
Reply-To: tonywenn@asia.com
From:   Tony Wen <weboutloock4@gmail.com>
Date:   Thu, 19 May 2022 07:00:53 +0800
Message-ID: <CAE2_YrCtgfqs+8hO2xiCFT0shc5zmp=YrfnsNtFvNjd-K9oh0A@mail.gmail.com>
Subject: engage
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4753]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [weboutloock4[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [weboutloock4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can I engage your services?

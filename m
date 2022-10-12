Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C635FCE85
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 00:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiJLWfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 18:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiJLWfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 18:35:36 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974C4D57E5
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 15:35:35 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y5so27843454lfl.4
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 15:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3doPDrK1i3CCYnmJWT1RJhZMSz9LGtLv1iv8irfeFNo=;
        b=f+swGSWK4BVipfbzH+PQ0qd5calf5UR7cwskex1Qv9BM+ltgMXXQIMRlD6OYgvoo+7
         /1KCEGUA15LE7UWMS1CGYqinxVr9VGWLV1RpymSvCGGx38XhdpWCz1FeoCHHzveTGJGp
         3x2W77YEbOLuSqTkSZ5uVk/4CmEyoJQcfd3cxjHK6oXWx2DUR/qUaS2kIAtbzV+ajNF0
         X9eiemVib0FlgF2lZaI5pX9MMAslOZEOmtaxJ0VNy9okG+sSrr4H7tp4t4LeRB1o+WWT
         5XZCj4blyaTbKkuuqOwT4guUz4qovo0+FtqtqunbgNhVDfJbvKh+wSb3GZegVW/NhlHR
         SRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3doPDrK1i3CCYnmJWT1RJhZMSz9LGtLv1iv8irfeFNo=;
        b=u/xRDeIIwaVNICWJSUB/MEJkoK1CZzAenL6GYPrNv+lkCZJJRc1W45E5F3S2+yBR0x
         XPA2XoI4ZsYuL3w2Mq56D8OKPgTT3s9s679K5PNMvySETaDITAm7mFl1BvmKbbj7oAuw
         dUcKoenv6E1b1UoswoEbZWTy46+/HCCMYt4+Pr5LYlgTgvcyhyONyWqP4+NIvgKWbyha
         ZM5a88dMfzuH1I+JZffjbvtoIbSliNQHv2W4mZa5m45TFDMC2G8M2AvgrIBkWtDzhgxs
         GkQPSVoeYppYUvwHsp4+WGqqkec8E53vjmQU9f9xmRhCLBNJS77CvbZePctpeElp34w9
         2c5Q==
X-Gm-Message-State: ACrzQf3aDNx9AgJ8gS8FXdSNMVZ0+14+KFD7MrUX8NLnTr35Wm93TRH6
        abxxavdNCQqSfS442mx+gJDs8ZNpG/7nCDiniHs=
X-Google-Smtp-Source: AMsMyM7EZGxS4wgDeKjwLPQ4WkrxSnyZrYxC+q//z6mQYxGUEEYnpehqINOlpbHC+f4WQaMaU7hXtMt1mwhiB0IlLfs=
X-Received: by 2002:ac2:4842:0:b0:4a0:53a0:51c with SMTP id
 2-20020ac24842000000b004a053a0051cmr10490885lfy.202.1665614133748; Wed, 12
 Oct 2022 15:35:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:61d1:0:b0:1e7:9b6f:7c5 with HTTP; Wed, 12 Oct 2022
 15:35:33 -0700 (PDT)
Reply-To: illuminatiinitiationcenter110@gmail.com
From:   Garry Lee <basaijapeter727@gmail.com>
Date:   Thu, 13 Oct 2022 01:35:33 +0300
Message-ID: <CACXn0DNtUZZckFHjwE5+bJDjyj-W4EQ+xhbJkEbusF9_8RDHHQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        UNDISC_FREEM,UPPERCASE_75_100 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:142 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [basaijapeter727[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [illuminatiinitiationcenter110[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [basaijapeter727[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 UPPERCASE_75_100 message body is 75-100% uppercase
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
DO YOU WANT TO BE RICH AND FAMOUS? JOIN THE GREAT ILLUMINATI ORDER OF
RICHES, POWER/FAME  NOW AND ACHIEVE ALL YOUR DREAMS? IF YES EMAIL US :
MAIL: illuminatiinitiationcenter110@gmail.com
YOUR FULL NAME:
PHONE NUMBER :
COUNTRY :
GENDER:

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AA452C3D9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbiERT5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 15:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242217AbiERT5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 15:57:15 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C7D16D499
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 12:57:14 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id n24so3948578oie.12
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 12:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=AeF58LI/PJfNkOmwQj/FJlhbvvlWl0RMB3ap67+sjO4=;
        b=LuphkSkb8y+Va9EEmmk/9tZVSND2sjl1sc5jcWdyEz8N6+JYaSMg64Ql9AZinp6NcB
         ChEc5OKjIPL1kHp1lx7OFpTA9eUR7bbno5UluBquuqGsMJ21RIiqUGZnWdq8ZlnpPr80
         IFle/KLOc/BUZpVpeGaDy4yxztaaOFInDKVLbKG0SPxb4TQ0+ZOzy6CPl63VUf77t+5c
         vq3ZizpufbzJqQEyoIk9rN5i8ZyqfexgYtjiXLBGHnFAwRQqJYJIzOX2bHFlKsQr0+8u
         G5J41p1XdQ55w0EJdXt3ZvpSWFWlzo9oU8KzYqXXCTQ17ZUg6aawDqmJxSSMol9lrrOn
         a1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=AeF58LI/PJfNkOmwQj/FJlhbvvlWl0RMB3ap67+sjO4=;
        b=Sm0XNc9hbVRkY0ukONp7yWS1+JRuuUhIvARNWGW8p18rzNaZGWhc9O1wSAKTmvLt5I
         uMQyfz1KTmT4HqcgZE+h7+QFgjmGM9aMF9K2IomM/nfl+JMyErmjAemo8AZ8FmNbx0fF
         xvxR2OS+Ib45uBUiY2UGp2hfBe2PrP4IeN/qqgcWMZKNm9bBWinv1QV2+Q2Y6tyilp5g
         KD33Na2YY4t3M91SWzOoUsuN2pyFSqRk4T7OLf83GkzCitgHypgYj1xJqRdIHSoR87Mt
         pPpR6zfF3xMdLW0EMeLurOo8BKe7UEWwFamrkRzLVgWAReCdP0qyLNenonSgeFOJdme4
         Ip/Q==
X-Gm-Message-State: AOAM5306eEIl4sHR/uHUhQrSiWJZw6N9UNQgzHMRyIjFxrbh8g/QpeWm
        K0TMqwxJBhxDFCXCa9G0wyJ05hm8ELNFVsaeqCI=
X-Google-Smtp-Source: ABdhPJx5xNzxfTI+LL5bm67TrW1Vw0AY4wratUFBTG5P3RYGpWgkXiy1iKD0Q4xSuJPGB7Nc2pc6+B+w8SCgWe9ZR0M=
X-Received: by 2002:a05:6808:18a3:b0:326:68c8:cb47 with SMTP id
 bi35-20020a05680818a300b0032668c8cb47mr703410oib.165.1652903834342; Wed, 18
 May 2022 12:57:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:6809:0:0:0:0 with HTTP; Wed, 18 May 2022 12:57:13
 -0700 (PDT)
Reply-To: bbir2657@gmail.com
From:   "SGT. Irene" <alexnationwidepaper@gmail.com>
Date:   Wed, 18 May 2022 22:57:13 +0300
Message-ID: <CAPuazPhQ1Ok-fAriux-bxXM8W-kFT0EDuofkhpbLo3Up9qFLTA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:242 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4993]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alexnationwidepaper[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [bbir2657[at]gmail.com]
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

-- 
Hello!

Did you see my blessed deal message in your favor???
For quick response and further info, send response only to my private
email (bbir2657@gmail.com)

Sgt Irene
United States Marine Corps (USMC)

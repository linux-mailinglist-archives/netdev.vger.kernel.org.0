Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A735BAE25
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiIPN34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIPN3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:29:55 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0641A040
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:29:53 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id j188so3807763oih.0
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=V+084zmGRyVKaznUUr4TuQQRjYavNffTtqEl3D71MGwV0qB1wo1YmHDbVZcQ9d3jnX
         yTZn5xaSR3Lkfne0/QdP5BsRGaibt+DYsH+fUOtOjzxQfSlCQlBbq9AzE2SzBmCSUpaD
         SMWbnFwkNLD0YWVG4ilr1tIOjrr2Xn/oN62svFb4O07zKMZR6J9PYQDUJRbPiIKj8vIs
         cVfXG88yYDvbGy6kVYYGKdYoaICwduz0zcWt/Tp1GFUvHUpdbMZVMcjs4LGEuW8RBV0H
         Jx5qfvXJ6sBJfTKK6FXbtolWT/Xz1iOf629+jhuYg2f4e7ecVgZq7Lm11uymI9dYW+KA
         N/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=d88TyO1fT2+WyUAfY6zx6CsBiKyEasph3X+fYihwvtkVDutA0D3uH16ZoNEKFoPZZS
         TOXqLtDjJPbbdONV8UtMmbeDdslGFLDgyoa0LJmF7cRZXgGSrmM52X1B/6IC3INUNlN7
         H99Q/M+fvmzRTKGzQD7TkNzAyA+sTfohIDQYTE1WP1BXqYCIVbInZuUP5173NT9PLSiI
         gDV1yOl8chlv/Tu7ix/wcUISOAW/2bUq9H0JOnsvtwzj3jW1wWogfPGLt4eKqCBKGu7G
         e1q5t06zyNaO32TySsN6brckagBw6VMttQGTwVc2XmyK04DLyOLMLQwduSIBEMDUbEL2
         rUBQ==
X-Gm-Message-State: ACrzQf0qK/73eH1KK+tWUZGA6gwdkWJGEpnjlz1b26A7yLkcw53nDvy2
        FrY2WsldF6dyxYBXf3Zok3wq9+h0epw6wfiwses=
X-Google-Smtp-Source: AMsMyM7wFbFAOAyVIVGM8Q8f+SMifQKFhrq0rY7cImI6HKine3zzuy3JRpHn3GC1TgXbZrDDpsxjRTv9TCjT+sLHeMs=
X-Received: by 2002:a05:6808:1117:b0:350:653c:fa5f with SMTP id
 e23-20020a056808111700b00350653cfa5fmr770593oih.164.1663334993316; Fri, 16
 Sep 2022 06:29:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:3186:b0:b9:63db:12bd with HTTP; Fri, 16 Sep 2022
 06:29:52 -0700 (PDT)
Reply-To: maryalbertt00045@gmail.com
From:   Mary Albert <edithbrown045@gmail.com>
Date:   Fri, 16 Sep 2022 14:29:52 +0100
Message-ID: <CAKCEZ_pYvxpNro=Y9m8MwwBZtWZudZqPSuuEEm20TiCt9Q9C0Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:235 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [edithbrown045[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [maryalbertt00045[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [edithbrown045[at]gmail.com]
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
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
how are you?

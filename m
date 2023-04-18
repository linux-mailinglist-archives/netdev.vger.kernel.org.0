Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D16E692A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjDRQQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjDRQQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:16:55 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD00975D
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:16:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-51452556acdso2459625a12.2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681834613; x=1684426613;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lmgdHSEBRJNsYGGAJ9I5LZ32sRl0hFuvA05jW3gCQks=;
        b=KAbIOj0ONdbbzyz/2K6RqdxSTvuTUbADZXyP6ka/WfElHlTky9Fcuz9auJeJDnsOiQ
         u+8rSDPQUZjc/rYXq/v/fTwF7Zj/cZvgT4FD6CnS60/jBvSAc6JSrehbAYe3MK8Z8xiG
         TEUe2T3fvdLxUS9PfhGIX1fAarhH4yWj8I6IQXat1P/DXxLJx1+dZhur6yxzx9oi1V/i
         d/ufAlxEqerXx+njreXlV9QgmM7dZh5DKeciRWZl61a7emlO4+EtzCAeDiy+afa8GBCG
         cgtMFJUlMEqnAiiOU7NWMkOm/RscCsqGLrkk18ZKgI2eje7MSkQ8kyAyT4DOiy1SMYMz
         9euA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681834613; x=1684426613;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmgdHSEBRJNsYGGAJ9I5LZ32sRl0hFuvA05jW3gCQks=;
        b=lt/v7Ly2b1m4mzpO6BaxA8OsuH9SDRm4O5VoR3ITJWJPSrqAC7X+U4vrUxpCnXDG4Z
         uo+MYKt4pI694kFrEIuVlFmiwNXOgyRPU8kztLkuWEnFzYCqpmVjeLA/a/m5j1LzT/+U
         KlM3FkP3N8LovS/ftIHeowdSWcYlJ02bdfIztG8ttJ9XNkqWEfB7GG8yg2W9CBpQUsuz
         Xz2QaWn1FuF5tr2cIIKi2VkQpoIc1TMjkx0SzEmGZGS2ZU2poW0+jeVwKXU3JEa5Xn1T
         mIy3D05V/Eo3m/dizh4+1Rvs4QZ9M1WJnOBZZTfNXrfqZmfnZgdBut5R3wwZhQft3diq
         yvMQ==
X-Gm-Message-State: AAQBX9ffMOvmmm1Lc4LQhMovpv072jUcUNNU8KILrFFmJqXb0hcxvUDR
        bPGPDou/WNn3FcCf2jGWCwswfSvyGI+Qf8Ym2as=
X-Google-Smtp-Source: AKy350aTG7mw0PrPJnCGC9nQ139VHaphvVC1GYLKxN7iAyesTogFXpS2+L7Ykt/98Q7/pyJDw18c4B7vWKRicB60QII=
X-Received: by 2002:a17:90a:6097:b0:246:f99b:fd65 with SMTP id
 z23-20020a17090a609700b00246f99bfd65mr106606pji.5.1681834613540; Tue, 18 Apr
 2023 09:16:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a11:594:b0:486:2d30:9b78 with HTTP; Tue, 18 Apr 2023
 09:16:53 -0700 (PDT)
Reply-To: thajxoa@gmail.com
From:   Thaj ti <t3997936@gmail.com>
Date:   Tue, 18 Apr 2023 09:16:53 -0700
Message-ID: <CAJYqmPqSM7ySTRmGUJKMZxQ5AivmOTK+q8sXXV0YujZffUj6HQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:534 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [t3997936[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [t3997936[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear Friend,

I am Mr Thaj Xoa From Vietnam and I have an important message for you
just get back for further details.


Regards
Mr Thaj Xoa

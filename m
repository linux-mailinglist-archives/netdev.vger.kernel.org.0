Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0124D4AF37A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiBIOA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiBIOA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:00:56 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA0DC0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 06:01:00 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id k10so542594ljq.2
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 06:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=rs5ueIfO7VLRLL2mOPAVZrEalM8O4FV33h7G2H9cfDk=;
        b=fGBQLvOpAyicEEbF6av99tE0CE/rp7wEew6BmcZoYXVLEEvqteAGtqNrk3c0RYTPM3
         KqCbHtBYUt/I6LsSwDAWax0dpQGph0rB7dtLjoTf8Q/iBH3ewnj6V0+3BNcQ17CW9nXG
         cX7441Il9BNqv9dUNcRVvVCGy27He1qOhlkUHMsCW3jWAec3KZwKS3Eh+61hGUROPrYQ
         UG/CdmN9b2AkxLl85BChAT3stj2oJMNPqubZwR2NAn4sFPdJ3jXWD5czSW/XRjnGoj49
         wa1NT4T4pTlghPIZVC3XWH1amf1W0mr3uBMnDiP/BdQvI5mO4K2ty5dmV1VNvDD599Gc
         RjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=rs5ueIfO7VLRLL2mOPAVZrEalM8O4FV33h7G2H9cfDk=;
        b=5UpZ3zC33webmGHaBxMYcEAfwTZH+Hl45c2ZF5IDzMf1JT9hvgFPhh1BgVVWQm1IpU
         AIBZz8qcJejRiRHrEXr6G/h5LGQnj+nGa9rWu4WxouM2jRBEJGf3TeWQNSxCk+9NVFOp
         4fgmwZ9yO6PEhcOUENDOQyyUq3eSlDxtta3ipDuoiWEG6Prua8mf8Rwa9xUL53h2Eww4
         UgzbxWYlPQYB0BXwbUW3gIBRreXJq+7vlVD56N435wQwU9oraYHbmq35NSiLdWW6o9S0
         3If5ffxXm2jvh9gNS6oVNoCzqdSFI1D9PVU+4E8mNrpHGOWbiA1q9dDxN/5S8pzcBc1u
         BOpg==
X-Gm-Message-State: AOAM533fKntiGbn6cluzCB3xMIkdykd9G9yRAcJTXuJlwM6j1QsQ/C1Q
        JmmxBmxuL9FL7dHSw23mLLb1BHk0/ZfIZ/J7usE=
X-Google-Smtp-Source: ABdhPJxjKCvjb4HogXjJjsyTIHen4ApqjXqfIPqC/KWvmiZqD2zamL6RtpSIdos2cjy1pDJtT5muMP2FqTREgk3c1Ok=
X-Received: by 2002:a2e:8210:: with SMTP id w16mr1652970ljg.485.1644415258408;
 Wed, 09 Feb 2022 06:00:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab2:946:0:b0:126:f746:f76e with HTTP; Wed, 9 Feb 2022
 06:00:57 -0800 (PST)
Reply-To: miltonleo137@gmail.com
From:   Milton Leo <guynancy96@gmail.com>
Date:   Wed, 9 Feb 2022 06:00:57 -0800
Message-ID: <CAP15NF5tcbg64gUP1N3z4JSQG9_wJYO4gjGDcAQ63Gt2eBV4Jw@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How are you today,I hope you are doing great.

It is my great pleasure to contact you,
I have an obligation that I would like you and i to complete ASAP.
if you dont mind.

Hoping to hear from you.
Regards,

Mr milton leo

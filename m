Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C829D503660
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiDPLfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiDPLf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:35:29 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9666E40A2A
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:32:58 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id m132so18276054ybm.4
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=xVJHepNq93ePmAbCv1LHbdOWJcqWYQh8v11fr0KUdVw=;
        b=mTGRyB37vDPp7R6N8XdzNiGYtXIZM+JddnoIiZIpv4OXFMfE7jCEBDmY6XkLS38+2b
         JjhVz2nII/Rx7cHLWjOV1tyLjEHfxZGqG1ZXU4CfXJ1ItE6yvNDGExF8ZnesQnKQND45
         cACo2m+omuf5K6jKRTvxxrsalYB0thDn81R0I52ip/VcGnVX5VfLNbqIzkXHLYRCxDAf
         6CPZvijRmdWg3VvQim2WwcCN+iIM2Ar3JGTr8TUk9iFX//+MWPHT5yuJ3h+eVU8Wa8/U
         9MafqLt0dqt9g+W4g/e0LG1gma7JxZTNJ4eoA0fiFS0W0idcTfpsSKpddhaXZCU3ytOz
         MOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=xVJHepNq93ePmAbCv1LHbdOWJcqWYQh8v11fr0KUdVw=;
        b=TA/QC6h2BBxZpYlm/pjYYF060xpGAmivWWs9GCvhYNIOBUH4ez2984TrKvnUChXUr+
         vPlQAnd4eRfKLSBspNjH4I8AtUcNEqUSRgRFZRuvGlNfgzYNxihKSc4VaiEHumntoGHk
         MO059Z4fZanUkw/x6DJC0HkNIfbT6RWlYw7XmhCP402JpHlt+Wve3JPq2GBI1zeWxGNi
         2zCgFtfJ7g9GPf61eSzGj1CBLqzTZTx2T0l7feu04A0FZbbVLduNEbW2hhYlXqSWBPkg
         58x1KFb8A5I/HXXFpkQQD0hEcL2WX1Ils3q5xv0RAaT00xbBCamfJPL3qZyYtoiOsuaq
         LNlw==
X-Gm-Message-State: AOAM5339YFgK4h3RE1sSo6KZv9Y1imv75Rl5vSG/AcUc+TakAwYzheN+
        AhWBHvDAgllUPi2ZpqPYHHbbo5hIs1gNsQQwSeU=
X-Google-Smtp-Source: ABdhPJw2AO0t6jjAYVr8C+A62DilU5ZCkg1yHUF+6vNhYB2fA3zR+gwyZmkozMuWBwVyZmTj5ZPxfr9oHHLMbTfuWQQ=
X-Received: by 2002:a5b:f87:0:b0:62b:f9d8:ed5 with SMTP id q7-20020a5b0f87000000b0062bf9d80ed5mr2541225ybh.467.1650108777739;
 Sat, 16 Apr 2022 04:32:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6918:8206:b0:b1:7d1b:9bdb with HTTP; Sat, 16 Apr 2022
 04:32:57 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <sgtalberts@gmail.com>
Date:   Sat, 16 Apr 2022 03:32:57 -0800
Message-ID: <CALPTejN=DFC_NtcGWK3f-idki9pA+YOohK9iCiiqoW9h-Sx4Ug@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b35 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lilywilliam989[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sgtalberts[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi Dear,

My name is Lily William, I am from the United States of America. It's my
pleasure to contact you for a new and special friendship. I will be glad to
see your reply so we can get to know each other better.

Yours
Lily

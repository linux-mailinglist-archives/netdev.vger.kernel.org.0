Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375E24D677C
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350732AbiCKRXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350733AbiCKRXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:23:46 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7932133E87
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:22:41 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id b14so6435409ilf.6
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=942bCCA5KRAkxRxCdYgG3Jqo6150gLHkspvP3e9cGUQ=;
        b=mIGD+ismsIHdFlJCKl0Z/45IiL/sw6Lvo0R32C602xzgxdY8UKb0VY3wh490Y98XFO
         ajkusfUlAi6aBxR2gfncQPNSWfVEqzWVl6HfusC5MvXAFsWGZY5dm8R5/ClgeJnRbrLt
         rTFTDiP1B1pKFnBa2tjpnzggdDXpfxfQ2wYYA7ptmlIQ/SUpUGnfeu/lidKB1+D8X5RG
         2sK8M3r2l6sEwTebb7OGQxF6Hyj3gRnsIwn9B2mh3L4ZlEHL9m63dXNQ4s4huKwYW7NQ
         tKDdbBU0kfGMW4am0bmsvjV6TJo3j7m+sxB0h5Brp0e64x89ejfDuryIbu7VjnFk6zX/
         jYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=942bCCA5KRAkxRxCdYgG3Jqo6150gLHkspvP3e9cGUQ=;
        b=f3TVZ70hapFcZ+3Uj/DJZYyg7aVpHfiiSC69sJPe7C6EseAI1xE6p/DvaU99EFxxq0
         +FIoLv1ZdAKDGz17OCVdOFaT2poudmQHy8MCg3e9MujY70PpMZxPCQc39DdgVKWQ19LN
         FniqGUu2dyvpUdB3dhT50fwOkg3MX3coIbgA3JRsxW1vXFZwoiXGVfSxSxjIXLuyXCaR
         M2vk6GdFdEuq5btgbdSDABT3Kh7zK/dSvwsc6d/s5Iw+foA7soHf1e6cydJmlCdgdhTj
         pf68bZfkbHvAMEVZAqAJjfn9SK/hbx1dWWbVse6pz95Fs2rw8FmZFHbXC+7vXjB0BEbf
         Iu1Q==
X-Gm-Message-State: AOAM5328XL/yqccuYp2dezR2o6z5oBMLxERMGVmGETsVycnyYaMCDYbE
        Yw54m3nAPNIPpFo066WHFNs2LpfJHjvzDODp/Vo=
X-Google-Smtp-Source: ABdhPJxH1qI3b+JH+CEZZiDawQXctL3DcxFe7F4rOB2QIGmyEeF2hHWiOzThK3FDdTfiQ0vbYSE7q4XJZaina/8/0bc=
X-Received: by 2002:a92:6e0f:0:b0:2c6:4ed8:7bab with SMTP id
 j15-20020a926e0f000000b002c64ed87babmr8055374ilc.41.1647019360929; Fri, 11
 Mar 2022 09:22:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6638:22c1:0:0:0:0 with HTTP; Fri, 11 Mar 2022 09:22:40
 -0800 (PST)
Reply-To: headofficedirectorbank@gmail.com
From:   "headofficedirectorbank@gmail.com" <db.banktg@gmail.com>
Date:   Fri, 11 Mar 2022 17:22:40 +0000
Message-ID: <CAFDfEebz1sTc+oGLWA1drQwGiKKzeoKxUJgOCs3vYtt6QzP0Sw@mail.gmail.com>
Subject: Hello
To:     db.banktg@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=ADVANCE_FEE_2_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FROM_2_EMAILS_SHORT,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:12c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [db.banktg[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.7 FROM_2_EMAILS_SHORT Short body and From looks like 2 different
        *      emails
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 ADVANCE_FEE_2_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
 Our office contact, 2554 Road Of Kpalime Face Pharmacy Bet, Lome, Gulf.

This is WU bank director bring notice for you that  International
monetary fund (IMF) who compensation you sum of $850,000.00 because
they found your email address in the list of scam victim . Do you
willing to get this fund or not?

We look forward to hear from you urgently.

Yours faithfully
 Tony  Albert
 BANK DIRECTOR
Contact Whatsapp, +22892905783

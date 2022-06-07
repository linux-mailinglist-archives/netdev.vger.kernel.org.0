Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB0853F71C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 09:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbiFGHYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 03:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbiFGHYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 03:24:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A1BC0389
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 00:24:47 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id c2so21747477edf.5
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 00:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=OHbou33WPhW0PDy9/CZae9mIrL4buN3/FALSld4obAM=;
        b=aj9a4twgH918z0NtrcSxERhjT3wQwz0t1RraqingYp6ICSt9qZjzTUREH440HfTk9j
         ibEolaIJTEuzquu2ogPJe9VG7g0YpBtDwZc26AmL5+4EI1khaTRHFyR9OR2cC43WEl/E
         Wb6QWnJJXrknnAsilrkh6D/ZbHlHr1R0Pe2vb5FZDowUpa/Wz32CIiaX5NVryKsqq+NW
         VgnYtmRgPqK2vDNg15AH9gCV4ppmKaWMQhoJcRRMqsBSfGydr9AezG4GZmQqYXP1j5HZ
         EYQB0krXHfUdS3w2UgMDCjwCtAN6dNsjwPstdBQO1f8H/dzkmqSkqtOjBP/RQ0bdMZZe
         /5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=OHbou33WPhW0PDy9/CZae9mIrL4buN3/FALSld4obAM=;
        b=nfD1E61VBA9Sdo3JicNrEb6EQKYPZI8Q4iTCUBh88ISbUBLE/NLykoTpTAB9wn1Llc
         RlUqUC683Ash40Vc1icWIoSL1kOdscrlt1H5Aa77WKCwnEsLQA06TI8NM34vUDlULueH
         DDnZfnX5FicDyuS6ylnT2q4Ztoa+4MAtWMZ67tCX0FfdI/GjS8Efdc07umZh/c+TLRpH
         tr5+pKRGxm20cLu4ao3cZQ6YjgG5AQNkdWQfo/CODD5joppG85oGqT0dMFdxtaBlsMJS
         SyFCPV6NKlr0GM+CrdbRi6+pwR8huOVOlXnMAPKnSG1vrT/j4WA6jYmgSG9re+4TOMfY
         sZFg==
X-Gm-Message-State: AOAM533d7mxsVI4T4B9ehbrHxJPJpwwfF/HTnZWz9lcWSD75lZN0llEt
        aDFTM2n81NIwIvPe83XRdhQmJYY1ksUdy00P4Qs=
X-Google-Smtp-Source: ABdhPJzdXRjKYABP8xEvXuYf92kSdaTy+FT2H/oUd8KBO1+tg/PFhqETM/u4+A1QBCAUn5Val09tBYwCvq8X3cWG5ZA=
X-Received: by 2002:a05:6402:3227:b0:42d:df54:ba24 with SMTP id
 g39-20020a056402322700b0042ddf54ba24mr31391562eda.49.1654586685582; Tue, 07
 Jun 2022 00:24:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6402:26c8:0:0:0:0 with HTTP; Tue, 7 Jun 2022 00:24:45
 -0700 (PDT)
Reply-To: andyhalford22@gmail.com
From:   Andy Halford <fameyemrf@gmail.com>
Date:   Tue, 7 Jun 2022 00:24:45 -0700
Message-ID: <CAATdNas-C2gDmaLc0OLfaXz_fU1BUXvMLECFJnFNA8Gx7XrFSA@mail.gmail.com>
Subject: Dear Friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:542 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5005]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [fameyemrf[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [andyhalford22[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Sir



  I am Andy Halford from London, UK. Nice to meet you. Sorry for the
inconvenience it's because of the time difference. I contacted you
specifically regarding an important piece of information I intend
sharing with you that will be of interest to you. Having gone through
an intelligent methodical search, I decided to specifically contact
you hoping that you will find this information useful. Kindly confirm
I got the correct email by replying via same email to ensure I don't
send the information to the wrong person.



REGARDS
Andy Halford

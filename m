Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5726B2720
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjCIOiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjCIOh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:37:28 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357A8EE778
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:37:08 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-536bbe5f888so38423857b3.8
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678372627;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6IEW8M/aeCm2sE5fVkmadnoct+8r+q1Vjruu3SWPyz4=;
        b=U56YwU+g+/dmUcbAcRBmIjhh7PeiJ25vxW1V7lgsN7wK9Z5Z2KL8fSdTPuNZ220gYb
         kgHZXZKZlX4AoZSxAla6xyfosJ5I5rHTfVeSBKzcL6YykZMIBv/Wege1AWr3kOjH+iWQ
         2c6Hc1bB9XsCW4ooEZ/5EES1dYlY4qitBu1U3jYh5D31nITENt5in0Wp/EQt4CPWYSVs
         rxngnsLeZ/vJx/PwLsatG5dDQGETwwo2ITSVdWwEkDjl5NZiwCJrnDe5kQsKYLIaT6u2
         wzPb264IlofyDGRkvnxGdBaYJ/CXjv0a992fRictq6CDHUWieoyvIfMCP1+vc3SoaeKd
         s4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678372627;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6IEW8M/aeCm2sE5fVkmadnoct+8r+q1Vjruu3SWPyz4=;
        b=CVRP6tHwEC16cvuQN0224L25sYuAhT+XqeKhDOLu9r0Wppt5c3nhyuvAodnQgqCcmW
         UgB+5o0mO+XvT1Xfo3/SRkPvqAy4OdO2rQMS+I3Ri+z9+PNnI6BzlTL6FfeJjDKzsNp8
         URGuOZFHO+DS4/dcBkO1hTNmIDjpqFZUNIsfX5I7yM9WvbBxrxMfOlNZiXkGPwPIIypI
         vQzqlbsNj5nrLRqWZruCE4QFGFRdX1OHpd6t9t0vwPpLZ9XS7YLw4tdXCShf29IDSU+p
         Y2AAEWReF5y3bktcaKtUwVfSu+YqeA4rFwdRy7+wSw53xFjPlmxUggar2bmMkJZvCXLF
         6Pcw==
X-Gm-Message-State: AO0yUKUI4JpDCQGRZEPSuJ/+rexQmDCNWxH0Jq7YSAn0WP5EXzLnBbR4
        07bpTw8eLXUfpDjitJCQxTuJm5aXo4yWSRI7DUo=
X-Google-Smtp-Source: AK7set9nHTDdIPyTIweE3ZEARedHdapvjNTmBr5T5OfR96jOyfk65iRsUYDPGw8SIsUwK4nod3+L/LvmPRT5Vbl44rA=
X-Received: by 2002:a81:ae4b:0:b0:536:5557:33a8 with SMTP id
 g11-20020a81ae4b000000b00536555733a8mr14217702ywk.9.1678372627103; Thu, 09
 Mar 2023 06:37:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:60c5:b0:32b:28c5:a477 with HTTP; Thu, 9 Mar 2023
 06:37:06 -0800 (PST)
Reply-To: wormer.amos@aol.com
From:   Wormer Amos <fatimamuhammad5689@gmail.com>
Date:   Thu, 9 Mar 2023 15:37:06 +0100
Message-ID: <CA+QAR6Uokw9Wb5-nffnKSyAjtv1hZ4aX224FrbR5UMO3G3yRNA@mail.gmail.com>
Subject: CAN I KNOW MORE ABOUT YOU
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.5 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8669]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1131 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [fatimamuhammad5689[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [fatimamuhammad5689[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear how are you? Are you capable for investment in your country. i
need serious investment project with good background, kindly connect
me to discuss details immediately. i will appreciate you to contact me
on this email address Thanks and awaiting your quick response yours
Amos

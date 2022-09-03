Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C415ABC4D
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 04:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiICCV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 22:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiICCVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 22:21:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85522EB841
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 19:21:52 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b196so3426125pga.7
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 19:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=ZUFKZOshb0NbhQMs8FpQU1/azWR5e8dxB6GuEBVxnuLm4STXVyNxxMbRoLoMOR5/4b
         T9tzxqB8vu8XO7FrKi0obIhIul6HbA/Hj7lkwRpAWlUzPw+Cia1pQ+Lg2AM1BaSPNZe9
         QQcaFpJ/srvndpo0pFsYN4rGSmYNi+Cko1ifOxw4VPv3oNAMDAuisHtbOX2o4fILsvXM
         PmUI4rvM0EkQhY2fse7pEbY3JQCfmDkbzqHt3PKnq1ijJohomcbs4tPmecm9/o4oSlVr
         dZWQ1p/1xgZb6dvV+1nlxSxsdvVuUfGUljjbqMlr1lFxEdJyWuIX862BGWZMjRwZQJxd
         0zpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=CcSLtY4IEV+bw7WNV2RRiy64qmQcMvw2GUeELAYIVB+i3CY1/9L97QR5vygZtjk5UD
         ivhFMR+u1hAdWRIDE2j4UZ5mOXuleE+vfTSvN/Cjpbk9lbVz43selwu6eqVuNMVN4lOB
         QI/OFDEmb4qTPTwdrEi6gRig/A4sy60jgbPpF7o+sdf/xA1HQ1jTfFjToy4by11bh2LA
         dWecre4L+bSnbJBWAp3pOC/BMMK39jY7xIW+o62KA8aAKAuED0woa73daLHopj1yYFez
         eNkUbWAbDCV+2bcpV+jKrfq1aZtheaMv56ZmhDl5Pg+Bxg2dgS77M3HDecSR9/1lAg9E
         HJLg==
X-Gm-Message-State: ACgBeo0E49KXG4NcMxPxpXu5IGKx8IBMwxreNQDm2eWzCuF73nXIhArJ
        Ni8qpo9jGtnEFfKsLECP6Dws7/VRYnUT164f6LE=
X-Google-Smtp-Source: AA6agR7ZcOp9+abbrNcrbuUFurdWvQMtZ4HTWmKHX5FlDqXnyEQcGNFlXS8AE9GNGL/7SI3lRtjNIat241rTd3Ihcgs=
X-Received: by 2002:a63:8aca:0:b0:42b:fa97:6bd5 with SMTP id
 y193-20020a638aca000000b0042bfa976bd5mr23979068pgd.44.1662171712075; Fri, 02
 Sep 2022 19:21:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:689e:b0:44:71c6:41bc with HTTP; Fri, 2 Sep 2022
 19:21:51 -0700 (PDT)
Reply-To: maryalbert00045@gmail.com
From:   Mary Albert <tinnaevan26@gmail.com>
Date:   Sat, 3 Sep 2022 03:21:51 +0100
Message-ID: <CALa62PoVyBKPc8_qoHozHT5DRBk-usC_occLL9XQ6GdbOi1YZg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:533 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tinnaevan26[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [maryalbert00045[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [tinnaevan26[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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

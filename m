Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07AA547B5A
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbiFLR67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 13:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiFLR6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 13:58:41 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3D8286E8
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 10:58:40 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id p69so4069571iod.0
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 10:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=qcNcKm5ssADtdjjBUet1aHzke4+v8usdKVzv1gusB/I=;
        b=DYA29BcckA8TxcNnl9mwEF3EpENr1bWan0ede3c6bL1vk95jH1tNgaJS9aWAHPOkaV
         yDkC8LSCqM6Qw3g52cCf2QTRum2pKL9+dwDIFJ1r6M5D0cJRab4gqF+Fw458LOsQvdGp
         XAf2BDzgGdyTsswE7sA9qV3vdfnADLtfysZJl/l4JBpIrZwh372m7Pdlc1hPGN3dv+qj
         Xa73zJejskzR1VbPqSBqp8GA8tRrlUKeI61s2AjeAQA439DFp13I85dRfjtup5tJTu2+
         4/7suQOfqkJ6nv/FJicbtrZj3KfdbG9f9NL3hzTtor4mDjNKphMmpHd4PnlQQbjj7yns
         bYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=qcNcKm5ssADtdjjBUet1aHzke4+v8usdKVzv1gusB/I=;
        b=aeKm5xRW1JZy4LMxZ0w20fmxPpCELvtpkmxy2keIFj+D05CR5MExYsWbaW5Da+/ihg
         PBHq504Fx/AipIZsQ/cIz40akRi+u57xs2tZiWYVZQgHop7WakNiGc4uumtISEoLmSgV
         pjUJ0StPb/SebWK+q9iJ0hLJbWOXQ6GZHZRBB0jbeF7HuR1h89PSfMpKZEa0g3m8ipfc
         mkdKTYHaQUDAQf5P+J6IUsOUO8vGNntJf+hJU625Tf3tKwl5uyt/shTIEKSVvHHzgI2j
         KcgscdQIbMaB7S7HOXhpouNm9P0SJdwL6BUKNbdJRccaSU8Rrr9nuHzEqX1M2uNcLYAF
         B2pg==
X-Gm-Message-State: AOAM532ZqohytD6+bVQqtVe5BzDO9YB8IiuYfSyq9EQ5vr403B2IWaDx
        APavJ+WabH0vms3ja3DX1jQ8jMwvT+U/QvEU72k=
X-Google-Smtp-Source: ABdhPJxEVqcXzOB1cJLc+EMxhJYT9SohumDXtUO4kD8GSh6wB2w/V0wqDe0AQGTE1qB8ek8nx95C+G6sp+TmMfSveCE=
X-Received: by 2002:a05:6602:2c4e:b0:657:4115:d9e4 with SMTP id
 x14-20020a0566022c4e00b006574115d9e4mr26323280iov.91.1655056719713; Sun, 12
 Jun 2022 10:58:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:e148:0:0:0:0:0 with HTTP; Sun, 12 Jun 2022 10:58:39
 -0700 (PDT)
Reply-To: filodavid817@gmail.com
From:   "R.Chantal" <chantakrow@gmail.com>
Date:   Mon, 13 Jun 2022 03:58:39 +1000
Message-ID: <CALeP5sEqt7sM=HpOMzGSRm1U7pAxiB8DM5cej_hnd6Zs2m+05A@mail.gmail.com>
Subject: SANTANDER BANK COMPENSATION UNIT, IN AFFILIATION WITH THE UNITED NATION.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5012]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [chantakrow[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [filodavid817[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 UPPERCASE_50_75 message body is 50-75% uppercase
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SANTANDER BANK COMPENSATION UNIT, IN AFFILIATION WITH THE UNITED NATION.
Your compensation fund of 6 million dollars is ready for payment
contact me for more details.

Thanks

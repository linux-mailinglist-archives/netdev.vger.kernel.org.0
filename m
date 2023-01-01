Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B20A65AB90
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 21:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjAAUdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 15:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAAUdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 15:33:08 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBE12709
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 12:33:07 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id kw15so62593023ejc.10
        for <netdev@vger.kernel.org>; Sun, 01 Jan 2023 12:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7XukgsAlfYiKI+yuvdwyFpb/FGCy9p+ybfvm0wRi4Y=;
        b=VRrmPjpyHQCwig/iNN3RA6+57q5mOqXTVfZokrXzI76t8mG4Dlj2G9vEIoR72Hl/29
         o458SMjQhqUQBn+snBmWuEKLLWk9TEV11XX5Y4qs13S+C5jWrvoWEfNOKVtznYcKniF3
         oRR9q6VZPQa1nshNbMshrRNqFjx/qEkQ3cZDJJqB0ZJWd7S7h1kzZZVFjl1ELLTThAWc
         QKZZ0u8Cvv9Ke/g1gYD12H+WmfkRxn0PDNGTw66HmwdmwRMN8ZEgbPrRN876YKOEzfDY
         piqyQHBp/NFCg9V29sGITNN9SJzxf64qISEm5HYheCE1D3CXLPblpIkP0gJWTSMwnhGx
         BwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y7XukgsAlfYiKI+yuvdwyFpb/FGCy9p+ybfvm0wRi4Y=;
        b=7vAwd25VYixLdD6MHj/v7hWwL2wVMgEYKCSxTrTU2QlExC6emafLVgjHJFE+UOK+pi
         OWJ8APGXe8wnXToylq8q5rlkK4LFKT+6s1arjkYOQvFhvfkrXEhK+ZWbL9pErYDj+1QH
         9hQmKLjE/+Yl+0fQ4UAEt40oPLRGLiCx7qZ2dc+8sfOEi67IiR+C9rQKR46d7o10UzZp
         B1uwiaumq59g50lTEH3V96BPjxtp8V3RjW4LeALnpaJciQG8PbVnFGhzcRN1dJxKJGxI
         ttEVCLq0UsnKi8aHrIwSWystkOXUxhUSVZ4LY51vFtPFkaEIAPtgf7ENXoQN0v/nuvV0
         xGQw==
X-Gm-Message-State: AFqh2kreK2i5fakRo/oZv3z4t8KaZlHcX/xThbBCcSo9RW2mzwQ/fwcR
        /OjLfRVcqty9cTdh0r5O26ojWvTJTe4gBh0HBg4=
X-Google-Smtp-Source: AMrXdXswWT00ymoKbYP0hvMXny6EqJ2I8PbLbBAG3+H1d3zECAJnR39h2N6b0Kj+I1Ig+Xq2nt3rp4fKsHeo94uuw4U=
X-Received: by 2002:a17:907:7697:b0:79b:413b:d64 with SMTP id
 jv23-20020a170907769700b0079b413b0d64mr2992459ejc.538.1672605185564; Sun, 01
 Jan 2023 12:33:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:640c:94c:b0:191:9203:76b4 with HTTP; Sun, 1 Jan 2023
 12:33:05 -0800 (PST)
Reply-To: ab8111977@gmail.com
From:   MS NADAGE LASSOU <oyomdemian@gmail.com>
Date:   Sun, 1 Jan 2023 21:33:05 +0100
Message-ID: <CAHqmVpbSd7Xx1nsuz79a1pBkc1qXvAX+gsBdXkXFRNjFkf8=SQ@mail.gmail.com>
Subject: YOUR ATTENTON PLS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:629 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [oyomdemian[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ab8111977[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings.

I am Ms Nadage Lassou,I have important business discussIon with you
for our benefit.
Thanks for your time and =C2=A0Attention.
Regards.
Ms Nadage Lassou

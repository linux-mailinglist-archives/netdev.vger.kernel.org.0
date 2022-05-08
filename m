Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262DC51EAA7
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 02:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiEHALv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 20:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiEHALt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 20:11:49 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DEB63DB
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 17:07:57 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d3so7089138ilr.10
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 17:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=PF1cKI3J2qY+qkEQ0Qx4QViHD+lV1w45Vz4SVngpaDg=;
        b=quwjzLS4kCo8HNiGFzHWKLBoC0ig6S0KDGe1ETLQr9hshimNZ5uaC8bazpszE+xHvc
         VEIfueJPFicKf9dEYTvfuF1yWS+7Tl5KCbys/Xn+QQAN4lt01sl+1RiNU7HOZu3a0TqM
         tFCedDszlsLohv4NK7GyUFSxxrTuKCIWYK9fruXGiCfTa7xj1AqM8rrz4/FIQX9DVwFe
         vy0EJdH5dsttKTs6zO7/JUz6jPtBbFJBvXCtdrW9ZFz+6k5pY3YcgtxG3luFDh6HQCFU
         v4tyKAYgljzs7iDj14ZiOseGAn8OBxOkQ989ZLKZbK6pglgKdsWOqARJhDuGgEVzxt83
         8ikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=PF1cKI3J2qY+qkEQ0Qx4QViHD+lV1w45Vz4SVngpaDg=;
        b=iUmjAGBFiZWp4vaEbGFBkdklfq+xMgdRDrVKANEsZRTuxgynnUsLrjHYw2mAOC/gfX
         iQhFrPbjlvF8UyFLY9E0o3663ZH52LXRKAck6w8HQmq5/1cWOQAr+F77+gE90njDuMAA
         RwvdzPNQnFS9uKQpCbDfhl2idHNgxHaZR579eVAuGjFgFKCUis+mKW5ea2b2+I51CmJN
         OF5xZB4GPwPsA2/y1quakjYVtvzbjg+nyuwBAvUUumvN0hmZKSVrjh9nf7x66wph9cKL
         qlbXUnVUwkhsbKUQW1chIO94QiPcpYEhoM7n7O6isOcuo+aevx4dpqJt4IpyIg32xN+H
         5zIQ==
X-Gm-Message-State: AOAM533ps376EPJ0wwfU0OhTI29qX/eoJaAW583w7ztP/NVUO2NB+PfI
        QXG+4Dz9wuiQVAXLmEU053QPoXNAG8rWqUTa5Zc=
X-Google-Smtp-Source: ABdhPJyUUQoeDe6iCrfGsAjN3F6FLsHIHUYyvKlftPb7SeS93kIKbQe30cAsWNK3/fyLpwyFpg/9/jCjuzcRB6XXH9U=
X-Received: by 2002:a05:6e02:1581:b0:2c2:5aef:db32 with SMTP id
 m1-20020a056e02158100b002c25aefdb32mr4200007ilu.158.1651968477106; Sat, 07
 May 2022 17:07:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6e02:5af:0:0:0:0 with HTTP; Sat, 7 May 2022 17:07:56
 -0700 (PDT)
Reply-To: fundsrecoverycommittee@aol.com
From:   Geoffrey Bristol - FUNDS RECOVERY COMMITTEE 
        <macarthuremmy@gmail.com>
Date:   Sat, 7 May 2022 17:07:56 -0700
Message-ID: <CA+v+581ZJYPrDLMvYKNaH3EXPXiHmmnoVT8x2N206F7iqmUkTw@mail.gmail.com>
Subject: COMPENSATION PROGRAM
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FRAUD_3,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:129 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5126]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [macarthuremmy[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  0.4 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TO WHOM IT MAY CONCERN

This message is from the Office of Funds Recovery Committee, a Panel
set up by the United Nations in conjunction with the European
Union,International Monetary Fund and World Bank to look into and
compensate accordingly all victims of internet fraud/scam.
In a recent report of a thorough research conducted over a period of
10 years,part of the findings was that about 30% of such victims
commit suicide after losing thousands/millions of their hard earned
monies in the hands of these evil perpetrators of online scam/fraud.
It will interest you to know that we are doing our best to ensure that
these culprits are brought to justice and prosecuted accordingly. More
than 10,000 of these scammers/fraudsters have been arrested in various
countries recently and huge sums of money recovered from them.
These internet fraudsters actually confessed to their crimes.
Against this background,we have been mandated to compensate each
scammed victims of these fraudsters with the sum of $500,000.00USD
only.
Be informed that your name and details were found in our list as one
of the victims. This is the reason why we contacted you through our
agent to compensate you for your loss.
You are therefore advised to get back to us as soon as you receive
this message so that we can commence with the immediate process of
releasing this $500,000.00USD to you without delay. Be informed that
your name is in the first batch list to receive $500,000.00 this week
as compensation.
Any kind of delay from you will not be tolerated as we shall quickly
move to the next batch if you fail to respond on or before 48hours of
receiving this message. We will assume that you are not interested in
receiving this compensation offer.

Regards.

Geoffrey Bristol(Chairman)
FUNDS RECOVERY COMMITTEE.

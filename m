Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F145513346
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345990AbiD1MDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 08:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345840AbiD1MDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 08:03:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4F2AD127
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 05:00:02 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t13so4077504pfg.2
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 05:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Q9idrEhyfUAp/UZgkvDvxYkLGWOWGEut4dPRaSMF9NE=;
        b=QHEJOoupenPnNEHMEEQXRwNJGR8CDyajSgj30tryiJeblwmjFLxryr9PxfkswxKHtk
         wZilTkIhhUQKFWhX+ltNIuRJ/aVY9rDaObaWHuQOrc231gj960a0TzrKgUt82hsJeF6G
         JTD9BQmYFLYCKuI2MAeE5ahF1zvnWuveo30VVym2enqBYkjbEm1pkRIkyOHhLddS6wMb
         yfu+R9RyMMdNrbmU/MBHRg7HEDzsTA+Tkis9O3wa79UuJebvrtRX7Zgchhhd18BJingt
         4w5PHnVkyW2Km4KtQVV73Pd6cjs7a3CMUPdKKN17dUHfVm83PG2q0+T5Pc5dfJEumZQV
         2yEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Q9idrEhyfUAp/UZgkvDvxYkLGWOWGEut4dPRaSMF9NE=;
        b=XeqghexiDTrWugr+dEhPrVPKTNwR05RpNd8MyD8bz1aJPdMi68aZi48vLHhWpZMey/
         eKJ+SxETJJjQHlr4BT0UZSCHsYtvMQ7UzqU/ZYbeOvPu3TWyKcl754g2acaMPsm1trGj
         3hqQsNXMEWW4Rf7skXUSV77DER/uUIZdbzvjhLTytmhtwu/yPPo3B9LbWjNt3yWhK60d
         LxHuZdwFciY0WG/UJv77EIdgtupB81CSWvNe/FxYKS5RavUbXv8WvYlB0qvwSeNYCcc4
         nTjT0bNqlfZuB11WAR2Hr8TGEi6oEdZ4zZRQDlHFDI1h0jwMqkDWROiz2FRWx/l+h+z9
         NHcQ==
X-Gm-Message-State: AOAM5337SwDeqJOyrPZzH9qaX4OJ+quEL0CSWyJUhsSZpkeo4UHjBfX8
        fRXlqNcggufT1KIgkNokCz0ATVhOsQdkDC8OK9o=
X-Google-Smtp-Source: ABdhPJxj3TPLOXIZzh4S9H1RWddnxFzXNlzlUZ64vXiCKaXQN7ciYX31xViqlzMoMKTBlEaYhHDQQ/kj4iO30j2T3f0=
X-Received: by 2002:a62:1611:0:b0:50a:41c5:e6fc with SMTP id
 17-20020a621611000000b0050a41c5e6fcmr34945492pfw.35.1651147200528; Thu, 28
 Apr 2022 05:00:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:522:8e14:b0:43f:4996:45bc with HTTP; Thu, 28 Apr 2022
 04:59:59 -0700 (PDT)
Reply-To: dimitryedik@gmail.com
From:   Dimitry Edik <dmrdavidnikiema@gmail.com>
Date:   Thu, 28 Apr 2022 04:59:59 -0700
Message-ID: <CAM0vfEwL5CO+xu6jzgzPPVG-U_LRJzfXM+B1mk==Onm31dhyCQ@mail.gmail.com>
Subject: Good day to you,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_MONEY_PERCENT,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:442 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dmrdavidnikiema[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.3 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  2.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day to you,

My Name is Dimitry Edik from Russia A special assistance to my Russia
boss who deals in oil import and export He was killed by the Ukraine
soldiers at the border side. He supplied
oil to the Philippines company and he was paid over 90 per cent of the
transaction and the remaining 50 Million dollars have been paid into a
Taiwan bank in the Philippines..i want a partner that will assist me
with the claims. Is a (DEAL ) 40% for you and 60% for me
I have all information for the claims.
Kindly read and reply to me back is 100 per cent risk-free

Yours Sincerely
Dimitry Edik

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997F8536C4F
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 12:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiE1KbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 06:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiE1KbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 06:31:03 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0063C18E0C
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 03:30:58 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id d132so3046987vke.0
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 03:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=QmYwoGsvlMY9BpfQUL9wY8zp7Es0gt8FgW8UUndyAh14MvTQZ1bCNu+6yT7dMSzA2r
         hm6heIv7p9nw/59rFoFFPaKAiC9VI60+hHRzJi70QojMnstBjzLPvT8gfNyP3hvGSEaV
         d2aERXAll+dYfuPTcrFDkCkTf5uOUZ4PiW0y2+YOGFABOV0iMWAkzqxsCn2ByOAl1qey
         V5lJpExGRH2y8TBmxi0tIV2hBCv7oKMdN8RK819tGCh8Iy7J0U/D1Hv/LVTm9kzwHxsP
         Aaz21wbb52yKfiHOyyEJTZbTQniELoYM8DqWogWZB8vgbMuFBX2yMm9NTzBYm4pmwbYk
         G3gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=eiRccRh7dZvzxGe1Fm8lBb8gZoaNlcZWbBAPd0vM3iwQhlczz0AMgXdsPIdjyZTgcq
         60BJaN6KoX9WR4N1rDNRAM/5CAsF/QxgM+iv/1Tfb93FqH0rNzU3rkvmJqIcC3xPJbqg
         p+tAJMRD7FAIDYYGBTm2vEwBdI//n4gFBhrDp1i4cQdGCdCkoet6g/0X/Xx+ijx2depj
         ejq30XndNwHBGRbCmWvIhTioocCh7Y9Br9c3UigSdP51dV8HL0lCeccoSin2TCthKeAh
         NNyUVa3MsPgvRrXsqBGpxrv0rkaNjzMgH4Qb3w8Qsky6HjVhCj3MVyZfZbi1dlFv+hfu
         HVGQ==
X-Gm-Message-State: AOAM533wjaxUoJJ8fqXH7vc5I4TBFofHgqApWWTGZl/NnG41BNuEs73e
        vxDBWCTM+lZ6kO3eNRbBx2jWCSfkdYswENih8jQ=
X-Google-Smtp-Source: ABdhPJwWLq8XU3b+iq8TvS/k3IknT5cTmLVVZL2LRxcWheaCwpxRYcW1AlWnxGsirhLtKXjIfKAk+MnP4gahBgqAjCM=
X-Received: by 2002:a05:6122:14e:b0:358:4f5b:f65c with SMTP id
 r14-20020a056122014e00b003584f5bf65cmr6435399vko.3.1653733857833; Sat, 28 May
 2022 03:30:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: issas2392@gmail.com
Received: by 2002:a9f:35cd:0:0:0:0:0 with HTTP; Sat, 28 May 2022 03:30:57
 -0700 (PDT)
From:   Zahiri Keen <zahirikeen789@gmail.com>
Date:   Sat, 28 May 2022 10:30:57 +0000
X-Google-Sender-Auth: nwgv_uVu9YP6N4QVAjJ3WKFqHGM
Message-ID: <CAKUU221qqmp2KotfoVbeEiMw9DjndWO7LWTpYMPhpUdFGf2+Ug@mail.gmail.com>
Subject: I Need Your Assistance.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [issas2392[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [zahirikeen789[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I know this email might come to you as a surprise because is coming
from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri

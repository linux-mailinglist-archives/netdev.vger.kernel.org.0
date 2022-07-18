Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5ED57871B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiGRQTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbiGRQTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:19:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CBF25C5D
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:19:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id oy13so22157170ejb.1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=K9aCivmd3pOhXO+7wSe24RMSLcWBP61HE/hhO1yg1yw=;
        b=POe8t4gArtA5jS3huF732Sgh5dMnubi8XqnVyUq5bHpC1xIcbgUIX3BECk7age3R+7
         VW1JI5Bg6jNv9vvYuhB8UCUwnF/gkbRXbsgq7b5+plHUKU7ZT7QFctoDEWuh6drJEhk5
         gp0S4fYujMgrIF/T4XrqFUNqvg4EqzeQ0dhwbS7eKWOuN6PeT1o8Nn0wSiCg7HCwbljT
         uEBTPFaHk4ZmPsCo2SfB/wJoEv/1XsmHLNMx0uIWD9x/4Mckk9EhsXuex31WrJW2RmQ5
         n09PUgM9zgCzGh7toEnK+S9+P9nlvuJgHY8Hzexup3XQF1Be/5klASLNWoV9wxgOvvrn
         RNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=K9aCivmd3pOhXO+7wSe24RMSLcWBP61HE/hhO1yg1yw=;
        b=ueeGicY7D+hN6R6cCHKeyoNlki76ZGUosAdn9fa8uj5YFAnkwdC08GgUHZQr8jp4CH
         G5XZUmLo9BflwYmPdRoYT0srw0qWs8YmDPnsjTxdtx+VbnxtngvlnFyGoKQtTjkKfbp3
         pGXZ8l2l6/wiibuDp0TeLWWxZWA2zO+EVbug4bc6DIJxRvXZmYrc8tDdvGv314hagcAy
         fQqs4o7ss7JB0cnTLJe8kcTAvK2SChsT5eJ7jwDWapf0KVbqk1kK0NkSKQx9eBs5NbIl
         CghqH9tTyOHqhMsdtTj3slSpvw1zjN+aa7jElIeJaf50E15GtRKPjZOpCXauJCn5Sui4
         ljMw==
X-Gm-Message-State: AJIora9Be0hRAj8cVlEvkvMVaM/Hdg0sgDr78riz/aEuuvKbVb4SwfF+
        BWuORQmAtLJIWN7VTxQ2DN6rSj0U30CZr5Q9k/k=
X-Google-Smtp-Source: AGRyM1vokk8Pei4Y/YHaQpmCmS/+iCv2AORwXWdLtYV1RRP6tnRgjVT5piHn28rXWb1I1cj2SewM58mcWAynoylUsEo=
X-Received: by 2002:a17:907:280a:b0:72e:e177:9e11 with SMTP id
 eb10-20020a170907280a00b0072ee1779e11mr20463241ejc.24.1658161145303; Mon, 18
 Jul 2022 09:19:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:2084:b0:20:102e:904 with HTTP; Mon, 18 Jul 2022
 09:19:04 -0700 (PDT)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <mrdavidkekeli01@gmail.com>
Date:   Mon, 18 Jul 2022 16:19:04 +0000
Message-ID: <CAMsn+iCHE9DWS5M01Bd3sNKdo_Kj99UiQPVpLC56ftH=+hVMtg@mail.gmail.com>
Subject: Greeting
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:629 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4997]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mr.abraham022[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrdavidkekeli01[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrdavidkekeli01[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Best Regard,Mr.Abraham,

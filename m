Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE67D6E06D0
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjDMGTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDMGTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:19:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08D861A1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:19:35 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id hg25-20020a05600c539900b003f05a99a841so15321339wmb.3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681366774; x=1683958774;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbAzMwX7irIoOYFZtmG8UV4zgkZ4VM0MiD12pKWgUOk=;
        b=S8fnmmRNXVYbkkVGQU+ktG3Skz2UxfnLAMNM3MmPcTOc7vgC8wQ5EfZXT7xVfGJgat
         zcGG299z7elrN8+Mi6jCgpzVmy65Gtw2zzIIFRGqmrx7y1wNEuJzXkbMg7/5E73GQ6iM
         1QU+mrSrTHMWPxbEQnqPSwiCsqAIZ+L5pVWSmi2DBftcX9kyQND8A87c/ocs8zvtze2W
         VrKBzc/llnqdMsphwcn2HkBpZvBebxtQCmF/UzB7Ww7T7tN6ZZwqAv54voTJXw9w2xTM
         aa0CAOp4JZQzARRuK7AVlfJk/PjFyOIB8lG18bmklW9zj2FJ3paoMys3qr51qTW/QAJd
         ktvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681366774; x=1683958774;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbAzMwX7irIoOYFZtmG8UV4zgkZ4VM0MiD12pKWgUOk=;
        b=KbweH/lIWGR3ehCeuUC95TT5yM6x295hyGwYH4dwMG1e/kKORlsgzXOPwGD3qIor6M
         7D/HHbhj+NdlodsDcQwViaywU1Js6O13Un31d3/j/KwanMM1m1bEHDg2Gk7sDza763pn
         XC0skXaBJ5DQ5p5+nSfSzbu81CnT7OY+gklaLko3aX+UDo363/PoocTXIA78f8ZKW6ko
         D++KMvF7cs+ZJqInpMyVjJdh+ONMSxRet48nCU43zYutqwDo2GFvwbcz5bwRm8sWycQ4
         QDZ097rHUDrMjwbD1RGaVhlxn3JiYMEHaSgPEMVmWqOZlrXavNrOz/FYegcwfzRlPQOB
         rTZg==
X-Gm-Message-State: AAQBX9dS4qLxqpYgyS58utAVNx7e3zzvUV0f20eEubEi3ywehE/VARGn
        urRHa/WRwM0ivqg+ZtUtHK2BWlYgjJqXvLuu5lw=
X-Google-Smtp-Source: AKy350ZMco4xR2SDkgLeD51LUhAOsSo1xYRR5ChKqR7rw75zx6LYMw3XyZuDTF7Z9fk8tM0ir+pwRteb+NFyzw/w2Tc=
X-Received: by 2002:a05:600c:2053:b0:3f0:49a3:586d with SMTP id
 p19-20020a05600c205300b003f049a3586dmr296374wmg.5.1681366773960; Wed, 12 Apr
 2023 23:19:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ef12:0:b0:2d3:4ce4:bd3f with HTTP; Wed, 12 Apr 2023
 23:19:33 -0700 (PDT)
Reply-To: miltonleo137@gmail.com
From:   Milton Leo <mrhugsonmoon@gmail.com>
Date:   Thu, 13 Apr 2023 06:19:33 +0000
Message-ID: <CA+0gGE0WB2-ypa+SAOPS6gV7FFKsoObRhDD4UzfbYvXNfq=qoQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.7 required=5.0 tests=ADVANCE_FEE_3_NEW_MONEY,
        BAYES_00,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:331 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [miltonleo137[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrhugsonmoon[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.5 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 ADVANCE_FEE_3_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day,

I am Mr  Azizullah Majid,from Burkina Faso  an outgoing Minister
confide on me to
look for foreign partner who will assist him to invest the sum of
Fifty  Million  Dollars  ($50,000,000) in your country.

He has investment interest in mining, exotic properties for commercial
resident, development properties, hotels and any other Viable
investment opportunities in your country your recommendation will be
highly welcomed.

Hence your co -operation is highly needed to actualize this investment project

I wait for your prompt response.

Sincerely yours

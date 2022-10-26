Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8974760E05B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiJZMJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiJZMJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:09:05 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C662CC81E
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 05:08:00 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n14so5792581wmq.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 05:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqmgx017SrITG5HrsBGB7w06Lc5in0p0fwM4eqQQxd4=;
        b=L0Aod8Iq2fQ4sk/tMqs3VjmawYjkJq4tI00cBbOG80TrZ2ZKGjRlHLuIN/JFMqj5mx
         8QEiLT9KowJ1vqHz6X7LgpGlYviBEeuS65s2NCdw3Is4S8eggE7Vxi/tIctMt6O3rvCZ
         fNhDtAs55w87TcYNHquv7Kjwd7FeWGYBpWBs8aFRLOuNX6zTc4YCkROAMQQV4a6yP8lj
         Ior/AP5/ZZw3SPRUlDSz+hBqjfLCvnfZOlUPHVsFZ/f3Qu8ruiY1gWqdWnByaF+MANe2
         IYkGpU7tmSqwCkwur6kQvOaL1/KjgJGzcbFUAuYpqNhBnsELqVrUKalYgiLsj9aNsF3S
         hxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqmgx017SrITG5HrsBGB7w06Lc5in0p0fwM4eqQQxd4=;
        b=CEq1lm8tHo7EscZEhpo3f+Oha3kjHnWNmRnBSkJC6E0O7pH2BlGBfPcGm/anfSoCDP
         KFSc0MRR8odsvLR5CMDasduUM2FKh131ipgrnOSs0t+ojYjNOxsvypZ9/lHx14kczJ7m
         rzvnvlamZporP90kOovB3m253SbofEmrL8nLzWTe1syembsVjs0t0GWNH1hRHZX+HyH7
         0YOvubbWD0+EUzbzU3j/CMrdgHHq1takQcgI6sT/JiFU2yOGRn5Wg55IxUN3gC+9KVoM
         Rkvf6pqQDNaCfhByqF56+ZHpSA6jgzjd20YOq/tPkGsYYW0m8yqZGhM5uzz2YJEt9D6F
         LYmg==
X-Gm-Message-State: ACrzQf3XX2XI86rKcHmawZb/tjHMwetshJBTrzpSOpVI8hq/9QK/hVtX
        8iKs9xHXdJ3rz3sI4sE5abd1blTpxDYZzJ4+I28=
X-Google-Smtp-Source: AMsMyM6iMZCf/sJKgpPh90GiwXagKl3oHMu07QHS+VluOHVTiwy2bhtuk4R8nVuVS50PpMZMSzGpDHybwLrl25s8FeE=
X-Received: by 2002:a05:600c:3d8e:b0:3c6:e58d:354f with SMTP id
 bi14-20020a05600c3d8e00b003c6e58d354fmr2219695wmb.176.1666786079330; Wed, 26
 Oct 2022 05:07:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64cb:0:0:0:0:0 with HTTP; Wed, 26 Oct 2022 05:07:58
 -0700 (PDT)
Reply-To: PRO@secretary.net
From:   Mme Biya Ahmed <ttc3227@gmail.com>
Date:   Wed, 26 Oct 2022 01:07:58 -1100
Message-ID: <CAPnJZBvQQPcxEsTcSdFU_qXCG5dq3WnukoNyQeRKMmE1FLa19Q@mail.gmail.com>
Subject: Good morning !
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:342 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ttc3227[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ttc3227[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  2.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fairdesk Bitcoin Exchange Cryptocurrency Exchange promotion in Burkina Faso/WA.

Good morning to you & congratulations!

During our visit to introduce bitcoin trading to the people of Burkina
Faso, we extracted emails only for Burkina Faso, but since the search
cannot be accurate, your email came out with 30BTC which value is
US$575781.00.

To receive this payment,kindly forward this message to our Claims
Agent: Mr. Benadith Conalthe - E-mail: GT2003@housemail.com
Phone: +226 52 92 03 22.

Your payment code is (30BTCBFS)

Your name ....
Phone.........
Address.......

Payment Valid: 7 working days.

Thanks
Ms. Biya Ahmed.
Bitcoin Trading.
Promoter Mr. Jacky Choi - Co-Founder - Fairdesk Technology Limited
Singapore Co-Founder Fairdesk Technology Limited.

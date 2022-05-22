Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF76530698
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 00:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiEVWvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 18:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiEVWvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 18:51:47 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400541DA4A
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 15:51:44 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c10so17041240edr.2
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 15:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=wX4BMjOypo5d/OsLI8Sw4NpZ7scgBV3K3bt0u2CQOQc=;
        b=JMXh9egJxmEpFG86HcEicdEz8xF5MJsfsIXU0ulMIDhLGkp6lwlH2aDf8E6i7gzyLq
         rRbXZsN8e58Iei6l/jJkT6FIuT1qEhkapKkR7vocGm9JL4zkhu6jjcRoMQKv9vITZUFD
         SRdCMB9iS8LSG8h9NggbCcOQxRYXjGxt8s9c7ee7JOhF9+UmQsi7q/4a32pqBrO2k2Y0
         +wITQ3AVm5o/eWQktnVM5VmkFqnHlNZlEeKHGft3FwOrdajURk9hJ/v4YLNc53+9hOv1
         DsjpXzd77/oTIVfId3valpG46+UgOExDtU7qBEe0whEMeFtbQZ6MOfeLJPVPAxsmu4Ih
         8lVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wX4BMjOypo5d/OsLI8Sw4NpZ7scgBV3K3bt0u2CQOQc=;
        b=LQ3YnHpWYkKXXdSLj/vyriECtcVxmF8Zncn7uApoaPRFPgqbKOVLsLDcC8ESATQQlx
         Qb4edoy0nxLjBhqrTuXvh9CNLIZxPE8UGVXogSQA9Ll3Y8CiONqtQWTsdQKw23p4AgYE
         jzfA2qoP8bCzXJV9CsFPOCOgC3iZU/lylC0nBttiCgFvWydcQVrWWb4r9ZYKv5OQAt4V
         z12tMDVRaOFEtx8X/Q6g+1QETE9pOKmxPcK2NfflyoA4fIgXMv8PAOyx1c64sFP4tDsl
         OlzpCLMwYEt1AtGNDgxlbjQB1+u7ckOuEVihiM2nmQT4UXDKYXzotsXb2i8mkJIt8B5b
         AlDA==
X-Gm-Message-State: AOAM532/dpjyhfnhO5Tn5pwHlJZ1q89hx/aBcOcS5Cp5uNib+kNSNQ7t
        zmk+AAd7syV/yfadvxfJRFfFzbj3LH4sjlAiehY=
X-Google-Smtp-Source: ABdhPJysamPqqujJ8MKrJku8gw6hFQF8/0t4/Kg3VNeORk/NNlY778QhyINMjx/0qdvgN5agqR5t5RETGV1NHC8yDTw=
X-Received: by 2002:aa7:cc01:0:b0:42a:402b:b983 with SMTP id
 q1-20020aa7cc01000000b0042a402bb983mr21255713edt.257.1653259902876; Sun, 22
 May 2022 15:51:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:858e:b0:1c:7fb4:f4ae with HTTP; Sun, 22 May 2022
 15:51:42 -0700 (PDT)
From:   uagokabouago kabo <uagokabouago@gmail.com>
Date:   Sun, 22 May 2022 22:51:42 +0000
Message-ID: <CAKSh1tA9V_qGQLqii46kctuDgrG9Fu5DzFC5B9fB1RwQitsKGw@mail.gmail.com>
Subject: GOOD MORNING !
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.7 required=5.0 tests=ADVANCE_FEE_2_NEW_MONEY,
        BAYES_50,DEAR_FRIEND,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5050]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [uagokabouago[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52d listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.0 ADVANCE_FEE_2_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,
My name is Mr.Kabo Uago, I have an inheritance fund of $13.5 Million
Dollars for you, contact me  for more details.

Regards,
Mr.Kabo Uago

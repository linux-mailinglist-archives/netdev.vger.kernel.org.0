Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B926A5081E8
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 09:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359663AbiDTHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359662AbiDTHXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 03:23:10 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F62825C5F
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 00:20:25 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id i3-20020a056830010300b00605468119c3so542219otp.11
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 00:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=B6riQB3pJoh1S/p2xBQAFL6gaVYbHsW6AyOH4eMZTg1g3wsortR3cuV4mHEEnuOEdp
         Ovzs3C5pSYc3e6FKfJaGBU3HtWkxZX0Uz/+PWFsmjTUCT9FGbPvcHuhokU+tdF2Utrjg
         ea71eAdrIyddO72bo0pUyOjiiI4GbbUbHQwQAHnnXksen+87lMtMx6y9Kip04HHdMhCw
         njPJ1uW2UV8M3NReVvYdBC6VdKD1Qv8v/VOXqL9/88eAbtbZxo9zLR7MrjcMgO0gAgtm
         hSclhSwsRhmu8LMpKcHKzsMUyKojZYL6LsCzqwvlqcyBw/UhLKe0ya1VnXruc42tQCGF
         Geug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=zUxpsgq2HrXnXZ43bBTYUs9yLnpOiyupiuNm0kK+FQ4Qcpri5+W3UyIAGariJjEbwd
         Fe262I2wiM9IPwu4osV9i+ZY5gKIMvcabY/3M/AqHbeaVZntXneUAJQi5ZMjk9O41Rkk
         7flyrv/6f5kqMStmW/m3DOrC0fBOguTzOaHvFksBiRaqNTS34G/e121sYdYPS3Ou4UEH
         HbQToQKdhcZPSSM4H5BJiCTCumAhW5ui7XXAoLXodC0XRakWQv/PWYxzUEvlugugOtoS
         wC7CA6cMkjeX4De1OuA7fncNbZZr0/94gZT2qFfSk/+QlcrnMOkkv2dmARiBiT+2zPD5
         KDKQ==
X-Gm-Message-State: AOAM532JcndPeAxFEn4d9xJ8W3MgdbNCRGUk4IaNPfIGKYkMhHd/Zb6Y
        QAAmcP/aeZoQIW4/tkr+scPAlSlToxOR3gHNBog=
X-Google-Smtp-Source: ABdhPJzbyVr5m3Hekan2R0KAWl6cXm9dULdCcfxK8xArdNPf4ZJwbK8NG3Jn8Jf1f7mZazFI4j0LGFRuhT4i0UAlH6M=
X-Received: by 2002:a9d:2947:0:b0:603:8c8e:7c5d with SMTP id
 d65-20020a9d2947000000b006038c8e7c5dmr7247626otb.205.1650439224539; Wed, 20
 Apr 2022 00:20:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:cf94:0:0:0:0 with HTTP; Wed, 20 Apr 2022 00:20:24
 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <harrykuunda@gmail.com>
Date:   Wed, 20 Apr 2022 00:20:24 -0700
Message-ID: <CAKN7XSWZrGQLdDHLT3xrV0wgYnRcMQk1wJFueE_596UCfGjgXw@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:333 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4979]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [harrykuunda[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava

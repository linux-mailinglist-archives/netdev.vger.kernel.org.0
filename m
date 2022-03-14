Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993DE4D8660
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbiCNOEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242094AbiCNOEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:04:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BACB9B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:02:56 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gb39so33970088ejc.1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=yKvpO9ch1BwCw3ZOg35NMglNdsnWtNHzDAHYk4nSP2M=;
        b=AU8jZzu+qdtzYgNx0VqWXWiMlFjrdGSSv00xYE4ZiTn845A7ZOAvnsJXZr0vgJzYdS
         42bZYgunfXX2D2nR6cPGh0wSXwJw8zT6Mi1J1Kc28Apsipm6EJzXcXhwNWmWJbHASh22
         SoIR2g5qR+qm1pyUgG9LdHY4YZOVccCDGMI6zTNuFwP/WSzCvbucxO+gEJOatZRJF2dg
         bjKxYsoJUhZH3OYXFiJPbn/FTSgB/eIGL6vzzr9p6Mti4fGHqFQ6uhT9b2+lwhv343Em
         kYZB9BVOJ+aSyfTBqHLhl7yLmH42Ofwb7Q6tDirlV44uXaibKeqvLsF+FPz5WbPKyWIx
         T/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=yKvpO9ch1BwCw3ZOg35NMglNdsnWtNHzDAHYk4nSP2M=;
        b=UJ48e1JMLzf7GRrZVxgE3xsfXAn5XLuRw95WiDeTx0cIUaGkcovD9pM760SW4eVG0D
         0L3ASzKiQQBgcs3fm9z8kg6F8xy4BzvZIxq2dwjiPblN3msPfnQaX/yc+L33RvfuSXLN
         WZk5EhdHmAnX5xheEnwLeHlQFPdROaZrgkZx9O9DB623oTkYJNVcFYASe8oPDAiiodmB
         Ori97qPsftIpZ+RzMvNZM/y5UfmYjnsNGQ40hh2dQg6NVM8WPpJKp/a9Zu+1sNqRmLLY
         YgV+S9oH+a9zm5xcyBK9+GwsHAPkyMhnXoYjiwJScdxKf5OnofeQezPRZ8ACX7f4gs+v
         IsEA==
X-Gm-Message-State: AOAM530B9/uteXbJHc6Jvlhx2ZwM0Z0w6FhtdODrgfhtypNdnveptL5q
        4pQcCZ62QVZuj4+jthpaNXQiPN95cEUQhWLx79Q=
X-Google-Smtp-Source: ABdhPJyC49I9r458cgOtFQMgvdeSzSOPwuadJoVC8dTGdJSQ3+ycCfFkIecYepvFY8UQihRgIye3MkTq+xy434YrWo8=
X-Received: by 2002:a17:907:7b8d:b0:6db:a30:8b96 with SMTP id
 ne13-20020a1709077b8d00b006db0a308b96mr19143449ejc.221.1647266566850; Mon, 14
 Mar 2022 07:02:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:eac:0:0:0:0 with HTTP; Mon, 14 Mar 2022 07:02:46
 -0700 (PDT)
Reply-To: michellegoodman035@gmail.com
From:   michelle goodman <goodmanmichelle700@gmail.com>
Date:   Mon, 14 Mar 2022 14:02:46 +0000
Message-ID: <CAL=4yxfikuj=dN7PZzHsqA6yKu7bYKZTAvjq4Rkox5SKHW-Hwg@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4092]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [michellegoodman035[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [goodmanmichelle700[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [goodmanmichelle700[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dobr=C3=BD den, pros=C3=ADm odpov=C4=9Bzte mi, pokud si p=C5=99e=C4=8Dtete =
m=C5=AFj mail
d=C3=ADk
Michelle

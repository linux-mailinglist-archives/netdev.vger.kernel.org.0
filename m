Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F62589459
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 00:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiHCWZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 18:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiHCWZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 18:25:42 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0013C2ADC
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 15:25:39 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m41-20020a05600c3b2900b003a4e094256eso1483407wms.0
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 15:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=RjtWv0rgGDI8xDUSOS7EQBV/dJppoeRofwhBZeW8EUkP+Tm54aISm+HJKuGS7C7txk
         y8JlXJulrvzycMiZo/eJByRB+5CYsQV6urdKQ3AomzNyayNh5RRS4h+i31LBpVQVTtm6
         NL2G9lqisegF6ABpu3a47ZRJx3XrH+J3836wR1xIAm/1I1SbTm+xaAQAhK3aByOrdp/g
         lpZuJQPZVuP4gzjQr4XgOel6neymlpAC0141le8PjegLbVIo0wNuv4QaS+kbJZ38MwGx
         rPphI6Q25x5VCnYjm8RC9zPLzXcghtO794HWQ0WJAM4IF3Qj0lRz1Tg5f16ebsN8kpaM
         311Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=B1eNII24SpHKteav8jhFagcZEB0RgUDq6Tp/mYA4oV1xAplnFbaUnjPx5U8wNaRwVY
         3qU1rjncKO01ozFla+WijHAxcNskzy+q1q4/BbV/WK3dYbKW52lSnZeY2j3Nn+Fxuof8
         ZNvwZrVR6y3YUC/jAkkuyan2xPyo1Xr7raMMqvLspvzvJPE2Cr3JR2CyfbgRKeESEYUc
         EA3QjTeQAH5uT/lcGMRCb/IZ9fa31A9XNRVVw9/K7UWdxL5ro2E/hSG9fhl1ZdSEOf/s
         nsGtP23cV06C1yG6H38ngzMq0BQ6c6fgxoEYQQdbSSha2N+k2KJPoa+BM93XnuLy08zD
         KUPA==
X-Gm-Message-State: ACgBeo1z3BZ27a58rHO/5MIOQ//8e7wc5RtMf0MV4tP+DaeLgrM3Wf78
        evXaakbTqo4qBuYKlRGmQ8x80Lb0Alsvu4uUxJE=
X-Google-Smtp-Source: AA6agR4HhFVg2seQyl88cRzdWxNfI4okZejkv/jQ5drY3vTTj/4v1A5378YW0FKXDoDOcfa1+mRHJ+LUV2JzLuMziPQ=
X-Received: by 2002:a05:600c:1d92:b0:3a3:2167:b8e5 with SMTP id
 p18-20020a05600c1d9200b003a32167b8e5mr4172596wms.24.1659565538558; Wed, 03
 Aug 2022 15:25:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:e4c9:0:0:0:0:0 with HTTP; Wed, 3 Aug 2022 15:25:37 -0700 (PDT)
Reply-To: felixdouglas212@gmail.com
From:   "Mr. Douglas Felix" <pamelamcpeak181@gmail.com>
Date:   Wed, 3 Aug 2022 22:25:37 +0000
Message-ID: <CADnBHHkOH3sokOKedD4gm7ESN3fO9idGNQpXSVzdFa2pnn0m2Q@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:336 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4987]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [pamelamcpeak181[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [felixdouglas212[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [pamelamcpeak181[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Barrister. Douglas Felix.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17F35E9C42
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiIZInJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiIZInH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:43:07 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D259356D2
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:43:06 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-11e9a7135easo8318628fac.6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=SnqSRKyiGjXNY3MxSBng4eq1z+iTb/ha18CqT0fa2gaU66CGD6bzfnh8s06GPEs5kR
         Aw5sDJBRuPUqq4/xAmQKsgwXR0NZmuU0clK0Zbji+JXIEFKdjbqoEbeDUCpKTij3x1w3
         A3a1GIqPggdru/CC4cv/a76ANIkPwr9BP8vYqIW0UC0fExAcM11ZufROxsu4fhsCtIzc
         msmpMQ94kLTitrDr0r6LrlNl22bNgeA4uhLXonyzyxqQav++K4dCuPfuRbqOBZ9uawwx
         w1GXxLpbJecoXApRIO9Ne1xRNuKIc+c+OilDGvZlT0MxgTivyQtTOibfY4uhRxj3pwZ+
         dIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=wsjZ5oyYL6S8Ys8T0MBNAcpzVbD257ofjyaoGev+LpRjvyGbtu+Rf89S+gBD1IKIdf
         385jKgNMYHsxsoBF1v4SqO9EKmvAxDV4Ajibp2RstM1zrzCgAQulhyVctsy0K68007Uv
         7mfR2315K3SNc/dl9kneUkJNmCdqGluyRcd7fsl4/tFhSn8ep50Juv3DZf9YW/CAAXka
         757S3X7LtUFzPy3bEFyjvSSZsfQLA40e1uw0VKgxVk6fM2Va4aIuGCtftcbCnAcBy8ZC
         I84RNlPz1tEsZsBDNQyYbmdHMMQBT27oQatyG3HVe0bibUY6khLiPK7SFW/sI0m0lMct
         UOgA==
X-Gm-Message-State: ACrzQf0z095XqdZkUuiIL1bRTQygW0HohNsAjoMxfdjRUA1rR2cwiG0l
        aGj6CQEawalJ2IPpljiBQ9GzS1uVmvlHlB/6xa4=
X-Google-Smtp-Source: AMsMyM7wG6zskDyiFPN0xX/1FOqzu5BYs7CZcj5HUKXSX1/SSBTY/XMHDGocNovVKezBfVcneCiG/3tsXSPUH7vAtLA=
X-Received: by 2002:a05:6870:249c:b0:10c:7f4d:71ab with SMTP id
 s28-20020a056870249c00b0010c7f4d71abmr11592299oaq.15.1664181785740; Mon, 26
 Sep 2022 01:43:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:52c7:b0:b3:4dd7:8c58 with HTTP; Mon, 26 Sep 2022
 01:43:05 -0700 (PDT)
Reply-To: sb9174937@gmail.com
From:   Susan Bikram <redw07882@gmail.com>
Date:   Mon, 26 Sep 2022 01:43:05 -0700
Message-ID: <CAND8bMJM77y-eOLgG74h8pQmjOjtvZq9EO0ncCYz77Bwa6hDfQ@mail.gmail.com>
Subject: Waiting to hear from you
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:32 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [sb9174937[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [redw07882[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [redw07882[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan

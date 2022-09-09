Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F925B30F6
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiIIHxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiIIHwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:52:46 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE742AC41
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 00:49:38 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1279948d93dso1884058fac.10
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 00:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=Bw2WLNEsLjqUYtI1zBJeli38GZA8w7Ds7dC+HQd/JU0=;
        b=M/Ln9Yk5ArBFzllSekeozrf9wq0zrHWNJwbliqQnUmtAaAyAPeGmHBPHENOjB7uk8L
         4Z66/w2vtY6rzWPmNeoVcQNUQ4x08pTagVUlJRSwQR//BHAmBxiveWrABlGxb126yO2w
         C8++UCA5GAfM+3eK/cgdewxoEqQYkZYGUV1VMQ14bKiYkRSkEEf89ihxEK8lDo7u/zFE
         wPn7GTKnMBJoL83q2zGX//biI43prD+hXaltwDIXwxW9A9lqFIGzmEi0zgiSNuq1Qjs/
         /VpTOSEMphtY8mTm9Q+k0QvYmWcqnR+hw3tS+xTSUOUF4XbTARuTTjGYYdfVZL9x85HK
         bftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Bw2WLNEsLjqUYtI1zBJeli38GZA8w7Ds7dC+HQd/JU0=;
        b=o3VHdku5uRonoRjjWjB7G7y39f5lCMTpvGJjWqmbOMX/lMmM4O3zR657hKQ1HpQeho
         j+I40b2Iyvz9r/bZmx3AG5D16an0TawnWkNssnuItTn8Ek76ClK5y2Zw4EdOLefvKgnz
         ZATKgKSeNQuaGXZ0Xx8dVyHRGFH2A6YWvcsDfpZkXOTYIo209/rgo1xDzz1uQNemyLx8
         L46o4Vy62d87yPoIQW6FtTMy7Z62uycPfeqkQkpnivmroJBvHTvOX0/I8AhXux8PeJ2b
         Qdv0o32GGDbWySDzHn1Cglk41gFXAArE2+ITNK48VDalDVOUGzzVbrFVKbcUuLSAvwVP
         HuPw==
X-Gm-Message-State: ACgBeo14hP6umFK09dpp4+Rkq4bU+VfUgWfiMZa6ylAmWWcKC2jK8sAh
        5QNfZIapkIx2r/64bvN+Bm3s8bpvEPk3Nb6TER0=
X-Google-Smtp-Source: AA6agR6ykQIPxToXQM0Qk7FxlvDeuIt6eXGn0EDx4KTIdil2kY2EkD5hTa/lNrHJPEUJpPcA+NKAcv3j8V2NNPtPYeM=
X-Received: by 2002:a05:6870:f291:b0:127:55da:8685 with SMTP id
 u17-20020a056870f29100b0012755da8685mr4128023oap.266.1662709777160; Fri, 09
 Sep 2022 00:49:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:ee05:0:0:0:0:0 with HTTP; Fri, 9 Sep 2022 00:49:36 -0700 (PDT)
Reply-To: mr.alabbashadi@gmail.com
From:   Abbas hadi <bellalogan296@gmail.com>
Date:   Fri, 9 Sep 2022 00:49:36 -0700
Message-ID: <CAOTcJ4rBHAwJJ4x4TunV+A0=5Hb9yVrFWReEss+=BRk2M9iZDg@mail.gmail.com>
Subject: Hello dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:2c listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6163]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [bellalogan296[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bellalogan296[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Greetings,

I have a Mutual/Beneficial Business Project that would be beneficial
to you. I only have two questions to ask of you, if you are
interested.

1. Can you handle this project?
2. Can I give you this trust?

Please note that the deal requires high level of maturity, honesty and
secrecy. This will involve moving some money from my office, on trust
to your hands or bank account. Also note that i will do everything to
make sure that the money is moved as a purely legitimate fund, so you
will not be exposed to any risk.

I request for your full co-operation. I will give you details and
procedure when I receive your reply, to commence this transaction, I
require you to immediately indicate your interest by a return reply.

I will be waiting for your response in a timely manner.

Best Regard,

Al'Abbas Hadi

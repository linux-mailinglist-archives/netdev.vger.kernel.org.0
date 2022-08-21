Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F91759B134
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 03:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiHUBXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 21:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiHUBX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 21:23:28 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444F5558E
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 18:23:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id vw19so1553186ejb.1
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 18:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=OreQW8LduJ+3/sytHN1UMAwYouobUY5jZBcqHsdHYnw=;
        b=IWULmn98JNsLN+GIcGoeU/Pt1XHkBYpzLr8xDFSEytBe9kvXus0yUOtNGw+GNt9pOT
         g8XiuqnTi+GAcvY23VqRNexrF6yEjdktv88B2fv8Y34Ab4gh7+3gjPPJFmhrSnI8Ewtj
         Qzm6WblEo7w18jYZfUD0Kekdk/iCr3IXJeIjrXpsnX3aR52S8s2RdCvB69Eg78Y4DItd
         AZYWKyNDbj88JWaQDdAnqbHHMNU02TXjlKEG645G1exN8LdJv/ssExBqO4vnZxxANAcS
         yc3PbEMSY0L8XfDAkOc9+5wTBzKQVvXqhUiyvlNhT25fGNaks2DyKI+j2xGy0CrcCdNf
         vOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=OreQW8LduJ+3/sytHN1UMAwYouobUY5jZBcqHsdHYnw=;
        b=CSbVvjl0DGKynVJDZiNwrvuVzk4+DNxl9XRfLxKqyoZxYWMmtoNduiJxxIBO9FdLUW
         46VDOeXsD1GWJJiato+yaTAEgXeY3u78AV8CxjpSt/daSAEGQq1W0ahHbhos9LJXU6Y/
         l0f6Sd0oSQnQmieRfUrVE6e0EO/wDRcnATkD689wEVbgQ/Z+ozVgZbjBWxnJvZ5QCCxh
         E0dAWxbBGCpiLFf42cBvmsD5CGbQtuG4gknPAeWASIESu5kiqy00Xb0s677wFhi/Fnyz
         NuBK7XtrqGb12HJMcNkJ8yem7ThmwdnrqeAQera4948JL2LYPPXYFLs7Xdmr4Apb1cHW
         V+8w==
X-Gm-Message-State: ACgBeo2iiJxgMBzGBDpDhE5QmKCdMseEY0fD5NjbRjPW6ongtxH7+ruJ
        fq0bvcNvol6FIIbVxauDSQ49Me50spaOMfkEybI=
X-Google-Smtp-Source: AA6agR5B+24SpcegR1aSRSWZxyXD+/c2nG+4F/u1AMIZEmpKWiEm9cH+Q9VuEZltSJqA9BnLXynZsQCxkQoh30E9FGc=
X-Received: by 2002:a17:907:968e:b0:730:bc30:da2f with SMTP id
 hd14-20020a170907968e00b00730bc30da2fmr8960205ejc.484.1661045005598; Sat, 20
 Aug 2022 18:23:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a5a8:0:0:0:0:0 with HTTP; Sat, 20 Aug 2022 18:23:24
 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Mrs. Mimi Aminu" <mimiaminu319@gmail.com>
Date:   Sat, 20 Aug 2022 18:23:24 -0700
Message-ID: <CAD-C4f6uQ9J_m-DzMsk1PV51cxke-5-=fGOe_F8=aq3+p5Uk0g@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:633 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mimiaminu319[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mimiaminu319[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [te463602[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
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
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

My regards,
Mrs. Mimi Aminu.

Sincerely,
Prof. Chin Guang

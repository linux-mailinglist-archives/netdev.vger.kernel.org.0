Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A27D595277
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiHPGVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiHPGVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:21:14 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FBF27869F
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 17:14:32 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id u6so9137608ljk.8
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 17:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=DJuMC9uSqOfhxPndYeVwtr9rxlpKg28GSgzlSwv/L28=;
        b=BV4tp2k8RBXcCx1l8s/tFTKmUvWsMF/hxlKkZJmau4/wgSv3cnBpJFEzAaAnlEJ9mI
         60u78fY4TWhUJiSaU1wuuda54nZJD7XGeg1IAlp+meHPw1doVWdW2basHPjaWKsz655g
         ZbRKfwNS7O9xZwG+G9/HLBa62fPBftqFj891v6dh/kT9PhyBxwrT6QEQMQo86W8InOhl
         Y4KLBokEBsuUhfs8zt3oesRsGyAmrRZ7mEppc3/8ulReClZ4TNQHBqiU8UjIA8EuKzHP
         oPjviqxJOhK8SvEKWZTefZykRl0+EQrk+hjIloqaUUkRe//EbS4I8l/3+dqSeHgbGpl8
         q3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=DJuMC9uSqOfhxPndYeVwtr9rxlpKg28GSgzlSwv/L28=;
        b=jcEFBnGxaezqZhnGfxt9/bYa0zp6dlsu4ZTdh4GCMa2wjWYdGdtY+hmyD9rrB9ky3B
         qDSwZbdPKsNGTB9E/CFrmYrbnSqesE0ONSIHY4eFNV+nsVNmc03Hr89L7/TxKx0cFzmk
         MUOxy6FXt8bmtCLo9+3M5VkdRgZyseXrHH890JsWuV3aTD/2XJXzZHEtKHcOlDok1QiO
         P10QB3c3tXoQfoo0bm8AV3KIewfmEj4Wm0ObSUrBtb2oqHd6YHSzrq0fWzNdIa2PrLaj
         DdQ70L3kvKXnxS6v2uTWG64ht02NvVBbPa+27ZgRKwCuejHP96BVE34HxTArvs10a/PV
         CS9A==
X-Gm-Message-State: ACgBeo2WV+vsgOFD89mkrnmXBLQ/GjCts601O0XgaiFa2xmcRDg+MNBj
        zUUZ8osvMGBU61ZNk9YJsEJec7sgVUza4/GNh70=
X-Google-Smtp-Source: AA6agR6++SyMXn2wyE5DieTUPNAsFJS6y2O/a1w0bnkdCfje26h4WDLcvC+Loy4RZ1wiVV1G1yD5G7XkmdnFIIoF9II=
X-Received: by 2002:a2e:8009:0:b0:25e:9d69:7cb with SMTP id
 j9-20020a2e8009000000b0025e9d6907cbmr5625363ljg.405.1660608869779; Mon, 15
 Aug 2022 17:14:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:2b81:b0:1fe:ccf5:aa58 with HTTP; Mon, 15 Aug 2022
 17:14:29 -0700 (PDT)
Reply-To: zjianxin700@gmail.com
From:   Zong Jianxin <gitetumary8@gmail.com>
Date:   Mon, 15 Aug 2022 17:14:29 -0700
Message-ID: <CADiDABgariXGK-yF+b2t2AkCwRLHQMCMoaUHWNtHAoeEHvFbNw@mail.gmail.com>
Subject: Deal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:236 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4992]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [zjianxin700[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gitetumary8[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [gitetumary8[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
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
I have a deal for you

Thanks
Zong Jianxin

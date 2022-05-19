Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A45C52D2B4
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbiESMmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237985AbiESMmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:42:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69372BA9A9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 05:41:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id f9so9795704ejc.0
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 05:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=lGz6riEaFeIr0vkotlsevP7rfxmb/QLHYwoT0+r5ie4=;
        b=eIH3G9rusO7sGyJKy+vioRC0Mdyz1diSC8AYQJpYZHXLLCDGK3pOVGqAWkWh3ZiqaF
         /IaUtsNM/gjzeygcLFU6/D6srNz8r5lOHyL4YTSvuA4dItTBnH12o7x3HR9psnz4Zphm
         NFkjLSx3q6fOWvRijAHTm94XTgxDS63hpBF5N48H4ShPwCwasZgBbm5e45LcVBZ3DFrT
         RRxjJ2vLk25fsHGqlsbSoNo9clzpIEqF7qUpONrBIgsRnkVpcfgReQXZYovJk69btt/F
         E5SQyFzA6sDOne1wbaxVv26Q7F0SWFTFaSl0zz4kxu0VTMvrnub+kUtzXbcuZgGH+11C
         rfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=lGz6riEaFeIr0vkotlsevP7rfxmb/QLHYwoT0+r5ie4=;
        b=RE7pU7kfFwjfPUYx1kQVc7XV9fMwl8gO/W5/oPCTJhbcRmrI9AMCxstSCIGfJlqTei
         lFaQJKNtGAvDnm7kWynI98zsAT2+YdX9C1nJE4U6P1X1JGuF3CpenYm47tUbIDm5OqVW
         ujPojJ7yPJA9WETQKkpi63DdFAilEWoCfxquz81BbqqJetNwVPKyloCuojRYlImIlruR
         JlWKi1Y5WpTZD2mWF5JxLASziTc7vMbK/M92SkEcMLg1M80S1bHTeTYG1F3s7+V6K0uY
         AEtwiMgadOPTJWDEyCVJyS7BUwM7Hnmm6b0GshrhBwGhkumYsihxs3urWBG40FHAEuSA
         91RA==
X-Gm-Message-State: AOAM533qFrdcIsStQzvz+7Zhr/5NLRw4gA11Byz0SYXImRkA2IaufB76
        kJmfcjNhgKdjdTH+NFGFFRBFA2fS/vEb0sIS+qk=
X-Google-Smtp-Source: ABdhPJyvPL88Ui7MrIPumcr8N7gnAVXP8uHzJ7wzgeDdVF0MWkOXqMI+h+CY4PADRYKQSHTR+tTmg5YWu9hVg4yCeb8=
X-Received: by 2002:a17:907:961e:b0:6f4:b201:6629 with SMTP id
 gb30-20020a170907961e00b006f4b2016629mr4244476ejc.152.1652964116915; Thu, 19
 May 2022 05:41:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:2605:0:0:0:0:0 with HTTP; Thu, 19 May 2022 05:41:56
 -0700 (PDT)
Reply-To: gomamartins20@gmail.com
From:   "Ms. Goma MARTINS" <rev.samueljohnson2@gmail.com>
Date:   Thu, 19 May 2022 13:41:56 +0100
Message-ID: <CAHn40-iLnZ2SP_Ayu+4spK5yOct0ccUHQJ2jdB07g2CcaBAncg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:631 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4043]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rev.samueljohnson2[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rev.samueljohnson2[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [gomamartins20[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,I have emailed you earlier without any response from you. I've
an important information for you and it needs your urgent attention.

Best regards.
Ms. Goma Martins

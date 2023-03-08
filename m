Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5416F6AFF5C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 08:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCHHA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 02:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjCHHAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 02:00:25 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF45A2182
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 23:00:21 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id t11so20114126lfr.1
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 23:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678258820;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=iTDSAvntIWEjbopCSvLhD7VAbMHgQ/OZIKIT3iJKHR0RqoGR6xLH7Hgc2nMDoq5YvM
         9CnKdqUKIPOX/4j5KeJkBTRaiyEK3s2tbk3i1HVExnrSIu3ZyCxbH1dLbABUXJOObjny
         cO1rQsB/rQ6q+SjVC3/xbqmcntda8g5wP0rXKF2x9OPp66BZLVBoMo/HJZoZWH54WuDt
         eAmFl5qfzbr97U0ouDymINx/RHqaAPDwwVkQRy+hIcnFKO8HX8KI2crh2mbT9ie7ddrE
         L/bTL5WrdkTmgJEBaiGYX7yh3LxxF8xe/n+7Hy9Gfv2tG+KqdthEW1nA76ZUmQeAQEJk
         FVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678258820;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=j+7zNR6tJnv/eZPWOqaSomaCHET06sOLCiGnonSta2KxqNE07ILjKy8QeIiuy9iQ9A
         jxUuK0weSpMK9mXUMWs07q2b777jxLDf/MgBFYde4gjOvXljJ5P/Y4fU0gMZYj1hDf3d
         EbR1MBRbk6GOdnIzUuMfYIV7Zy+HnuTlXhKvXtR6haYlRdaQGxd61ziIzboFj4AbuDHi
         BskR8jC3b8RqRxptoEm1UtlQSMXoJystZmCYw3vSAIT/2ZCg3+Vxi8jMJ4GR2HF6MWyY
         L0aJYYIc+g6YlpVKRb5EHq2H1kGFGXTppaAczZofYzQKDzNGyEpNm8swS5cX0LzN/Q2u
         CvXA==
X-Gm-Message-State: AO0yUKWQ3aRpIe+8Zxc1KLTHUj0JD+X0Bij9++aGduI5boBmkb/VgwJF
        rzTDTmHK84lNOpN7G/pf4Smj2e3BgBFtGBCCpAM=
X-Google-Smtp-Source: AK7set82AZwVeB+nNWNYKLW7JGxfxMGB86NGifokLnXUss8wTelZFHHoL/+0rDyg8A/upQpJPKqA96Bnswrh/O9Asno=
X-Received: by 2002:ac2:46db:0:b0:4e1:d025:789e with SMTP id
 p27-20020ac246db000000b004e1d025789emr5395931lfo.13.1678258819882; Tue, 07
 Mar 2023 23:00:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:a36f:0:0:0:0:0 with HTTP; Tue, 7 Mar 2023 23:00:19 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <hde46246@gmail.com>
Date:   Tue, 7 Mar 2023 23:00:19 -0800
Message-ID: <CAC1T3Q-UrZJRVn-vqm8m_G6OtUZcGpdcEwHFuzpErCVpkJPZ1g@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5319]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hde46246[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hde46246[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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

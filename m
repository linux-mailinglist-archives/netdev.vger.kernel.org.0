Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE75F53BBEE
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiFBPzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbiFBPzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:55:46 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD6A2875A8
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 08:55:45 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z17so2795113wmf.1
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 08:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=1Br/N6WhyVMlujnGsxiPG2oa5QW+rtf7KlXAbdHBbwA=;
        b=YG598HvRGKtHEm3JABfFOleuzpKHw6YuQc5htypWc2fCxoBQImfBzPtD0BkG/LFoND
         U0hxV/2JC9xCV18L5m9QTtp3OcS9hA0qoDGvY/Z9ug2hRkMpNwRD10V3CD0Q8TNi284Z
         x/rPLPWBkPl6XQQRQB/ebFL7AtJTeGkpbrA3JxHPnizHMBW/W4JAYQGP95lyMkRlipLd
         vhSYcvh6bNLtf/f7e99vrkXvTcawwVuB+Dy/6994jka+6lkfaMKtR5td+NSnMBloCgEl
         8f0o6H6jZ6IVwXQUDD1rZg55mLlo+urNq4MjQFvqo3JrCbjce/MjTL9FVGOjWkPtjDMc
         Ztvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=1Br/N6WhyVMlujnGsxiPG2oa5QW+rtf7KlXAbdHBbwA=;
        b=Y0OijcY1G08MlyRHus+BoGE/rfuqe31aMFg5XKrTbsUC6VcuR1UDPcwfe+iK4CVbas
         Q9ho8Uxyds1LFQvICcbzPSssfrjvnaLLlRhCmomLHbxNdZwDR57kAXHqQYnhzVEzQXw/
         U6dN/vhT9WTBIq5eeg33+B5ARal5mQWjFZtZVwTAi26k74kfSbeuQwSIW3aocqAUgwC0
         noxh3x31jDm/5Sfg5vRCjPCqK2iNOxyueyenJvNDc1tv+ams2AqU4GZty/xSo+vJectY
         Q4RHM6AIkA9XVy6slvbmrbOg98HfySwFBUnHfX7QcY2qtJCxxxI33uNnyrNBKBwlOkNJ
         mMRg==
X-Gm-Message-State: AOAM531lYreXGKz8QBdT7Ms3vXWawWdkynBcRhYUfLlsWJXUO2oNC3j5
        eRawBpYAX8OAAlqRKSYtxhYg6Gyt5S0Y1nENSE0=
X-Google-Smtp-Source: ABdhPJy3YHDh7Tt0D9//Tsi1/vmJXagFlGEUVMnMUTS8Lw7RKIQHwEzRj+EYwmVTsWgQOXkw2yAoKPQ++l5QI8h/usY=
X-Received: by 2002:a7b:c449:0:b0:397:4714:bf56 with SMTP id
 l9-20020a7bc449000000b003974714bf56mr33345190wmi.108.1654185343654; Thu, 02
 Jun 2022 08:55:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4bc2:0:0:0:0:0 with HTTP; Thu, 2 Jun 2022 08:55:43 -0700 (PDT)
Reply-To: mrsbillchantallawrence58@gmail.com
From:   chantal <mrsdansan57@gmail.com>
Date:   Thu, 2 Jun 2022 08:55:43 -0700
Message-ID: <CAKP3MPO9BTg8+fZsrAjHOty60KTv4DBc60LKMWdT7prm0WgZ=A@mail.gmail.com>
Subject: dear frinds incase my connession is not good
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:341 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrsbillchantallawrence58[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrsdansan57[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsdansan57[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello....

You have been compensated with the sum of 5.5 million dollars in this
united nation the payment will be issue into atm visa card and send to
you from the santander bank we need your address and your  Whatsapp
this my email.ID (  mrsbillchantallawrence58@gmail.com)  contact  me

Thanks my

mrs chantal

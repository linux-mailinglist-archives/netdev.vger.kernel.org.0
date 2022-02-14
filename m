Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0F24B55F9
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356308AbiBNQVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 11:21:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356331AbiBNQU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:20:58 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E2742EE7
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:20:50 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g7so11790157edb.5
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:cc;
        bh=7MR/c1c0HoGO/HVVoYlYmh/1TEGUfmBelnD0hQ6ZZJc=;
        b=Tqt+g8MeJIddSizPcYyneq7VdZtE9IYp8qFx3XOpgvvftUekwgEGZIieibAKUIS3hY
         I8N1aVsujZ8xsZ077/YVb/VMh401O3iz77HyTKwBkeKmBa0SzCINNS8G+oU2lgTueTIH
         AgGzLeslhzk4jAOojwJvu3zrgbmxYJ5XXgWbnRSfSLNYKlJT9osKHiTIOFBMm74kUt0Z
         vuV5jpgGX64hxxjY0LCpfGdQJf9iz+jaXvOQR7WJqlJM/pugeEtwu9JjI+WQzcaRZhBT
         G752dV/Dn3AU+8wpOMZb3g4y+uo35kSyYpd12E3KUlNeQadVWPO4qj8g2CdrCAUwy3RZ
         0ZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:cc;
        bh=7MR/c1c0HoGO/HVVoYlYmh/1TEGUfmBelnD0hQ6ZZJc=;
        b=3M5Vy1Xd7Xdrykr/s+i7jUasAoG7W8SOblla4ftog1gqJHFM56tshIRx+EGuDogxLG
         iKwyFtpZEkqKxMP8m3dmgHCfAwVbnpiUP/1tQcn5ZX//Z08MejbX+OQEnSX0WrfGWFS1
         G67fVVMgbPAAfvhaEzpPk1XyALX9rz76KzWyUVIwcfRiNGxWJNsw4uXsP94mNqfPdiAt
         473v9CbtMoG5IVt1U4dSIF0cBMIG16fFeWRRCwQxQk1gGA3/tZtVFgMfOU38Mn8QkEJc
         Guo29C7DUC0ybnl5OEeCY/SzC87JcHb8pbDA1LypizA1jRgPdhos50Zk8Mc4IPDw6OX9
         qmjA==
X-Gm-Message-State: AOAM533KCXte81DzBCkL0NeYo7rbsk5BefS2mZI88GWOSdbsBHyJr6Wj
        DWziDNRwD5s3IgYE9PMvs99AgvKl+zNhma8+AkI=
X-Received: by 2002:a05:6402:d0d:: with SMTP id eb13mt324080edb.6.1644855648718;
 Mon, 14 Feb 2022 08:20:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:3ac7:0:0:0:0:0 with HTTP; Mon, 14 Feb 2022 08:20:47
 -0800 (PST)
Reply-To: israelbarney287@gmail.com
In-Reply-To: <CAL-3urjUgS02pTdapMpXa_0vvJbY1JNoJr0pL4huj_CrL_81-Q@mail.gmail.com>
References: <CAL-3urjUgS02pTdapMpXa_0vvJbY1JNoJr0pL4huj_CrL_81-Q@mail.gmail.com>
From:   israel barney <solomonhiroshi@gmail.com>
Date:   Mon, 14 Feb 2022 17:20:47 +0100
Message-ID: <CAL-3urgyszfbig0JOAc20nG4OBHdhCH-QWHMJbCXgPb+RYRK1Q@mail.gmail.com>
Subject: hi
Cc:     lisamuna2001@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,
        MISSING_HEADERS,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:531 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [israelbarney287[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [solomonhiroshi[at]gmail.com]
        *  1.0 MISSING_HEADERS Missing To: header
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,

I'm happy to inform you that i finally succeeded in getting the funds
transferred under the cooperation of a new partner from India,
Presently I'm in India, for investment projects with my own share of
the money and also on charity work to the less privileges and the
orphanages. Meanwhile i didn't forget your past efforts to assist me.

After your inability to cooperate I found a new partner who helped in
getting those funds transferred for charity work , please use this
share of the money for your self and also invest some on charity work
in your country.

So i left a Visa Card of $850,000.00 US Dollars for you as
compensation for your past effort. Contact my office manager and give
her your complete address so she can send you the Visa Card through
Courier Delivery Logistics

Her Name is Miss . Lisa Muna

Email: lisamuna2001@gmail.com

NOTE; The Visa Card is an international Visa Card and you can cash it
in any ATM machine in your Country.

Regards
lisa muna

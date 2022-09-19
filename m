Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D90C5BC1F4
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 06:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiISELB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 00:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiISELA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 00:11:00 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B423F175BC
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 21:10:59 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 125so19533262ybt.12
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 21:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=EF466CPlDwWEbmcND2CUJGJ+vMb2ggZktd60vz1ev24=;
        b=lpoUdZsw5DmzzaPP49EXxCZnWXGNLxFDsoa38nxUff2nSBN/8zp3lVvrNZN9seSfyM
         7Siy0qy0O70Pzz3OD68q9LAKkp2djjiByOVNBq86gwRtZPpTXYn6sDGqY93iCZsV8kIk
         sTi7X6GbUNvzPoMc9hMLSGxKa5cm0k5VE8swNDvzOUAw07MugWA+2lbk5KWiLEBUMMDp
         sTV6B/ppr/vx98UBHgPKdoXUlILdR2yV15cdML5vHLKo7F+OWNIqpP1sLKy2995ctYKx
         KgudT886/kQdGVHhZeHXAjDknsBCXSYP8c50U8E+2iWOsZDtDDEeIQbbpaDjLeSksovq
         I+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=EF466CPlDwWEbmcND2CUJGJ+vMb2ggZktd60vz1ev24=;
        b=rtbi44yKhIm6sLHDKE4PDsAr/hpUlX580CDv37kPHIF6Z9xUXrZMJS3osM49ft6TyF
         jImLbaSVqk77VygLcrh54EalKhn30yf6lEP1aQvmfXBJ/j4EXVA4jYDXcaggApnpCFOf
         jS84dDC/ROwy2u+EFie5+my6AB42lr1xWKn6Y7eeUQEUUwUDCvnZBMvgj+cOurpSY8/g
         CCA9P+ssC1981MYkXsHCPRBVuXY/G4mlqbiiCnmDjiJOGSKRw6mNW+P9wzKGGL4kHJRo
         K0Q/O+HHyD2ZgtoOgEI+djho1kIBGMze6gujCShAHLUD95MHZwfdOGGmoIDFvbrBJFI9
         JzOA==
X-Gm-Message-State: ACrzQf0RKLBN0ZedLMqLr6eUHQKOHuD4eBQgxx78x7+ZR+V3KqqGeejk
        LwyrplXSssx79unTi7T/PPL8jPWtU16xbYmBC+U=
X-Google-Smtp-Source: AMsMyM5qXttVnsYVKOBq/1N1fROccBk1BcLLe1u5LsR9Hvh8yE7SUtA4NS5Utqj/mJxMLpHzuGD5+gjDD9WtdLLmqQg=
X-Received: by 2002:a25:1641:0:b0:684:d31a:feff with SMTP id
 62-20020a251641000000b00684d31afeffmr13676015ybw.538.1663560658913; Sun, 18
 Sep 2022 21:10:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6918:1684:b0:df:33a7:7e4f with HTTP; Sun, 18 Sep 2022
 21:10:58 -0700 (PDT)
Reply-To: ali_suleman55@yahoo.com
From:   "Mr. Stephen K Garret" <sherrymorgan888@gmail.com>
Date:   Sun, 18 Sep 2022 21:10:58 -0700
Message-ID: <CAKwJ9kd3rvuTrC5E4poNX+9n8zWNFL_+Wnv_wWtpj_jbD9QqTg@mail.gmail.com>
Subject: Kindly Let Me Know
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sherrymorgan888[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ali_suleman55[at]yahoo.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sherrymorgan888[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


I have sent you two emails and you did not respond, I even sent
another message a few days ago with more details still no response
from you. Please are you still using this email address? I am VERY
SORRY if sincerely you did not receive those emails, I will resend it
now as soon as you confirm you never received them.


Regards,
Stephen K. Garrett

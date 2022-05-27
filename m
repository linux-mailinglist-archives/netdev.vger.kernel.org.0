Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816E55368E6
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 00:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354858AbiE0WnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 18:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiE0WnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 18:43:15 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B6A5E771
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 15:43:14 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id v9so6281265lja.12
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 15:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=mtc6I7Oc2giNnQD//vwJqJGiICc/iBsuQvl4MULecZQm4erPGTeuXStfzwcYED1XRV
         AjuJlGzNNeMbLRxjY4dCY+xsppmYLPum+TLxaTtoPbN218YC0KIjvQgXhoESROwKje4A
         OReMgLdR4yOxQOzK026DRGK/R5vjZJ7oopePAQp7H13SLByCk6JXHjxjwK2yns8IZi7V
         wrEcfgufxLIIXYhXYzLsvdPsDlHqJwxGHXzfLZ/muQG5vyQT2LIIHLcTqXP8j1828Ybz
         zOb0EtClcQbuo84bTHfhsnWMmA3HDakcy4Sv2ecd4CbuTmaNsB4LTZNh1z5PvZICNHNk
         Z+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=BoFpK/RmY9zDhcUbuD/nxElZGQ46VLBwKwVTlCxpGEDtfeeAqldCjH4JvUMuH772GH
         y5KK/pory+8UVFF5NI8chm20HVhuY1ftlHdO7Xct6BGpiDrGRj2Ji/z8jkDxz42XAhWq
         K3QlfG37eOsWep2VB1rZxbHe3UTBwy2r5MXFqTEz37RF32aTGfTpGYo4WY2vpfep4b1d
         WZNbBfXTqk6fZX2EBPwPiFzfqii9jVVfac/UzeRq07fqSwN7IC+UVNHEp1f6tOF4Dn7G
         +lcQcCTr03JqfljrawyVGWRyKqeJvzFlUQKjBtb8Ua3tN1txG4LDQ4nNLy0mTl4VArWL
         UvlA==
X-Gm-Message-State: AOAM530+oxGqM4KEkoZOp1KHUcRGtK5a2CV3hzoiHgTsC5QI1d4RGxa+
        L5C7PC9M5582mPDRquJXpd8SfW6dkyW6HTNMPgs=
X-Google-Smtp-Source: ABdhPJxGxIMz/qEevarmhElRTgefH3L+TperFLTt+UMVnwQoUJV2SlL7DW/ysdtTwh1StqAZn4NPTiw4XwFtgibacrY=
X-Received: by 2002:a2e:90cf:0:b0:253:ec29:ad7b with SMTP id
 o15-20020a2e90cf000000b00253ec29ad7bmr16170082ljg.340.1653691392048; Fri, 27
 May 2022 15:43:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:651c:230c:0:0:0:0 with HTTP; Fri, 27 May 2022 15:43:11
 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <tracydr873@gmail.com>
Date:   Fri, 27 May 2022 15:43:11 -0700
Message-ID: <CAARq6VawSps4gb6HVeAC9ShF6p6b-6-xU_-56pSAfVXGP=-C+Q@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [tracydr873[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tracydr873[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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

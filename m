Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3055A68BC27
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjBFL4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjBFL40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:56:26 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3432023870
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 03:56:01 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id x8so5731430ybt.13
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 03:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=XdxCFFK78AFJheBu1CiD4UMQzHpyqkeqJT5Sm9+xbqj9Sos6aQGCUc0Z7t+/wK1V6A
         XdkC6aOFS7MP13rNG2+1+8jK3qQv2+SCkVeTxIUocx6xmzNU6iu+qMVCaF4gGdiCN6ei
         kMNthUyB4CcXuTRsbSpIDFt4xQAKJbPPDGer8QR7TO5WsT4Z9LykSgZsA7I9KXe3x99H
         lIPe0/pnQC8uUdQwM99+ub/8nHd04NUHzXOaX/HSYtiz1ed8oiliX2hzDQM1nyjOTSh1
         i1mtdYVJ0VbhyQskQYIkwGf8ZOoXOXk7ri8fcgQfyVqotb9xplcc50vrTj16EFKi/3A8
         kU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=zXS7U8ykxFnNYdJJHxbJiWEeSEvKGd/EB6G526iGViNxitjG6RGJucE18uEbA7yK0J
         eRx1S/FB8Z0Jv2g6w33bW2tn8AmGeayn1DQMLRYx9az9K2bxIAPT3ZeUzyAve507hr+r
         G73z2XMhXaG/66Smhdz15ZiUwr0kUKF0fvyJ6dB6qEUxq4PHy5Bq0Gt4q9Z8t9z3j9KC
         dRS62ewTvWZYd88TVbAv49/H+5TDs7/3+YbT+tYoIaNnoyo7WYqpyWnJ4z+k+ZI4x0PK
         I0Qw11lwj0+pf2ehXYFpJmbheNlZP+Vr18R66ExrqgEFQhBw161IF5yUhkuPJjwMnpCw
         czXg==
X-Gm-Message-State: AO0yUKUFLj6WSpZXVLJqc+IxJ3zdmMcpyV4vNTgOyAdyY7mQvgVf6GXS
        aZDzEDsInIOn2YjX8VBUKMMcwKNuVzybewkaqLg=
X-Google-Smtp-Source: AK7set83rKriUU/mlMtxtzXQULquvqkU+/ybAgScjGWGBWLLegVM3txyIvWiLQkCVWMi0Ylg9vFldAVt4yH5putjT4o=
X-Received: by 2002:a25:b18a:0:b0:6f9:890c:6468 with SMTP id
 h10-20020a25b18a000000b006f9890c6468mr2088241ybj.610.1675684560099; Mon, 06
 Feb 2023 03:56:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:c0c:b0:1b8:5cc2:7650 with HTTP; Mon, 6 Feb 2023
 03:55:59 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <dasfes56@gmail.com>
Date:   Mon, 6 Feb 2023 03:55:59 -0800
Message-ID: <CADyKiReWNo3JQGMaxRsJmjC4prNYXQJQCm1FYCxr9y+Jx7AfnQ@mail.gmail.com>
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
        *      [2607:f8b0:4864:20:0:0:0:b44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5004]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dasfes56[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dasfes56[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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

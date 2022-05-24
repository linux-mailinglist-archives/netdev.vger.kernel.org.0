Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5AE532368
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbiEXGmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiEXGmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:42:05 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54DB3F898
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:42:04 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id h13so9367739pfq.5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=+/ObZQdcudoKPi9EHyxehxS+g8fV78JSk4u1MMEObnU=;
        b=Ogooy9tc/DXDLzAYpbEri4U1z1FGgUGvKdtkuN8+c41KuZeltBY3BwhCJ/hLGxl8Li
         lp+T8uszpNaMyr+6NoD7+W2APk2LS7AO1U/a1naR4opn3VeobRHt40dRRANUB+4eErZv
         r+q5NbgIU11yjN34Qt8vEROA/wV7QZYxJtmwXKRJsWIy6F38v9cCDl43rX8OzLhEz+1J
         8IZj3dFXXxdfueFXOAS8NSUrEfmxG1JLEQ9hpBEN3ZogFmizbSPFoDZ/ZQA4dGTHGiYv
         UNwooyjSkMcewZhcGKh805dSWpuHE6skbusNmXkvEhUx9pZl89Y1XsEf7IAJE8TVDtow
         bwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=+/ObZQdcudoKPi9EHyxehxS+g8fV78JSk4u1MMEObnU=;
        b=JGv8fwu1+2hS+3lJBQGKFq3XaR7mrikrXjINXqNjIqDDwRmJs1jJzikevloNQX9o9q
         9OImj0GhEZvssrmG422LeI182u1XCtoyYD9mJP2qP1ugYuc6UaPxfZHYwHtxAvknxap0
         2wl896otWJ3AnAxeuRwL6Diussm0uRz93ou4aESrFkX08GutfIQP8jdITYWtC7C/JqoO
         ix6TIGpGuxP0tRY9I05lJR5SYTxvupVlVR0Ku6UGlyfDQLJ2CiAcaejZondhg565cjH0
         VrCcCY1YHnFt59VkfHlzJMc41Z6xNVBXKjb1LCfxlsykTD+FLKCmKua6GEAGha44TFiU
         MiHA==
X-Gm-Message-State: AOAM530qhxt1/PEYo6FAwJbaYmcHNuxMp/bF3zfpYS3SwNik7HeRvOcw
        NDZZlfZ4Yz8C8HwIELGUSEkiObyGGjjt74z9LR0=
X-Google-Smtp-Source: ABdhPJzzDOc2XF7fLuBz51AiJaACG5o1jQZ8hPB22aGfAKrbPmDgBD45azxOfPNJPmVUiusO1iI465HIwiJGCyFYhfc=
X-Received: by 2002:a05:6a00:238f:b0:4f7:78b1:2f6b with SMTP id
 f15-20020a056a00238f00b004f778b12f6bmr27202042pfc.17.1653374524121; Mon, 23
 May 2022 23:42:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90a:e7ce:0:0:0:0 with HTTP; Mon, 23 May 2022 23:42:02
 -0700 (PDT)
Reply-To: BAkermarrtin@gmail.com
From:   Martin Baker <davidabula9077@gmail.com>
Date:   Tue, 24 May 2022 06:42:02 +0000
Message-ID: <CABMMw34WD_wjCV-RQHfn4YnwUtubJQagndRMa59C1kReG9+nWQ@mail.gmail.com>
Subject: Morning Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:435 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5502]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [davidabula9077[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [davidabula9077[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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

Morning Dear,

How are you, Please my previous mail you did not reply it

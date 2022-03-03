Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA844CC00E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiCCOgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiCCOgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:36:04 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17904188841
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:35:19 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id p12-20020a05683019cc00b005af1442c9e9so4716289otp.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 06:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=PAuhlXKoN+F1w1gfMETzhilH+R2APbQy2NKsIVQ13zs=;
        b=BLsYAeYo7tBHqXrwglYTO1hVrTF7bNjQDbqtYWejGvufcFIwHXUA7K0TCX2jiuuVtG
         YCceRY7uc3I4C/uBLPehbXKhr3J7eFYwrbOGabvh86Fwa7TsUZpeWQ6cnU0wHV4Ka7yK
         UC3dXMQvgMdVEqD3l4gnxRwSXlUEGQl/59hBsENnIYgSAy8J4LmrxrV2O/EewFzpoDdG
         8a5SPETTc2oCNdJNlBxEfyD+2R6t70OK2oM5v4MAcU7If4rKkT60l7QBKCHgAM2V5rlt
         EdPKR3dH6fQdIJKEG3jUV9uj6wcDkGE4XNq+AOdUlfVqSOtY0USjGp9ha81ik5ZngZS7
         DgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=PAuhlXKoN+F1w1gfMETzhilH+R2APbQy2NKsIVQ13zs=;
        b=BDOMooO3Mb9dVpr8gaikxiaj3qZ2dskwIGYt0A36DRKZOo5y71Vk9Pw230/hwTo9mv
         sf06ncZrzCk2uVG1vdhz2PU4Yw4vfC7S7kK6SF1tbRhV0Vqh4nRwwPvqtK1jWuVHMHGS
         9+5GzdlWzkttigIbm2vO3Z/Gtq5z18mRUEThZPjliG4SSEL7dQYUiLvHpxOIZBVDYaXc
         R1/3WmhHE0fiNElm86/9FN5eAGVnll7m+9FSXEpfxofRPHbzQ2ddIzgCKv7iWv3VmYLS
         8gmZIZMxmdbeWyx+Kplka2rBuWfEj+B3XjPBU2REOSSmfqloXkL+6Mv0oHnCazBg1K35
         yP9w==
X-Gm-Message-State: AOAM530NFErYk/b/ZteHSZkhAx6mOBp3LbB135XSSSWdgp7WurLBprYz
        zCfNts4pf8SRvWzf9ZTuXXHkG6dWbG9XhKYCuUM=
X-Google-Smtp-Source: ABdhPJyS9EO/pr6dDN1b+lLgMJ4Kx4V70ayAe3TR/usKewTuhNAYHFtqypkWksKWpLxXgtmDSsyE3VVSH4JY+ea5U7A=
X-Received: by 2002:a05:6830:55d:b0:5ac:ebf8:6d95 with SMTP id
 l29-20020a056830055d00b005acebf86d95mr19420180otb.162.1646318118389; Thu, 03
 Mar 2022 06:35:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6839:1a4e:0:0:0:0 with HTTP; Thu, 3 Mar 2022 06:35:18
 -0800 (PST)
Reply-To: fflorajones@gmail.com
From:   Flora Jones <maurmbama1@gmail.com>
Date:   Thu, 3 Mar 2022 06:35:18 -0800
Message-ID: <CAD2nLk71Tz=9siJqf01_BjwDFqra4nmo1Gz4uD_ijwJaOZLC1Q@mail.gmail.com>
Subject: MY MESSAGE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:334 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [maurmbama1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [maurmbama1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear,
I am Flora Jones, a widow with a child who is 7 years old. Pressure
from my family has compelled me to seek for your assistance. Can you
help me receive  in your account, this money is for investment into
real estate, I don't want to lose this fund as pressure on me with
life threatening is becoming unbearable. Since the death of my
husband, his brothers have been seriously chasing me around with
constant threats, trying to suppress me so that they might have the
documents of his landed properties and they have confiscate them.
Please can I confide in you, I will give you more details once you
reply back.
Flora Jones

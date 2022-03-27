Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0494E8B04
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 01:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbiC0XF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 19:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiC0XFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 19:05:55 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD05DEAF
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 16:04:15 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so10849947pgc.12
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 16:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=VSEH8Q3Lr+Mcr/0lsL1VFPftJp7ALZ21MKYEz4sry74=;
        b=ih7X/vg5BNT7M1qfsqlt21JFvmfwSJ2c76Tv+SO5MhVQE9nCs5g2VeObVprvNi8Zmp
         v19+cDs1IMXdsxERfdT/V9JTSf4f9end4xSQ9HjduJk47xDBniK8d+8WEtUd0JW3z6jq
         0/CuFlrAmNDmGypD952XwluDXn9Z+IPVNG/RAdAK8xQl1bi6I4JwQ6ktVOUye5Wajv+2
         deQS/+soa5ZsVN6llAW6+eBxDYgqIpuit7AFhC0QiK7U34feCumdeq78yCx8iRYgU5Yp
         4ZEy81ZlBUtupuHsZ3dbYaTP+irvYQVy9ptiGbv5FLVyO6o01ErZP1PLpHlBDH+2H5wa
         GmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=VSEH8Q3Lr+Mcr/0lsL1VFPftJp7ALZ21MKYEz4sry74=;
        b=VwXI9jielr0u2Iprvowh4KSy4ziV9WISdAeQIxK50XRD/i/m3FQW6lGrxnH6cflzfy
         dfIshfsFVoxobCsK/1hC2PWRIrEtSZZDb9+Zrcy9paoG5Af1Ev2U4H3KyoFc+3TMSUiX
         9j0a1CeVxPTEHK/wY54Bi7Y7WutUabYN86kN0BLgZ6jda4WlHc8e3WOcSCqBWlKCUmhp
         mdCxx4SqXo0iWYwCX3ytpH9hI9uNyMLjzAazAxL5kJ5NkBtZ/+MJUC2iJ3rlUxGVWrDl
         hc9tSES9zPMrEpl/mi/ot0p0JAs47JPBj607JgoLPvNWYo+PZrqayW/pYJlZOQBKCcV+
         Xpgg==
X-Gm-Message-State: AOAM530NMBLmA+/eNxrUIoO40fy4ddq1PAldNd4ohfe9L44EjVZU7mYw
        SpUXULDQgGiJ9ZPzUMY+A7zEsYUHxnAzwyXeJ3A=
X-Google-Smtp-Source: ABdhPJwlC/sBRo11wRM1nZPuiQt/VKU6K7YMv/qxy5PrycpL4CmCQh4G9DwNYKlOi7OR3rh3qLLY9dlIy7lHQ6y3azY=
X-Received: by 2002:a05:6a00:9a7:b0:4fa:ebe8:a4b3 with SMTP id
 u39-20020a056a0009a700b004faebe8a4b3mr19537250pfg.11.1648422255100; Sun, 27
 Mar 2022 16:04:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:453:0:0:0:0 with HTTP; Sun, 27 Mar 2022 16:04:14
 -0700 (PDT)
Reply-To: christopherdaniel830@gmail.com
From:   Christopher Daniel <dc60112201@gmail.com>
Date:   Sun, 27 Mar 2022 23:04:14 +0000
Message-ID: <CAEqp4oQ098MtSrMWic-O8G33Vq3zqOHuMi96OtO9VRY6z4CDqQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:543 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4961]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [christopherdaniel830[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dc60112201[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dc60112201[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.
I wish to invite you to participate in our Investment Funding Program,
get back to me for more details if interested please.

Regards.
Christopher Daniel.

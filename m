Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D273642863
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiLEM0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiLEM0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:26:05 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB0F63AB
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:26:04 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h193so10332682pgc.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mwuIivs2bXND3SDhAV+zSYDmApbibgZQPxXCRZ6VkeU=;
        b=mBlrLcvjtpRZw5Jx0V313vkD4VTZniZba8zKWCzaqMSBf8H9peLJqvr2VmzYq7n9li
         7BBIpEPCRmpBZcuM80ica7GMnA89sv0s3uAxgJfyp6gpC2wxfCqk1IIU9zq++t2vprw5
         Q9ypwHataVp6vsH7aEjnYXfOhO4W8UX1gg8aS14BNy9+T2qAyAVMobGNvTMipxL/7RWs
         OvA3c7b75l5ljxMDvDvnjkJ5wuF05klScGWQj1aMrKc7NzXc5WdwYFaVD0P6x1eTK/hE
         Hn/2I44/BOr/u8z0Uqj1MQisDNygKei/9B2haPLZoqcdxqRw9Q3l27W00bFKonj7Hd3V
         d3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwuIivs2bXND3SDhAV+zSYDmApbibgZQPxXCRZ6VkeU=;
        b=GssxCjuWDDF7CLv+Nr+IEfQRFP3D0c/Z4akCcWLGU4mN9Za7vmdUfzIVuyjtPZCYRn
         +t8fxXmcWBradDv+zhG4iXwlp3lFql2ToJIRBTtSF9+mCiHw+95VcnLb8qrrMCRa8drf
         imHjyiPBpwn0XbFaJFzEXWmuMyW6GNhjG/UFUMwNZH4gdargX/me8oB3vEqoI2uJrrD8
         XmmbnEFiio1msLhhZdQ65p+9kWKQe+J9BzKHNKK1ZIxYoEqP4jC+UoGLn4OHkl+n3H5R
         tUqzuEeJoyLfylXLSVtTrmNGzjyQ1iGiC6kB9J10iLFcrIresPuMZiHktm4P9FnU56BB
         7ZLg==
X-Gm-Message-State: ANoB5plRWwFKIJM/iHZs2WajqcV9kcSWJk8r73v2ayoTdRfF8bxBlAao
        WiUw+8fmHYrtZLv7M74FlL4Ln0XM/GsG8XylNlk=
X-Google-Smtp-Source: AA0mqf66Jq1pgcKnjLKJkFY4AH3L0agV4qSCuF+AgOYVYLpITG39bNWhVZPUsTFbgG98IofrUevM4FIrFFQiX/JmHLk=
X-Received: by 2002:a63:e444:0:b0:477:6a3a:e614 with SMTP id
 i4-20020a63e444000000b004776a3ae614mr56676334pgk.81.1670243164055; Mon, 05
 Dec 2022 04:26:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7022:4416:b0:47:5338:655c with HTTP; Mon, 5 Dec 2022
 04:26:03 -0800 (PST)
Reply-To: canyeu298@gmail.com
From:   Can yeu <aidenalexander304d@gmail.com>
Date:   Mon, 5 Dec 2022 13:26:03 +0100
Message-ID: <CAMw2Tatr1MYtJVmo8mopXHkbC2vfKjtmuyEjeT2DnJgrmp_Nrw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear Friend,

I have an important message which i want to discuss with you.

Your Faithfully

Mrs Can Yeu

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CE6640266
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiLBImm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiLBImk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:42:40 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAB8615F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:42:36 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id l15so4235436qtv.4
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 00:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ud2Qp+0j+JXG+xzOTKtAs0iVLtO4HhzSJ3v0hgygifc=;
        b=eYbPByqaYduydv396FS656/rMj8InUBtjy6+P3JSNETj1ZhjUg9LOkGYgvAQ+z3OfK
         NAW7IGcNEnhwp2+Qk3uwCqGrLrU5eEIsHk9VQcNrYTmSTVEt1d4cc34HBjUg7cBsxjqV
         8HdBJxV6t/GVAnTU0zU8f5agWKHYKOvB/w2uMsFTMC+nUPkJ3ghmBmU38aCXabTDDSWq
         Jjejrl7NqZibBynxvr1FAS6/chdl4OoEopfgPgMyfGQp9bjhVP0F83ROH1NFqHzXlO8F
         ZXBlK1pxN7bAlPj4Tw/wD+PmlOYmuhPNiBzBIRWRu98uJgy3vhVWoaSFL+MYeXYBgtLZ
         aeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ud2Qp+0j+JXG+xzOTKtAs0iVLtO4HhzSJ3v0hgygifc=;
        b=EVJJTj274KSotS2B6kQ6Z316QYxZXo56RtdM2h1Mp5QcLyFwer1gaTTUVmcT+X42Gg
         4XmmMUORULk90hOwYSusR5YoyRHIs1f3Syj0vsKyc/VAz3kX/l3tPqiOquPVlmZYV2sC
         qm3bGc/+t4EQ6QmKx6L6In8RRtKlIY6MvGE87QEGo0dT1X3tu7UutqUAQLl9JL84VoiV
         xc5PscPuK+4yx4P4WLtKpXReZdSjsDws9NcFkiYtYTRQym3pwbZwppqXJR1OgYG0j+lw
         Ve8ESAXWzwOP4gVHRBrJhIvC8zAC+VkOwLVRCeo9ADYOQ00ApgF5911B+wyyRXXoRxkN
         yd7Q==
X-Gm-Message-State: ANoB5pl3dGu9SwEVG0HhPgqSaSQKiZBbyVxp/5WtClbPTISTXHEw+l71
        lWBtC15sgtxCUbuRBFcBbABPRI2ir9YCoVshxAr+HCUWGSs8jMhF
X-Google-Smtp-Source: AA0mqf4wD6dfWwd/HIhk/juYwXMjTCcuP1nlKHtzIB4V3ZOvTmnBYeMPYxwmCRZUAsuxO/6tlNyX4RcWAxnZp4aF7VU=
X-Received: by 2002:a02:6d53:0:b0:372:f7ed:9f78 with SMTP id
 e19-20020a026d53000000b00372f7ed9f78mr26657566jaf.245.1669970174707; Fri, 02
 Dec 2022 00:36:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a02:cd05:0:b0:387:2dd0:23c with HTTP; Fri, 2 Dec 2022
 00:36:14 -0800 (PST)
Reply-To: akiraharuto@yahoo.com
From:   Abd-Jafaari Maddah <victoriastevernson1983@gmail.com>
Date:   Fri, 2 Dec 2022 00:36:14 -0800
Message-ID: <CAF46jtc5JuWGLc2zcs2k+1LzfouAzaL+oRJyRN5uwQjEActntQ@mail.gmail.com>
Subject: Did you get my mail
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear,
I had sent you a mail but i don't think you received it that's why am
writing you again.It is important you get back to me as soon as you can.
Am waiting,
Abd-Jafaari Maddah

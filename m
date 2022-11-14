Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A392627978
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiKNJuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiKNJts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:49:48 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89741E3DF
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:49:45 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id r188-20020a1c44c5000000b003cfdd569507so1940337wma.4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+MwenMg8mbDGUFmuXsuytZ9h17qsjodjdjT3gS4W0iU=;
        b=Gh7mDah38dErfP1Ma+k+mCSbLkGs0I5riPEC4VXoj2tSSEbpdVhtgGXS/UaVcFEOYg
         Tfzua6Hl8iWIKU+2xNY8kPgruva2i1yPUz4rTeo4U51mpvYkJyk+gfijNi1fFKrLSCqJ
         aq1jGm51tlDX6XLlCuupxNA3a7hLH0y2S1Pd24AbeDxb3UUI4BLR55C+S77jZERKdMTX
         UTElMc21ElHoT7asH6q7xUZtJvplmtBrA1iYW38SqDXAjaC1EhDSHY84P/xfGasvZeqr
         ZpdcR11zWtmmGT1mOnbD9atU5vwHlzIPIQ6tU9aeS1rFYylC5Jqhp67qOhaz8zZIyVYs
         RP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+MwenMg8mbDGUFmuXsuytZ9h17qsjodjdjT3gS4W0iU=;
        b=Sb1M9XlFCJJIRsgu8PfoqJQSI6DAT7I/SkBKafB9GldG5wsFjZYViVcfYuKxm1I/7W
         D7wKxq10GGoViyUUY7pCFIPD1jX5vUl5pFJxjL2wMvvJ9gdYy8kKLfr9zZ2lC8KTtRQE
         YRtqes8mEySSiGTvTRPn/f0cunnmZbmFr4myjBpe/CpAy+p1uIYjhnOpMqZ3ido3O8nC
         IDIWbw6oZZr+e9H+Nb9Ww7g4iWUHSJt8I3776nQpuBlCF0FmJL9gALuX+2tDIgwTCP+4
         W2/cDg0CA0f7pvFJlnzS68FcgiuG373uqTA3hplyAvzYEvHuq0fVsdTiLAcuEp+vmdui
         HAFQ==
X-Gm-Message-State: ANoB5plIGNioU2zosIJx/mOuJF/mI4OVUUm2EGVfozkEkHO6Kmzi6vKM
        Z+ZxuWDQ4jHmpWjVGgmLlA9XIMXzaW7Kx4/sjdE=
X-Google-Smtp-Source: AA0mqf4LlidA+g0Kc1PkPK4OhXLrYq5SwLFyfgmxKdnlW6YhhkVWZM5M9or2EIu9nSpFH/1CX+071Dwg9DukvjG8BUU=
X-Received: by 2002:a1c:29c4:0:b0:3cf:e137:b31d with SMTP id
 p187-20020a1c29c4000000b003cfe137b31dmr1110406wmp.205.1668419384374; Mon, 14
 Nov 2022 01:49:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6021:230f:b0:22a:4c71:d7a7 with HTTP; Mon, 14 Nov 2022
 01:49:43 -0800 (PST)
Reply-To: a2udu@yahoo.com
From:   "." <ab5787039@gmail.com>
Date:   Mon, 14 Nov 2022 10:49:43 +0100
Message-ID: <CAPfd+w8quWJ4EH3MBACGAUbJTVy4mok8MYMfZ-4F9fTa2qLktA@mail.gmail.com>
Subject: Hello
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
Hello,

I am a Banker. Do you have an account to receive Money/funds?

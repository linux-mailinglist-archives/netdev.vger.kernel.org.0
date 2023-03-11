Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF79C6B5CFC
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCKOoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCKOoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:44:19 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10BCE6828
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 06:44:18 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id p8-20020a4a3c48000000b0052527a9d5f0so1227048oof.1
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 06:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678545858;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qj8nrG0sL8loOIOhZdmt6f4M2skgayD9pumOqV207G8=;
        b=pvKnHvmAI6/QRAdRgC+LwxctvPmJtF9sE+bCDB6o3XA5Y97wdVQDjYJ42s/pw+Aa8H
         3q1bRe5qRZOWICSO0qXEcoKvjYi8AeRJHogrIJGePyWSWlAn4oVDiS+iTkNDal5Em1Jo
         5DQ6o2LYrri/nP/wSq1MS+iSeDFqK8HA0YyTn10PSazJsowYHiPmbjz4y2xYbF3cw+Gp
         UIX8SmSa/KSTZzWoJwZF5MNzFDcaukTjI/gVWyqkcSZfUbbqJpWRBjfp8rCZ6CgV+q2l
         jwhemiQJB4IDAoPoTc4do0fxvP/rEqYlXWyTUDs3XFlOtKsuzQbQrUmlAcR+QlqS5V4i
         WXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678545858;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qj8nrG0sL8loOIOhZdmt6f4M2skgayD9pumOqV207G8=;
        b=cdQ5qJBJ5jrTKWxwFn66SqVx90pLYzC7FOOVjstDazqT78G3BheuqUPULAlxBd+ymo
         Eayi/XD/ARPHBbRNjRggZYqyAb/gU6dAQ4H6Ucqv8iafIRTaGbdHFQB2tmjTPo2urvoX
         WvMN8IdBFqZyN/tOMzp6rrdT9Y/+n0qcDtS8rt1WEZXTHIV6Uziu4G/poi43v0UcniQ4
         O922aGk8BAiZscMH37bmR8fYuXYInztwNAJ1KY4TGrmMOsVW8blGqSTMG5chUk8WX8+p
         P/AZZbrPcgVbroGfkBl8Tn1B84CORO05/Evn8rYkCIcySTjuIrdwem4Fqn4I/0Gjilxc
         M0hg==
X-Gm-Message-State: AO0yUKWGgCFT4J+7JjVP4WjysIsTNJMCbZ7DTBZ66+vWjBID8BAQ//ny
        s341RpzJEyM698mfJmXKsdcmDN+Ow7XBuRxI8DU=
X-Google-Smtp-Source: AK7set8AICpt9G9YPXDraRMV1oHe/Io16A+yD0ZuAIrim5LgpUB9XVGI9s5+KV79xgMpuQpvEzW3h0BpvLATi9b+jD0=
X-Received: by 2002:a4a:d5d2:0:b0:525:54b6:dac1 with SMTP id
 a18-20020a4ad5d2000000b0052554b6dac1mr10999074oot.1.1678545857889; Sat, 11
 Mar 2023 06:44:17 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6870:391f:b0:176:ab4f:2236 with HTTP; Sat, 11 Mar 2023
 06:44:17 -0800 (PST)
Reply-To: wormer.amos@aol.com
From:   Wormer Amos <kyamadou51@gmail.com>
Date:   Sat, 11 Mar 2023 15:44:17 +0100
Message-ID: <CACKjaVkgFfCgNmGJE4y3XbNPbxg6sOC1urXVJrfNPx197ftb4w@mail.gmail.com>
Subject: VERY IMPORTANT PLEASE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:c29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [kyamadou51[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kyamadou51[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please are you capable for investment in your country. i
need serious investment project with good background, kindly connect
me to discuss details immediately. i will appreciate you to contact me
on this email address Thanks and awaiting your quick response yours
Amos

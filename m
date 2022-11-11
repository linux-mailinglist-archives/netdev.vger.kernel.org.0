Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D261A625A73
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 13:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiKKMaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 07:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiKKMaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 07:30:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EB866CB7
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 04:30:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so7654994pji.1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 04:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffCoKNiZCbLVipbg2otJCA7P5+JqnENgNvxYbkwxONY=;
        b=N+Nr23sjC8iHuDV8sBYjCDxfUaW9xTWufeYgLdv0iQPUZjkB3AuQpFxGzfFHP9Ksg5
         mwSg+0N5bMCiSSH/X4oHtzItCxXD5NgCxhovidkgmSDZdvZX6XoS1s0uKXVf1tU07pcw
         XZl8LzA1q9kn8mQvWNgFTr5hiSR/u/J0hiZhEufA9MMG7Ij2fssvrHolOPZKK3sheZjf
         DuBLkN0sSVYUXcqkEnHdM/XuUJiOoOqQJgsZZVwVIw5NC5+Aw5EK5gxGNyvIi8TV5sf9
         EVfB+MYDaNYV9YIa2Ub6amsZKHd0kGSuPtJrZqckuY13V34Iha2+GnQ7IIDVEzkSYYT4
         P/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffCoKNiZCbLVipbg2otJCA7P5+JqnENgNvxYbkwxONY=;
        b=i2EFm8h8eMDlHIdm1soOZULcBIB+hCfNndqrIzLpeqRp2VXHfQR8mULoX71A6VS00p
         TG2dlj3KIO/vFD7vfv0SBP7BWzUjUaveokNI1u5f34tlRrSOhO99NKNoZCkpO8cSoHKk
         KPj6uXBL58O/tq1J6O9PA8LXAtqiNB51+FhdgAbe3TQx2OTApcgocess/OdTtZq6N97e
         6FgA0HWiJnXj0oe0lR7E0AD13Rd9luFWCXOiXgoXkU0yj4EX+kOe/4CKxzcsspSJdgzp
         oKlGYk5YmMGUjckHezWNGsaYTLP2tEhNbzNVvFLTZcJTMD+XYOwGlTtvKqoKuZb8h5OA
         R+XA==
X-Gm-Message-State: ANoB5plfo///WTbChrntKGe/DeRFbRlAss6MNMLnkL5h5PZhjsxxTAWM
        ewYxpSfLrOP19Ru6th9R5nGaIBwK8gGTq9zU2uE=
X-Google-Smtp-Source: AA0mqf5C+N7KITTal0uVxMR6CKVzAKplA5WtQGe13CGWVHtVW3eHI2B2g24G6VslNPiaSs5UXctvTzEEE+g1t35404A=
X-Received: by 2002:a17:90a:b286:b0:213:34f7:fb14 with SMTP id
 c6-20020a17090ab28600b0021334f7fb14mr1695901pjr.25.1668169821449; Fri, 11 Nov
 2022 04:30:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:902:e884:b0:187:110d:29fd with HTTP; Fri, 11 Nov 2022
 04:30:21 -0800 (PST)
Reply-To: ecobankauditormanager@yahoo.com
From:   ECO BANK <cw209886@gmail.com>
Date:   Fri, 11 Nov 2022 13:30:21 +0100
Message-ID: <CAByE_KHj=Zig85B_QK84ApzCrC-irLPXdfNkAsmnLcBu1fhdcQ@mail.gmail.com>
Subject: 
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

Hello, please I need to communicate with you,
Can I share words with you?

Steven

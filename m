Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86967427A34
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbhJIMlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbhJIMll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 08:41:41 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86C3C061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 05:39:44 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 77so10987230qkh.6
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 05:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=FLGhN4fnuusLIGZMWIrjPRNVn80RK3lbiS5XqHk2rXc=;
        b=XcM0jiMt1O7o1D+eGLTr1cJPA0wCQO2GiB4VjCpdXHgPOhz6VCfRSbilPPa3z8UDpr
         bxkeMMTSVhmFzFB5yBvJw3oGFVtSXORK6El426CAce9fVuHQat3x+c88NCqIU9PiFAJn
         4EFtA6CchDgIIh843yGVcPtq6IMcvmtTNy38ymTme9Oehk4JU6FLL5hAtdAv7yHfSN32
         bzpHKHkpiD1g3f+0KiI3YPcO1ZJ4PDd5PoYzmZXq/rNo8bQ2jyugSCIyihRZUeSg1y+9
         nItlWhVjk2uylr09Msgsjzp11MNh8L8zvhezDwV6/HTr7PN4nUrio96mUNm1UBdUqsoE
         EwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=FLGhN4fnuusLIGZMWIrjPRNVn80RK3lbiS5XqHk2rXc=;
        b=j6HWpY8EGkpx4wNSIfP8uGGL8YJyNRDz4Rfk1D6f7KoQo94rCLZNcLwu9SSyLyHTFH
         x4TBy7yF3F9kvfx0rYTmgcHJ+k87+0zTQjcnQ1yKNjpBwxJyJFAN7Dz+DPPFoX+K/XAi
         1piefZg+FFX6iF+s+1EzwN+TsnppP1Vdx9C16D29YvJedZTt/5J4eKg8SvAYDzCEWe2c
         a8uy94Sr/7nxGzUQLD+lWfD5xZgYChKVsWryVpjEvtAPmbb55XxZURd/QTlwtk3YM+QL
         rmxcH9BY9Wnn+dRBtDc/19hPkYJ3n2EhDiHtFl4cD2r66ybmIQgcxr5QGkACGfx4wo6f
         qc4A==
X-Gm-Message-State: AOAM531x2RPyy8wxUh9uGft9Fx6szk8jZbvRHNUgBFMekoXYTkP/Rh5Y
        rH6uLLV7Wrr1G3v4nt7hkU7Pd4PHutYbVmOYC/gMWuEQ0EI=
X-Google-Smtp-Source: ABdhPJyN5wXGLql5LX50CH0G7du1pgaRc6lfd5KbM9WpCWg8lEy1wo8BmlZoyZYIQQqfGN+UY3Cvl0cASj5omEd2AgI=
X-Received: by 2002:a37:2ec6:: with SMTP id u189mr7195019qkh.466.1633783183491;
 Sat, 09 Oct 2021 05:39:43 -0700 (PDT)
MIME-Version: 1.0
Sender: reymonddennis@gmail.com
Received: by 2002:a05:622a:296:0:0:0:0 with HTTP; Sat, 9 Oct 2021 05:39:43
 -0700 (PDT)
From:   Mrs Carlsen Monika <carlsen.monika@gmail.com>
Date:   Sat, 9 Oct 2021 13:39:43 +0100
X-Google-Sender-Auth: 1yNV44Q20o-G50mGvaEds0Ap3r0
Message-ID: <CAOOE2sHQeawZdtzSgfc6TbYHFBJNC9VJSwdj4_V8SFYZgUFpMg@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 I sent this mail praying it will found you in a good condition of
health, since I myself are in a very critical health condition in
which I  sleep every night without knowing if I may be alive to see
the next day. I am Mrs.Monika John Carlsen, wife of late Mr John
Carlsen, a widow suffering from long time illness. I have some funds I
inherited from my late husband, the sum of (elevenmilliondollars) my
Doctor told me recently that I have serious sickness which is cancer
problem. What disturbs me most is my stroke sickness.Having known my
condition, I decided to donate this fund to a good person that will
utilize it the way i am going to instruct herein. I need a very honest
and God fearing person who can claim this money and use it for Charity
works, for orphanages, widows and also  build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained.

I do not want a situation where this money will be used in an ungodly
manner. That's why I'm taking this decision. I'm not afraid of death
so I know where I'm going. I accept this decision because I do not
have any child who will inherit this money after I die. Please I want
your sincerely and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your
reply.

May God bless you and your family.
Regards, Mrs. Monika John Carlsen

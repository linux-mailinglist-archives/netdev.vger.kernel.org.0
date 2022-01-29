Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA06B4A2FF9
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 15:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbiA2OHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 09:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiA2OHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 09:07:32 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE06C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 06:07:32 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id y84so11259945iof.0
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 06:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=/gRHScMGOcqWfHhCJcR+16Delg1iStzbMk9qT/Uh7C0=;
        b=IZCiyUFEBvWZ9dJKC0YjUSfbrZAEm8SAdYA/I/ZvYJv5BDT59tSNBEaMy7JyQ8twNy
         FM2UkiPqDYSdpvuVifAd7Khnj8tJO2qp46krv72MaYuPucNnZapl/69w/jAVQvSZJbvm
         o8itfuaMNQH8FHiVuLKV/pUgcwBkFh/tILOCSEBzGUbBY4SyCJOA1MRQ+9N9fAwuoEwb
         o90ITsM9yrwNpzQCMHF0dcuRfoOn4890wqszQPDnQM9Gin4TxA3Pcj7OqkRcx/1vbvpR
         QWwhRRQsHbC2TzG36xDCf6pk8eSqjlfkLjQP7QfgrHTiOV34H5sIqQqC+addw0pNk1ru
         GWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=/gRHScMGOcqWfHhCJcR+16Delg1iStzbMk9qT/Uh7C0=;
        b=PGaEJ+IhwqMpM988dgGiApxvaC+15BGoob6WndeY0OWkm6piOi8NI/uVLagWs+MPVu
         AiIeDSow96fbJwRpd1cZrIY3fzYG+A4L+JZ36SMzp/DcESsG4D1O8NmkFbsOgayAVJLT
         Yc6o3POswVYs11IM1zELaoDvAhJR76uodHB/PS5eKrIPxWANAlY4cCT6B09rH73s0LlC
         5V9J7jIu0VPWl3bNKRdxW3vFT0+XMmeM+sBG5hl2hpg00wGUqAcKgnCkyAnAM36iKs0U
         tM8UGOY/6Qny7UmPHOpW4nWT4fKxrefKi8GS+2vAWEfUIpU8ePBFH+M8a4lC4+/eJj0t
         B6qA==
X-Gm-Message-State: AOAM531iVy261vrbGq+4CAG14/+//RiAZNoG77XHRSv9CvGk7b0lGoIr
        2O4zA1W0dsiAKqWWTKt1njBpcgsRCnzbFDwgZ78=
X-Google-Smtp-Source: ABdhPJyMCsElMvvM31a2P9SSHVNB6q9vHeET3H91BQHsnhyTnX1+nvuiClQfgzR4C1NBiiqQd0iDwU4TIBDUB6pxQxU=
X-Received: by 2002:a05:6602:2c8d:: with SMTP id i13mr7983515iow.181.1643465252022;
 Sat, 29 Jan 2022 06:07:32 -0800 (PST)
MIME-Version: 1.0
Reply-To: mrsayakaazumi891@gmail.com
Sender: kafandozida1@gmail.com
Received: by 2002:a92:c7d3:0:0:0:0:0 with HTTP; Sat, 29 Jan 2022 06:07:31
 -0800 (PST)
From:   "Mrs.  Ayaka  Azumi" <aeyuhlmy739@gmail.com>
Date:   Sat, 29 Jan 2022 06:07:31 -0800
X-Google-Sender-Auth: SB_WPW_VnyVZrxUyQCoXW-UaNAY
Message-ID: <CAKAv60eH9s8Hekuhyyp6WX6dTHfLLfRicj58nqQke8YPD5whyA@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,

Please forgive me for stressing you with my predicaments as I know
that this letter may come to you as a big surprise. Actually, I came
across your E-mail from my personal search afterward I decided to
email you directly believing that you will be honest to fulfil my
final wish before i die.

Meanwhile, I am Mrs.  Ayaka Azumi,  62 years old, from Japan, and I
am suffering from a long time cancer and from all indication my
condition is really deteriorating as my doctors have confirmed and
courageously advised me that I may not live beyond two months from now
for the reason that my tumour has reached a critical stage which has
defiled all forms of medical treatment. As a matter of fact,
registered nurse by profession while my husband was dealing on Gold
Dust and Gold Dory Bars till his sudden death the year 2016 then I
took over his business till date.

In fact, at this moment I have a deposit sum of  Eight Million Three
hundred thousand US dollars ($8,300,000.00) with one bank but
unfortunately I cannot visit the bank since I m critically sick and
powerless to do anything myself but my bank account officer advised me
to assign any of my trustworthy relative, friends or partner with
authorization letter to stand as the recipient of my money but
Sadly, I don't have any reliable relatives and no children.

Therefore, I want you to receive the money and take 50% to take care
of yourself and family while 50% should be use basically on
humanitarian purposes mostly to orphanages home, Motherless babies
home, less privileged and disable citizens and widows around the
world. and as soon as I receive your I shall send you my pictures,
banking records and with full contacts of my banking institution to
communicate with them on the matter.Please contact me with this email
address.(mrsayakaazumi891@gmail.com)

Hope to hear from you soon.
Yours Faithfully,
Mrs.  Ayaka  Azumi

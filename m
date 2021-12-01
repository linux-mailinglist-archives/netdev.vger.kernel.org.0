Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880AC4652DC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351357AbhLAQkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 11:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351165AbhLAQkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 11:40:00 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86D1C061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 08:36:39 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id o4so25035676pfp.13
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 08:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=IDOcbRkbL/lHBNZGIvbk/gdSH9Hrdi21+y/YJa4oFF4=;
        b=nXQN8LstfPsDomjNLFtZJLQLmaiYHTVlxaMbLEZRswkhw84J2e+vHZ9e2DsxB2my0t
         rk9HNgq1UhYNxtkMmwfjm2pXQoeDz0PZJfMEVm2x6fFntjkqecvPAGb/qYuuY8F0akix
         xoYoEmjU2nB0DGlT0J6Jge/cjE/TOmiqspN+X1q4YsfufLFCZdu+u9tYNe82RTwSXNZ6
         aDd+Y3blRroyl9Uc2OC4tpPXuf/s1IFUqKWVuHs5fRMnZ3WSkKH0VwfItYrc2NAyA2EM
         TVgiKKx9YvBqkkXKDJ2CRxoD2On7zFvaOhx7i1BUL3SywTffzNej05Mtv8kSGEqiqRcv
         OrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=IDOcbRkbL/lHBNZGIvbk/gdSH9Hrdi21+y/YJa4oFF4=;
        b=wfTE+Lmok2FdZvz5ly7rsfwTzYXmiiD15RYR7PHgkLUqnNNvPRlPjySBPFzKriylyd
         6Mjx0QX/5knPOyNzzoXMZ06eWs3BrGAHgjsu5PWhBus0wW/D2FvaCiPCIbxVQTB3PW2a
         bXIz2qEcZf9YQ3pn8CpxqzzyFJnYt1dKnE1GRDq4mrl92T/b/kfp4TlClr/PFMmFGWkn
         Zmd5eVN5LQdtjEfpBn+x4LejdYd583x9HEypCY/QT+Wv9nev6/obvfGsBQiXuKTJYzKH
         wJVz2Bp562diIbXiaznmITaAG/HGfutraSKgKZG87mqsp+9Zpl9lOtcqOitAgjG6F2rg
         2R6w==
X-Gm-Message-State: AOAM532Bj6SEX9FWqHPC2BpLKNaWlTtHmow5IPA7LiLiv9Ex8iKQpVJO
        tovbURkukt6HO/9k4MAR3BXEUKjonkObnKD2+Vo=
X-Google-Smtp-Source: ABdhPJwOucBK/CYk9duh+gr5hKgtw0I2J8H3XmjvlIToX0Z+KW+XHvH1oKxEEjhF1DGYOD/r/XXlf5zg+//12wIWRco=
X-Received: by 2002:aa7:8b07:0:b0:4a4:d003:92a9 with SMTP id
 f7-20020aa78b07000000b004a4d00392a9mr7016262pfd.61.1638376599070; Wed, 01 Dec
 2021 08:36:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:bb1e:0:0:0:0 with HTTP; Wed, 1 Dec 2021 08:36:38
 -0800 (PST)
Reply-To: ahmedzzango@yahoo.com
From:   Ahmed Zango <julietkabuka@gmail.com>
Date:   Wed, 1 Dec 2021 08:36:38 -0800
Message-ID: <CALfLPeKLiW_O0gGAsUWVMxyrxtujgbeCmMaTu82XYqHU-nZ9RA@mail.gmail.com>
Subject: Confidential Latter
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Please pardon the abruptness of this letter. However strange or
surprising this message might seem to you as we have not met
personally or had any dealings with you in the past. I must apologize
for intruding into your privacy.

I am Mr. Ahmed Zango, Working with a reputable bank here in Burkina
Faso as the manager in audit department. During our last banking
audits we discovered an abandoned account belongs to one of our
deceased customer, a billionaire businessman.

Meanwhile, before i contacted you i have done personal investigation
in locating any of his relatives who knows about the account, but i
came out unsuccessful. I am writing to request your assistance in
transferring Sum of $19.300.000.00 (Nineteen million Three Hundred
Thousand United State Dollars) into your account.

I decided to contact you to act as his foreign business partner so
that my bank will accord you the recognition and have the fund
transfer into your account. When i receive your quick respond the more
details information will be forwarded to you.

I am expecting to read from you as soon as possible you receive this message.

Best Regards
Mr. Ahmed Zango.

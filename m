Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0C0A7785
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 01:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfICXTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 19:19:13 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36755 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfICXTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 19:19:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id s18so6806177qkj.3
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 16:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=GdvqnaDkynUyxCRG5z3moH1W0+n24RWuJYervO7J6q8=;
        b=lTpuI0sREkZ5rjuhbtVeupgeTZ2b8fsV25YS59JyxpOkZE8gp4ukBzi0MwE330JNmF
         fM5NOfS6d9Qp3RplDoPnnYHyCmdT47naW6AeLjhacjSyQ412dt7BJRhJHYVoDbkzMBYn
         FFOnFv8iH40HTs6lvocjV1aQxa1FM1ot55wAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=GdvqnaDkynUyxCRG5z3moH1W0+n24RWuJYervO7J6q8=;
        b=FF45ySeFJtD8lS8sQibXzwbj1Bu7wW+ax/MX0Mg4/NPHmjjJkh8fY5qbYvfGRsjDQL
         8wHzqn+iSWQdstVEsqr9vBLaPnJrGZ4B/6YoM8nsSWj7YL7GNQWEM+9I+bdmVLTdt0lF
         LNdvoAUxVQch1cY4qhTDefZ3Bly02jqcnuGs7rqEHjFabUOT0FX9tyLRK+L/eT7mmJYc
         UDL4rk+UPND9P/DRlH2HJvT35uHknqoMthiUct07wMsZlPq7Og2hCq9+0zeCoudRLPtv
         GuscuCu0gh+pxznVh/6xSYGGNQz9o83gqHUbOGBHrlS5QQgwST89exXjchfD7X/Tdgyq
         qO4A==
X-Gm-Message-State: APjAAAUcSTcIsORld6Vdchs3fGcDGCZLg8b9xrHzRIvr6ut15M3B2NoI
        Y3601qc3tfhSjGCnAt0vBGsCH78/Qd1XbVGJHm6nMw==
X-Received: by 2002:a37:4d90:: with SMTP id a138mt34384376qkb.128.1567552752398;
 Tue, 03 Sep 2019 16:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <0835B3720019904CB8F7AA43166CEEB2F18DA7A9@RTITMBSVM03.realtek.com.tw>
 <BAD4255E2724E442BCB37085A3D9C93AEEA087DF@RTITMBSVM03.realtek.com.tw>
 <CACeCKadhJz3fdR+0rm+O2E39EbJgmN5NipMT8GRNtorus8myEg@mail.gmail.com> <20190903.155037.530228169649734979.davem@davemloft.net>
In-Reply-To: <20190903.155037.530228169649734979.davem@davemloft.net>
From:   Prashant Malani <pmalani@chromium.org>
Date:   Tue, 3 Sep 2019 16:19:01 -0700
Message-ID: <CACeCKadbxAMrEGzAd5845RUd16m0JTzO3SjNX48zisPB_hhQWg@mail.gmail.com>
Subject: Re: Proposal: r8152 firmware patching framework
Cc:     Bambi Yeh <bambi.yeh@realtek.com>,
        Hayes Wang <hayeswang@realtek.com>,
        Amber Chen <amber.chen@realtek.com>,
        Ryankao <ryankao@realtek.com>, Jackc <jackc@realtek.com>,
        Albertk <albertk@realtek.com>, marcochen@google.com,
        nic_swsd <nic_swsd@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Narrowing the recipient list for now)

On Tue, Sep 3, 2019 at 3:50 PM David Miller <davem@davemloft.net> wrote:
>
> From: Prashant Malani <pmalani@chromium.org>
> Date: Tue, 3 Sep 2019 14:32:01 -0700
>
> > I've moved David to the TO list to hopefully get his suggestions and
> > guidance about how to design this in a upstream-compatible way.
>
> I am not an expert in this area so please do not solicit my opinion.
Noted. My apologies.
>
> Thank you.

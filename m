Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360792CAD91
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgLAUnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:43:47 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:39942 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgLAUnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:43:47 -0500
Received: by mail-ot1-f50.google.com with SMTP id 79so3010090otc.7;
        Tue, 01 Dec 2020 12:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22pNz27A1ivrlMf6rV8cNdPaTU9Q80rrRMZs0/Lgfm8=;
        b=gN9WyKjp5wwaNNROHcVUEWNzEJzbkM944W429B81m8nRB5nWHMrOrIEX5+rrk0PWzm
         DkgzNv1yQlErc3d1egUzgtcrMsScBLhDQvXod14s7iBqk83jLv7vC3EEn5vxz3l9jdmo
         NWeU4thv4DDyyM03zwn/OvoIyTHKyvs53rWfNU/bznOAqHgf6Mx6D5a8cB+GCZnVPtC9
         +PD188F0nHDzldJuKKxMhshjz1RH3qt6yOK22/9odjxYQN5hAo2FX6EMemPrDLR+MgbI
         nk6HYp9zsK6rEg5axGwXY1oBnjDPWUfI0qGKrh/vlKpZeuVid6+tsIWE+6yeFvpo99Ne
         EIyQ==
X-Gm-Message-State: AOAM531fkkIxZ2kmvqVYVyVRdDCxxGvmUmrrUzNdKAefkpylIb/QjxwO
        CstDrogtdGo9vh6rugNTrwcES+p0Jhr38V08fdgcf/pKWmg=
X-Google-Smtp-Source: ABdhPJyyz99mhwtX9D8k1N8gMSi8/EVYsOJrunQyr36xwLMHuNK75HOMRu8fZu6tTzrGk5l6LNK1CUkNlHDgFpfDRr8=
X-Received: by 2002:a9d:5381:: with SMTP id w1mr3210780otg.7.1606855385020;
 Tue, 01 Dec 2020 12:43:05 -0800 (PST)
MIME-Version: 1.0
References: <CAG4TOxPXerpdxxyTbo+BFxBAvDHNFg38hf0zz5eigBJokhLWvA@mail.gmail.com>
 <3a9b2c8c275d56d9c7904cf9b5177047b196173d.camel@neukum.org>
In-Reply-To: <3a9b2c8c275d56d9c7904cf9b5177047b196173d.camel@neukum.org>
From:   Roland Dreier <roland@kernel.org>
Date:   Tue, 1 Dec 2020 12:42:48 -0800
Message-ID: <CAG4TOxPrjYVZr4eTxB=v15WxBwswnuXDC5Z3NQM1U1TrsOd5Bg@mail.gmail.com>
Subject: Re: cdc_ncm kernel log spam with trendnet 2.5G USB adapter
To:     Oliver Neukum <oliver@neukum.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> your criticism was valid. Could you test the attached patches?

Thanks - I will build a kernel and report back.

 - R.

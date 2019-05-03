Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF041350C
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 23:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfECV5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 17:57:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39326 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbfECV5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 17:57:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id z128so2024858qkb.6;
        Fri, 03 May 2019 14:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:message-id:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Cw/GYpeRQBGmwY7J4O04tUGhUSupj1uW+IECpewsoeA=;
        b=H15d7ajFdDczdCq3vtOQpsIjx5z5a+D6di/Y3bqHknOq2zRHxG/UG+DkJNxkVfnmSm
         8aFs7wIBkTG/jVDC9UoBBU7B2C+UXild8LubHVqj8/DbTdRy7nBF5d96Wk2oiQPSq5uL
         5X1DJVgwkqHoRpEIHpGLau4QrUQ/A5xYD8sxtL8Op5VdXNdj+89cDYGHgsddEkoxcuvi
         K7mfZk5GHspyleq3+hevQA3r7+V/SFLnFicqMBx1n1AJJ1usDdJu+kbwWQ+gzO5EjsRQ
         AmVvccCP9lyKNDGTH91mWrGDZEKKlfIR/ar79ilDqzL+C5RLOuwZBKoSkhMGs5M5ajO7
         C2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:message-id:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Cw/GYpeRQBGmwY7J4O04tUGhUSupj1uW+IECpewsoeA=;
        b=pCHExl/6rw026bIejVWLYbumzoPBOj+yxFW1rJuxyZ+AknAL0iYEncG0cKfDYgUeDL
         n4fbnWdd/h3qKp82biVG6ZPlH6y530zGCord3+bgDptuhnjA236tvENd8DcoC1CcPoHP
         F5rONiIN8WnBS4ZGRkma0T73ALOCPmcwFG2wW4Hg/X46BeZWnBjHgcjVHwYcAAovFTMk
         5OsRj8J9rJoivIsjmmhkzqSkjh6vDw1W0zzpCoffP3u20Y1w35J83b3aliPoI5fLVbBS
         /jb1oZ1tElCBYyYT9vPy4mhnOe4j55I/1mC7P+iSkTy1Y7Xx3OTWJ1/d3ILhiJ7uTUpB
         RjSQ==
X-Gm-Message-State: APjAAAVay/ZQYNjeycdt4A8yn1ii2TY20XwiBJZL2EP90fr8gJZFzM+l
        xjw+w2ffVCs9lKwhQKPzMaY=
X-Google-Smtp-Source: APXvYqzFfUxkp5d2tA1hgRQ4AYz5bZTG3zai7IbO3gF5GQw1v2/01DqZM9C9XtcHLcObTauCAn4qag==
X-Received: by 2002:a05:620a:482:: with SMTP id 2mr10046467qkr.323.1556920654063;
        Fri, 03 May 2019 14:57:34 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id r49sm68077qta.6.2019.05.03.14.57.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 14:57:33 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
X-Google-Original-From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Date:   Fri, 3 May 2019 17:57:32 -0400
Message-ID: <20190503175732.GB4060@t480s.localdomain>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: Re: [RFC PATCH 2/5] net: dsa: mv88e6xxx: rename smi read/write
 functions
In-Reply-To: <20190501193126.19196-3-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-3-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Wed, 1 May 2019 19:32:11 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:

> -static int mv88e6xxx_smi_single_chip_read(struct mv88e6xxx_chip *chip,
> -					  int addr, int reg, u16 *val)
> +static int mv88e6xxx_smi_direct_read(struct mv88e6xxx_chip *chip,
> +				     int addr, int reg, u16 *val)

I have a preparatory patch which does almost exactly that. I'm sending it
to simplify this patchset.

Also please use my Gmail address as described by get_maintainer.pl please.

Thank you,
Vivien

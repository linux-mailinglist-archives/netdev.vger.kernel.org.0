Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29E4199BE6
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgCaQly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:41:54 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:37098 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730442AbgCaQly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:41:54 -0400
Received: by mail-vk1-f194.google.com with SMTP id o124so5880829vkc.4
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 09:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wCYQayx3iX0110qvIb2aGvmYrLe1/2odpUqnIm574ns=;
        b=m+WZnXE5bRETadPsiXWXKge74C3dQ5nxbKdMN3v6vlg0CaF3DMlbfLuaAdt/sRy+od
         IVf1Gz2Je92mAd0HInFZe8NVLszBKdaMB3O0+49l9DCcUstSoaV5UQmVoLUw/MGomKvq
         zKSxpJSEbpUjP7y5WEt5X/RasCqeUKZczcDeo4VS/hwd90APWIb/6fRTRE/PCOZF5CS9
         r583RJri0B6XFS/mBSmjGUmB0zmA6Uqd82aL+2384Q02dLDIwD8oWLnnKBmGGyjg0yZk
         jiKmoHcCLERCBLJXgQeI/bYsb3+6uOvVA7SoHnp8U5ZTyCCu+JwYdnCBcyi+tjEXSxo5
         6vuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wCYQayx3iX0110qvIb2aGvmYrLe1/2odpUqnIm574ns=;
        b=sZbEo7YG8naA9ncix/Zrk/pmxjExvrcriURm3ikXyPmUdhFajUVZpoGcbyuUUO3Cdi
         h+8yWTaWWOn7EnvjOBtTduT1Z4v1WIkS/3G99fUlW+gbvIA5KVd5mJB9Ly26fo/0BXte
         8Ysazz8QT1aZWNgRbPymL2pzBkXavC3/qBSXQWAQvqPVD83e7pkBrcHk5zXBS5mv0je0
         Zv+GepIbXaKl3hfSIUlrWE42Rpw+0zUSe36XXS95X6P3IwQdQ6Q38PUUJre0vbJUSZ6n
         QWoxrBNQptio0X+JiSd3gvc4qMqZl6rFdyq3Savh2y3PEwCv7QZn3IAoey2pd/9mVILR
         c1NQ==
X-Gm-Message-State: AGi0Pua7trq1TiPksq9y+PmpaakwUgtcbx0qSlQ1B9f+KRelFp+YymVf
        yRZuPx24faO+4oznbqduzwMbui3zezPbLYqWHFgFRA==
X-Google-Smtp-Source: APiQypJ3gV/E5ItMhiCjFWxTulmpoFYSBjhtX1yaCeVz0MjK0BxEQnUzKTzryis3e8S673j+zHAlRPTKTyX9K8Q0ILo=
X-Received: by 2002:a1f:9645:: with SMTP id y66mr12207504vkd.56.1585672911223;
 Tue, 31 Mar 2020 09:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200331163559.132240-1-zenczykowski@gmail.com> <20200331163904.ilucynm3brvgfezw@salvia>
In-Reply-To: <20200331163904.ilucynm3brvgfezw@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 31 Mar 2020 09:41:39 -0700
Message-ID: <CANP3RGf5Y=-GX=b=jWURaBdDvey0zb-_MkXj6W+TWtRvM4C3sw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By client code do you mean code for the iptables userspace binary?

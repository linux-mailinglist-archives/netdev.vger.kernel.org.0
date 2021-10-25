Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05F4438E50
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 06:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhJYEa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 00:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhJYEa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 00:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A8BA61073
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 04:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IjsCwc/s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1635136085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bsxdnjdMraVXJU7SCAC5zlb0BNltSibuXlT0//A9cE8=;
        b=IjsCwc/sPmPFlLTLeUwox1Xq6ByhC1VWZaYN3CaD9JjfLadLb0SrTbK8veXiUK8mIqibl+
        jEYb1F5ixqwxHlje892HPtEATA9zSM/2HSCxlpCY94F4LJyDdxqHLR2ZQZSA72OOTEFy7T
        WYMojQwHljLNaJI4VvsyoPKgau2m/Ss=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 573eded6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 25 Oct 2021 04:28:05 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id d204so7078196ybb.4
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 21:28:05 -0700 (PDT)
X-Gm-Message-State: AOAM5338XOY2uqGDhW5So/g/4qxFIS+KrMrr86q1tigByHw7TbyklxRh
        fU2c2MWbVOxh90sMLLOVQtjNsMTSwp54ilKdme8=
X-Google-Smtp-Source: ABdhPJyS4hV7RxZzHUaxNIq4jV7WU4Gyt4fTFmYsvO1BaBPMOW/10zVTpGLKd1H9wtf0M7rueXJpD9cr5Wn/mf27YqM=
X-Received: by 2002:a25:d047:: with SMTP id h68mr15438323ybg.416.1635136084210;
 Sun, 24 Oct 2021 21:28:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:2047:b0:fa:da35:6920 with HTTP; Sun, 24 Oct 2021
 21:28:03 -0700 (PDT)
In-Reply-To: <YXYtTs/04zZ1SU6f@Laptop-X1>
References: <20210901122904.9094-1-liuhangbin@gmail.com> <YS+GX/Y85bch4gMU@zx2c4.com>
 <YXYtTs/04zZ1SU6f@Laptop-X1>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 25 Oct 2021 06:28:03 +0200
X-Gmail-Original-Message-ID: <CAHmME9phOhLr0Y5TmuppVn5Zeht0ivwiNJV3S_Q9nzM5nAv7Sw@mail.gmail.com>
Message-ID: <CAHmME9phOhLr0Y5TmuppVn5Zeht0ivwiNJV3S_Q9nzM5nAv7Sw@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: remove peer cache in netns_pre_exit
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Xiumei Mu <xmu@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've got a patch set staged to go out this week.

Jason

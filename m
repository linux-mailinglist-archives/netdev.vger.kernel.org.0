Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8062C2AD636
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgKJM3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:29:55 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:56605 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJM3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 07:29:55 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7deff3e4;
        Tue, 10 Nov 2020 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=YzgELJ7ylEabPOcZlCo18et2KoY=; b=WBjxtd
        6W0g+c0z/1xGEhuGJs9o/jvazO/jYh62aUJFh7Y0ZvDpgwDaLQTrUxfBvdIMSZ+1
        a3PKYxLztMSec32GXZLkI0whEYvdeWRFuBZhmVK1/cDe/FqNwJ9AgDReQOAny5nc
        7suGQfqMzB7naiSHkqNR1Nj4zsSJUOkePxhT0gHOp//o6kyMrg7iNardP5nSAj6i
        huu1TFckHXVfjXbfCH0etbFps/TaMumiwkMkDG/H+GoiIzRvEHRQQLvHq+VAparY
        vosBKlMH41bZi1lHU7TF0J0bnc4MvpX73giD+Vac4s3rQH252yGkAzIHCA42f5vx
        YG8jOIzA1TbSZS5w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b7f6c62e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 10 Nov 2020 12:26:57 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id c18so11462816ybj.10;
        Tue, 10 Nov 2020 04:29:52 -0800 (PST)
X-Gm-Message-State: AOAM5325D13e9GyYz79/gtwCd1vAMKQAvCOnO/KLAXiF50g3oUjXpim6
        ZM0+v+w4RTs28v45LCZdRWkG7gQjLWKgH5nhfmI=
X-Google-Smtp-Source: ABdhPJxUEae0A+fdf0YSnYoTpZqZcCpZqJYzVJL7j3pYEaDgphVE2z74+IWj/x4fh82HFVi6DYEpmn2tmc3vLV988SU=
X-Received: by 2002:a25:6cd6:: with SMTP id h205mr23667681ybc.49.1605011392369;
 Tue, 10 Nov 2020 04:29:52 -0800 (PST)
MIME-Version: 1.0
References: <20201110035318.423757-1-sashal@kernel.org> <20201110035318.423757-26-sashal@kernel.org>
In-Reply-To: <20201110035318.423757-26-sashal@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 10 Nov 2020 13:29:41 +0100
X-Gmail-Original-Message-ID: <CAHmME9pPbitUYU4CcLaikQLOMjj-=b16nVXgp6+jh1At4Y=vNg@mail.gmail.com>
Message-ID: <CAHmME9pPbitUYU4CcLaikQLOMjj-=b16nVXgp6+jh1At4Y=vNg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.9 26/55] wireguard: selftests: check that
 route_me_harder packets use the right sk
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Chen Minqiang <ptpt52@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note that this requires
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=46d6c5ae953cc0be38efd0e469284df7c4328cf8
And that commit should be backported to every kernel ever, since the
bug is so old.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DAE11D6CC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfLLTHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:07:05 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:35121 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbfLLTHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 14:07:04 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 58c28a01;
        Thu, 12 Dec 2019 18:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Gap4hyb3YJho4i7tIDDW6ea2M7E=; b=GfeDyC
        oTdom0f29bx7WQEfihXhBCQdSLOdasAvB0dalfeNHjtmMQm89xwF6KrDQJ3gwZ7l
        chCkqbktrtUApPCE84fiRUalcI0PiIzvLmdGXpFf7Ao2wC9WKvbmdP8tRA75jhPI
        jENw/TCtpC1ZR/yxQiEhJhRUGS+2rJV0+KVyRr03hmhfUNQQPrTsYAKlN15U9XPN
        /CUYpZImVbfa7nFvkLjUTpwcUgXo6u3GQ01mcwPQeAicwi85FWduCEkPhz5MrEqc
        kwFw5NPSSUh6VoY6raDbQuEwkyoRRX0XCAzZt2PTCqda7bHQpbDwFeJJtHZNBhvU
        HCkuKEDj7IddxaFw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c4395c53 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 12 Dec 2019 18:11:13 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id d17so3124526otc.0;
        Thu, 12 Dec 2019 11:07:02 -0800 (PST)
X-Gm-Message-State: APjAAAWc+kkh3Do9yUbgNuTwjg8nQS9x2Y06mD2aMiT6DsD0xJxw29Gb
        rizHw9CJtC5OkAc2qIgFrmc+bGxMEYmOGgEv7HM=
X-Google-Smtp-Source: APXvYqxCKAGJ2V7i7Z038u/aSejmowoq1mmb2+5F30wgv9JmKhhntQi57wRLGO7+Adc9XeyCGdQX/971aGYA9LxcTVo=
X-Received: by 2002:a05:6830:1b6a:: with SMTP id d10mr10174984ote.52.1576177621494;
 Thu, 12 Dec 2019 11:07:01 -0800 (PST)
MIME-Version: 1.0
References: <20191212091527.35293-1-yuehaibing@huawei.com> <20191212.105258.579549471896891617.davem@davemloft.net>
In-Reply-To: <20191212.105258.579549471896891617.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 20:06:50 +0100
X-Gmail-Original-Message-ID: <CAHmME9osYEbi1BDmJL=4N+A1rbb7_MPqVijogHSFhU39rRCbdw@mail.gmail.com>
Message-ID: <CAHmME9osYEbi1BDmJL=4N+A1rbb7_MPqVijogHSFhU39rRCbdw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Remove unused including <linux/version.h>
To:     David Miller <davem@davemloft.net>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On Thu, Dec 12, 2019 at 7:53 PM David Miller <davem@davemloft.net> wrote:
>
> From: YueHaibing <yuehaibing@huawei.com>
> Date: Thu, 12 Dec 2019 09:15:27 +0000
>
> > Remove including <linux/version.h> that don't need it.
> >
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>
> Appropriate subject line for this should have been:
>
>         Subject: [PATCH net-next] wireguard: Remove unused include <linux/version.h>
>
> 'net' is too broad a subsystem prefix as it basically encompases half of the
> entire kernel tree.  When people look at the git shortlog output you need to
> be specific enough that people can tell what touches what.

I have these fixed up how you like in the wireguard-linux.git repo,
and I'll submit these in a series to net-next next week all together.

https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-linux.git/log

Jason

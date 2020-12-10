Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439742D5757
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgLJJiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:38:13 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:36201 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgLJJiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 04:38:12 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b17ad22c;
        Thu, 10 Dec 2020 09:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=wNxKzdrmCn9Tgs9JwbJfdXjq2Ho=; b=xzv75Z
        ySrK/0Vd63ZNpGMFv+h6ZAT/zHevAiSrIbiNmf2G2+EcwEXhK6K/WDxET8pkU7ge
        n95tmiNVBQnSIE0QkUZFPpeYSmM6AgiRQ7lPylK0pO6AnXKtGQ3k5y3WOlqDF0kk
        Jo+G6Rb4IF/p0qmcPssiD14nA2ZI7+n8jDfJrOBDHBpsma+TNxVlTgv+xm+yTQP6
        X7a1vLrWdjoC4jCzkH90Rvb6vrD86E1MvylkjVLTItSEPI+eBRfeN0vHAPqYodn8
        OgXi4aHVj8saAH5Fj0yEnL2z0aNUtxWCAf492oC/LNo3eMNWVJvgeIqcBVX6wdvH
        u1V3hSnJpnrME6EA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8217adb1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 10 Dec 2020 09:30:41 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id w135so4094330ybg.13;
        Thu, 10 Dec 2020 01:37:30 -0800 (PST)
X-Gm-Message-State: AOAM531uEudovtrPlS1CVICefUPenz8OrrvrpkGl7MJbbbOkxr+l55ip
        48Mk+uBukNZMgzA3nyx/drCBKqMH8meUFBHAYjM=
X-Google-Smtp-Source: ABdhPJwV4bxZCCxe3IwlIdqjIMwelMkb0qJWuwVeqTBtEJWsuHOYaUQbIeEcknjClta/jPpJwyPbz/jwiEKh1Jqj8fk=
X-Received: by 2002:a25:df05:: with SMTP id w5mr10743072ybg.20.1607593049638;
 Thu, 10 Dec 2020 01:37:29 -0800 (PST)
MIME-Version: 1.0
References: <20201210085505.21575-1-a@unstable.cc>
In-Reply-To: <20201210085505.21575-1-a@unstable.cc>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 10 Dec 2020 10:37:18 +0100
X-Gmail-Original-Message-ID: <CAHmME9pOZRtzqBELQTG6tONiWxJJU8KQhSxWST2T_ReCX3ZNYQ@mail.gmail.com>
Message-ID: <CAHmME9pOZRtzqBELQTG6tONiWxJJU8KQhSxWST2T_ReCX3ZNYQ@mail.gmail.com>
Subject: Re: [PATCH] wireguard: avoid double unlikely() notation when using IS_ERR()
To:     Antonio Quartulli <a@unstable.cc>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 9:56 AM Antonio Quartulli <a@unstable.cc> wrote:
>
> The definition of IS_ERR() already applies the unlikely() notation
> when checking the error status of the passed pointer. For this
> reason there is no need to have the same notation outside of
> IS_ERR() itself.
>
> Clean up code by removing redundant notation.

Thanks for the patch. I can confirm this doesn't change the codgen at all.

I've queued this up in wireguard's staging tree, and I'll push it back
out as part of the next series.

Jason

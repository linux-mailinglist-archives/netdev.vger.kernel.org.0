Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8036911C9EC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 10:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfLLJxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 04:53:09 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:50019 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbfLLJxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 04:53:09 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 27aff7ec;
        Thu, 12 Dec 2019 08:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=uLMjB8m4/DGzwbgB4YAjzY8FX+s=; b=W0zjhy
        FuZk2iDgknFlmyo7GxA2cpuOWLEZgWuRp3L6VPFZIkKIMGeClAq3vJMrh1Njxztl
        KYpyG6juhnFoNZDCN/yctB02IqatVHaPrJZmaZom4SSV3KU6NIdu2mXIZ6cG6Aiz
        yLlE/YLgFSv8Qavk+h4NwoFs0zHjP3h2fEqJY9WSApOixeN9Y9nbHOUBlrkZYwYP
        v8caggK+asJGXMQYqXyo/CNGzQxyEfRmRwRQgS5Q4KbZ9gEMmiAje00JBWZIjBfk
        lDKIOVdCfHphrXiMMYR415/QgNqFKjQMDy6x6t5qIGQxljs7CQTb2bdAubeQAdzd
        UoqSgYghBxJCT9hQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d19fdaaa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 12 Dec 2019 08:57:20 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 66so1228261otd.9;
        Thu, 12 Dec 2019 01:53:06 -0800 (PST)
X-Gm-Message-State: APjAAAUNT4PprM++2G2MUaAD+Us+twyFKYMzj7Nm50J3lgklPA5kbF+c
        R+7l+01z2DgTH4lb/R4m/kDKuZSPRII0fu8s+9c=
X-Google-Smtp-Source: APXvYqzzCr8AIVVzRHm5jB+v++pLKtoFo36nbLfIhws6k4JnwsU8tvA44DpopjLtyjY6u6I87eEYZ1DhGjq6VqKLNOw=
X-Received: by 2002:a05:6830:1b6a:: with SMTP id d10mr7471945ote.52.1576144385762;
 Thu, 12 Dec 2019 01:53:05 -0800 (PST)
MIME-Version: 1.0
References: <20191212091527.35293-1-yuehaibing@huawei.com>
In-Reply-To: <20191212091527.35293-1-yuehaibing@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 10:52:54 +0100
X-Gmail-Original-Message-ID: <CAHmME9pVuOR-EMxXVHVqippJ6UL4cMEoXZ4hoooK-qtQ=az5uQ@mail.gmail.com>
Message-ID: <CAHmME9pVuOR-EMxXVHVqippJ6UL4cMEoXZ4hoooK-qtQ=az5uQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Remove unused including <linux/version.h>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 10:18 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Remove including <linux/version.h> that don't need it.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks. Committed with some wording changes to wireguard-linux.git for staging:

https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-linux.git/commit/?id=062fd1993cdbf64a57395320c719e58b9a75b767

I'll re-send this to net-next as part of a cleanup series I'm
preparing in a few days.

Jason

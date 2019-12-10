Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C11D118F5A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfLJRxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:53:09 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39982 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfLJRxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:53:09 -0500
Received: by mail-ot1-f66.google.com with SMTP id i15so16298137oto.7
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AO+PN2hY/Xvp4eO/rU7Mhl0C0g0rUPkGRTMroOrD5aM=;
        b=gl5nFMWwcKzXjLR8vsvFa7oY9zmjuGbFDiXyoAxmTkvHPOuc5HL54joWzx9TkxsJ0l
         KuWwinn3CQaQJUMW/1Rq+2B6hAb/fq4G8WWEtkVuxWzft1PRrS/bI+qEjl4bRmndbyyj
         Pn9fdwX1gqOy1aV+fvX+zsAdDMynWbQ41i4/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AO+PN2hY/Xvp4eO/rU7Mhl0C0g0rUPkGRTMroOrD5aM=;
        b=D/3beidq5zKt7lFhmaSpO6zuujpMUWxl9OM/3PPdx7z/9A5bBA4aRH2q+CKFXsWeN0
         qv5qAPrGrzEhwSVpUc7zC6VpKQk7RCg9L8mUuMdG3SAJV8gJW5BwplOSvoPo9NuQjq7p
         eUDJIBxyVIE6GdL+JaGUX2wovEkIxmYFqR7XlXtDDJlhmlOBq9kPcRhFTRHqitBTY16c
         aqFQt7agAm6Cr3wI/awu9vysBE9Dxp3T2YUCeDkTiLKLcuCABChtpgSWbTcjo0G/5ucV
         P2MDPzGFZM4i6jbPCZJDZQ2nZ0EFgrhZaHjLiU5CR5PfEEzfvUGSJmQqseq0uvgdj8un
         e8Og==
X-Gm-Message-State: APjAAAXYne4NZuqq0TseSz3jLBxMOUp0+KQdqaM5Qp3bZoFqKj75XXPe
        X9M3UhJbOu8PE+pNuwgWgftWz/uYJAfNtq4OkG1e5OZ5
X-Google-Smtp-Source: APXvYqx8XDPBybpBncePrCEuIZxgaNFtM60+QTePF3wP0St/MFqU71u1O5Zj5du8Y/wYVzHYR59VU9A/iQRtwhDN+gs=
X-Received: by 2002:a05:6830:2142:: with SMTP id r2mr11337395otd.334.1576000388187;
 Tue, 10 Dec 2019 09:53:08 -0800 (PST)
MIME-Version: 1.0
References: <20191210163946.2887753-1-jonathan.lemon@gmail.com>
In-Reply-To: <20191210163946.2887753-1-jonathan.lemon@gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 10 Dec 2019 09:52:57 -0800
Message-ID: <CACKFLi=JCfD04fAQNi5C6k8DdqPtznkw1JFoOyPWyEv-BZLzuQ@mail.gmail.com>
Subject: Re: [PATCH net] bnxt: apply computed clamp value for coalece parameter
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 8:39 AM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> After executing "ethtool -C eth0 rx-usecs-irq 0", the box becomes
> unresponsive, likely due to interrupt livelock.  It appears that
> a minimum clamp value for the irq timer is computed, but is never
> applied.
>
> Fix by applying the corrected clamp value.
>
> Fixes: 74706afa712d ("bnxt_en: Update interrupt coalescing logic.")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Thanks.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4CA6D077
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390644AbfGROwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:52:13 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34547 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfGROwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:52:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id n5so29353635otk.1
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 07:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g91fBlR0pN6dY8NX+J2cvG9CqlL2ujCnSzNLNEQHl+0=;
        b=W1UOaaWtKgqnGdPVDpmCZ09iT3kpQuo90BcGIONjk9twvefDngbby3WWzgJBiIGvtU
         vGk6OYv5hv6MBon1JliWVqHqbr9RXHK+DpVc4vBDYbGPEpZhYFFcZPjlAOMlKOzByRew
         Bfu9XZz9BNbHd8ESnfXcPzqVPJNsFCrkVoyy4elPEGhbKJApEuMRRP/z2Rsj16HIZ2m6
         2hnW85d8044XESLJZ315f4f/6b9q61pRbfQhhHM+lNvnRQIMs5raGh+xVdhfSrq6/5pz
         GN186KjvMrcynQ0LBhpRdjssFwQeaiJ2dlUn/b3lyyE4V1eaDDEHLIQuKj2ZZucYcTUX
         bleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g91fBlR0pN6dY8NX+J2cvG9CqlL2ujCnSzNLNEQHl+0=;
        b=sf+vXSCVpfZey93JdGAikOJqx23OPyMl/Fo+eyQPc7qrCGJ4WT03CFeh6K+8D9Jnrc
         b/ldehTVIhv4t+tY5cZ6XdGOuaQUP5zyzPEbgvXzN2OHn5nz59UmAEvCXHsIVvZ0t+aq
         vN/0XCmuw/V0n2qQm31tRc+/RBuKLJUvzreMMSp997BWKv1B9xTKq1IREqI6WkU7Ford
         5wMK7gFsZYm7Ftvm2E7A4o84t3Yex9vXskMUY0cA58Oh5A0yLNs1ljvr7k0r/iPxquU9
         hHvIONFvsp7KIOhUK8QlJAFxFZumoH/ZAhVNpzl0pOx3XIOr27MAltP/vqF3Gahs7L/i
         1Spg==
X-Gm-Message-State: APjAAAVCqMWNR8MezMayyJrN4a1Yz1VecfU4SxSuJKu/KWaBXwBoZnrN
        mpYLlMgLPxA4N0VA0lSAeM2CP8NbnunoWhDfpTmLKcJjHBo=
X-Google-Smtp-Source: APXvYqyBcJcAmVcq8+rb+lvFIQo1uegJdVXzFsFACNi4WDvOp53brGWkzCFrHkYCM/M+I9pl/UbNKE89rG+xpoNzig0=
X-Received: by 2002:a9d:5cc1:: with SMTP id r1mr27809079oti.341.1563461532480;
 Thu, 18 Jul 2019 07:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <1563460710-28454-1-git-send-email-ilias.apalodimas@linaro.org>
In-Reply-To: <1563460710-28454-1-git-send-email-ilias.apalodimas@linaro.org>
From:   Jassi Brar <jaswinder.singh@linaro.org>
Date:   Thu, 18 Jul 2019 09:52:01 -0500
Message-ID: <CAJe_ZhdFBUWQwf+OcDX_0_wYTpTqHJvqJi2QE3CP+8rwXCLjMw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update netsec driver
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019 at 09:38, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Add myself to maintainers since i provided the XDP and page_pool
> implementation
>
Yes, please.

Acked-by: Jassi Brar <jaswinder.singh@linaro.org>

> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

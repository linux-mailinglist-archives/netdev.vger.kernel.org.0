Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2FB5195321
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgC0InJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:43:09 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:44756 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0InI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:43:08 -0400
Received: by mail-vs1-f67.google.com with SMTP id e138so5663286vsc.11;
        Fri, 27 Mar 2020 01:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92v3v9O6F1Q3whXiHw17g/dqUG5CfN1T3QTIoEEIQ7I=;
        b=p81juotZx1bUgpdZ8gT/wQT4KZ2KZ5jHpKcKYDqJLluurY2AkbcvlxofvjDUeK+Hm2
         uMijT84QxPlGZXhx5PD13awOZJtygx15wwcn8InHDNhwSdQPlt0iBVgM+7jC/tenVZWo
         i9CcAzd+UFgSbdUaCTNzqTrY09VXiVhT3OYMWgIsaAiey7ala7gN0Hu1IVHazDRRF/uL
         um2TPgUL9WxZhuKUKGNhYgYmfN4g+/5P1oqdCo6cF2oPAeEP2+FJLcNNOzKGXOxlsYZD
         rVuo840bAwmJsxoAqVTc0ZgZyQP/GKfUEzxUM5lunnkN0E+Cl4cglPhs1cus5PQH+0j0
         gfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92v3v9O6F1Q3whXiHw17g/dqUG5CfN1T3QTIoEEIQ7I=;
        b=oGLzgp1Wh8d6UyPbn3Dk1XRVAkBECJBCt4xCZUwyUQT3S3zq3yrJpjVAt9JhAB3xu6
         1UsoPzQdK6K7mxduxEBXJPBab6GmcDx/PfQ9O2+I2UkZ3A4KpTN8wkY183KXBQ3MI9hW
         NZkDfIO7oD+b1gMoF+bnLhBicZF6azzyi8w0JjqDJKpHm/7bi2ZWaaGxBIMnMih0bdtv
         HXB0apkrUgsIunL1I2/Kxzw1riM+VZA51Tom+4xGh1W+wji+Nc4gKyoLW3pO2jqATbZn
         nLNNiWXMgSDMSZypyVWxmJ2GOKKeZ6yz+tzSDaNOGj+04EE1XXfoTH/8mYtu+vkFUR3W
         ZlEw==
X-Gm-Message-State: ANhLgQ1zn47b8j5HcPpUUUF0QjFxaMoEWFLrDlgJE5MRqABKJxiGaNpZ
        5yfkHJdI2edoBCxgu/36zaGQYzwRJAe3lX/uzzo=
X-Google-Smtp-Source: ADFU+vsaaXTxlvmi+j4L1dYa6RpljDs7DpBADmI8karwZkMAv/1NaPX5Jt9jmLZwtSpHb+EgRO9uuM5HEK8Fb1dVevc=
X-Received: by 2002:a67:2786:: with SMTP id n128mr11373783vsn.21.1585298587138;
 Fri, 27 Mar 2020 01:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
 <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com> <105f17f25e90a9a58299a7ed644bdd0f36434c87.camel@marvell.com>
In-Reply-To: <105f17f25e90a9a58299a7ed644bdd0f36434c87.camel@marvell.com>
From:   Marta Rybczynska <rybczynska@gmail.com>
Date:   Fri, 27 Mar 2020 09:42:55 +0100
Message-ID: <CAApg2=ThxqOj8a2uZbRVgXZFjHWHk9g_xY3eseobQWwHLxiREg@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] task_isolation: userspace hard isolation from kernel
To:     Alex Belits <abelits@marvell.com>
Cc:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 8, 2020 at 4:48 AM Alex Belits <abelits@marvell.com> wrote:
> +/* Enable task_isolation mode for TASK_ISOLATION kernels. */
> +#define PR_TASK_ISOLATION              48
> +# define PR_TASK_ISOLATION_ENABLE      (1 << 0)
> +# define PR_TASK_ISOLATION_SET_SIG(sig)        (((sig) & 0x7f) << 8)
> +# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
> +
Thank you for resurrecting this code!

I have a question on the UAPI: the example code is using
PR_TASK_ISOLATION_USERSIG and it seems to be removed from this
version.

To enable isolation with SIGUSR1 the task should run:
prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE
    | PR_TASK_ISOLATION_SET_SIG(SIGUSR1), 0, 0, 0);

And to disable:
prctl(PR_SET_TASK_ISOLATION, 0, 0, 0, 0);

Is this correct?
Marta

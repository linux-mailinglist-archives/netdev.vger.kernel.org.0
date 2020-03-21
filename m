Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6CD18E1B9
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 15:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgCUOLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 10:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgCUOLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 10:11:19 -0400
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7A220842;
        Sat, 21 Mar 2020 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584799878;
        bh=z3bsHcwPw1dy+MZ69yHRllkviwuFf+1W8mJ1Vq6tZx8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U6uraq1+O/wBDq9BdnirqCkla8fi4hhFooa9u8EOGpG/NUK8KcAg8m6t2KHRzRSTZ
         U1tt2IsiTDMVS0ltxGzSghSwm0SPd3Ix8AtBnYo+moOc67e2fIk/ICATj9ELG9zqHj
         KWOd3QQR+qDycpEtfRl0ifl4E+I1zEKfB5l1H1GU=
Received: by mail-lf1-f53.google.com with SMTP id t21so6707987lfe.9;
        Sat, 21 Mar 2020 07:11:18 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2NRbh5XueagTwvvEpfNbQrjY3WjmYWsExYRuD9ZYsKAjI5eANG
        5wC7rxeybWBIdvZuJtjEJiBY448WImtO3Cpbfzs=
X-Google-Smtp-Source: ADFU+vt7yzzoIODXTl3pSLaF05QHM7NQajznhAWuFfmnjqd/dl0IS02TuRz56P5ko6Q0w3g4sq26da7i2uTfuhqRlWs=
X-Received: by 2002:a05:6512:1116:: with SMTP id l22mr8128251lfg.70.1584799876421;
 Sat, 21 Mar 2020 07:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200318204408.010461877@linutronix.de> <20200320094856.3453859-1-bigeasy@linutronix.de>
 <20200320094856.3453859-3-bigeasy@linutronix.de> <tglx@linutronix.de>
 <CAJF2gTQDvmSdJB3R0By0Q6d9ganVBV1FBm3urL8Jf1fyiEi+1A@mail.gmail.com> <87zhc9rjuz.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87zhc9rjuz.fsf@nanos.tec.linutronix.de>
From:   Guo Ren <guoren@kernel.org>
Date:   Sat, 21 Mar 2020 22:11:05 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTTFYSwFYZArmJRkVJOKL2pWWgLj9nAQ_EdH2rU3jTdbw@mail.gmail.com>
Message-ID: <CAJF2gTTTFYSwFYZArmJRkVJOKL2pWWgLj9nAQ_EdH2rU3jTdbw@mail.gmail.com>
Subject: Re: [PATCH 2/5] csky: Remove mm.h from asm/uaccess.h
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, balbi@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, dave@stgolabs.net,
        David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org,
        joel@joelfernandes.org, kurt.schwemmer@microsemi.com,
        kvalo@codeaurora.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        logang@deltatee.com, mingo@kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        torvalds@linux-foundation.org, Will Deacon <will@kernel.org>,
        linux-csky@vger.kernel.org, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 8:08 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Guo Ren <guoren@kernel.org> writes:
>
> > Tested and Acked by me.
> >
> > Queued for next pull request, thx
>
> Can we please route that with the rcuwait changes to avoid breakage
> unless you ship it to Linus right away?

Ok, I won't queue it.

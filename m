Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C7E772
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfD2QQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:16:31 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36296 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfD2QQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:16:30 -0400
Received: by mail-ed1-f67.google.com with SMTP id a8so7592944edx.3;
        Mon, 29 Apr 2019 09:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TEEvDMj9Vnh4ofwZ+ypl/2/A05GwNPsk2joWuaOOOw4=;
        b=HJz0hQbA1rP8NYrqGN7y0hlrW3zLp4WGDSN0ueeyblkx7/6tCXcGmfDbLKuDutP5Xm
         WVZP3vKy3VAx021VsNT7G8CgslKnBkyox4ENDFJ1cRMpLXt8kdL9ih9pMTI+d+kZpatk
         RhPSnF8P2ySOxKw8ez/bHZ0O6OvDmD1iLPKZUt5CUD1hg/LJFpZMEdniT5UixMNK+Htm
         HA+vvLvRiNwp4D6YOnMY/Cfh26skl+g4pNUOihXCD9ga0WEGHNgLzKjbITIqTZf7+rku
         A/IfpppA8iKK/q1dDcPJCOx+t24qbWYKpajXooOQCuNNxMbCe0OFVZFWd5H3uTiSpwH0
         YMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TEEvDMj9Vnh4ofwZ+ypl/2/A05GwNPsk2joWuaOOOw4=;
        b=iQoD/DD0qAsmIiPxbIjEON851bQmMI5dv7wlYe1Etv141Bro9C1Xlx08ZPMvR74kgi
         G2n5lsWk46nb20kPzGqmmMXchR+qWg2bpZJ4DuL0q/ee+WJAttiCgrnxjTWlSz5xDK4m
         wdxZt8HLCLpI0GZXrm8LiamJfXkaJ9lAjsaPen+qqnbHBiVVC6EOCW4c0ywkK4jVSMGs
         TQYElKlG3ITrHbHqt/yXZa0PxmUh45azQ1lbaRzUDnzY0xV07/BVLy9IiHZ4kBuId5ie
         2LKOjnFP+T/K8dwgvuSVZYdkzIihcSAhIjV5RP0m9zBsywKh1rnAUzJF9PX2rl4OQUc+
         mnAA==
X-Gm-Message-State: APjAAAV6DiTTYNuVecu59ERUI9cnVioPLTqqUHXltj2H4XM+yniNpAfA
        OPckElv0M3QwHc3wK12cdHgYTJqv+Dc2gzwn6Kk=
X-Google-Smtp-Source: APXvYqzfHd8EUL9/YOPCq45PtaLoMvDgtXEeoUUMFLXy5GztgZp7M/yNI5RTJ5FvH9J/MLiZ5MpfkrDKcAmLyOChczw=
X-Received: by 2002:a50:bdcc:: with SMTP id z12mr37920478edh.138.1556554588928;
 Mon, 29 Apr 2019 09:16:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190429060107.10245-1-zajec5@gmail.com>
In-Reply-To: <20190429060107.10245-1-zajec5@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Apr 2019 12:15:52 -0400
Message-ID: <CAF=yD-+Z=u5Vh=z73BSDrAQZSSXvwOYAxZNLzVMksz5pdfmP=Q@mail.gmail.com>
Subject: Re: [PATCH] net-sysfs: expose IRQ number
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 2:01 AM Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Knowing IRQ number makes e.g. reading /proc/interrupts much simpler.
> It's more reliable than guessing device name used by a driver when
> calling request_irq().
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> I found a script parsing /proc/interrupts for a given interface name. It =
wasn't
> working for me as it assumed request_irq() was called with a device name.=
 It's
> not a case for all drivers.
>
> I also found some other people looking for a proper solution for that:
> https://unix.stackexchange.com/questions/275075/programmatically-determin=
e-the-irqs-associated-with-a-network-interface
> https://stackoverflow.com/questions/7516984/retrieving-irq-number-of-a-ni=
c
>
> Let me know if this solution makes sense. I can say it works for me ;)

If parsing /proc/interrupts is problematic, also see the
/sys/kernel/irq interface added in commit ecb3f394c5db ("genirq:
Expose interrupt information through sysfs"). Does that address your
use-case as well? Though it does the inverse mapping from IRQ to name.

Another practical issue is that many network devices register more
than one interrupt. Perhaps one control interrupt, plus one per
receive queue and possibly one per transmit queue. Unfortunately those
cannot be identified in a driver-independent manner. Because an
interface /sys/class/net/$DEV/queues/rx-$i/irq would be useful.

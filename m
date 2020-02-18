Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1394116220A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgBRIJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:09:07 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44679 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgBRIJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 03:09:07 -0500
Received: by mail-yw1-f65.google.com with SMTP id t141so9024345ywc.11
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 00:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uyEWJShR9LJ8QX/N1ukvXqIWrjedExR7sHN4ZEGu88k=;
        b=KDtqPFiqjc6anygznsqiZcpIk46uJIl9oilHJbX1l36GKOFR01yP39QOzv7QEy697M
         9w9nOumO5qRvaveaWfy1xnML2FkL8x3089WO/zbTGthxhTQw1PD4ricG8Ht+Oi68IL8G
         nB1T5Ya83zXvSRICBdspsaFCFOVW+SZzImZj01U+mIzlW7CTM8IB7EDai1km5E31ikS0
         ko4+fwuxZnivwN4Sb5P9zhylqCT7aU6zh13yJE7N2bSAHs6d7Yo639uCMLqcQ11mYIx2
         zXGj3sekcDHGa2orAGsmpS5iT3XJbrfdHlBkGGsQHoTg86hRjk2T2KK7K64zhx8xd7Oo
         tskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uyEWJShR9LJ8QX/N1ukvXqIWrjedExR7sHN4ZEGu88k=;
        b=p48Lfhqezos6UWCphb+r/2NXIOlPndCyXGH/RdpLztz/HJ4pI7r+v3sw2F4dSquCj7
         njPy2LJgLJ16AAE/xqKRJHVbg6Sw4zR1u48HSkMevkamvsCP4A5HTniSjzOLOf+JEoU9
         1f6UvQa1CsD7gp9u5JsBxfErG8CY7CdOzAi6nLWe/DFuSA4+ETlISQqRxL9+DxI8V6kZ
         VE55CmW5hwAfxmun7UdXobjKohUkNEQR0bd+yUEzUzD4PXpjioqczLU42EODS/tJ4rcT
         WwZ26p6aYlV6KfjzLPYQd1G7rukMHlF6OQtcoSZ9XezDyP8vBa/ESyxoeU/Vl8BXZEBj
         XiLA==
X-Gm-Message-State: APjAAAXFglurahbh9GTkvmR23odEtCP2CwWhd6h0b2KyJrI79xs9A9kf
        RW0MfUWlPSvLeHkKguOiYKpXd34KMcFvUNUy4Fit8PjS
X-Google-Smtp-Source: APXvYqzi3eC5vVQRDw30BA0bpN/7CkSRP7kIyp3kffOCs2bIkygZ1KqZbystmKKe4o9yS9/fvA9eylZI3zgZ4Q/322I=
X-Received: by 2002:a0d:e28c:: with SMTP id l134mr16547923ywe.54.1582013345866;
 Tue, 18 Feb 2020 00:09:05 -0800 (PST)
MIME-Version: 1.0
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
In-Reply-To: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Tue, 18 Feb 2020 09:08:54 +0100
Message-ID: <CACna6rzgH0Ltgib+mmDNLMQE5qmU2xBYUFBJDCswvyC1bnonjg@mail.gmail.com>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a leak)
To:     Network Development <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Feb 2020 at 08:37, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> I run Linux based OpenWrt distribution on home wireless devices (ARM
> routers and access points with brcmfmac wireless driver). I noticed
> that using wireless monitor mode interface results in my devices (128
> MiB RAM) running out of memory in about 2 days. This is NOT a memory
> leak as putting wireless down brings back all the memory.
>
> Interestingly this memory drain requires at least one of:
> net.ipv6.conf.default.forwarding=3D1
> net.ipv6.conf.all.forwarding=3D1
> to be set. OpenWrt happens to use both by default.
>
> This regression was introduced by the commit 1666d49e1d41 ("mld: do
> not remove mld souce list info when set link down") - first appeared
> in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
> Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.

Thinking about meaning of that commit ("do not remove mld souce list
info when set link down") made me realize one more thing.

My app accessing monitor mode brings it up and down repeatedly:
while (1) {
  ifconfig X up (ifr_flags |=3D IFF_UP | IFF_RUNNING)
  select(...)
  recv(...)
  ifconfig X down (ifr_flags &=3D ~(IFF_UP | IFF_RUNNING))
  sleep(...)
}

So maybe that bug running device out of memory was there since ever?
Maybe before 1666d49e1d41 ("mld: do not remove mld souce list info
when set link down") I just didn't notice it as every "ifconfig X
down" was flushing list. Flushing it every few seconds didn't let list
grow too big and eat all my memory?

I'm going to test some old kernel now using monitor mode all time,
without putting its interface down. Is there some of debugging
mld/ipv6 kernel lists to see if there are indeed growing huge?

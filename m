Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FF6C8C5B
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfJBPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:08:41 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45230 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfJBPIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:08:41 -0400
Received: by mail-ot1-f65.google.com with SMTP id 41so14935730oti.12;
        Wed, 02 Oct 2019 08:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJIjCiQ2NYS0xuLDviUg5MNMrtpokzrxmaZaxyzzQ+w=;
        b=viD9ISzUoE03KqyTDPzoGP5j7FlOzU6mIDolt0h5q17eo4s0bbNtYO0SCEQDhsOKCT
         6z8A4Aw+NZiXBrTm/90NusQPpxsxKuQrjh4AYIix1zsDunIBFO1plI8+TIpsbx8u0tcc
         Af/d55bFh3bFxuC+ik3uSOfON+5CxEREUwnsKHDFZwQf13fsN5wOIT/IWuI8RJTMbDiT
         gP8zSUP0rjg3pqyWqS5a6tEQbcF8UHL7srBmiG0kR2vEh1+839GItKkdKDhokgs+K+GP
         nloKBSUyBicIiMoOGR0dmEloHru3Mvmug3YyNgqta1AVPGMhw+XGsyZ/EOPOz5mor0YU
         8ayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJIjCiQ2NYS0xuLDviUg5MNMrtpokzrxmaZaxyzzQ+w=;
        b=O6W5HCiOZ1vkiud1sAKn8yK0CrPcX5ctu1IIpKpP7kh6UntM5igszxE8GGhbxeCDup
         l1qURAqFuLyXCtyKnZH7bLpH/jdf6hkArRNncg0NMt8LvwdGq6zUKXeS0l8lYn8PS/xv
         a9AoEAg6qjEAWf/XJIIRDmw5nzs1464a87qAyJdxQR8CJIdR5ADrR+3oRu7VJPRw12w1
         vc5BZcZf0TFdvTuRB6rx5CSKM0grE5+qCDcZF5ukGTIBKZH7PiKFIiO0ghxDXt42b9Jn
         p7nmdluz56GO0LvMk2przrgCtyqon4pW9eMGfTtPXjDRgJPT7ckDsAUxrEbDEpgdDYdZ
         2DNA==
X-Gm-Message-State: APjAAAW20hOH3i0KVwsRHc9jGldEM0nQE0/u4A+mIYo1PiXa7qz0OGid
        mqkYW+7vfKZD9QIavqt2C3kvwBx1f4fgzvcDMuo=
X-Google-Smtp-Source: APXvYqzVt2LfQjyE/WxPgCJo/TBcWbnj6q/XHQzZrBF0p8HsfEx2NDpJWLQjANJ2HG+Zzz35jRfV3NXTHRGPA9UV6sQ=
X-Received: by 2002:a05:6830:1451:: with SMTP id w17mr2939034otp.332.1570028920662;
 Wed, 02 Oct 2019 08:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190918183552.28959-1-TheSven73@gmail.com> <20190918183552.28959-6-TheSven73@gmail.com>
 <20190930140519.GA2280096@kroah.com>
In-Reply-To: <20190930140519.GA2280096@kroah.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 2 Oct 2019 11:08:29 -0400
Message-ID: <CAGngYiXet4-2zUZ0oEO1iOqFM22zgVPZQ24Dzz5Q9TzTOTzjJQ@mail.gmail.com>
Subject: Re: [PATCH v1 5/5] staging: fieldbus: add support for HMS FL-NET
 industrial controller
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        Frank Iwanitz <friw@hms-networks.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 10:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Discussing "patented" in a changelog text is a big no-no.  Please don't
> do that.  Talk to your corporate lawyers for why not...

Interesting. I will definitely have to investigate what's covered by those
patents.

>
> Why are you adding support for new things here?  New hardware support
> should _only_ be added once the code is out of staging, otherwise there
> is no pressure to get it out of this directory structure.
>

Because I am adding configuration support, and the existing supported h/w
does not require this to operate. So I thought it'd make sense to add at
least one in-kernel user of the new config interface.

Would it be a better strategy to add an (optional) config interface to the
existing supported h/w in staging/, rather than introducing new h/w ?

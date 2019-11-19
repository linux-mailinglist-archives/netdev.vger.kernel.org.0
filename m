Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5381028D8
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfKSQEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:04:10 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35851 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbfKSQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:04:09 -0500
Received: by mail-il1-f193.google.com with SMTP id s75so20143770ilc.3
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0n+Ri5ngsQuRhhoRNrG05rRLmRCmZ1hhPN4FwF7ZaY0=;
        b=GVZpkzDb9Nr59zMGPmDdF8Fvz/6kRENShsoH2YywUtgf4QBZ+ptBApCsz+n6B8ADmp
         jpeX8rl8kyfVbzMnRYda+FSC53Dj8/J91fPTID6zVLCZWx2I+vpX///BJbT59huRkZx+
         o3ZlMDyGy4+LT1huuHZCc+J7fmAISGQI18R0Zs7uE0XxVTD8K5B+DyLSHbWM7O9rZ2YS
         MDOTJsZ5opXUJmiSncdiJF8wiG0GhkOvLhzHIaoYhXMWtUHo+JGE4i/Z3Sa2n/o3ic1i
         xxAw+kCAOUXUElpKoAv+x6nf2mCIGy6dEFzgHGt6AYrRLXB/7+Q200FRDbb8uh6HbEpl
         Kg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0n+Ri5ngsQuRhhoRNrG05rRLmRCmZ1hhPN4FwF7ZaY0=;
        b=RmWqiy60LCUahKC7DfdMe7fqahGPSVkPg3Yj5y/qDegEl6yR6pGtOSt1DJLrrZc3M5
         q7IpO/7LqJyaoAHuMLV0p9v6gKQWiYSZcLMIvOJULu+2FGf5ArWOoJCHYiNjGZrhdpyF
         Qs3MKamYyLwgqP7SXNGb8fYYijqad/bHQEH8kM9SxgqChTxsf3N6b08QDjaSCh9vIESQ
         +XTJARjoPgdNV8j+M4rfZR2kVWhpfnkUY4VYiQEaEIMteaS/5OX/2+zt4gWmB/VvujUl
         gbsZ75IckyG09JE8tQbDBdWBs9mqV8QCf5NLcAJUQ6Y6BSO/yE2CyrCl0Ek2z97mIFTB
         spJA==
X-Gm-Message-State: APjAAAWeM3E9lRtizlLSRihemg9Vmhh1d0D8XF0VbO2lSOcsr9REcQ0q
        b79XDeEFppDcnY+SX86vJ2GFWGn868nzgfLd0vcGmheL
X-Google-Smtp-Source: APXvYqwrqu+s186BC89/S183qNyqaTJvIFoEsZl6axGHm/47j81zDotW63JONzIt7rDgTd7CL4hKbRtYCAOvQQFrYMU=
X-Received: by 2002:a92:1017:: with SMTP id y23mr22918642ill.258.1574179448644;
 Tue, 19 Nov 2019 08:04:08 -0800 (PST)
MIME-Version: 1.0
References: <20191119024706.161479-1-adisuresh@google.com> <20191118.185125.2116597513753649065.davem@davemloft.net>
In-Reply-To: <20191118.185125.2116597513753649065.davem@davemloft.net>
From:   Adi Suresh <adisuresh@google.com>
Date:   Tue, 19 Nov 2019 08:03:57 -0800
Message-ID: <CAHOA=qwsqmnwOzXxREbuigPmG5mD+OY6XQmRNGRv40cwvTaTsA@mail.gmail.com>
Subject: Re: [PATCH net v3] gve: fix dma sync bug where not all pages synced
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed in v4.

On Mon, Nov 18, 2019 at 6:51 PM David Miller <davem@davemloft.net> wrote:
>
> From: Adi Suresh <adisuresh@google.com>
> Date: Mon, 18 Nov 2019 18:47:06 -0800
>
> > Fixes: 4a55e8417c5d ("gve: Fixes DMA synchronization")
>
> This commit doesn't exist in any tree.
>
> [davem@localhost net]$ git describe 4a55e8417c5d
> fatal: Not a valid object name 4a55e8417c5d
>
> The gve patch submission process is getting very frustrating for me,
> just FYI...

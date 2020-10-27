Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D75229A387
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 05:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbgJ0ECS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 00:02:18 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42786 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgJ0ECS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 00:02:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id t22so65498plr.9;
        Mon, 26 Oct 2020 21:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEWfF2+wHDXs51FoMh8BpSfr6/k+l32KvU6FkfuYmZw=;
        b=A8gZPcWpVxlr2DAl+5oIq9jH7CGdcsfJL1bZm36bBjnu6xbobQ27Q191lt1THV0xoi
         T8lLq9Ed9M78d0HS3oHqRJjAO1gd7tyJfZ+924Xh1IBharef3PnyG18pcxWj8gCJp4OU
         v96WqnZYKaW9Ad/U+FcOydcW7cySKlCzpA5PtRiqM5GTk6o2y6wwVN82DYIglzu7FEXM
         ocZGcD2V1STjfLtBC7bSypAFpqZ4mnz2q5qHXKHVW+OuCwCdl619Cb2e9cfFCyO+HbLZ
         HAE7N9TyzZAN+J0XQLMpgAc01IWQ64NZrBykV9gAYai8RAPwpGndqsoNeOmT8xOVokHK
         o55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEWfF2+wHDXs51FoMh8BpSfr6/k+l32KvU6FkfuYmZw=;
        b=nbKY7cmdcjUopA4xsGNr1pNgwmraONsAEegg5FR0vLMJp50nKCvAUYjIH6hxol3xSO
         AFeyYi41TADDLmNaCiP9kZDa8+m9tjyRvLtBQFanE/gUjcUngj6ViqU7TS7067AIoSg0
         7k47fKO1n/21Yp/7dUDS6HI18gqmS5KkZdXHvVABuNsS7Qgq8zNAtt4dMeHyGIctFrWe
         ucvdwgPEZIeIoMbsm3SHKf2THI5WQkQ7QzwooOjCTPq2Bexd/n+g2vMqbUV6F5VvGjSN
         SxS+moWTur4ufwRS7VzmkjC5EAx4XFmq8R3ITJnBKUrch3QI5tTPYfghX0vJ2C5WQafx
         LgLg==
X-Gm-Message-State: AOAM532H9+UN5EKplgr7IgkxtgJ+zVX3ciropfD9EpiLc/EbEf+5O4Ek
        CPpquiIeEUeQlmZjxSeOUqGGYTS1EIfxVt4TS7Q=
X-Google-Smtp-Source: ABdhPJybZzqkdp/e+29ztmpiTqE7aMjqTOPhVPrxcYPwefdunbcDQaBo2qgbZgqOUUtGL/DQ2HLSPatdJkiU1rfSOwQ=
X-Received: by 2002:a17:902:d90d:b029:d5:ee36:3438 with SMTP id
 c13-20020a170902d90db02900d5ee363438mr480534plz.77.1603771336410; Mon, 26 Oct
 2020 21:02:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201026213040.3889546-1-arnd@kernel.org> <20201027035558.16864-1-xie.he.0141@gmail.com>
In-Reply-To: <20201027035558.16864-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 26 Oct 2020 21:02:05 -0700
Message-ID: <CAJht_EPSs6W-r6kpWUNQDPzCjL-+_8mqq2JBoY=qhsQREgn92g@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] atm: horizon: shut up clang null pointer
 arithmetic warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Chas Williams <3chas3@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 8:56 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> > -  for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
> > +  for (mem = (HDW *) memmap; mem < (HDW *) ((uintptr_t)memmap + 1); ++mem)
>
> Note that these two lines are semantically different. In the first line,
> "+ 1" moves the pointer by (sizeof memmap) bytes. However in the second
> line, "+ 1" moves the pointer by only 1 byte.

Correction: in the first line "+ 1" moves the pointer by (sizeof *memmap) bytes.

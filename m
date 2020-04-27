Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11BD1BAEE1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgD0UKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:10:17 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:47969 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgD0UKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 16:10:17 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 52f47ff3
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 19:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=Q7VYboEJNCOk
        URuX+1jh1ouRkq0=; b=hynlG3bRSAUtARKhi9RP+Nle8UuF7J9orPXXt9pXhC8C
        tIlr4gB7+eEx93QlMWWohtZW9LDYDNg1aaada7Hbhz4rNen4A+fhUwbOvkwDyBhl
        DuksR9X+HCv56ZqxJX2Bn3gRoRAJ5+1vfFGKr9KG0+8fSxGMmyjyLsheVugCagS2
        PISbSlqZRAH2olHd7SWebvyls2/Qq+Jc4Nv6wBJqpzXEqTqFWHdg0QZfS7bdR91/
        9zMfKFuFl/Q+1eom7ELbJsb6FZs8AH17dJCY3Aqw60xoSL/XOOpT6PoDaALBOGPF
        sozrqtQ2/JB7Qb3cbIRbrXIgPSfI73RyykM2W8HjAA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e2c4198e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 19:58:43 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id k23so5066684ios.5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:10:16 -0700 (PDT)
X-Gm-Message-State: AGi0Pub6OPOyUOK4jbqJsZmKIUOuowkN6ay671Y1w9g1LiyKYTg4VQOG
        u1FCAsaWaexDDr4cAOUuUjDX2rL8D+I+/pE8NYE=
X-Google-Smtp-Source: APiQypIgeKgXaowAA6JM2A8wlt3ANLKsRp+USmkAZQia/DoRqvaz5in2LHL73wNtXaUNpq8dhCjWltqz98BBOLd7JFU=
X-Received: by 2002:a02:77c3:: with SMTP id g186mr12573165jac.95.1588018215307;
 Mon, 27 Apr 2020 13:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
 <20200427102229.414644-1-Jason@zx2c4.com> <58760713-438f-a332-77ab-e5c34f0f61b6@gmail.com>
 <CAHmME9oygxd=Sa5PvXWYm7Mth4tc_LfqnZXM+XrHuouKP1AQxg@mail.gmail.com> <87ftcoy9lx.fsf@toke.dk>
In-Reply-To: <87ftcoy9lx.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 14:10:04 -0600
X-Gmail-Original-Message-ID: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
Message-ID: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
Subject: Re: [PATCH RFC v2] net: xdp: allow for layer 3 packets in generic skb handler
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 2:09 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
> You could try the xdp-filter application in this repo:
>
> https://github.com/xdp-project/xdp-tools
>
> (make sure you use --recurse-submodules when you clone it)
>
> That will allow you to install simple IP- and port-based filters; should
> be enough to check that XDP programs will correctly match the packet
> contents, I think?

Thanks. I'll give it a whirl. XDP here I come! About time I joined the part=
y.

Jason

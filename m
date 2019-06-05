Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F54435581
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFEDDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:03:45 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35398 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFEDDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:03:44 -0400
Received: by mail-lf1-f65.google.com with SMTP id a25so17979221lfg.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 20:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QMuYTQ6jcAuftn8cOy3+6dxlA2Bt9xvS4jpE5pwbb3Y=;
        b=GcNVRMX5N4stMkdjXxhD7qejH2dVsIJRh2ewD8ahwS3sif1ngh2+ZkFu4afPHQmZr3
         f5NPgoEmEE8zaczMV6ObFWWBCbOkl1h8Rl11I8/a2tG3t3NzggBVtb3V5ugzY5J/ddi9
         DsGBY17XMlasXuGLJxas8y2PVItKfHerbVTgta/h+DG9XuFKapkbKZgKd3g9plCjWpZp
         JKdIPOO7FsTL46j4j4pmT11Qqfz9vLZuvS46jKtpqwsSrjVI0r2CSIBv9U3N0bGe0RbG
         pYb0ERO3a81+fQAh6Gi6qHMX3dzQ8a0y2p+LfaDGikYwBrt0kXu1/4hU0bI2WyNVrCIR
         cKvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QMuYTQ6jcAuftn8cOy3+6dxlA2Bt9xvS4jpE5pwbb3Y=;
        b=foyW2XfpD5fthKqCf/LRfj+Xwh1R43Uy1WYmtyotGvI/uTfz9ZANxaKJzSvrovF0qn
         SBdb4KjlU+zoI90Hz2LRASlSlGa56PsJZXXrrHRGU6tbtFvEgwBEb5i2G8TGN94VBn+7
         OBFNZhYExqyakk4IRHehFg9/7rn8+AerZIwbQo0zAeqpbc5pdc0yXILRSlqLZSYvQQgE
         TZSzqu/tzGOw4IazuOJAQ5yi2zAYMxVOcYHGndNLEuNK2Dt9GVi8v+GzM4E3CQaoXA00
         Iiw1xrEkP/0NXGVnus37ShA2aHvMxJlDwpTQMEBKXQ/xObzSa2kElQ8CjUFI1+wMosIE
         jy7w==
X-Gm-Message-State: APjAAAX7duTLO80z7zVvf4Ysuift8IOyvTqHJNQBGEL5tjSXwo3zIvwq
        GtN7mpLscK+3hq3TGpIK6ELN84ChLCcSS5L5Oaw=
X-Google-Smtp-Source: APXvYqxGJTyqnIokRgeRWUx1Pf4odXiULgOB5MILvOcVwLlUHx6YhDhZEeqmuc2abETKpwcdYVET7WpyK0pHlpaQjpQ=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr10557075lfe.6.1559703823052;
 Tue, 04 Jun 2019 20:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190604031955.26949-1-dsahern@kernel.org> <20190604.192741.471970699001122583.davem@davemloft.net>
In-Reply-To: <20190604.192741.471970699001122583.davem@davemloft.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Jun 2019 20:03:31 -0700
Message-ID: <CAADnVQLRjBQaoYA0Af12dBLgzWqFjOmpnY+kBrhQNrpQQqQEsg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Miller <davem@davemloft.net>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 7:28 PM David Miller <davem@davemloft.net> wrote:
>
> From: David Ahern <dsahern@kernel.org>
> Date: Mon,  3 Jun 2019 20:19:48 -0700
>
> > Set 10 of 11 to improve route scalability via support for nexthops as
> > standalone objects for fib entries.
> >     https://lwn.net/Articles/763950/
>
> Series applied, thanks David.

imo that was a bad precedent to make.
As far as I can see the discussion on a better path forward
was still ongoing in v2 thread between David, Martin and Wei.
Since the set is already applied it demotivated everyone
to review and discuss it further.
Please reconsider such decisions in the future.

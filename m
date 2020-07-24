Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3A722C958
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgGXPfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGXPft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:35:49 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA47BC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 08:35:49 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d7so4620176plq.13
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 08:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yBElfW5FAoM+vP0vM453Li7wrjesC0h0Ec60X0KfhLU=;
        b=I7YkIepB3tzJ7fsXux/HwK4QpdSvKxvFRTLekhaYRqSpJ7QI8/xLZqKBeFQlzZDqr7
         qSUyF/0upcUAqjrZFJ2RuBtENj4fFMAQiEjWgr8E4rgYjvAx+K4OlmLkKIbGe7CuIJnz
         P3ufI1Wxq3Kv2YLb6f3h6ufY+4B8x9jxOyF39sgRBKinX6014rkDMvXfxkyGAVKixcHM
         QFp/J0Ir1NpVQE4Gs+pVaLQGvBmparswPViW4UEhpJjg/tTOk8umLyNSBTR8W1LDg+8S
         aTWQg36s+SmfaRT01GcGdLakbKN2liEKEEBIBnbukMb1Jteb0chfRcdiq6RbzJuhla2c
         PPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yBElfW5FAoM+vP0vM453Li7wrjesC0h0Ec60X0KfhLU=;
        b=gUU6EaKnddKFxdDqw8MXrCh6D7L2GWlOrhL7v7ZjaFffEpMf45XOWs7RD/73Pbghem
         YbqkbrtdDl7xiTAKKOUBw1mIS0ZgHVDhWXsnApCOWNXfBARibw10IebWw9x3KvuSwdTl
         RDdVaQuMFn1r2ogi6CRvFnvVIVNeUMvrjRoKXAPQQdU/amP6TqFPdH0duyX5iAPdJeoK
         oORrc2IlZp14ePAdgZJK+9pZBcjfDAn/t8PPON62RNNwiD7quvCbFtEtu2Xl6XIgVu1G
         QQwRJQ0NCtprZguQbeuGhASn+twy+ntzoXhcv98FOidxMN1EsZUwYp+I3YuoI+4z2I9M
         G/Ig==
X-Gm-Message-State: AOAM531gKBHMfu4wPMc5igbz5aIjK3wbMpyYBdmLZwJDfhvqO6vxOqMv
        TUXzoFRV5lOdFBv6XXRYLR6a1gjosZfqMg==
X-Google-Smtp-Source: ABdhPJyWU0LNLsuUgBvrPg6zhJUoHFr65hqRpfZtV6M0JWb2zD6TBALxiO7exqpKEpv+VXMd6psV8w==
X-Received: by 2002:a17:90b:30d7:: with SMTP id hi23mr6329676pjb.69.1595604948867;
        Fri, 24 Jul 2020 08:35:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n22sm5993519pjq.25.2020.07.24.08.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 08:35:48 -0700 (PDT)
Date:   Fri, 24 Jul 2020 08:35:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     George Shuklin <amarao@servers.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Bug in iproute2 man page (or in iproute itself)
Message-ID: <20200724083540.0d0df332@hermes.lan>
In-Reply-To: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jul 2020 15:45:20 +0300
George Shuklin <amarao@servers.com> wrote:

> Hello.
>=20
> I'm writing Ansible module for iproute, and I found some discrepancies=20
> between man page and actual behavior for ip link add type bridge.
>=20
> man page said:
>=20
> hello_time HELLO_TIME - set the time in seconds between hello packets=20
> sent by the bridge, when it is a root bridge or a designated bridges.=C2=
=A0=20
> Only relevant if STP
> is enabled. Valid values are between 1 and 10.
>=20
> max_age MAX_AGE - set the hello packet timeout, ie the time in seconds=20
> until another bridge in the spanning tree is assumed to be dead, after=20
> reception of its
> last hello message. Only relevant if STP is enabled. Valid values are=20
> between 6 and 40.
>=20
> In reality 'ip link add type bridge' requires hello_time to be at least=20
> 100, and max_age to be at least 600. I suspect there is a missing x100=20
> multiplier, either in docs, or in the code.
>=20
> (I'm not sure where I should send bugreports for iproute2).
>=20

Good catch all the time related values in netlink API should be
scaled by the user hz value (which is 100).

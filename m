Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78811EB4B2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbfJaQ0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:26:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49045 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726540AbfJaQ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572539202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8quF5CgnZt6wbPqgLcGQgSnxQKKPC1DUKjHyzV1ux8=;
        b=i4SSEBYHo82yWvrvuU9ykvrf/EgbgawWJmTNPWYYjAJDcXqrDKBqP1xXSOBvqqu2SjKNd+
        lSb8qvqPNd9GRxeyGD/XCzejM9yRJ20hBk3cP0ZcNyPZGHLkphIDU1cqEr4gRFEpZ1aPw9
        7bVYG98kILfy7bxsvw2nbpxiSTJXDd0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-Yh7SRomNOlWB32ecykCPdg-1; Thu, 31 Oct 2019 12:26:40 -0400
Received: by mail-ed1-f71.google.com with SMTP id r26so4502679edy.13
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:26:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R8quF5CgnZt6wbPqgLcGQgSnxQKKPC1DUKjHyzV1ux8=;
        b=HxkcJ+Lgk5lt9nXfQeuVY7jC5upKl7pb1xRJj4T8OqqpYoTVepP8/G5uXv5UJc2PHI
         fdPBpnzvHRKgRd8WprEJKLq2OPRs7tZcNIUJC55lIOLmW9GQQmms9djw/sb5il1Dwh9f
         xg43CfhD9zNMlXTxuSwq8GWYqaQiz/NGKttnIi7PbBEZVILUmZteuCUQMyKug+C8NCK4
         CQzKgl5jzj1XWhhh7rcUfRjq5Fm+azJTUB+u5BwBGk2BIR1bAkrRUubhRGV0uyNSQvu3
         nxMyCOTj45EutFtMa4PzhFoTeM+kcL8EB7gzxRUr9dsaJrL2a4T6mrnqriv/zAxCBjhS
         Zg+g==
X-Gm-Message-State: APjAAAU/4Etxhp+KTllrB1PMGoCz5CR2qsfKprXn39tDYJawj6y8zXXD
        PmTbuSAa7msqxB2JIWyRAwKjikdQO8nBMkryPoia75h9SfukXfy82Ac8z2BsFVPQqYQNwRW9jl+
        v+M1KRVOqjGP5tGwH+CmwETd/1Th6ca7r
X-Received: by 2002:a50:ef0d:: with SMTP id m13mr7033968eds.210.1572539199504;
        Thu, 31 Oct 2019 09:26:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz89+0R2RBhj3DgJe5wWAZoiBFRWTIlF8AIgKAG4cKt19uEa5B1vzZMWusrHffp44bjwMBXd4xAovF0tWSatAU=
X-Received: by 2002:a50:ef0d:: with SMTP id m13mr7033951eds.210.1572539199325;
 Thu, 31 Oct 2019 09:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <99a4a6ffec5d9e7b508863873bf2097bfbb79ec6.1572534380.git.aclaudi@redhat.com>
 <f15a41a2-f861-550c-0f0b-5fc0b40db899@gmail.com>
In-Reply-To: <f15a41a2-f861-550c-0f0b-5fc0b40db899@gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Thu, 31 Oct 2019 17:28:43 +0100
Message-ID: <CAPpH65ziPuhSHwXdvfsMHf=Fddp8hj_nvum48w_01hD_+UBfAg@mail.gmail.com>
Subject: Re: [PATCH iproute2] ip-route: fix json formatting for multipath routing
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
X-MC-Unique: Yh7SRomNOlWB32ecykCPdg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 5:11 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/31/19 9:09 AM, Andrea Claudi wrote:
> > json output for multipath routing is broken due to some non-jsonified
> > print in print_rta_multipath(). To reproduce the issue:
> >
> > $ ip route add default \
> >   nexthop via 192.168.1.1 weight 1 \
> >   nexthop via 192.168.2.1 weight 1
> > $ ip -j route | jq
> > parse error: Invalid numeric literal at line 1, column 58
> >
> > Fix this opening a "multipath" json array that can contain multiple
> > route objects, and using print_*() instead of fprintf().
> >
> > This is the output for the above commands applying this patch:
> >
> > [
> >   {
> >     "dst": "default",
> >     "flags": [],
> >     "multipath": [
> >       {
> >         "gateway": "192.168.1.1",
> >         "dev": "wlp61s0",
> >         "weight": 1,
> >         "flags": [
> >           "linkdown"
> >         ]
> >       },
> >       {
> >         "gateway": "192.168.2.1",
> >         "dev": "ens1u1",
> >         "weight": 1,
> >         "flags": []
> >       }
> >     ]
> >   }
> > ]
> >
> > Fixes: f48e14880a0e5 ("iproute: refactor multipath print")
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > Reported-by: Patrick Hagara <phagara@redhat.com>
> > ---
> >  ip/iproute.c | 23 +++++++++++++++++------
> >  1 file changed, 17 insertions(+), 6 deletions(-)
> >
>
> This is fixed -next by 4ecefff3cf25 ("ip: fix ip route show json output
> for multipath nexthops"). Stephen can cherry pick it for master

Oops, I overlooked that. Thanks David for pointing this out, please
ignore this and sorry for the noise.


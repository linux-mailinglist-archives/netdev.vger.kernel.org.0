Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A088156AD1
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 15:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBIOJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 09:09:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39811 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbgBIOJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 09:09:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so4312948wrt.6
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 06:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FshNQgsEi8HE1nRWhj+AFbPAqCW4EMYVHaNUx5ydcHI=;
        b=N4xSbugdvdrercq4Zdqnfnadi3dBSTp9iexfwUkDoeUIQt8LtFNyZ1gnUPvXkP4oh3
         XwILAJaZNbHxqXDaonXdmwM6Of96KNKZG46r0MpqQ1/2oofBNxjII0GqZTs+BHQpt/PJ
         gsJGdmmiWGOhky61uepc3ANgpGC/RdNks8pQinmPWqpZSTUaJASSrY9Wd7SJ0F00DUib
         DpDKECpz4pvudNOhqZq9i6tRW1ft03NXZAtJ66oJi2d1hfNMMP/JPFoZeO8YF7SIdf83
         8Ue/Bd4+K2pW57Tv+EvQQQVz8nTrsYJKYOEHwLbYQZpGxrQ6shlc+tiW2h8NfY8koQ0h
         BfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FshNQgsEi8HE1nRWhj+AFbPAqCW4EMYVHaNUx5ydcHI=;
        b=dPvhmPlWq8ibIJwrhGb03gziC0t62H8CmUz2KTPMNPIKkA2iF4N9NPSNB0jofR6Si7
         R1CRpdWbAT2uPzwDPLLrNGX/Ve8m6rGPerPbudRsiX4ThfnWsP5Ri671vj8QEyjOyaTZ
         4DAO7i3T6p0RFVLVRX6wCmRVuy4QcMu3YsUINQrBgSMkHRAh23Ik2SDOWghj+baxSHpu
         ihqdHYtNgFnzgNBh95nZn5SyN87oVZ9VlrNCaM2zsUPE9A1EhiVmhHgNQ0NE1A6ErRdt
         DgBnz5hxtsbXnbjGqRM3gdEjCUOZf6hQK4shw1D1F4nxRUvTXAcTVHADIzCL6C5t1MPt
         RTGQ==
X-Gm-Message-State: APjAAAWtBrV0wDtpM2LyaMZ8Q9AMSuhBipSZnEBfclDdEaB+gYzdKAR3
        0VLt9o7QuQxL6irYKp9+nrLs0eh3x+kNG9uK7iBXLxUO
X-Google-Smtp-Source: APXvYqyJzAF83jS1DFx5/5J4XPG974Df1Mn1CMGnvouAOmldiWOrGyWEDg5HQEnmfG2paCeMhlnsibisGpplapJ8iwI=
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr11254023wrs.395.1581257376377;
 Sun, 09 Feb 2020 06:09:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1580708369.git.lucien.xin@gmail.com> <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
 <4e62548a-6d2d-558e-aa8e-999648a89b7a@gmail.com>
In-Reply-To: <4e62548a-6d2d-558e-aa8e-999648a89b7a@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 9 Feb 2020 22:10:01 +0800
Message-ID: <CADvbK_dqtpPjQ6VLQZBVBfx7C-RUeZ1SLQ+t9NNZWtMUTY+=bA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 1/7] iproute_lwtunnel: add options support
 for geneve metadata
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 7, 2020 at 12:07 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/2/20 10:39 PM, Xin Long wrote:
> > This patch is to add LWTUNNEL_IP(6)_OPTS and LWTUNNEL_IP_OPTS_GENEVE's
> > parse and print to implement geneve options support in iproute_lwtunnel.
> >
> > Options are expressed as class:type:data and multiple options may be
> > listed using a comma delimiter.
> >
> > With this patch, users can add and dump geneve options like:
> >
> >   # ip net d a; ip net d b; ip net a a; ip net a b
> >   # ip -n a l a eth0 type veth peer name eth0 netns b
> >   # ip -n a l s eth0 up; ip -n b link set eth0 up
> >   # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
> >   # ip -n b l a geneve1 type geneve id 1 remote 10.1.0.1 ttl 64
> >   # ip -n b a a 1.1.1.1/24 dev geneve1; ip -n b l s geneve1 up
> >   # ip -n b r a 2.1.1.0/24 dev geneve1
> >   # ip -n a l a geneve1 type geneve external
> >   # ip -n a a a 2.1.1.1/24 dev geneve1; ip -n a l s geneve1 up
> >   # ip -n a r a 1.1.1.0/24 encap ip id 1 geneve_opts \
> >     1:1:1212121234567890,1:1:1212121234567890,1:1:1212121234567890 \
> >     dst 10.1.0.2 dev geneve1
> >   # ip -n a r s; echo ''; ip net exec a ping 1.1.1.1 -c 1
> >
>
> Thanks for the command list and example. It would be a lot easier to
> read if commands were 1 per line and used the long form.
Yep, thanks, will do in v2.

>
> Same for patches 2 and 3
>

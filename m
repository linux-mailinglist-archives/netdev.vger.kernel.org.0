Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457282F2177
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388847AbhAKVEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:04:46 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:24282 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730563AbhAKVEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:04:45 -0500
Date:   Mon, 11 Jan 2021 21:03:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610399042; bh=vcu//doyECUTnhIiITA/X39kwSyLf2KhHEjPp8bJwpg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=gcPLtnWEa+t+9+1BPvXLHnZlcc4wAQhhVrcczGB8ewUh7b1aY3/V7wUxE27cFJx6+
         tpUbFzh4YzvhUuy/o5nWOONHEyWTm3u1NIjg2jlmPFFGgZd9sh7Dz/BtxH8fLsfusG
         RKVecP9Q+HCSgyIVWxgKzf5s6IcqlB3n5TddCjrqaLM80fWhfAylg6GLv/nXrQXj4V
         0tvgBykcaCN3iG+ZSKfN/XlDdm0GMSY2Q7ADqSy6sk+KbxuZQnx3u0+1641f/Wicxb
         4q1NcbtMKcFdWy4t/83Qhag0OBgT63NVo+i6YgHgrMA4oTjoRa4dQzWuiHOWw0oiCl
         4idWrzklmWJKg==
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 1/5] skbuff: rename fields of struct napi_alloc_cache to be more intuitive
Message-ID: <20210111210329.18881-1-alobakin@pm.me>
In-Reply-To: <20210111184945.e7y35uym73ujfif2@bsd-mbp>
References: <20210111182655.12159-1-alobakin@pm.me> <20210111182801.12609-1-alobakin@pm.me> <20210111184945.e7y35uym73ujfif2@bsd-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Mon, 11 Jan 2021 10:49:45 -0800

> On Mon, Jan 11, 2021 at 06:28:21PM +0000, Alexander Lobakin wrote:
>> skb_cache and skb_count fields are used to store skbuff_heads queued
>> for freeing to flush them by bulks, and aren't related to allocation
>> path. Give them more obvious names to improve code understanding and
>> allow to expand this struct with more allocation-related elements.
>
> I don't think prefixing these with flush_ is the correct approach;
> flush is just an operation on the structure, not a property of the
> structure itself.  It especially becomes confusing in the later
> patches when the cache is used on the allocation path.

Agree, but didn't come up with anything more fitting. Any suggestions
maybe?

> --
> Jonathan

Thanks,
Al


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02EF21008E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgF3XoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:44:24 -0400
Received: from mail.efficios.com ([167.114.26.124]:39406 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgF3XoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:44:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id CF6BF2C8628;
        Tue, 30 Jun 2020 19:44:21 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 0vJOA2UfVbAo; Tue, 30 Jun 2020 19:44:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 787472C8354;
        Tue, 30 Jun 2020 19:44:21 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 787472C8354
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593560661;
        bh=xwV0C8vTsPSlnmGbQy2hbyNyodmOGB/RFnq+mV8bBdg=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=T+fNjcpVMrKbACA4plRKj2I5ve8mu9T+5e/l8MBCCFygcxdfisFxkQx2WbYgSW29N
         yuiLHpu2GnTeqJKCduT8rkJxFyPL3pWHy5gkyZ/9tDMSy7NL/nCpy10GIbkwN+EoEI
         3dhiP3KFFeysI6Uy0czTdUeuBcxbWmYM7oeK37NzQd3RKUq7VYiRlkdj9OlQnh+pqt
         +RNSFFpQGonHhg9vzBRrFh+O5f5GnWOSr4HAGdEmqZzmCEC71cSurY9vgWL7NvQO4G
         wbYWacIw6RoZT6TA5R+9VO5EM+sesb2hX2OrKb0HaOifUM9S0h/3yG6SdCuDrTyJrD
         eW5WPd2/AZhGg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id w9K2b6F0Itho; Tue, 30 Jun 2020 19:44:21 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 665DD2C85B5;
        Tue, 30 Jun 2020 19:44:21 -0400 (EDT)
Date:   Tue, 30 Jun 2020 19:44:21 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>, paulmck <paulmck@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Message-ID: <416125262.18159.1593560661355.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
References: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com> <20200630.134429.1590957032456466647.davem@davemloft.net> <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com> <474095696.17969.1593551866537.JavaMail.zimbra@efficios.com> <CANn89iKK2+pznYZoKZzdCu4qkA7BjJZFqc6ABof4iaS-T-9_aw@mail.gmail.com> <CANn89i+_DUrKROb1Zkk_nmngkD=oy9UjbxwnkgyzGB=z+SKg3g@mail.gmail.com> <CANn89iJJ_WR-jGQogU3-arjD6=xcU9VWzJYSOLbyD94JQo-zAQ@mail.gmail.com> <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: TCP_MD5SIG on established sockets
Thread-Index: B06Xl8CKUYbxp+VQ6LJs8ecBAejacQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 6:38 PM, Eric Dumazet edumazet@google.com wrote:
[...]
> 
> For updates of keys, it seems existing code lacks some RCU care.
> 
> MD5 keys use RCU for lookups/hashes, but the replacement of a key does
> not allocate a new piece of memory.

How is that RCU-safe ?

Based on what I see here:

tcp_md5_do_add() has a comment stating:

"/* This can be called on a newly created socket, from other files */"

which appears to be untrue if this can indeed be called on a live socket.

The path for pre-existing keys does:

        key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
        if (key) {
                /* Pre-existing entry - just update that one. */
                memcpy(key->key, newkey, newkeylen);
                key->keylen = newkeylen;
                return 0;
        }

AFAIU, this works only if you assume there are no concurrent readers
accessing key->key, else they can see a corrupted key.

The change you are proposing adds smp_wmb/smp_rmb to pair stores
to key before key_len with loads of key_len before key. I'm not sure
what this is trying to achieve, and how it prevents the readers from
observing a corrupted state if the key is updated on a live socket ?

Based on my understanding, this path which deals with pre-existing keys
in-place should only ever be used when there are no concurrent readers,
else a new memory allocation would be needed to guarantee that readers
always observe a valid copy.

Thanks,

Mathieu

> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index
> 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..ecc0e3fabce8b03bef823cbfc5c1b0a9e24df124
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4034,9 +4034,12 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct
> tcp_md5sig_key *key)
> {
>        struct scatterlist sg;
> +       u8 keylen = key->keylen;
> 
> -       sg_init_one(&sg, key->key, key->keylen);
> -       ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
> +       smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> +
> +       sg_init_one(&sg, key->key, keylen);
> +       ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
>        return crypto_ahash_update(hp->md5_req);
> }
> EXPORT_SYMBOL(tcp_md5_hash_key);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index
> ad6435ba6d72ffd8caf783bb25cad7ec151d6909..99916fcc15ca0be12c2c133ff40516f79e6fdf7f
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1113,6 +1113,9 @@ int tcp_md5_do_add(struct sock *sk, const union
> tcp_md5_addr *addr,
>        if (key) {
>                /* Pre-existing entry - just update that one. */
>                memcpy(key->key, newkey, newkeylen);
> +
> +               smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> +
>                key->keylen = newkeylen;
>                return 0;
>         }

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

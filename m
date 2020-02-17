Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2DB161DCA
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 00:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgBQXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 18:21:41 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44288 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgBQXVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 18:21:41 -0500
Received: by mail-yw1-f66.google.com with SMTP id t141so8581786ywc.11
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 15:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jfqrWoKpu38ZkwNqe5obyuate8qeWCb2dvEdePTZn/I=;
        b=Qvv8V7/1UIVp28J6PxIMjitTOyJwqvOtp9g/o8oQ1+IUQdmbb7mUoXSQWI6fRXFjYI
         eyo7hmaoD0qFdKKxtp055GfkWwxN9crm/kztI0rWSfOdgb/wjRsaVMGkjs1TjCFK9H8I
         DzRhq9oza9un7J521Dk96XmlFg3k9sdJDWWoeVIQ6jFnBy/SZ2+MDyR4JjEkAcpjgR0U
         l4/tZZpj3duvxtc1WzpF1FXGE91a+ZjLpmrpfZzzWdhnWARnNMWZJgmcUtzznGJbbq48
         wJwS7aUHQCtXbRHHz9NZ/RwIivjJ9y2A80JbjqHPQupIt0MbiSc2zGrSjmieR7rbcX/f
         yrew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jfqrWoKpu38ZkwNqe5obyuate8qeWCb2dvEdePTZn/I=;
        b=VJfzJhgVFEWLwLT751LgI2PN5ewJJOA/kwifS4FKPLRkixH0yEbemI5AXnfV009sGN
         ihw9vZhG6TId5fPTp4qGYBO5KQAGyvC2R7cJreyQ7oILz8OePzmiLznefPIQeVcxWYsP
         0q9gjBDT9DJ6KCg3G8s0PDxohxcdNcOt8o7DCCwnjGsvZjw9FNu0Hc7A9ZfBBnYZKlvq
         SDCdfTbLE2n1wrST5pnw4b8Zx8ztiWxYFEKx6baSUlwir4BNBO4cSRQ1leuHuReD3YET
         y6FBuFOyTzWh7ktVN+YboSxIEAfsyezmYckqHxBvFkpq0idPVzrHqmDHHICrfhHd4SOI
         sSQQ==
X-Gm-Message-State: APjAAAUcI57y3NS2Oz0jsXzbls59LqZkgMxKfiFzkB2K+56qg/JJpAY/
        a3aT/2e0ipgMmTXtLOWxwXrv4WBC
X-Google-Smtp-Source: APXvYqxY2QIP1zRlsFpQQWMsPrsRybIVNnO6GtBkvMiMvYhgSprSbPTEi/G12AIxYm4/T2wkngoUxA==
X-Received: by 2002:a81:e903:: with SMTP id d3mr13870605ywm.494.1581981699893;
        Mon, 17 Feb 2020 15:21:39 -0800 (PST)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id a124sm929820ywc.104.2020.02.17.15.21.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 15:21:39 -0800 (PST)
Received: by mail-yw1-f51.google.com with SMTP id z141so8575134ywd.13
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 15:21:39 -0800 (PST)
X-Received: by 2002:a81:6588:: with SMTP id z130mr13325726ywb.355.1581981698437;
 Mon, 17 Feb 2020 15:21:38 -0800 (PST)
MIME-Version: 1.0
References: <CAN_72e2m8ZYTu1wsqHabvHct8d0Ftf6VHrh-ZGJNR0-Bpa2cyw@mail.gmail.com>
In-Reply-To: <CAN_72e2m8ZYTu1wsqHabvHct8d0Ftf6VHrh-ZGJNR0-Bpa2cyw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 Feb 2020 15:20:59 -0800
X-Gmail-Original-Message-ID: <CA+FuTSdB8nAohzbKKS3aGifRB4iJx_tFKTPaD_0MSAPLxRdrSg@mail.gmail.com>
Message-ID: <CA+FuTSdB8nAohzbKKS3aGifRB4iJx_tFKTPaD_0MSAPLxRdrSg@mail.gmail.com>
Subject: Re: [BISECTED] UDP socket bound to addr_any receives no data after disconnect
To:     Pavel Roskin <plroskin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 10:53 AM Pavel Roskin <plroskin@gmail.com> wrote:
>
> Hello,
>
> I was debugging a program that uses UDP to serve one client at a time.
> It stopped working on newer Linux versions. I was able to bisect the
> issue to commit 4cdeeee9252af1ba50482f91d615f326365306bd, "net: udp:
> prefer listeners bound to an address". The commit is present in Linux
> 5.0 but not in 4.20. Linux 5.5.4 is still affected.
>
> From reading the commit description, it doesn't appear that the effect
> is intended. However, I found that the issue goes away if I bind the
> socket to the loopback address.
>
> I wrote a demo program that shows the problem:
>
> server binds to 0.0.0.0:1337
> server connects to 127.0.0.1:80
> server disconnects
> client connects to 127.0.0.1:1337
> client sends "hello"
> server gets nothing
>
> Load a 4.x kernel, and the server would get "hello". Likewise, change
> "0.0.0.0" to "127.0.0.1" and the problem goes away.
>
> IPv6 has the same issue. I'm attaching programs that demonstrate the
> issue with IPv4 and IPv6. They print "hello" on success and hang
> otherwise.

Thanks for the report with reproducers. That's very helpful.

Before the patch, __udp4_lib_lookup looks into the hslot table hashed
only by destination port.

After the patch, it goes to hslot2, hashed by dport and daddr. Before
the connect and disconnect calls, the server socket is hashed on
INADDR_ANY.

The connect call changes inet_rcv_saddr and calls sk_prot->rehash to
move the socket to the hslot hashed on its saddr matching the new
destination.

The disconnect call reverts inet_rcv_saddr to INADDR_ANY, but lacks a
rehash. The following makes your ipv4 test pass:

@@ -1828,8 +1828,11 @@ int __udp_disconnect(struct sock *sk, int flags)
        inet->inet_dport = 0;
        sock_rps_reset_rxhash(sk);
        sk->sk_bound_dev_if = 0;
-       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK)) {
                inet_reset_saddr(sk);
+               if (sk->sk_prot->rehash)
+                       sk->sk_prot->rehash(sk);
+       }

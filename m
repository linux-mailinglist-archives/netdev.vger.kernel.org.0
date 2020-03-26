Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0077919410C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgCZONq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:13:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38649 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgCZONq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:13:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id c5so4954215lfp.5;
        Thu, 26 Mar 2020 07:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s4Ip9GlrlXH3w8IgLCzY7e6/JKcdBO3P2fUyUsD1eXA=;
        b=BsQjkp8OOxXSqy7SW8on2tzh2Uzr/2PIpWcFt1MPoqwG6PXKQH6jE6FjPBCqfjD0oX
         p2s0g79wOYBv8tpxf6hcvYSeHehtQ+e/gS4jJRACg+Kds4HjEwP0U0v+pLnts/xgAq/S
         kGzqhseOxN/fzxNmYUDvKKmwwNOkKBwChtzmu8d+zHHrWFfI1rUCELJRBSR250LTzc4H
         7Voibb8UyrNDg16p51MpRIek6HohF2fRqhEsgOQrSIEsic7nNtBCcjBtHEfdbI4DlitA
         q2nXQv4fwYGt9rASrhMCykKl9N9byiY5tP42t8RU7xwYpoURvWfdLeA8aHnEPMP0AX9d
         31oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s4Ip9GlrlXH3w8IgLCzY7e6/JKcdBO3P2fUyUsD1eXA=;
        b=gA/wVBu28uMF2s5hAADQmRuBTSL6wIUUB8QeyQ3PUY/Lc+140a/H1cWoTqMpjX+VEq
         QQEjzsuCFJrbSyOvW2OytPoLITzmWQdjBe0IBD3TWIugF55B0rzUlkYwft5YlOTL4Ili
         AylrXvH8uKVksCmaPu6ao5Yu8nlZ8FLfs3mqKWSNUaXjJaR0bJ+BDOJzBQypCLeUBtfc
         cNK1KX+nPbXgWVe3joYFTbZUlM5Kp5zPdsIPgRj33kVFb5yp4iXM3k04wRhuJPhoGsoL
         RChMLWmcr+d8W5pvKk3RxKPiQGdqXNrnZQUYLjEG8u78J+f18uXhdBu79IU+m7iQIzul
         2e2g==
X-Gm-Message-State: ANhLgQ37asLg25XHxvTwQulZHg6Iw8UgNQQXkDntw2rohQvaxTLl3APh
        n65X5pK8ivdzURZBUjPjCkzvHLz8hokL9coqAR0=
X-Google-Smtp-Source: ADFU+vuXVQnmzFtq/yKZPBUP6NFh5YybbICaCkkPvaW9NRrTM5E/pNcrwWWmxW3xLt4zCj74xcSByecrz7Tv/fKcP7A=
X-Received: by 2002:ac2:4350:: with SMTP id o16mr5202095lfl.136.1585232023288;
 Thu, 26 Mar 2020 07:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200320030015.195806-1-zenczykowski@gmail.com>
 <20200326135959.tqy5i4qkxwcqgp5y@salvia> <CAHo-OoyGEPKdU5ZEuY29Zzi4NGzD-QMw7Pb-MTXjdKTj-Kj-Pw@mail.gmail.com>
In-Reply-To: <CAHo-OoyGEPKdU5ZEuY29Zzi4NGzD-QMw7Pb-MTXjdKTj-Kj-Pw@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 26 Mar 2020 07:13:33 -0700
Message-ID: <CAHo-OozGK7ANfFDBnLv2tZVuhXUw1sCCRVTBc0YT7LvYVXH_ZQ@mail.gmail.com>
Subject: Re: [PATCH] iptables: open eBPF programs in read only mode
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think your build system's kernel headers are old.

Linux 4.15-rc1 commit 6e71b04a82248ccf13a94b85cbc674a9fefe53f5
Author: Chenbo Feng <fengc@google.com>
Date:   Wed Oct 18 13:00:22 2017 -0700

    bpf: Add file mode configuration into bpf maps
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -218,6 +218,10 @@ enum bpf_attach_type {

 #define BPF_OBJ_NAME_LEN 16U

+/* Flags for accessing BPF object */
+#define BPF_F_RDONLY           (1U << 3)
+#define BPF_F_WRONLY           (1U << 4)
+
 union bpf_attr {
        struct { /* anonymous struct used by BPF_MAP_CREATE command */
                __u32   map_type;       /* one of enum bpf_map_type */
@@ -260,6 +264,7 @@ union bpf_attr {
        struct { /* anonymous struct used by BPF_OBJ_* commands */
                __aligned_u64   pathname;
                __u32           bpf_fd;
+               __u32           file_flags;
        };

        struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH command=
s */

On Thu, Mar 26, 2020 at 7:08 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> I don't get it.  It builds for me.
>
> And it doesn't if I insert an intentional syntax error in the same line,
> so I'm definitely compiling exactly that code.

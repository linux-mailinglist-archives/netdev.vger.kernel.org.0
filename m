Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A89B17C214
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCFPpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:45:54 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36944 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCFPpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:45:54 -0500
Received: by mail-pg1-f193.google.com with SMTP id z12so1256404pgl.4;
        Fri, 06 Mar 2020 07:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=8+Cq7o+IX8QlbPCtLIBM5xMA011gFGmhE4u5xqCeFgA=;
        b=m3Pl0RkyZ4sBExjcOfdCjaoWdZk0E0jVk4qobvM+w0fmoxmovT5L/6DeLP7uRh7dyq
         xKhEJpGxRCP6bUdGxivL1Pimw6AqYWFj04hFgzV4UXWksIEjNHaXgX5MPRfkaTBDmbTu
         or5g2OKRp2T/WcF2WFOCTV24Z+EMzsYEMWcYqSDbX62JnR0sT/hue85eyKWpdaKkCw9v
         lWpZluqhZyuc3p1+il662aii0MGB3BmJnJ0tw6y5wGgdWvDx51aNph5t0j9No1K7/5E2
         qJefBezCfTBUfhcjW2DW+Hm5VndDOhfKCBgCArgS/2YKlL/q/iIf4Rqd56cU62A9muJz
         nMsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=8+Cq7o+IX8QlbPCtLIBM5xMA011gFGmhE4u5xqCeFgA=;
        b=Y8yxtU0nKzHNl8Cjxn2Rv0SqQIl1u+/B50vr2gAUF93L7YIRmhac2eh7Dic4RN83mZ
         UN/cgIAoJQ8/+MR1+L7lTLembDRIlnu2uJ6kqhbdKwj9D2zwdHVf6KTQ5IBxaeKMenny
         VBmTuW5SFtDE+5L/Bpye749E6rWxiOz4qzcGWVNECRlJ02Hxs86WTWo+20gmYOoThlqq
         hockvCLkzQtQwjxTj3QfgVPNRms1/4XsK82lLJaxsDKp9jjjdK2TpMp9nAeppTWn921S
         9+sqqPbn7f7dDLaJDm7W0+8dJuhMnKZfqJtoLBgQqt34MhKjdIYHCEUT8p5p8sNn7QKo
         bzDA==
X-Gm-Message-State: ANhLgQ3nf95FnF/RxLkppd0VgFCz8dtl4sbOxALUfI3o8+5Nm1HEzQ8F
        XGW6fVBhKxf9fOTMZclq2DI=
X-Google-Smtp-Source: ADFU+vt3UyWmn4t2fBZSHJeHSrwKf7APQAbEonMud/SpzI6/L34fwUUBRc1jScwEfgaCaVE3Cai3Zw==
X-Received: by 2002:a63:3d44:: with SMTP id k65mr4017600pga.349.1583509552759;
        Fri, 06 Mar 2020 07:45:52 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m9sm2860602pga.92.2020.03.06.07.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:45:52 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:45:44 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e627028b606b_17502acca07205b440@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-1-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 00/12] bpf: sockmap, sockhash: support storing
 UDP sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Thanks to Jakub's suggestion I was able to eliminate sk_psock_hooks!
> Now TCP and UDP only need to export a single function get_proto,
> which is called from the sockmap code. This reduced the amount of
> boilerplate a bit. The downside is that the IPv6 proto rebuild is
> copied and pasted from TCP, but I think I can live with that.
> 
> Changes since v2:
> - Remove sk_psock_hooks based on Jakub's idea
> - Fix reference to tcp_bpf_clone in commit message
> - Add inet_csk_has_ulp helper
> 
> Changes since v1:
> - Check newsk->sk_prot in tcp_bpf_clone
> - Fix compilation with BPF_STREAM_PARSER disabled
> - Use spin_lock_init instead of static initializer
> - Elaborate on TCPF_SYN_RECV
> - Cosmetic changes to TEST macros, and more tests
> - Add Jakub and me as maintainers
> 
> Jakub Sitnicki (2):
>   bpf: add sockmap hooks for UDP sockets
>   bpf: sockmap: add UDP support
> 
> Lorenz Bauer (10):
>   bpf: sockmap: only check ULP for TCP sockets
>   skmsg: update saved hooks only once
>   bpf: tcp: move assertions into tcp_bpf_get_proto
>   bpf: tcp: guard declarations with CONFIG_NET_SOCK_MSG
>   bpf: sockmap: move generic sockmap hooks from BPF TCP
>   bpf: sockmap: simplify sock_map_init_proto
>   selftests: bpf: don't listen() on UDP sockets
>   selftests: bpf: add tests for UDP sockets in sockmap
>   selftests: bpf: enable UDP sockmap reuseport tests
>   bpf, doc: update maintainers for L7 BPF
> 
>  MAINTAINERS                                   |   3 +
>  include/linux/bpf.h                           |   4 +-
>  include/linux/skmsg.h                         |  56 ++---
>  include/net/tcp.h                             |  20 +-
>  include/net/udp.h                             |   5 +
>  net/core/sock_map.c                           | 158 +++++++++++---
>  net/ipv4/Makefile                             |   1 +
>  net/ipv4/tcp_bpf.c                            | 114 ++--------
>  net/ipv4/udp_bpf.c                            |  53 +++++
>  .../bpf/prog_tests/select_reuseport.c         |   6 -
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 204 +++++++++++++-----
>  11 files changed, 399 insertions(+), 225 deletions(-)
>  create mode 100644 net/ipv4/udp_bpf.c
> 
> -- 
> 2.20.1
> 

Nice series thanks for doing this. I'll drop it into some Cilium CI just
to be sure everything on the sockmap/ktls side is still working but
looks good to me.

I'll try to add send bpf hooks here shortly as well so we get the sendmsg
bpf progs running here as well.

Thanks,
John

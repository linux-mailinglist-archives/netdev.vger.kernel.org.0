Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769461974BB
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgC3Gzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:55:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:43699 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728489AbgC3Gzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585551344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ajoDkbQ/qcpUsEb0QgM4LBFTevZKUmFKbf6Bf6g6uF0=;
        b=gzo/liQunUXkL9jemoiGygokK7h9uY3PGyMsTAHJ8ksUt9wJ6XwQG0Cto8YTLZml2Z5eYS
        uBlBSgu8Ob2QqYBh/Ei9qUPdeFoMbdmo0lGGpbLzwJbvgsmKhPd2niHff3pfS0G9RZctog
        c1EnkXV2qp5msDEUHdG5ISNHRDqJMOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-iQWA9ZThMQWutNgQ2DSbEQ-1; Mon, 30 Mar 2020 02:55:40 -0400
X-MC-Unique: iQWA9ZThMQWutNgQ2DSbEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E550B1005512;
        Mon, 30 Mar 2020 06:55:37 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B32160304;
        Mon, 30 Mar 2020 06:55:31 +0000 (UTC)
Date:   Mon, 30 Mar 2020 08:55:28 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Eric Sage <eric@sage.org>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] samples/bpf: Add xdp_stat sample program
Message-ID: <20200330085528.18e3ca7e@carbon>
In-Reply-To: <20200329231630.41950-1-eric@sage.org>
References: <20200329231630.41950-1-eric@sage.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Mar 2020 16:16:30 -0700
Eric Sage <eric@sage.org> wrote:

[...]
> ---
>  samples/bpf/Makefile          |   3 +
>  samples/bpf/xdp_stat          | Bin 0 -> 200488 bytes

No binary files please.

>  samples/bpf/xdp_stat_common.h |  28 ++
>  samples/bpf/xdp_stat_kern.c   | 192 +++++++++
>  samples/bpf/xdp_stat_user.c   | 748 ++++++++++++++++++++++++++++++++++
>  5 files changed, 971 insertions(+)
>  create mode 100755 samples/bpf/xdp_stat
>  create mode 100644 samples/bpf/xdp_stat_common.h
>  create mode 100644 samples/bpf/xdp_stat_kern.c
>  create mode 100644 samples/bpf/xdp_stat_user.c
> 
[...]
> diff --git a/samples/bpf/xdp_stat b/samples/bpf/xdp_stat
> new file mode 100755
> index 0000000000000000000000000000000000000000..32a05e4e3f804400914d5048bfb602888af00b11
> GIT binary patch
> literal 200488
> zcmeFadw3K@7B}3J3=jqBsGw0%qmFA((L_ZP0nL~h=+TKr0YMQ7h6IpXmdrrB5}XOp
> zHiPlHuInmZ*2O!!A~!Laa7hqvfHxE`5ie9T3aCgxg?ztXb<d<>o%i|v`2P8x=M4|(
> zu2ZL~PMtb+>YP(momu|i;0%{bN&aLgmnlru<rhnk^;=OUbjy@!{wh`qmG1a`s&b0b  
> z6=}DGF^74@hdd`_$fS~dW?4yvwXxhHJAY9|F;Ywy^P%*SzdN5v3i)KY&YxoY)p{1%
> z1(Q!D+sbCSE_}`9FZ|>d%SZC*f5d7b`E-_(?ZvHpCGNG#+0VtRtYq@(EJxl{*ION|  
> ze)tNBn0ywhR=G#*XR;izS#EdCD!2QeR=L#ECS$k#O!AX7^8Z?^7@oyQF<s1u;*-BS
> zpTy-)*>|CFd@t)~6)fv#wU>MbyGt}B`An9(7Uf9i|JxsX7?kVm_R{gC;Yh2-<kRk^
> za{lCrw_JSD`IE=>n>=x9xVB$y;l=$fzUaJ~Y3E%a``ru0C{shO9<H46_opwvV6!Ld  
> z#dVX5&-MIzPFB@tpOJ3T!1{>8AL85WlFv${nJ@b#g~gpgSQY-i_H_F(ML!!!u>|DM
> zpHd``ITR#QZ>NFJL*svj&vE@T_zh{`Z=wT#hJR6-cK@5Ep6k-U{b}H2#Gkc$R2uwa  
> z)6n@#ntFasQ_t8m@X|DJk*3|XY1;i)8vHxbj8~sD_+8TAf0u^N9%<@1FAe;qH1*t@

No binary files please.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


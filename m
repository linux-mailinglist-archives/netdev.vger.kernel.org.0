Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488F01E25E5
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbgEZPqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbgEZPqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:46:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756FC03E96D;
        Tue, 26 May 2020 08:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=f5trgiJH5V/8C2C/LXnwvUAj6Z8CNkwv12V2Vhc+Pn4=; b=B57VcRK1h7jmKgXnMJAs+RL/9Q
        HL21I+jvKaM0Z6V3jxHUi2GruRwLyizy9RoGE8/ZCNHtcadJBRc0z/6UcqFgZsEE/Iz1/A3okBmy/
        dHU9C75GHE2f8cn6DfAioBeoDy2ZVfJtJw1zC5yedsZGJUsjIhiNHLEdbiG6KZ2GF55iy+y+Tq51o
        KnIj6SndpsBmssq20QfWfVtYhKpedxFz1WZ94oG7k0JLgEjKPhjNqUCHXTb4SjVW0cUnOFyyJqAKy
        gC+EcvLdWl1C6dgWEQG6v227zmcgmm9ppKvgC7OZ0xTwvUlhtrpYR1SU52icI5aaLX6NMiag2HBN5
        vQXhQyCQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdbn1-0003Kd-02; Tue, 26 May 2020 15:46:51 +0000
Subject: Re: linux-next: Tree for May 26 (drivers/crypto/chelsio/chcr_ktls.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
References: <20200526203932.732df7c6@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ca9f612e-1cd7-d2b8-d1f0-497ffcbd5de5@infradead.org>
Date:   Tue, 26 May 2020 08:46:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526203932.732df7c6@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 3:39 AM, Stephen Rothwell wrote:
> Hi all,
> 
> News: there will be no linux-next release tomorrow.
> 
> Changes since 20200525:
> 

on i386:

when CONFIG_IPV6 is not set/enabled:


  CC      drivers/crypto/chelsio/chcr_ktls.o
In file included from ../include/linux/tcp.h:19:0,
                 from ../include/net/tls.h:41,
                 from ../drivers/crypto/chelsio/chcr_ktls.h:8,
                 from ../drivers/crypto/chelsio/chcr_ktls.c:6:
../drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_act_open_req6':
../include/net/sock.h:380:37: error: 'struct sock_common' has no member named 'skc_v6_rcv_saddr'; did you mean 'skc_rcv_saddr'?
 #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
                                     ^
../drivers/crypto/chelsio/chcr_ktls.c:257:37: note: in expansion of macro 'sk_v6_rcv_saddr'
  cpl->local_ip_hi = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[0];
                                     ^~~~~~~~~~~~~~~
../include/net/sock.h:380:37: error: 'struct sock_common' has no member named 'skc_v6_rcv_saddr'; did you mean 'skc_rcv_saddr'?
 #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
                                     ^
../drivers/crypto/chelsio/chcr_ktls.c:258:37: note: in expansion of macro 'sk_v6_rcv_saddr'
  cpl->local_ip_lo = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[8];
                                     ^~~~~~~~~~~~~~~
../include/net/sock.h:379:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
 #define sk_v6_daddr  __sk_common.skc_v6_daddr
                                  ^
../drivers/crypto/chelsio/chcr_ktls.c:259:36: note: in expansion of macro 'sk_v6_daddr'
  cpl->peer_ip_hi = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[0];
                                    ^~~~~~~~~~~
../include/net/sock.h:379:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
 #define sk_v6_daddr  __sk_common.skc_v6_daddr
                                  ^
../drivers/crypto/chelsio/chcr_ktls.c:260:36: note: in expansion of macro 'sk_v6_daddr'
  cpl->peer_ip_lo = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[8];
                                    ^~~~~~~~~~~
../drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_setup_connection':
../include/net/sock.h:379:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
 #define sk_v6_daddr  __sk_common.skc_v6_daddr
                                  ^
../drivers/crypto/chelsio/chcr_ktls.c:295:27: note: in expansion of macro 'sk_v6_daddr'
       ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
                           ^~~~~~~~~~~
../include/net/sock.h:380:37: error: 'struct sock_common' has no member named 'skc_v6_rcv_saddr'; did you mean 'skc_rcv_saddr'?
 #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
                                     ^
../drivers/crypto/chelsio/chcr_ktls.c:302:29: note: in expansion of macro 'sk_v6_rcv_saddr'
           (const u32 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8,
                             ^~~~~~~~~~~~~~~
../drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_dev_del':
../include/net/sock.h:379:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
 #define sk_v6_daddr  __sk_common.skc_v6_daddr
                                  ^
../drivers/crypto/chelsio/chcr_ktls.c:400:26: note: in expansion of macro 'sk_v6_daddr'
        (const u32 *)&sk->sk_v6_daddr.in6_u.u6_addr8,
                          ^~~~~~~~~~~
../drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_dev_add':
../include/net/sock.h:379:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
 #define sk_v6_daddr  __sk_common.skc_v6_daddr
                                  ^
../drivers/crypto/chelsio/chcr_ktls.c:494:27: note: in expansion of macro 'sk_v6_daddr'
       ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
                           ^~~~~~~~~~~
In file included from ../arch/x86/include/asm/string.h:3:0,
                 from ../include/linux/string.h:20,
                 from ../arch/x86/include/asm/page_32.h:35,
                 from ../arch/x86/include/asm/page.h:14,
                 from ../arch/x86/include/asm/thread_info.h:12,
                 from ../include/linux/thread_info.h:38,
                 from ../arch/x86/include/asm/preempt.h:7,
                 from ../include/linux/preempt.h:78,
                 from ../include/linux/spinlock.h:51,
                 from ../include/linux/wait.h:9,
                 from ../include/linux/wait_bit.h:8,
                 from ../include/linux/fs.h:6,
                 from ../include/linux/highmem.h:5,
                 from ../drivers/crypto/chelsio/chcr_ktls.c:5:
../include/net/sock.h:379:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
 #define sk_v6_daddr  __sk_common.skc_v6_daddr
                                  ^
../arch/x86/include/asm/string_32.h:182:45: note: in definition of macro 'memcpy'
 #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
                                             ^
../drivers/crypto/chelsio/chcr_ktls.c:497:22: note: in expansion of macro 'sk_v6_daddr'
   memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
                      ^~~~~~~~~~~


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64515F7EE9
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 22:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiJGUf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 16:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJGUfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 16:35:25 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42117199A
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 13:35:13 -0700 (PDT)
Received: (qmail 32597 invoked from network); 7 Oct 2022 20:34:46 -0000
Received: from p200300cf07391f0080daf588667072be.dip0.t-ipconnect.de ([2003:cf:739:1f00:80da:f588:6670:72be]:43536 HELO daneel.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <linux-kernel@vger.kernel.org>; Fri, 07 Oct 2022 22:34:46 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Jason@zx2c4.com, andreas.noever@gmail.com,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bp@alien8.de, catalin.marinas@arm.com,
        christoph.boehmwalder@linbit.com, hch@lst.de,
        christophe.leroy@csgroup.eu, daniel@iogearbox.net,
        airlied@redhat.com, dave.hansen@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        gregkh@linuxfoundation.org, hpa@zytor.com, hca@linux.ibm.com,
        deller@gmx.de, herbert@gondor.apana.org.au, chenhuacai@kernel.org,
        hughd@google.com, kuba@kernel.org, jejb@linux.ibm.com,
        jack@suse.com, jgg@ziepe.ca, axboe@kernel.dk,
        johannes@sipsolutions.net, corbet@lwn.net, kadlec@netfilter.org,
        kpsingh@kernel.org, keescook@chromium.org, elver@google.com,
        mchehab@kernel.org, mpe@ellerman.id.au, pablo@netfilter.org,
        pabeni@redhat.com, peterz@infradead.org, richard@nod.at,
        linux@armlinux.org.uk
Cc:     tytso@mit.edu, tsbogend@alpha.franken.de, tglx@linutronix.de,
        tgraf@suug.ch, ulf.hansson@linaro.org, vigneshr@ti.com,
        kernel@xen0n.name, will@kernel.org, yury.norov@gmail.com,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        loongarch@lists.linux.dev, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org, toke@toke.dk,
        chuck.lever@oracle.com, jack@suse.cz,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH v4 4/6] treewide: use get_random_u32() when possible
Date:   Fri, 07 Oct 2022 22:34:47 +0200
Message-ID: <3216619.44csPzL39Z@daneel.sf-tec.de>
In-Reply-To: <20221007180107.216067-5-Jason@zx2c4.com>
References: <20221007180107.216067-1-Jason@zx2c4.com> <20221007180107.216067-5-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8143310.T7Z3S40VBb"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart8143310.T7Z3S40VBb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Fri, 07 Oct 2022 22:34:47 +0200
Message-ID: <3216619.44csPzL39Z@daneel.sf-tec.de>
In-Reply-To: <20221007180107.216067-5-Jason@zx2c4.com>

> diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
> index 7c37e09c92da..18c4f0e3e906 100644
> --- a/arch/parisc/kernel/process.c
> +++ b/arch/parisc/kernel/process.c
> @@ -288,7 +288,7 @@ __get_wchan(struct task_struct *p)
> 
>  static inline unsigned long brk_rnd(void)
>  {
> -	return (get_random_int() & BRK_RND_MASK) << PAGE_SHIFT;
> +	return (get_random_u32() & BRK_RND_MASK) << PAGE_SHIFT;
>  }

Can't this be

  prandom_u32_max(BRK_RND_MASK + 1) << PAGE_SHIFT

? More similar code with other masks follows below.

> diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c
> b/drivers/gpu/drm/i915/i915_gem_gtt.c index 329ff75b80b9..7bd1861ddbdf
> 100644
> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> @@ -137,12 +137,12 @@ static u64 random_offset(u64 start, u64 end, u64 len,
> u64 align) range = round_down(end - len, align) - round_up(start, align);
>  	if (range) {
>  		if (sizeof(unsigned long) == sizeof(u64)) {
> -			addr = get_random_long();
> +			addr = get_random_u64();
>  		} else {
> -			addr = get_random_int();
> +			addr = get_random_u32();
>  			if (range > U32_MAX) {
>  				addr <<= 32;
> -				addr |= get_random_int();
> +				addr |= get_random_u32();
>  			}
>  		}
>  		div64_u64_rem(addr, range, &addr);

How about 

 		if (sizeof(unsigned long) == sizeof(u64) || range > 
U32_MAX)
			addr = get_random_u64();
 		else
			addr = get_random_u32();

> diff --git a/drivers/infiniband/hw/cxgb4/cm.c
> b/drivers/infiniband/hw/cxgb4/cm.c index 14392c942f49..499a425a3379 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -734,7 +734,7 @@ static int send_connect(struct c4iw_ep *ep)
>  				   &ep->com.remote_addr;
>  	int ret;
>  	enum chip_type adapter_type = ep->com.dev->rdev.lldi.adapter_type;
> -	u32 isn = (prandom_u32() & ~7UL) - 1;
> +	u32 isn = (get_random_u32() & ~7UL) - 1;
>  	struct net_device *netdev;
>  	u64 params;
> 
> @@ -2469,7 +2469,7 @@ static int accept_cr(struct c4iw_ep *ep, struct
> sk_buff *skb, }
> 
>  	if (!is_t4(adapter_type)) {
> -		u32 isn = (prandom_u32() & ~7UL) - 1;
> +		u32 isn = (get_random_u32() & ~7UL) - 1;

u32 isn = get_random_u32() | 0x7;

Same code comes later again.

> diff --git a/drivers/mtd/nand/raw/nandsim.c b/drivers/mtd/nand/raw/nandsim.c
> index 50bcf745e816..4bdaf4aa7007 100644
> --- a/drivers/mtd/nand/raw/nandsim.c
> +++ b/drivers/mtd/nand/raw/nandsim.c
> @@ -1402,7 +1402,7 @@ static int ns_do_read_error(struct nandsim *ns, int
> num)
> 
>  static void ns_do_bit_flips(struct nandsim *ns, int num)
>  {
> -	if (bitflips && prandom_u32() < (1 << 22)) {
> +	if (bitflips && get_random_u32() < (1 << 22)) {

Doing "get_random_u16() < (1 << 6)" should have the same probability with only 
2 bytes of random, no?

> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c index
> ac452a0111a9..b71ce6c5b512 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> @@ -1063,7 +1063,7 @@ static void chtls_pass_accept_rpl(struct sk_buff *skb,
> opt2 |= WND_SCALE_EN_V(WSCALE_OK(tp));
>  	rpl5->opt0 = cpu_to_be64(opt0);
>  	rpl5->opt2 = cpu_to_be32(opt2);
> -	rpl5->iss = cpu_to_be32((prandom_u32() & ~7UL) - 1);
> +	rpl5->iss = cpu_to_be32((get_random_u32() & ~7UL) - 1);
>  	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->port_id);
>  	t4_set_arp_err_handler(skb, sk, chtls_accept_rpl_arp_failure);
>  	cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
> diff --git a/drivers/net/ethernet/rocker/rocker_main.c
> b/drivers/net/ethernet/rocker/rocker_main.c index
> fc83ec23bd1d..8c3bbafabb07 100644
> --- a/drivers/net/ethernet/rocker/rocker_main.c
> +++ b/drivers/net/ethernet/rocker/rocker_main.c
> @@ -139,9 +139,9 @@ static int rocker_reg_test(const struct rocker *rocker)
>  		return -EIO;
>  	}
> 
> -	rnd = prandom_u32();
> +	rnd = get_random_u32();
>  	rnd <<= 31;
> -	rnd |= prandom_u32();
> +	rnd |= get_random_u32();

>  	rocker_write64(rocker, TEST_REG64, rnd);
>  	test_reg = rocker_read64(rocker, TEST_REG64);
>  	if (test_reg != rnd * 2) {
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c index
> fabfbb0b40b0..374e1cc07a63 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> @@ -177,7 +177,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp,
> struct brcmf_pno_info *pi) memcpy(pfn_mac.mac, mac_addr, ETH_ALEN);
>  	for (i = 0; i < ETH_ALEN; i++) {
>  		pfn_mac.mac[i] &= mac_mask[i];
> -		pfn_mac.mac[i] |= get_random_int() & ~(mac_mask[i]);
> +		pfn_mac.mac[i] |= get_random_u32() & ~(mac_mask[i]);

> diff --git a/lib/reed_solomon/test_rslib.c b/lib/reed_solomon/test_rslib.c
> index 4d241bdc88aa..848e7eb5da92 100644
> --- a/lib/reed_solomon/test_rslib.c
> +++ b/lib/reed_solomon/test_rslib.c
> @@ -164,7 +164,7 @@ static int get_rcw_we(struct rs_control *rs, struct
> wspace *ws,
> 
>  	/* Load c with random data and encode */
>  	for (i = 0; i < dlen; i++)
> -		c[i] = prandom_u32() & nn;
> +		c[i] = get_random_u32() & nn;

> @@ -178,7 +178,7 @@ static int get_rcw_we(struct rs_control *rs, struct
> wspace *ws, for (i = 0; i < errs; i++) {
>  		do {
>  			/* Error value must be nonzero */
> -			errval = prandom_u32() & nn;
> +			errval = get_random_u32() & nn;
>  		} while (errval == 0);

> @@ -206,7 +206,7 @@ static int get_rcw_we(struct rs_control *rs, struct
> wspace *ws, /* Erasure with corrupted symbol */
>  			do {
>  				/* Error value must be nonzero */
> -				errval = prandom_u32() & nn;
> +				errval = get_random_u32() & nn;
>  			} while (errval == 0);
> 

> diff --git a/lib/test_fprobe.c b/lib/test_fprobe.c
> index ed70637a2ffa..e0381b3ec410 100644
> --- a/lib/test_fprobe.c
> +++ b/lib/test_fprobe.c
> @@ -145,7 +145,7 @@ static unsigned long get_ftrace_location(void *func)
>  static int fprobe_test_init(struct kunit *test)
>  {
>  	do {
> -		rand1 = prandom_u32();
> +		rand1 = get_random_u32();
>  	} while (rand1 <= div_factor);

> diff --git a/lib/test_kprobes.c b/lib/test_kprobes.c
> index a5edc2ebc947..eeb1d728d974 100644
> --- a/lib/test_kprobes.c
> +++ b/lib/test_kprobes.c
> @@ -341,7 +341,7 @@ static int kprobes_test_init(struct kunit *test)
>  	stacktrace_driver = kprobe_stacktrace_driver;
> 
>  	do {
> -		rand1 = prandom_u32();
> +		rand1 = get_random_u32();
>  	} while (rand1 <= div_factor);
>  	return 0;
>  }

> diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
> index 5a1dd4736b56..b358a74ed7ed 100644
> --- a/lib/test_rhashtable.c
> +++ b/lib/test_rhashtable.c
> @@ -291,7 +291,7 @@ static int __init test_rhltable(unsigned int entries)
>  	if (WARN_ON(err))
>  		goto out_free;
> 
> -	k = prandom_u32();
> +	k = get_random_u32();
>  	ret = 0;
>  	for (i = 0; i < entries; i++) {
>  		rhl_test_objects[i].value.id = k;
> @@ -369,12 +369,12 @@ static int __init test_rhltable(unsigned int entries)
>  	pr_info("test %d random rhlist add/delete operations\n", entries);
>  	for (j = 0; j < entries; j++) {
>  		u32 i = prandom_u32_max(entries);
> -		u32 prand = prandom_u32();
> +		u32 prand = get_random_u32();
> 
>  		cond_resched();
> 
>  		if (prand == 0)
> -			prand = prandom_u32();
> +			prand = get_random_u32();
> 
>  		if (prand & 1) {
>  			prand >>= 1;

> diff --git a/net/ipv4/tcp_cdg.c b/net/ipv4/tcp_cdg.c
> index ddc7ba0554bd..efcd145f06db 100644
> --- a/net/ipv4/tcp_cdg.c
> +++ b/net/ipv4/tcp_cdg.c
> @@ -243,7 +243,7 @@ static bool tcp_cdg_backoff(struct sock *sk, u32 grad)
>  	struct cdg *ca = inet_csk_ca(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
> 
> -	if (prandom_u32() <= nexp_u32(grad * backoff_factor))
> +	if (get_random_u32() <= nexp_u32(grad * backoff_factor))
>  		return false;
> 
>  	if (use_ineff) {

> diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
> index ceb85c67ce39..18481eb76a0a 100644
> --- a/net/ipv6/ip6_flowlabel.c
> +++ b/net/ipv6/ip6_flowlabel.c
> @@ -220,7 +220,7 @@ static struct ip6_flowlabel *fl_intern(struct net *net,
>  	spin_lock_bh(&ip6_fl_lock);
>  	if (label == 0) {
>  		for (;;) {
> -			fl->label = 
htonl(prandom_u32())&IPV6_FLOWLABEL_MASK;
> +			fl->label = 
htonl(get_random_u32())&IPV6_FLOWLABEL_MASK;
>  			if (fl->label) {
>  				lfl = __fl_lookup(net, fl-
>label);
>  				if (!lfl)

> diff --git a/net/netfilter/ipvs/ip_vs_conn.c
> b/net/netfilter/ipvs/ip_vs_conn.c index fb67f1ca2495..8c04bb57dd6f 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1308,7 +1308,7 @@ void ip_vs_random_dropentry(struct netns_ipvs *ipvs)
>  	 * Randomly scan 1/32 of the whole table every second
>  	 */
>  	for (idx = 0; idx < (ip_vs_conn_tab_size>>5); idx++) {
> -		unsigned int hash = prandom_u32() & 
ip_vs_conn_tab_mask;
> +		unsigned int hash = get_random_u32() & 
ip_vs_conn_tab_mask;
> 
>  		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[hash], 
c_list) {
>  			if (cp->ipvs != ipvs)

> diff --git a/net/rds/bind.c b/net/rds/bind.c
> index 5b5fb4ca8d3e..052776ddcc34 100644
> --- a/net/rds/bind.c
> +++ b/net/rds/bind.c
> @@ -104,7 +104,7 @@ static int rds_add_bound(struct rds_sock *rs, const
> struct in6_addr *addr, return -EINVAL;
>  		last = rover;
>  	} else {
> -		rover = max_t(u16, prandom_u32(), 2);
> +		rover = max_t(u16, get_random_u32(), 2);
>  		last = rover - 1;
>  	}

> diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c
> b/net/sunrpc/auth_gss/gss_krb5_wrap.c index 5f96e75f9eec..48337687848c
> 100644
> --- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
> +++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
> @@ -130,8 +130,8 @@ gss_krb5_make_confounder(char *p, u32 conflen)
> 
>  	/* initialize to random value */
>  	if (i == 0) {
> -		i = prandom_u32();
> -		i = (i << 32) | prandom_u32();
> +		i = get_random_u32();
> +		i = (i << 32) | get_random_u32();
>  	}

--nextPart8143310.T7Z3S40VBb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCY0CNZwAKCRBcpIk+abn8
TrpgAJ4nsyVCsxjHWfs+evNVPSQ5uTLV5QCdGcxIX2E4WNsbKxKWHgs2EVSpciI=
=UYR+
-----END PGP SIGNATURE-----

--nextPart8143310.T7Z3S40VBb--




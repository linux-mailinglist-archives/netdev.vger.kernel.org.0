Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9E1229819
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgGVMRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgGVMRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 08:17:09 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7E7C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:17:09 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j11so2234693ljo.7
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=KDQ7v8Cm4abDVKMKnlWuLlGXPImMSg6jDl7cdiUj9Es=;
        b=oE8lvE0uOlHhdoKbqZt4B/mSaexsfTZjIGuTTMKkKvn5vup8rXuK4c7zueH8pe3JeR
         jUYubcAqubDo8qb9ovRyFu3c4O/KkA7eZoY6HMIAL1YkepkMcPW0O3ZSRxVaSXVTTCHF
         z5EWOQKgREPDKF79pmpPL8jzchj2DL6xnE5kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=KDQ7v8Cm4abDVKMKnlWuLlGXPImMSg6jDl7cdiUj9Es=;
        b=ZCGS3KdW9KRyR1uLkCDFgiRTSCj6o5LATtr5tXGUniap7L7XBLDtR+7m487EOxxRd0
         RFoW+sUdCc13AXZP3fFOQiG0LPEWD0MnkRCj8osl8QLxa9gEvm44PcJp3kotud5K2Vvo
         rDXCtau0zVWbRCQAW7nA+4Onyp1NN6iqrczsF1o3RRThaGo6RnLe2mSUhEpOh+ROUVxz
         oIw501Od+jkTh2i/kpq2zsUFEFNbnwcXs3xGrtw17xuIJQeYPDrbM0MhIYJwhNEikYpV
         UwlwHz+/dQ97BXQ2dRAjmnou4NHf/GeEjwUzt0HDyM6bu5xQ54HtEEN7NRgPHy4djaw1
         s9DA==
X-Gm-Message-State: AOAM531FiZXwIOmdG//IGZBYLa4H79k+09p4JwbM/lYU+0puFOZ7qDiQ
        ZSM9KmTGarpqPx+HI/TKZBnp2USFfCw=
X-Google-Smtp-Source: ABdhPJxGQlT+m2wmcUpDcQT+EirYFTNer4xuc5FN0GY49qhvhgWmJpcFl1SyCfUKE0RHTxHsIrahbA==
X-Received: by 2002:a2e:5cc6:: with SMTP id q189mr13982642ljb.251.1595420226553;
        Wed, 22 Jul 2020 05:17:06 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y1sm4945185lfb.45.2020.07.22.05.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 05:17:05 -0700 (PDT)
References: <20200722132143.700a5ccc@canb.auug.org.au>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        kernel-team@cloudflare.com, Willem de Bruijn <willemb@google.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net tree
In-reply-to: <20200722132143.700a5ccc@canb.auug.org.au>
Date:   Wed, 22 Jul 2020 14:17:05 +0200
Message-ID: <87wo2vwxq6.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 05:21 AM CEST, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the bpf-next tree got conflicts in:
>
>   net/ipv4/udp.c
>   net/ipv6/udp.c
>
> between commit:
>
>   efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
>
> from the net tree and commits:
>
>   7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
>   2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")
>
> from the bpf-next tree.
>
> I fixed it up (I wasn't sure how to proceed, so I used the latter
> version) and can carry the fix as necessary. This is now fixed as far
> as linux-next is concerned, but any non trivial conflicts should be
> mentioned to your upstream maintainer when your tree is submitted for
> merging.  You may also want to consider cooperating with the maintainer
> of the conflicting tree to minimise any particularly complex conflicts.

This one is a bit tricky.

Looking at how code in udp[46]_lib_lookup2 evolved, first:

  acdcecc61285 ("udp: correct reuseport selection with connected sockets")

1) exluded connected UDP sockets from reuseport group during lookup, and
2) limited fast reuseport return to groups with no connected sockets,

The second change had an uninteded side-effect of discarding reuseport
socket selection when reuseport group contained connected sockets.

Then, recent

  efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")

rectified it by recording reuseport socket selection as lookup result
candidate, in case fast reuseport return did not happen because
reuseport group had connected sockets.

I belive that changes in commit efc6b6f6c311 can be rewritten as below
to the same effect, by realizing that we are always setting the 'result'
if 'score > badness'. Either to what reuseport_select_sock() returned or
to 'sk' that scored higher than current 'badness' threshold.

---8<---
static struct sock *udp4_lib_lookup2(struct net *net,
				     __be32 saddr, __be16 sport,
				     __be32 daddr, unsigned int hnum,
				     int dif, int sdif,
				     struct udp_hslot *hslot2,
				     struct sk_buff *skb)
{
	struct sock *sk, *result;
	int score, badness;
	u32 hash = 0;

	result = NULL;
	badness = 0;
	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
		score = compute_score(sk, net, saddr, sport,
				      daddr, hnum, dif, sdif);
		if (score > badness) {
			result = NULL;
			if (sk->sk_reuseport &&
			    sk->sk_state != TCP_ESTABLISHED) {
				hash = udp_ehashfn(net, daddr, hnum,
						   saddr, sport);
				result = reuseport_select_sock(sk, hash, skb,
							       sizeof(struct udphdr));
				if (result && !reuseport_has_conns(sk, false))
					return result;
			}
			if (!result)
				result = sk;
			badness = score;
		}
	}
	return result;
}
---8<---

From there, it is now easier to resolve the conflict with

  7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
  2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")

which extract the 'if (sk->sk_reuseport && sk->sk_state !=
TCP_ESTABLISHED)' block into a helper called lookup_reuseport().

To merge the two, we need to pull the reuseport_has_conns() check up
from lookup_reuseport() and back into udp[46]_lib_lookup2(), because now
we want to record reuseport socket selection even if reuseport group has
connections.

The only other call site of lookup_reuseport() is in
udp[46]_lookup_run_bpf(). We don't want to discard the reuseport
selected socket if group has connections there either, so no changes are
needed. And, now that I think about it, the current behavior in
udp[46]_lookup_run_bpf() is not right.

The end result for udp4 will look like:

---8<---
static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
					    struct sk_buff *skb,
					    __be32 saddr, __be16 sport,
					    __be32 daddr, unsigned short hnum)
{
	struct sock *reuse_sk = NULL;
	u32 hash;

	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
		hash = udp_ehashfn(net, daddr, hnum, saddr, sport);
		reuse_sk = reuseport_select_sock(sk, hash, skb,
						 sizeof(struct udphdr));
	}
	return reuse_sk;
}

/* called with rcu_read_lock() */
static struct sock *udp4_lib_lookup2(struct net *net,
				     __be32 saddr, __be16 sport,
				     __be32 daddr, unsigned int hnum,
				     int dif, int sdif,
				     struct udp_hslot *hslot2,
				     struct sk_buff *skb)
{
	struct sock *sk, *result;
	int score, badness;

	result = NULL;
	badness = 0;
	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
		score = compute_score(sk, net, saddr, sport,
				      daddr, hnum, dif, sdif);
		if (score > badness) {
			result = lookup_reuseport(net, sk, skb,
						  saddr, sport, daddr, hnum);
			if (result && !reuseport_has_conns(sk, false))
				return result;
			if (!result)
				result = sk;
			badness = score;
		}
	}
	return result;
}
---8<---

I will submit a patch that pulls the reuseport_has_conns() check from
lookup_reuseport() to bpf-next. That should bring the two sides of the
merge closer. Please let me know if I can help in any other way.

Also, please take a look at the 3-way diff below from my attempt to
merge net tree into bpf-next tree taking the described approach.

Thanks,
-jkbs

--
diff --cc net/ipv4/udp.c
index b738c63d7a77,4077d589b72e..f5297ea376de
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@@ -408,25 -408,6 +408,22 @@@ static u32 udp_ehashfn(const struct ne
  			      udp_ehash_secret + net_hash_mix(net));
  }

 +static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 +					    struct sk_buff *skb,
 +					    __be32 saddr, __be16 sport,
 +					    __be32 daddr, unsigned short hnum)
 +{
 +	struct sock *reuse_sk = NULL;
 +	u32 hash;
 +
 +	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
 +		hash = udp_ehashfn(net, daddr, hnum, saddr, sport);
 +		reuse_sk = reuseport_select_sock(sk, hash, skb,
 +						 sizeof(struct udphdr));
- 		/* Fall back to scoring if group has connections */
- 		if (reuseport_has_conns(sk, false))
- 			return NULL;
 +	}
 +	return reuse_sk;
 +}
 +
  /* called with rcu_read_lock() */
  static struct sock *udp4_lib_lookup2(struct net *net,
  				     __be32 saddr, __be16 sport,
@@@ -444,13 -426,20 +441,13 @@@
  		score = compute_score(sk, net, saddr, sport,
  				      daddr, hnum, dif, sdif);
  		if (score > badness) {
 -			reuseport_result = NULL;
 -
 -			if (sk->sk_reuseport &&
 -			    sk->sk_state != TCP_ESTABLISHED) {
 -				hash = udp_ehashfn(net, daddr, hnum,
 -						   saddr, sport);
 -				reuseport_result = reuseport_select_sock(sk, hash, skb,
 -									 sizeof(struct udphdr));
 -				if (reuseport_result && !reuseport_has_conns(sk, false))
 -					return reuseport_result;
 -			}
 -
 -			result = reuseport_result ? : sk;
 +			result = lookup_reuseport(net, sk, skb,
 +						  saddr, sport, daddr, hnum);
- 			if (result)
++			if (result && !reuseport_has_conns(sk, false))
 +				return result;
-
++			if (!result)
++				result = sk;
  			badness = score;
- 			result = sk;
  		}
  	}
  	return result;
diff --cc net/ipv6/udp.c
index ff8be202726a,a8d74f44056a..ca50fcdf0776
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@@ -141,27 -141,6 +141,24 @@@ static int compute_score(struct sock *s
  	return score;
  }

 +static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 +					    struct sk_buff *skb,
 +					    const struct in6_addr *saddr,
 +					    __be16 sport,
 +					    const struct in6_addr *daddr,
 +					    unsigned int hnum)
 +{
 +	struct sock *reuse_sk = NULL;
 +	u32 hash;
 +
 +	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
 +		hash = udp6_ehashfn(net, daddr, hnum, saddr, sport);
 +		reuse_sk = reuseport_select_sock(sk, hash, skb,
 +						 sizeof(struct udphdr));
- 		/* Fall back to scoring if group has connections */
- 		if (reuseport_has_conns(sk, false))
- 			return NULL;
 +	}
 +	return reuse_sk;
 +}
 +
  /* called with rcu_read_lock() */
  static struct sock *udp6_lib_lookup2(struct net *net,
  		const struct in6_addr *saddr, __be16 sport,
@@@ -178,12 -158,20 +175,12 @@@
  		score = compute_score(sk, net, saddr, sport,
  				      daddr, hnum, dif, sdif);
  		if (score > badness) {
 -			reuseport_result = NULL;
 -
 -			if (sk->sk_reuseport &&
 -			    sk->sk_state != TCP_ESTABLISHED) {
 -				hash = udp6_ehashfn(net, daddr, hnum,
 -						    saddr, sport);
 -
 -				reuseport_result = reuseport_select_sock(sk, hash, skb,
 -									 sizeof(struct udphdr));
 -				if (reuseport_result && !reuseport_has_conns(sk, false))
 -					return reuseport_result;
 -			}
 -
 -			result = reuseport_result ? : sk;
 +			result = lookup_reuseport(net, sk, skb,
 +						  saddr, sport, daddr, hnum);
- 			if (result)
++			if (result && !reuseport_has_conns(sk, false))
 +				return result;
-
- 			result = sk;
++			if (!result)
++				result = sk;
  			badness = score;
  		}
  	}

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D53E27F79E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgJAB7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJAB7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 21:59:16 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A388AC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 18:59:16 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v8so4900333iom.6
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 18:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=kABIIXNeaR55vgNnSiuxyCpxJ1MHBLC6ZtmLXoyxw0Y=;
        b=A1uwCo3GDegHPi33zU97r/HuAUX6OVD4YLsGXNHRTRNh8v3CpVBBZMcozqCn7k8QEl
         F7iX0tjZXNITizXTXFn3YPLWXwPsFGo91B/6GFEcX4SG/yH06iZCwgZ7tpXLx5Hpx8Ee
         vIAsUtU4Y7GCimaTxh+lhXUtRXyQwmpPE3TlKevWCA1d1l1IN/kjToqRLH9epjOCdmme
         yTyz+5C0FSraD99rlDwSOovebuHugBqwUlfv7rPiPd8M0cyQtWgYOZ6texMATzqk0ClU
         ga5bsXElFPyR56yambaFHc1MuxisjBkyCxTu0LyicpC0kcro7Ehbvw/ImTvkbeqifPRn
         xPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=kABIIXNeaR55vgNnSiuxyCpxJ1MHBLC6ZtmLXoyxw0Y=;
        b=fAZ3h/yxT2aToYbIFddPOlcze6cTS9V5ez/k87v76H547vDAYolmCPFw1s+cs3X5pT
         8IHbdmeqW20RlA8gJMh9PpPaIzbOZ2RIT0HM5s20fDDOKRapBzoRy7f5v0sul4rYEZ3j
         qhbHGeuH2WSDhM9dINdHg07Wrfu/z+OFEwwDcHoRv7sKmqi2ki4tJENCM1tPTUf37HSc
         vsvj6C49W49MehUMV1aMVONgVmvyk3tXFRdvIndFz4ny6deeZkzLseoOYH/oKd6T8znD
         +jQEtGLvP9z/NNQLZz6TteIrY6dGelqbR7POhDBpuV30hh5V2zXnTD68EqhYj71PGXQd
         hVdA==
X-Gm-Message-State: AOAM533LPsuv7JHIQHEpDtr01fSGr0cCjkBZPyvju424Ov4BOcMW92B4
        HwkVzBWyUNV6JTIRXpM9Mwg=
X-Google-Smtp-Source: ABdhPJxvJ5K5PLTQ82Q/7gQTujqtC9mOgd06GQE+JzoZe0U/jwvvhqYQpkX6k+COLFeyU9sDwqpPVg==
X-Received: by 2002:a05:6602:22cf:: with SMTP id e15mr3667161ioe.114.1601517555915;
        Wed, 30 Sep 2020 18:59:15 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r15sm1932484ilt.71.2020.09.30.18.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:59:15 -0700 (PDT)
Date:   Wed, 30 Sep 2020 18:59:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        lmb@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Message-ID: <5f7537e9802fb_364f82081e@john-XPS-13-9370.notmuch>
In-Reply-To: <87eemjtwqd.fsf@cloudflare.com>
References: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
 <160109442512.6363.1622656051946413257.stgit@john-Precision-5820-Tower>
 <87eemjtwqd.fsf@cloudflare.com>
Subject: Re: [bpf-next PATCH 1/2] bpf, sockmap: add skb_adjust_room to pop
 bytes off ingress payload
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sat, Sep 26, 2020 at 06:27 AM CEST, John Fastabend wrote:
> > This implements a new helper skb_adjust_room() so users can push/pop
> > extra bytes from a BPF_SK_SKB_STREAM_VERDICT program.
> >
> > Some protocols may include headers and other information that we may
> > not want to include when doing a redirect from a BPF_SK_SKB_STREAM_VE=
RDICT
> > program. One use case is to redirect TLS packets into a receive socke=
t
> > that doesn't expect TLS data. In TLS case the first 13B or so contain=
 the
> > protocol header. With KTLS the payload is decrypted so we should be a=
ble
> > to redirect this to a receiving socket, but the receiving socket may =
not
> > be expecting to receive a TLS header and discard the data. Using the
> > above helper we can pop the header off and put an appropriate header =
on
> > the payload. This allows for creating a proxy between protocols witho=
ut
> > extra hops through the stack or userspace.
> =

> This is useful stuff. Apart from the TLS use-case, you might want to po=
p
> off proxy headers like PROXY v1/v2 (CC Marek):
> =

>   https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt

Great!

> =

> >
> > So in order to fix this case add skb_adjust_room() so users can strip=
 the
> > header. After this the user can strip the header and an unmodified re=
ceiver
> > thread will work correctly when data is redirected into the ingress p=
ath
> > of a sock.
> >
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/filter.c |   51 +++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  1 file changed, 51 insertions(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 4d8dc7a31a78..d232358f1dcd 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -76,6 +76,7 @@
> >  #include <net/bpf_sk_storage.h>
> >  #include <net/transp_v6.h>
> >  #include <linux/btf_ids.h>
> > +#include <net/tls.h>
> >
> >  static const struct bpf_func_proto *
> >  bpf_sk_base_func_proto(enum bpf_func_id func_id);
> > @@ -3218,6 +3219,53 @@ static u32 __bpf_skb_max_len(const struct sk_b=
uff *skb)
> >  			  SKB_MAX_ALLOC;
> >  }
> >
> > +BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,=

> > +	   u32, mode, u64, flags)
> > +{
> > +	unsigned int len_diff_abs =3D abs(len_diff);
> > +	bool shrink =3D len_diff < 0;
> > +	int ret =3D 0;
> > +
> > +	if (unlikely(flags))
> > +		return -EINVAL;
> > +	if (unlikely(len_diff_abs > 0xfffU))
> > +		return -EFAULT;
> > +
> > +	if (!shrink) {
> > +		unsigned int grow =3D len_diff;
> > +
> > +		ret =3D skb_cow(skb, grow);
> > +		if (likely(!ret)) {
> > +			__skb_push(skb, len_diff_abs);
> > +			memset(skb->data, 0, len_diff_abs);
> > +		}
> > +	} else {
> > +		/* skb_ensure_writable() is not needed here, as we're
> > +		 * already working on an uncloned skb.
> > +		 */
> =

> I'm trying to digest the above comment. What if:

I'll delete the comment its not accurate. We happily write headers
from verdict programs today. Do you have a specific concern or
just noticing I was a bit careless and cut'n'pasted an incorrect
comment around.

> =

> static int __strp_recv(=E2=80=A6)
> {
>         =E2=80=A6
> 	while (eaten < orig_len) {
> 		/* Always clone since we will consume something */
> 		skb =3D skb_clone(orig_skb, GFP_ATOMIC);
>                 =E2=80=A6
> 		head =3D strp->skb_head;
> 		if (!head) {
> 			head =3D skb;
>                         =E2=80=A6
> 		} else {
>                         =E2=80=A6
> 		}
>                 =E2=80=A6
> 		/* Give skb to upper layer */
> 		strp->cb.rcv_msg(strp, head); // =E2=86=92 sk_psock_init_strp
>                 =E2=80=A6
> 	}
>         =E2=80=A6
> }
> =

> That looks like a code path where we pass a cloned SKB.

Right but its there to cover the sk_eat_skb in tcp_read_sock()
otherwise

 sk_eat_skb() -> __kfree_skb() -> skb_release_all()

would go all the way to page_frag_free().

> =

> > +		if (unlikely(!pskb_may_pull(skb, len_diff_abs)))
> > +			return -ENOMEM;
> > +		__skb_pull(skb, len_diff_abs);
> > +	}
> > +	bpf_compute_data_end_sk_skb(skb);
> > +	if (tls_sw_has_ctx_rx(skb->sk)) {
> > +		struct strp_msg *rxm =3D strp_msg(skb);
> > +
> > +		rxm->full_len +=3D len_diff;
> > +	}
> > +	return ret;
> > +}
> =

> [...]=

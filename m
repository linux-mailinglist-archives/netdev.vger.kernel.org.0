Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E81330B48F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhBBBSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:18:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21512 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhBBBSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 20:18:35 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210202011750epoutp034fef7e05b27510bf86c19bf97d1fd0c3~fyW8Higmb0314003140epoutp03O
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 01:17:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210202011750epoutp034fef7e05b27510bf86c19bf97d1fd0c3~fyW8Higmb0314003140epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612228670;
        bh=i5rADIZ0Sj9wrKQNewc1LdBisv/3fefoGp/S9dd+tMg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=LLaHMoDhHIAukChdgyxQIXinMarjXkptkFflN3u9i2Ef1UY2NABlsM55/jAApaT2u
         iU4gakDEIUXoFbDfFTt0d1nyTmKDeFSt9xVO3UGft9IF16kGE9vuQbc07Sn5KRKnVn
         JrcbyX1DNy2VlNrvkElimzxftpgWBVP7bUrNyyh4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210202011749epcas2p3d66e8c65e040f9d6d38468e97dd46745~fyW7mA8fD3022530225epcas2p3v;
        Tue,  2 Feb 2021 01:17:49 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DV6PR2Phyz4x9QF; Tue,  2 Feb
        2021 01:17:47 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.69.56312.B38A8106; Tue,  2 Feb 2021 10:17:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210202011746epcas2p2a58b8b98e06879185dbf469312e8703a~fyW4vqdF03223432234epcas2p2Y;
        Tue,  2 Feb 2021 01:17:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210202011746epsmtrp1bef97ea754c72a067e4eb6fe627dfa09~fyW4ukgAq0897208972epsmtrp1h;
        Tue,  2 Feb 2021 01:17:46 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-4b-6018a83b6b26
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.8E.13470.A38A8106; Tue,  2 Feb 2021 10:17:46 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210202011746epsmtip154393722742c3b8029f2ed718dfe39d2~fyW4azFO91746717467epsmtip1T;
        Tue,  2 Feb 2021 01:17:46 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Alexander Lobakin'" <alobakin@pm.me>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        <namkyu78.kim@samsung.com>, "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'David Ahern'" <dsahern@kernel.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
In-Reply-To: <20210130155458.8523-1-alobakin@pm.me>
Subject: RE: [RESEND PATCH net v4] udp: ipv4: manipulate network header of
 NATed UDP GRO fraglist
Date:   Tue, 2 Feb 2021 10:17:46 +0900
Message-ID: <021c01d6f901$36da2d80$a48e8880$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH3UkD7ra4ajhnLvSE7bwMwZ51/XAG/rNSqAaWf2U6p6DEcMA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHd+5tbwsb5q68Tlii3XVsk4XSVstuVYib0tzEbWG6GF2IpSl3
        FOwrvWCQPcDxbJliFREqm2wjEzodS22Qh+hWGFpZsEqHjo1FM15u8rA8FJGwthcz/vucc77f
        3+/7u/ccPiqYxGL4Wfoc2qRXaQkslNPStUEWv6URpounqnHS/vdFDvlo8TRKzi78wSNnuq9i
        5Ldfz6Nk3Y1iDvlDewlCft7aiJDj08OAHLt8BCE9LUe5ZH97HUYW/lmEkT31UeRC168o2WF+
        zCMnnd08cryhBpBznRbOtnDK2fQ7QlmLJnlUm22IR9U7cinLnVso5bCbMap0wI5Qv1zqw6ij
        TjugHCUNXGrGsTb1+Q+1WzW0KoM2CWm92pCRpc9MInbuVm5XyhLFkniJnHyTEOpVOjqJ2PFO
        arwiS+sfjxAeVGlz/VupKoYhEpK3mgy5ObRQY2BykgjamKE1SiRGEaPSMbn6TJHaoNssEYul
        Mr8yXavxmgcR4zdr8679Ji8E3mgLCOFDfBN84lpGAizAWwF82LbXAkL97AOw5shNwC7mATxZ
        5uY+c3S5ennsQSeA1WeKUXYxDuCg7wIIqDA8Dj6wlQUdEX5u6lkMlkLxHi7s67RjgYMQfCM8
        VdeJBjgcV8PaK46ggYO/AmdvWYKaMFwOj1sfIyy/CN21w5wAo/g6eHGiDmUjCeHCyHcrzd6G
        D58uo6wmAp42lwbTQfxUCJzzLPFYww5Y5StfmScc/nPVubIfA+9XlvqZ7+cCWFKRxnq/ANB7
        mW0M/aFto2UgoEHxDbC5PYGVr4fdgyvR1sDyrqWVKmGwvFTAIgGts0q2BoTj7hOcY4CwrZrL
        tmou26r8tv9b1QOOHUTRRkaXSTNSo3T1r3aA4MWPU7SCqolpkQsgfOACkI8SEWHXj0elC8Iy
        VIfyaZNBacrV0owLyPxf2orGRKoN/pejz1FKZNLERLFcRsoSpSQRHcaI7yoFeKYqhz5A00ba
        9MyH8ENiCpHojsOaD9bv9+FvbMEkuk1P9v1Y8El72r8pn1ZNkWPqlrxZUcSeDo3n3O7ze5aW
        NnacH+lOePW+N/vY2XXoaHPfl7c7kuOdP8fuvwf6GgzPWQ5mr7k98LTiTHKj81DFsrw8/FzX
        0PdMxaJH0ahyX/rqPdfLYNhys6ZWUbH5ZOaiyOXNl/kSeNOxM4u7JhR3rTfuxVU90iW9dl3o
        ufb+WENltkfuTW+a6x0QCrivR5bWu17SfCbY2Z9nHk4pOrBPI8pXRyre6q+OdB3uKUAenG0L
        F+6NcvcWjyTP+rApaj5llLpwZ/tHnGZrZWhBT+wL7w5Jf9pFXzFz/4rYlpzmHkoY/RgjOIxG
        JYlDTYzqPwKoT4KBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGec85284s6bRZe520xhAtI+e6voaaBcWJvmQf1KzUkSe1nK4d
        NfVDjLzkllp2d95NRFcJTnM6W5CXUgu1mqWtCDHLKE3RTMmo5gr89oPn9zz84U/iAjshJuMT
        kxlNojJBxnUhmjtkks27amG0X9l1KTKOmgn042cxjmYX7Dw00/mEi25XzuGopD+LQPWWbAyd
        b6nF0PjUB4A+PczH0EBzAQe9tJRwkfZtJhc9rliLFjqe4ahNN89Dk02dPDRefQug71Y9ESyk
        m+qGMbowc5JHtxre8egKUwqtH3qB0yajjkvnvDJidNeDPi5d0GQEtCm7mkPPmCSHVkS4BMQw
        CfGpjEYeFO0SZ9O9wdRVkrTuQX8tsIn0gE9CahvsaH/K0wMXUkC1ATgzN4npAfk3gNDSuM/p
        COH7rE6O0/kIoNaWy3UEXMoHfjVc4DjY7S/XPf4JHBJO2Thwtm2acDasANpLs5YsPrUV3iyx
        4g4WUkrY1Vi5xATlCWdf6JdWXSl/eKVwHnPyathT9IFwME5tgvkj2cDJ66F5ogR3nieFC2M1
        /67YC6cXf+NOxw0W63Lwy0BoWDZlWDZlWDZlWFapAIQRuDNqVhWrYhVqRSJz1pdVqtiUxFjf
        E0kqE1j6v8/GFmA2Tvm2A4wE7QCSuMzNtffK2miBa4wyPYPRJEVpUhIYth14kIRM5Dqg74kS
        ULHKZOY0w6gZzf8UI/liLbazq1f6+vD9wNAMRUQB9Op296vt9OsVzYtzhrpz8spWoosNM9Fr
        Mp5RkR4D8bWA3h0+ZPHqCVDlVX7fwWlRR97BcO+a0cUTLduvraus8jCPCW9ObyktN3MWpEJF
        X8jz+xqV+Kq8/OPBY3WcqkGUV98YHrkKX3fhV/qq9MLfIWGByYaR4+S51EVtkW3HmjGv60Op
        e6eOxIiPjQdY486oWJP/Ac/t4offdHOTkgDseGaQaN9Jbzt/4tKmQHla6IiqdU78SXCAtNqG
        w07x5RtusKKG1nvN/cGPshQWdanvZ/nEXY/B3NO6XMkeb/cv9rD95sygbmNUWoX0aPH7Ufyq
        jGDjlAofXMMq/wDJMOn1bgMAAA==
X-CMS-MailID: 20210202011746epcas2p2a58b8b98e06879185dbf469312e8703a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129232630epcas2p1071e141ef8059c4d5c0e4b28c181a171
References: <CGME20210129232630epcas2p1071e141ef8059c4d5c0e4b28c181a171@epcas2p1.samsung.com>
        <1611962007-80092-1-git-send-email-dseok.yi@samsung.com>
        <20210130155458.8523-1-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/21 12:55 AM, Alexander Lobakin wrote:
> From: Dongseok Yi <dseok.yi@samsung.com>
> Date: Sat, 30 Jan 2021 08:13:27 +0900
> 
> > +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> > +{
> > +	struct sk_buff *seg;
> > +	struct udphdr *uh, *uh2;
> > +	struct iphdr *iph, *iph2;
> > +
> > +	seg = segs;
> > +	uh = udp_hdr(seg);
> > +	iph = ip_hdr(seg);
> > +
> > +	if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
> > +	    (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
> > +	    (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
> > +	    (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
> > +		return segs;
> > +
> > +	while ((seg = seg->next)) {
> > +		uh2 = udp_hdr(seg);
> > +		iph2 = ip_hdr(seg);
> > +
> > +		__udpv4_gso_segment_csum(seg,
> > +					 &iph2->saddr, &iph->saddr,
> > +					 &uh2->source, &uh->source);
> > +		__udpv4_gso_segment_csum(seg,
> > +					 &iph2->daddr, &iph->daddr,
> > +					 &uh2->dest, &uh->dest);
> > +	}
> > +
> > +	return segs;
> > +}
> > +
> >  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> > -					      netdev_features_t features)
> > +					      netdev_features_t features,
> > +					      bool is_ipv6)
> >  {
> >  	unsigned int mss = skb_shinfo(skb)->gso_size;
> >
> > @@ -198,11 +257,11 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> >
> >  	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
> >
> > -	return skb;
> > +	return is_ipv6 ? skb : __udpv4_gso_segment_list_csum(skb);
> 
> I don't think it's okay to fix checksums only for IPv4.
> IPv6 checksum mangling doesn't depend on any code from net/ipv6. Just
> use inet_proto_csum_replace16() for v6 addresses (see nf_nat_proto.c
> for reference). You can guard the path for IPv6 with
> IS_ENABLED(CONFIG_IPV6) to optimize IPv4-only systems a bit.

As you can see in __udpv4_gso_segment_list_csum, we compare
ports and addrs. We should use *struct ipv6hdr* to compare the values
for IPv6 but I am not sure the struct could be under net/ipv4.

The initial idea was to support both IPv4 and IPv6. Thanks, that's a
good point. But the supporting IPv6 would be a new feature. I want to
fix IPv4 first, so the title is restricted to ipv4.

> 
> >  }
> >
> >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > -				  netdev_features_t features)
> > +				  netdev_features_t features, bool is_ipv6)
> >  {
> >  	struct sock *sk = gso_skb->sk;
> >  	unsigned int sum_truesize = 0;
> > @@ -214,7 +273,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> >  	__be16 newlen;
> >
> >  	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
> > -		return __udp_gso_segment_list(gso_skb, features);
> > +		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
> >
> >  	mss = skb_shinfo(gso_skb)->gso_size;
> >  	if (gso_skb->len <= sizeof(*uh) + mss)
> > @@ -328,7 +387,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
> >  		goto out;
> >
> >  	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> > -		return __udp_gso_segment(skb, features);
> > +		return __udp_gso_segment(skb, features, false);
> >
> >  	mss = skb_shinfo(skb)->gso_size;
> >  	if (unlikely(skb->len <= mss))
> > diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> > index c7bd7b1..faa823c 100644
> > --- a/net/ipv6/udp_offload.c
> > +++ b/net/ipv6/udp_offload.c
> > @@ -42,7 +42,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
> >  			goto out;
> >
> >  		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> > -			return __udp_gso_segment(skb, features);
> > +			return __udp_gso_segment(skb, features, true);
> >
> >  		mss = skb_shinfo(skb)->gso_size;
> >  		if (unlikely(skb->len <= mss))
> > --
> > 2.7.4
> 
> Thanks,
> Al



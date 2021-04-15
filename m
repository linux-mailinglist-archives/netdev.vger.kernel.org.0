Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890413600D1
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 06:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhDOELA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 00:11:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12369 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhDOEK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 00:10:59 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210415041035epoutp013d397444240f25663d1fa4fd2cb3c878~17KU_iz6I2618726187epoutp01a
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 04:10:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210415041035epoutp013d397444240f25663d1fa4fd2cb3c878~17KU_iz6I2618726187epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1618459835;
        bh=kYDiQWnulVw9Hz0VXnv8I2MPTid3lpYmPkltURzzSss=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KaK/TGp+GttqHEp1d14jqdp8FosNfVilHUu1XA7jzMX+6fAjh1wjiCW7WGD3J7JkS
         RDDiJenB8kIIbukiiY/nToAuuzpjw+JGPVdFjBEc4Gi6tCMKzSF4fGHGX+1NXdnq7S
         UADSEbM2a9xILLRx6Kcdb90USrGgFJRYAcmLlE/E=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210415041034epcas2p435677faaef61b1596e2b745b9ef1efcd~17KUVXAgu0544805448epcas2p4J;
        Thu, 15 Apr 2021 04:10:34 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FLQqY5r6hz4x9Q0; Thu, 15 Apr
        2021 04:10:33 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.41.40705.9BCB7706; Thu, 15 Apr 2021 13:10:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210415041033epcas2p482063d25741610f550da879cae95ee11~17KSsgAWK0545205452epcas2p42;
        Thu, 15 Apr 2021 04:10:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210415041033epsmtrp2a54877fa8c32a495b4a745ccc517eeb9~17KSr3SVY2896428964epsmtrp2B;
        Thu, 15 Apr 2021 04:10:33 +0000 (GMT)
X-AuditID: b6c32a47-e7fff70000009f01-68-6077bcb9e07e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.C0.33967.8BCB7706; Thu, 15 Apr 2021 13:10:32 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210415041032epsmtip251c3b00618793469dd9e31a6184627f0~17KSefZVp0515705157epsmtip2b;
        Thu, 15 Apr 2021 04:10:32 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>, <netdev@vger.kernel.org>
Cc:     "'Willem de Bruijn'" <willemb@google.com>
In-Reply-To: <cfb7af92-5a0b-059f-f598-be2c95f5419a@huawei.com>
Subject: RE: [PATCH net-next] skbuff: revert
 "skbuff: remove some unnecessary operation in skb_segment_list()"
Date:   Thu, 15 Apr 2021 13:10:32 +0900
Message-ID: <03b401d731ad$477a4e60$d66eeb20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQIdz9wXg/1iejeqDLXmejTpDcfoowJ/hovHAvGer8yp/BY8sA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmme7OPeUJBls/61k0vOWyOLZAzOLb
        6TeMFu+2HGF3YPFYsKnUo+XIW1aP9/uusnl83iQXwBKVY5ORmpiSWqSQmpecn5KZl26r5B0c
        7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtE9JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9c
        YquUWpCSU2BoWKBXnJhbXJqXrpecn2tlaGBgZApUmZCTce7LCbaC7+IVLx+GNDBeE+pi5OSQ
        EDCRmP3yKFMXIxeHkMAORolVX+azQzifGCVWzpgC5XxjlPj7spkJpmXCtJ+MEIm9jBJdc5qg
        +l8wSnxd8psRpIpNQEvizax2VhBbRCBPYtuxT2BxZgFdidOTL7CD2JwCdhJrTjWwgNjCAgUS
        Lw91AtVzcLAIqErcXlIPEuYVsJR4eH0aO4QtKHFy5hMWiDHyEtvfzmGGOEhB4ufTZawQcRGJ
        2Z1tzCBjRAScJFa+TAc5TULgK7vE1MkvoR5wkbhybCs7hC0s8er4FihbSuLzu71sIL0SAvUS
        rd0xEL09jBJX9kHslRAwlpj1rJ0RpIZZQFNi/S59iHJliSO3oC7jk+g4/JcdIswr0dEmBGEq
        SUz8Eg8xQ0LixcnJLBMYlWYheWsWkrdmIXllFsKqBYwsqxjFUguKc9NTi40KjJEjehMjOB1q
        ue9gnPH2g94hRiYOxkOMEhzMSiK8blNKEoR4UxIrq1KL8uOLSnNSiw8xmgLDeSKzlGhyPjAh
        55XEG5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C6WPi4JRqYFKbfWnpLhX7+y9r
        N+8puhfsdUzK3cZVV3Z2a/+U2K75h3SkXWIUpeND9cs2B2SzT+ttKVMuXGjqVLljgvW+jN7b
        Z1M/u/UIvbluc1bteXuYQvsDbuGGZgEGN5XIoCufBd236CyccCyFx9n6ybSPl6adLWlIPt3v
        d8TsWWJoY6lY/vwpfw/rlEsq7tf//K5ygZzAtpDkeydvH/HRPHmkddOOKXZXq+RPKppqGYle
        tKrXd/7y9QRvTujVbcUJe04obqi+94N9/xyzO1lz0u9FbTjh3RT68WP/B6bQKVa2M4Pdbs43
        Eg42Ef3Jd12oX8uA7R37U0EFuQLOXX8N6rY0Tuh/fPX3iorKKzOUqhe4KrEUZyQaajEXFScC
        AIO1U/sQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvO6OPeUJBt/OWVs0vOWyOLZAzOLb
        6TeMFu+2HGF3YPFYsKnUo+XIW1aP9/uusnl83iQXwBLFZZOSmpNZllqkb5fAlXHuywm2gu/i
        FS8fhjQwXhPqYuTkkBAwkZgw7SdjFyMXh5DAbkaJ87vnMXUxcgAlJCR2bXaFqBGWuN9yhBWi
        5hmjxKFNvYwgCTYBLYk3s9pZQWwRgQKJno9NYHFmAV2J05MvsIPYQgK3GSXWH6wAsTkF7CTW
        nGpgAbGFBfIk1qy4zAiyi0VAVeL2knqQMK+ApcTD69PYIWxBiZMzn7BAjNSW6H3YCjVeXmL7
        2znMELcpSPx8uowVIi4iMbuzjRlkpIiAk8TKl+kTGIVnIZk0C8mkWUgmzULSvYCRZRWjZGpB
        cW56brFhgWFearlecWJucWleul5yfu4mRnBkaGnuYNy+6oPeIUYmDsZDjBIczEoivG5TShKE
        eFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYBI40mVe1ht9
        02f2n+yzqm4N06WuRTUo/mX6/GCS5Hq1woqszzNelyZekS/K070/NftkX33Sv89dL6Muv5FQ
        nnwjljmv8p1lEM8aud3nd02R0mTMCtLMC+7OFtor/0FlL9N0lbkbT73q6pxecm15jJ7IMrnP
        i55f1rWaV8Kymtk1/GdQdNqxgyzGod2H9XIl17bo1U1eHnC7gu/+3sMLOo6aRog5Sa89H79T
        MOT/hPsVxo7Ss/OT7xVey3v0qLI4liPut8GVlM9PEq/olFedYT9sqrQoQ3HOo3bX5rSlcxtt
        2JLZueMt15xdfGTtwveGDDPcPB53HtMM0jwxU+ZaTH529fFZFRXK9rKne2ZIKrEUZyQaajEX
        FScCAMPiucL7AgAA
X-CMS-MailID: 20210415041033epcas2p482063d25741610f550da879cae95ee11
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210415022339epcas2p2a711db4427fff4b1e3e3d45ffdf26d81
References: <f092ecf89336221af04310c9feac800e49d4647f.1618397249.git.pabeni@redhat.com>
        <CGME20210415022339epcas2p2a711db4427fff4b1e3e3d45ffdf26d81@epcas2p2.samsung.com>
        <cfb7af92-5a0b-059f-f598-be2c95f5419a@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 10:23:17AM +0800, Yunsheng Lin wrote:
> On 2021/4/14 18:48, Paolo Abeni wrote:
> > the commit 1ddc3229ad3c ("skbuff: remove some unnecessary operation
> > in skb_segment_list()") introduces an issue very similar to the
> > one already fixed by commit 53475c5dd856 ("net: fix use-after-free when
> > UDP GRO with shared fraglist").
> >
> > If the GSO skb goes though skb_clone() and pskb_expand_head() before
> > entering skb_segment_list(), the latter  will unshare the frag_list
> > skbs and will release the old list. With the reverted commit in place,
> > when skb_segment_list() completes, skb->next points to the just
> > released list, and later on the kernel will hit UaF.
> 
> In that case, is "nskb->next = list_skb" needed before jumpping to
> error when __skb_linearize() fails? As there is "nskb->next = list_skb"
> before jumpping to error handling when skb_clone() fails.
> 
> The inconsistency above is the reason I sent the reverted patch:)

Yes, It is needed. skb_clone clears the next pointer.

> 
> >
> > Note that since commit e0e3070a9bc9 ("udp: properly complete L4 GRO
> > over UDP tunnel packet") the critical scenario can be reproduced also
> > receiving UDP over vxlan traffic with:
> >
> > NIC (NETIF_F_GRO_FRAGLIST enabled) -> vxlan -> UDP sink
> >
> > Attaching a packet socket to the NIC will cause skb_clone() and the
> > tunnel decapsulation will call pskb_expand_head().
> >
> > Fixes: 1ddc3229ad3c ("skbuff: remove some unnecessary operation in skb_segment_list()")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/core/skbuff.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 3ad9e8425ab2..14010c0eec48 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3773,13 +3773,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >  	unsigned int tnl_hlen = skb_tnl_header_len(skb);
> >  	unsigned int delta_truesize = 0;
> >  	unsigned int delta_len = 0;
> > +	struct sk_buff *tail = NULL;
> >  	struct sk_buff *nskb, *tmp;
> >  	int err;
> >
> >  	skb_push(skb, -skb_network_offset(skb) + offset);
> >
> >  	skb_shinfo(skb)->frag_list = NULL;
> > -	skb->next = list_skb;
> >
> >  	do {
> >  		nskb = list_skb;
> > @@ -3797,8 +3797,17 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >  			}
> >  		}
> >
> > -		if (unlikely(err))
> > +		if (!tail)
> > +			skb->next = nskb;
> > +		else
> > +			tail->next = nskb;
> > +
> > +		if (unlikely(err)) {
> > +			nskb->next = list_skb;
> >  			goto err_linearize;
> > +		}
> > +
> > +		tail = nskb;
> >
> >  		delta_len += nskb->len;
> >  		delta_truesize += nskb->truesize;
> > @@ -3825,7 +3834,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >
> >  	skb_gso_reset(skb);
> >
> > -	skb->prev = nskb;
> > +	skb->prev = tail;
> >
> >  	if (skb_needs_linearize(skb, features) &&
> >  	    __skb_linearize(skb))
> >



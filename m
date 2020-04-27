Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BABF1BA242
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 13:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgD0L1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 07:27:06 -0400
Received: from mout.web.de ([217.72.192.78]:43353 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgD0L1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 07:27:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587986811;
        bh=u35VrCt8medsivMDHaOutmpmvu9KIs/e9Ch87ZjO3vc=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=W8rMPUR7ZHcqDJKxjm66tJwBzxZYUTYGk/NH1cdSIRSS/z5CqFITv8P/peewO4B90
         nuMdGpnOET0ElQaYE+9l8exuGtixJuIKMm4yFVgohwXxWm0U/Vbc1YokBCDSgVzOg1
         vlYnA/Gwv4frDnqRM1MhZg/3fV3g1z/2zi7v24go=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.190.48]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lpezi-1iwT6r26y6-00fRdt; Mon, 27
 Apr 2020 13:26:51 +0200
To:     Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>,
        netdev@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: Re: [PATCH] dpaa_eth: Fix comparing pointer to 0
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <332befc4-efd1-9303-7c9d-f7f3809cd81e@web.de>
Date:   Mon, 27 Apr 2020 13:26:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:m1lzIOTWu5edMqRRyCQJq4KBZcNljlhFecvVYZCKRwFDVenNrCG
 yLvwR/DueaOQGjxOGsTnt1cz3VtG8jQ50xr8vUeCPIPLB0sDNEX5U7vSzG/tfU60KAG33eW
 0TE7b7Kc8rVWeE/bZJMFfoFlvOlnWHNyDOLKt7LejYpIntR0caJnAHv2wUes4InCNqoHTpA
 D2IgUHOeoRPeEpVLMYTRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GnzX39we2Gk=:m04wqwdrjegXNR3MXXhVAW
 /XMWgDlSCRzYcFaiiXewVFjOA/wvi1c0hhkD8WXoRW+1Q+IvO6OM+WjzSLXyw3n4+reY80QAX
 lAlKxHrnd5cVQgH7D7lXEykPlRtTpBIrC136IrP4Aun30bBm4jTGc40OW+R7WFU5IgbW0EtGT
 j5js5O65Bg4F/Dut19gw7TIEdin/dsoquqDy3u8108acjGMF7XChfgpCYI8GZm9Q7EuZ8Jj0S
 E6zE4mfgD0RjlTgBt1gGOxqDBJWY80FpbLCcORunBcftc7y3104M4U2QQsxZYJiAtwCI3sLU+
 dtN3n/miHytRNuyqpR/aoyNi/0Eq8nEJsnu9G8Pscdrrnp7LHgxn7d+pgFgg9fV7SDqPu6xt6
 8Eo1nMqurpSFpu6z0k3PUj2h77Ol6UTrBWWFc8pPo+nFfJZLIF4EPjdYB4OkiNQUaVYEY0PNM
 FZoMZVh+PMocNqYnvr0NUNaFCF8n1LesIe3kHXyxnE/oEJjoOXGQc+tSVjDCH+sdzuxhwDgOI
 xWqFF0bhx7/AcgcJZev2gpu4s1qrR6ZHLAl59fZHSDBhzvIpqK3mCslcF1Too1BWx7CAKSDAK
 s8swH6QWop6DIQDDcxEEtVZ3ru+lz29Clvf/KX13jlFGMA02CcraLSfxY+Tq+lTTwbiq+W4ap
 /3hLNAq5Cywjfmj4qG5i98QitJQI8kBAwAqpjloJl0b2MOky4JTkcxMdE823QCUkA9/iV7S4b
 6sc94rocoiWeBH20OXM+kpaR0VQQUELLOfxwUMThV+R7pVjMD+klOUVRf3hWya0ZL0sGtVqyf
 SoYYLE8YUgryu3eubEsB2oSVwgeUR51YfBmQqOS4Wu210S4rKgyLmZ75cWpddHdl0u8GBNtH7
 MuEjf3pTkERZGlyoUnmDeRmih76J6fuYSEELmlRLLO1bChlFb0caWrBGVNbi3pCU8fMjYg7rF
 FMOoqyaPJCUgbNYuGMawrp6JazYJCkKKC+zQDzTmXzrjG5JM3oOwFQ1jXju02C2ypdRqbC+Rd
 s+BMdR3HN8wlifhwWc8JjOfgfO42bHdw37VFCHMTkaKqJ/oSU+PpZTXey8j56WcxDdAEJ+8kc
 2V881kfFmMpxQUHMIL9EFYsc/6WbfnrPtoLx9DN7dPgU61PvhyHV93/+fLywuZ5k0qHrnYbLA
 ZHEXqdVaXWdakJJuZlV31s8NM/234x2MyZFRfFSfVI0lM+lHot5ZB3gbS6qhE9VKJ0CJbcUX6
 5u9L0RffmvS1Dr7RN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes coccicheck warning:
> ./drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2110:30-31:
> WARNING comparing pointer to 0

Such information is actually provided by a known script for
the semantic patch language.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/scr=
ipts/coccinelle/null/badzero.cocci


> Avoid pointer type value compared to 0.

But I suggest to reconsider corresponding software development consequence=
s
also around mentioned implementation details.


=E2=80=A6
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2107,7 +2107,7 @@ static int dpaa_a050385_wa(struct net_device *net_=
dev, struct sk_buff **s)
=E2=80=A6
>  	start =3D PTR_ALIGN(new_skb->data, DPAA_A050385_ALIGN);
> -	if (start - new_skb->data !=3D 0)
> +	if (start - new_skb->data)
>  		skb_reserve(new_skb, start - new_skb->data);
=E2=80=A6


I interpret the source code in the way that a subtraction is performed
with two pointers. I would expect that such a pointer difference
has got an integral data type.
Will this view trigger any further software evolution?

Regards,
Markus

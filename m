Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2D336C20
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhCKGWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhCKGVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:21:45 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C816C061574;
        Wed, 10 Mar 2021 22:21:45 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id g8so2094246qvx.1;
        Wed, 10 Mar 2021 22:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=mwI4bRpwupjwaOM766OD0JzhQH2VY3vQqz4Cyis/nWw=;
        b=iPYyNGHMDgHcReMaKZZcDWfpCX7RaYlzElT6BUVQG1EqTF4lDSoeGlJOmE668FNFx3
         /RekKh7QjywWQbFtvIaMp8Hk6O3Nx3PNcT2UybtofF2mCj39fpOhZCXT1Ma2TGNe/Dd6
         Q5gALJna5wQc+DPGQy0Lh8jcsfif9ahR0k2i0dULfGHtyrrsVPP7AuPsHptmmWYYgAMT
         rp7BWiCDJof/WP3X9JQguHTolaWF65Qgmea2QWiJsV9XrlHeKPxsVMmVdQMH118fad/c
         w8u89WrM9PEo52oYdLCuf+BVfkVlN43+aTIBMnU6x/S+abjldFD3IEOUV22OJnaDlHab
         jdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=mwI4bRpwupjwaOM766OD0JzhQH2VY3vQqz4Cyis/nWw=;
        b=Xe2ME/KOLMlLwouAVf3KFyo1A7SEKK/ybkvqSy/6PkvH/x+tuFp58ZZbKWbdWF72RO
         kJbd9rS66lRUZMv0LK6g29u+3eTLfDYIbcLKKJ/u98j0jZCwOD9KSESCvl6ZD1q5av6p
         l9fopbjLN1b/53z7ln5KZz01Tio6MuGVhYYIgGXr8yHPouPE5eX/akabWCeBRXSVmOv7
         rkckOrsaDEpHDGZ1OSpzfwjqEvNNm1eHyMasnKza57oh6s6gJwWRN1YCVxUBUYpzSbTW
         Nblio+CBM5n+QTMn8YG8cQriOOeNe4MRAgjrsjQfm/qwwpgqmsg2tRbYhvqrfmAgCsvk
         abFw==
X-Gm-Message-State: AOAM533NP1KwsHZGreDEVghUcb6PbhuIK6qTDAXLJJs2cN4Vvo+Vpop3
        IGnyOMjLAM6ZPMjGfDnCGVM=
X-Google-Smtp-Source: ABdhPJyT83kqdvObAxCcZYXi0DujrbSPpoelNSxU1D5yeGuPI8x/AKLUsbZhh8+jsm+/kMdpzXQqVQ==
X-Received: by 2002:a0c:c488:: with SMTP id u8mr6285052qvi.9.1615443704737;
        Wed, 10 Mar 2021 22:21:44 -0800 (PST)
Received: from Gentoo ([156.146.55.115])
        by smtp.gmail.com with ESMTPSA id p7sm1307505qkc.75.2021.03.10.22.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 22:21:43 -0800 (PST)
Date:   Thu, 11 Mar 2021 11:51:31 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: Few absolutely rudimentary typo fixes
 throughout the file filter.c
Message-ID: <YEm26xk0pOeBSUmu@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210311055608.12956-1-unixbhaskar@gmail.com>
 <786f4801-c41f-cddd-c855-b388ec026614@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y2n5PfDwgrKa+sR2"
Content-Disposition: inline
In-Reply-To: <786f4801-c41f-cddd-c855-b388ec026614@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Y2n5PfDwgrKa+sR2
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 22:12 Wed 10 Mar 2021, Randy Dunlap wrote:
>On 3/10/21 9:56 PM, Bhaskar Chowdhury wrote:
>>
>> Trivial spelling fixes throughout the file.
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>
>Hi Bhaskar,
>
>FYI:
>
>a. we accept British or American spellings
>b. we accept one or two spaces after a period ('.') at the end of a sentence
>c. we accept Oxford (serial) comma or not
>
Hey Randy,

First one had an apostrophe in the word....(s/free'ing/freeing/) ????

Yup, last two was bad change ..it all same whether it's "s" or "z" in
it.Apologies.. will be cautious ...


>> ---
>>  net/core/filter.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 255aeee72402..931ee5f39ae7 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -2927,7 +2927,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
>>  	 *
>>  	 * Then if B is non-zero AND there is no space allocate space and
>>  	 * compact A, B regions into page. If there is space shift ring to
>> -	 * the rigth free'ing the next element in ring to place B, leaving
>> +	 * the right freeing the next element in ring to place B, leaving
>>  	 * A untouched except to reduce length.
>>  	 */
>>  	if (start != offset) {
>> @@ -3710,7 +3710,7 @@ static inline int __bpf_skb_change_tail(struct sk_buff *skb, u32 new_len,
>>  	 * be the one responsible for writing buffers.
>>  	 *
>>  	 * It's really expected to be a slow path operation here for
>> -	 * control message replies, so we're implicitly linearizing,
>> +	 * control message replies, so we're implicitly linearising,
>>  	 * uncloning and drop offloads from the skb by this.
>>  	 */
>>  	ret = __bpf_try_make_writable(skb, skb->len);
>> @@ -3778,7 +3778,7 @@ static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
>>  		 * allow to expand on mac header. This means that
>>  		 * skb->protocol network header, etc, stay as is.
>>  		 * Compared to bpf_skb_change_tail(), we're more
>> -		 * flexible due to not needing to linearize or
>> +		 * flexible due to not needing to linearise or
>>  		 * reset GSO. Intention for this helper is to be
>>  		 * used by an L3 skb that needs to push mac header
>>  		 * for redirection into L2 device.
>> --
>
>
>--
>~Randy
>

--Y2n5PfDwgrKa+sR2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBJtucACgkQsjqdtxFL
KRUHxAf/a1X94/OMJEC73SGsqAit7BuFpA4Hcp/7CEe+I6TAWvpmqWW8i+B3IvpC
1K3HqqETVKT8w0Vj8i6zeaki9nirpSj/8Ok+YKu7wvuf0UKZLn/ZgulS9e7wPDPq
3EjZSyxIzA/yERJRmO9IyykwEkSajLPODgHwmyJJGKY3huzjkZVaEGcHCdhl+6vW
I6YRC1W+jsBAVmgU/pVTO34QZTE5MJzDUqgzGTUrLTlo3/PKnZIQwPbck7Z3UKiu
v8vnnT12z0YCxiz6/A24h/BZMGI3o6ooP8Mzv6UFU4ZewUardHwX7ndheL9HpLp3
8YmCOtQOx5Vsw/fSh50XQUUbPWEv1g==
=0qoF
-----END PGP SIGNATURE-----

--Y2n5PfDwgrKa+sR2--

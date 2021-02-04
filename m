Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602F730EA3F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhBDCdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbhBDCdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 21:33:35 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81829C0613ED;
        Wed,  3 Feb 2021 18:32:55 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id a12so1965690qkh.10;
        Wed, 03 Feb 2021 18:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=MJioKdNVOEvo/KsyqvjYGpC+hN5xTn7omYEUx0bMXvA=;
        b=pHBuobSKILbJhuLLcc/3hth4BHKUubli9fuZUhZC+rObDP8cZ8bgoJmT3tzjw2EIg8
         epntF8Yw9jYjZ0p3PZ8Aub5vPEkryWi29byJhQzH8Fn6PVBgQTIh5Iia20YZDOEs+udO
         WelxyU/fEXLkjepwX1O4YkQUvFUErIANe2fGgIWWrimjEE1Qen3bLyvdHvFAoSyVKNXe
         uwikz2zf6rUJvOrsRDPYUQMxbK/DcPK9+q34NsRcDDzpmZuzlM+AsIF8b10yNWpCzHdL
         4kRKJPGbw+gQXjiiQCX9iulrmlR+Lr8OmjGRy8YeGGZemxroN9bKnm/im9h2PUzPWqb8
         8BaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=MJioKdNVOEvo/KsyqvjYGpC+hN5xTn7omYEUx0bMXvA=;
        b=dn5EZauf6o/zmDZevH4vGS3sXpQVeS4GX3qJFfNUOl/5y19XEETT0uD6S/hHm/irlo
         /mmYFv8rTjNu3e4E/BZoTETCl6zOgNfbtR5F8+Vbznsrl1IuKIpsK3Pzv+8vWwWF71Bx
         Php5fdN2Q+zcyYVUQKzpE2uXftQKMDcY/iCnMvLgcS3TkwnWfa727d2xL7bEAO2IemY4
         JY0Cjc4ZL7k4+ZjmZwV9JjQkv3h8ZkdTer5O7o3oASRfWF7J6Fbwi2tv//Ldjlm4yoZj
         Eh91ht9jk6u15iwIJAauuuJk9fCFAqtUSqigtU5F2fISnrGOX8rg6Hgq76Q/eoX35v98
         rXRA==
X-Gm-Message-State: AOAM532gs6+R8d2z1zCGkUIbPNtQ1nRelkTYia+laWG66LswWJg/QUU5
        p//27IiYQAlMvZNslOlVGeQ=
X-Google-Smtp-Source: ABdhPJx8lCqzRhCNeQl1whuWue+5WRmG99XC7j3zoNvxdquVVyaGP6f4KGPx5SJ4mJazMH/jozA0bQ==
X-Received: by 2002:a05:620a:2239:: with SMTP id n25mr5605909qkh.46.1612405974819;
        Wed, 03 Feb 2021 18:32:54 -0800 (PST)
Received: from Gentoo ([138.199.13.179])
        by smtp.gmail.com with ESMTPSA id n78sm3818564qkn.22.2021.02.03.18.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 18:32:53 -0800 (PST)
Date:   Thu, 4 Feb 2021 08:02:43 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] drivers: net: ethernet: i825xx: Fix couple of
 spellings and get rid of blank lines too in the file ether1.c
Message-ID: <YBtcy8WPPSz6wCfO@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210204011821.18356-1-unixbhaskar@gmail.com>
 <bea4f9c4-b1bb-eab6-3125-bfe69938fa5b@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dz9hAsEg3MNNcKsb"
Content-Disposition: inline
In-Reply-To: <bea4f9c4-b1bb-eab6-3125-bfe69938fa5b@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dz9hAsEg3MNNcKsb
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 18:09 Wed 03 Feb 2021, Randy Dunlap wrote:
>On 2/3/21 5:18 PM, Bhaskar Chowdhury wrote:
>>
>> s/initialsation/initialisation/
>> s/specifiing/specifying/
>>
>> Plus get rid of few blank lines.
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>> Changes from V1:
>>    Fix typo in the subject line
>>    Give explanation of all the changes in changelog text
>>
>>  drivers/net/ethernet/i825xx/ether1.c | 9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
>> index a0bfb509e002..850ea32091ed 100644
>> --- a/drivers/net/ethernet/i825xx/ether1.c
>> +++ b/drivers/net/ethernet/i825xx/ether1.c
>
>a. don't delete the blank lines
>b. the change below is not described and does not change any whitespace AFAICT.
>   I.e., DDT [don't do that].
>
But what do you do when things getting automatically inducted in the
patch???(You got to believe me)

I haven't had touch that bloody function with my keystroke and it gets it on
its own! Bemusing!

Those blank lines too inducted from the fresh file(means in pristine form) ,so
thought pruning would be good..hence the decision to get rid of those.

Wondering what the fuck is going on....

>> @@ -1047,7 +1044,7 @@ static void ether1_remove(struct expansion_card *ec)
>>  {
>>  	struct net_device *dev = ecard_get_drvdata(ec);
>>
>> -	ecard_set_drvdata(ec, NULL);
>> +	ecard_set_drvdata(ec, NULL);
>>
>>  	unregister_netdev(dev);
>>  	free_netdev(dev);
>
>
>--
>~Randy
>

--Dz9hAsEg3MNNcKsb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmAbXMcACgkQsjqdtxFL
KRXE3wgA08qhl3UlYZ5F03/kEOuJVrzbjZ27P2zjgZmen5iEaTN2Jlc/VjMe/tI0
B97nAdg8pPmTtBpSS0e7Fc7W0t5y3/FOazlV/86V7fiEov3grjhJl+tzt4NfwxXL
Mlhn3+8aL0Kui1YEKqKJuwYFwRO+ZaiqOFVi28VyT7ZcZDscXOXDmyR2tzfNFLl/
HtPl6rO8nXBpoI6Af0hl2pcNFIP0WDKXsy6lOiCNLHPMEHZLceVpuzuFupx4eXXg
qfZPnWDEA6MOGIt1INSdI/yZndi2eRnTVjPnRD6fRp+J4kiNyQrmnlnxLyJWZRF1
5pwZRSn3pCRybvO+htN137Yi86zLsw==
=gNBU
-----END PGP SIGNATURE-----

--Dz9hAsEg3MNNcKsb--

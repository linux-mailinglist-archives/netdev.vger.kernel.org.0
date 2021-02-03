Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99F130E7E6
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhBCXwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhBCXwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:52:46 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E55C061573;
        Wed,  3 Feb 2021 15:52:06 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id c1so1184924qtc.1;
        Wed, 03 Feb 2021 15:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=LWDBz11RsEKuXQrdXFjH1+vI1NJWjWDUc79Y8gU0Dzs=;
        b=kHHIcea+bU3FPDTBvBjb7OFVs326OtyWwtSHA8j+Eu4SrBIECbq9n9BIcan8vJJiiy
         +A1dnpEAD8DwhSUtQnO//Vcp8elafTtdoQpS2Eq6eOQCE9i3MHDSGphLoQ9lBt+UM/Xs
         J7xKrf/7zeadMMutgrYPyKlMBILqm3bMsMtgegRXXsCmEaxyVf/H/nNIzGDaQcXEtgwj
         Ze7BpX+QH6Bov6ewYL7hAM3oMt42O8rkuDR1yifF8drKC/r/RgTh6dCM5upBqeNd5BS+
         Bp42pgPuTdWPxTS4ZLnEGfFcaIf/C4AU8tNciDOTsct95eSzCMNMHfgV87mO2Lt4QigS
         BUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LWDBz11RsEKuXQrdXFjH1+vI1NJWjWDUc79Y8gU0Dzs=;
        b=Q4YmD7RCMVGbfpuyOYzoucAk60zdTMQvCN9hz/MXGz9v/9tSjau6vFX+XqUKOzzele
         JMpZXH/4C8YK+ZmVurb8jc+RGu/GH8W6ajV8YDX9rr1Qmd48/+23p5YaxaejkKMjwUq3
         6zBnwf8cJdLzYvGiklMTOwGsgSbwHiL3Zt+AQLi7EQpjsHXH3p7cqs0sZXnxRoWr2bxv
         S33U7Nsk1+usr06qCFa4OyWfo9gdPo+vmOiOrT0e5IKvA92/PK3PyeFupv+VyckBsXrV
         ulO2CtycENf9t10RyAXPIoR/dodBXlZjuD80oN0o035T+V2vSbstz53xvUWibQNYZqNw
         l0Ug==
X-Gm-Message-State: AOAM5306XD+JxO5aVdez1aIrm+KR4s/EsBYC965cNgWo+OgdgrlrwsSt
        Uel/83c/qhOOnVIBmR3SbpAN0dWZKq+4J5Ch
X-Google-Smtp-Source: ABdhPJz83XPsMoY6aRs2ze9gwQKINWz+j1LYlx9iJP8K3cN/DCePE+bN1MkIuBb3QVRs9iWRhM8Pzw==
X-Received: by 2002:a05:622a:8a:: with SMTP id o10mr4931100qtw.9.1612396325963;
        Wed, 03 Feb 2021 15:52:05 -0800 (PST)
Received: from Gentoo ([138.199.13.179])
        by smtp.gmail.com with ESMTPSA id 202sm3384810qkj.92.2021.02.03.15.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:52:05 -0800 (PST)
Date:   Thu, 4 Feb 2021 05:21:54 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux@armlinux.org.uk,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: ehternet: i825xx: Fix couple of spellings
 in the file ether1.c
Message-ID: <YBs3GqKQqLkN0fOt@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux@armlinux.org.uk,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210203151547.13273-1-unixbhaskar@gmail.com>
 <fb09ac34-12a9-f7df-131e-a98497f49d1b@infradead.org>
 <20210203121352.41b4733d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G9hZZrgodwUjX8Ad"
Content-Disposition: inline
In-Reply-To: <20210203121352.41b4733d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--G9hZZrgodwUjX8Ad
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 12:13 Wed 03 Feb 2021, Jakub Kicinski wrote:
>On Wed, 3 Feb 2021 09:54:22 -0800 Randy Dunlap wrote:
>> On 2/3/21 7:15 AM, Bhaskar Chowdhury wrote:
>> >
>> > s/initialsation/initialisation/
>> > s/specifiing/specifying/
>> >
>> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>>
>> Hi,
>>
>> $Subject has a typo/spello.
>
>This happens more than you'd think with spell fixies. Always makes me
>chuckle. FWIW "net: i825xx:" is enough of a prefix, no need to
>transcribe the entire directory path.
>
>> The 2 fixes below look good (as explained in the patch description),
>> but:
>> can you explain the 3 changes below that AFAICT do nothing?
>

I am so sorry that error like this lean in . I will fix that Randy..thank
you...
>I think we can jump to the conclusion that Bhaskar's editor cleanup up
>trailing white space.
>
>Bhaskar please make sure that the patch does not make unrelated white
>space changes.
>
>> >  drivers/net/ethernet/i825xx/ether1.c | 10 +++++-----
>> >  1 file changed, 5 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
>> > index a0bfb509e002..0233fb6e222d 100644
>> > --- a/drivers/net/ethernet/i825xx/ether1.c
>> > +++ b/drivers/net/ethernet/i825xx/ether1.c
>> > @@ -885,7 +885,7 @@ ether1_recv_done (struct net_device *dev)
>> >  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_command, NORMALIRQS);
>> >  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_status, NORMALIRQS);
>> >  		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_rbdoffset, NORMALIRQS);
>> > -
>> > +
>> >  		priv(dev)->rx_tail = nexttail;
>> >  		priv(dev)->rx_head = ether1_readw(dev, priv(dev)->rx_head, rfd_t, rfd_link, NORMALIRQS);
>> >  	} while (1);
>> > @@ -1031,7 +1031,7 @@ ether1_probe(struct expansion_card *ec, const struct ecard_id *id)
>> >
>> >  	printk(KERN_INFO "%s: ether1 in slot %d, %pM\n",
>> >  		dev->name, ec->slot_no, dev->dev_addr);
>> > -
>> > +
>> >  	ecard_set_drvdata(ec, dev);
>> >  	return 0;
>> >
>> > @@ -1047,7 +1047,7 @@ static void ether1_remove(struct expansion_card *ec)
>> >  {
>> >  	struct net_device *dev = ecard_get_drvdata(ec);
>> >
>> > -	ecard_set_drvdata(ec, NULL);
>> > +	ecard_set_drvdata(ec, NULL);
>> >
>> >  	unregister_netdev(dev);
>> >  	free_netdev(dev);
>> > --
>> > 2.26.2
>> >
>>
>>
>

--G9hZZrgodwUjX8Ad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmAbNxcACgkQsjqdtxFL
KRVHwAf+Ln8hvEa+7y8Zo2IjmVGI+vDnyXaapcZTCwHTeqY5N/pWs5O80JqZMfqT
EaHX8H2rXtICBFKIpW2V4gn1o8xDPYj76e9pQGSW1klMn/N3+zBcNaC7tLsdctai
skyC0k+KPACWXHjQmLiS7KmXr5szYzgMhdmRQjpzBPmu1HzjcVE2mSuSVxHG977w
JPZKO+eti+2BpYTHkJpZ48iy+VWB0leaszytLoJdvmpnfvt698jrG+3IpZJwtkTy
rzpRg7R9Zg7EyhcT9pIImtBNH+WWW5l16E1qVrdBSRVAc94zkbi9d3dlVhQlO77G
yfn/AUxdwIatcJ8BG4n8lCA4Z7dqBg==
=y56c
-----END PGP SIGNATURE-----

--G9hZZrgodwUjX8Ad--

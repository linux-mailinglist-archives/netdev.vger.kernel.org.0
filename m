Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5D74BC616
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 07:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbiBSGwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 01:52:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiBSGwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 01:52:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA3032EF6;
        Fri, 18 Feb 2022 22:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74BEA60A29;
        Sat, 19 Feb 2022 06:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B11C004E1;
        Sat, 19 Feb 2022 06:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645253511;
        bh=vjgeWGGdTos3osksGe25MRc85Z5ip7dI9hHWP2rg6lM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B/26i0m5pDBGIQ6eqSyJXSV61NY2S4NRvkuLxdSu1vMb9GkPhXVj1tP6K0H+/UpEL
         4CJ7OKzeY//koPo8Cv92QS5VjGBW3sPZj1SnaY8YhsLh+vowp9kMefKWar1yTQmyIY
         CuN6XLAymG6/JxDEHTEbzOIE7lssNMbGZ9Jq5QkjkHcPwsWs/o8le0bdXMHH3bueRb
         p/zz7PUEYO5rhHFUZONtyuDqZ3ZXtpERRwiVLNUhL8tWPuemtujpdYLi1XQi1cRCJ1
         i+o+7+gXnlL3JqKhrMLVRYoJVI9IYdJQmFq55+6SW1PCE6x20dg9UYWVcHQ/Cilinf
         ZGtvaOO5tgtzg==
Date:   Sat, 19 Feb 2022 07:51:45 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        42.hyeyoo@gmail.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, vbabka@suse.cz, David.Laight@aculab.com,
        david@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 11/22] staging: emxx_udc: Don't use GFP_DMA when calling
 dma_alloc_coherent()
Message-ID: <YhCTgS4PmyuPHjE8@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-12-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="D2wz4PwjX2gwFU3n"
Content-Disposition: inline
In-Reply-To: <20220219005221.634-12-bhe@redhat.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--D2wz4PwjX2gwFU3n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> --- a/drivers/staging/media/imx/imx-media-utils.c

$subject says 'emxx_udc' instead of 'imx: media-utils'.


--D2wz4PwjX2gwFU3n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmIQk30ACgkQFA3kzBSg
KbYaRQ//SwbI0+K/CaMf5s3yHU3X3zwd37JPp7SObiWgF0LJxKbzPZ7WVpeowPuU
OkrNFgb+1pnAJlGdXXtVcfLINjj8yo1DmbitrutFwBc6m5JPzwHLetUXuMgCtLqq
Gp7NyKEzVeovJl+94NZXDaV9kzoVJBACd2dcafnmkKpoNdycxYrnLyxL+p9yn4JW
0p64pGqS/c3zsZ4YHuW4dFh1v1rHGQ7qyXoNzZiL8495bDuCeuC4AR3AzVyVDSK8
oyOVIAB9zW6xFnaD6D/qoryUsymmPagj5fRpSfzpgOoGt9RS6BliQkZp9oTQMl/v
36ua3wljKTYpWpqIN4iPAuG79riEfn4/hE0HCiRJH36LnLH6gRxcYviR0tLA6WBw
/D2AYIyrx4FsX4ltYdBpaxZZ71R0+lCCSqMPwyrc6i9cvrOmIFsMkS/RfzJe0/7m
o4CWYnjLMpiCu24CyfqPnM1KGuEfFGXb1THZdW+f6QxIiiNLFSGqYnW/nbmPOm/6
3m3bsGJ++o6iytmFC/LmMvJTVCD/9wNN/mXXRCFmCPxrdlR4zBtIPMXVY1cMwuo5
31RZE/Oc0J7HOkRhcn+cBGETIy8x3MuYuKDwif8O627oUwAMm8GFSIbzE5LkURmr
ymKOInLEc6+HNcl5ictyuoX23gxX3NQcLYLIuJGZAJddGW9uAlI=
=mFLq
-----END PGP SIGNATURE-----

--D2wz4PwjX2gwFU3n--

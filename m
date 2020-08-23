Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4A424EBB9
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 07:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHWFuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 01:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgHWFuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 01:50:02 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09593C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 22:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1598161794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/w9wtTgUFAfnZ/V+ZprD6aGtvFc9a4IfLLPsuWQJwa8=;
        b=Tl7uDJkaV1sBKLE1i4DZRRILEsx66j1H/xU67mec/6LJSE1JN+H9RJl5Hft62fhKIVZRNO
        TnKSdPT++0A8whb0xBMEWLWx/dhuxiIh4Ge3BdEyvNqOx3Pb4IjNrbJ/jm3I9W/uwiwTdD
        Lr4R2kahezFgwrMq5KZ53QEFR9QdSEs=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 0/8] net: batman-adv: delete duplicated words + other fixes
Date:   Sun, 23 Aug 2020 07:49:43 +0200
Message-ID: <1676363.I2AznyWB51@sven-edge>
In-Reply-To: <20200822231335.31304-1-rdunlap@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3238041.zqnHrrKj3g"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3238041.zqnHrrKj3g
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, 23 August 2020 01:13:27 CEST Randy Dunlap wrote:
> Drop repeated words in net/batman-adv/.

Please rebase to only contain the changes not yet in 
https://git.open-mesh.org/linux-merge.git/shortlog/refs/heads/batadv/net-next

Kind regards,
	Sven

--nextPart3238041.zqnHrrKj3g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl9CA3cACgkQXYcKB8Em
e0aLPw//YiXX3hTmjuwrfrwU3PH8X7RrNwDqp20IFr7tNag9pBtc9IQARHdT3eEC
GOAFjPOibVyU9keF4fsbXQxUrq4Jux+Jg6AsBAcZLA3hkGcA0kG6fmJTAXey8RWI
qpy4KzVOwaWgeW3J3lR5saOXZIY1FezhgZcJSWeU31lMwJYN4A9W8OvHXKbvCKff
Dqf6+jSCOSgKhlAPe+UVpadajB2z9mgaXYOXquSfHWctlWjJnhUsh3txTWNqSBZi
iWqI1wBXW5qb6WGBKU52c6QaTrVTPEcnFZIFC597oE7L+adUqu+WItcyGHbcUNy5
tEhsjTU1YpumlG984P95SIndAuBkVFpEXON00oOsIdEt+NsjB4VdM6e71EMShaG5
tjBWtMuSXtK35E8ScaMIpr4zXFW53+Etgklq65+K9tV9PEv1LD85hN9fiSzYC0TX
tyCHHS1FEZaCYYWhJZTarBBEm6dxUhBwy1Hnnnc9vlRVPFGsxDg6V1QKXFKoB61q
6cifUHxV9j5paN635O/+9A9cONnBH+ppy4LXfI1rWOmLCg4M8fZFr/QSObvt4dy0
vBa9dYmX4BE6pObHDNatyAFo5pwHobwfyLK4rusiUjtwrt/nW8vKqnDPEUUP4nxl
tMztFtvGBLdXc2V936H6FLKOjS7tukfiq2mc8GsHAO8Y8E3Tpp8=
=Dvr/
-----END PGP SIGNATURE-----

--nextPart3238041.zqnHrrKj3g--




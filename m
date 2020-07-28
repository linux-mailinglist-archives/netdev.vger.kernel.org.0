Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D322310EF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgG1RcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:32:10 -0400
Received: from mail.katalix.com ([3.9.82.81]:44044 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731892AbgG1RcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:32:10 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id D12527D370;
        Tue, 28 Jul 2020 18:32:08 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595957529; bh=TAKsGs3/FWFqWI9CMKH0LAMcH0k7tTZFQ321M8e4xMc=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2028=20Jul=202020=2018:32:04=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20netdev@vger.kernel.org|Cc:=20j
         chapman@katalix.com|Subject:=20Re:=20[PATCH=200/6]=20l2tp:=20tidy=
         20up=20l2tp=20core=20API|Message-ID:=20<20200728173158.GA4582@kata
         lix.com>|References:=20<20200728172033.19532-1-tparkin@katalix.com
         >|MIME-Version:=201.0|Content-Disposition:=20inline|In-Reply-To:=2
         0<20200728172033.19532-1-tparkin@katalix.com>;
        b=1m60tMH04yAqY+1kclvzlJglAaxBSYUGrooWBPIgVrROAyaW5MQPl2irQJht4yZjk
         e83Ty+3Ccf1iRMC0fo6ia1g5pzsN3pMnqssinCfjiWpv+zUR3RRCeyPq9NBTAAEcqb
         Jcbg7DM1Qir2bqzoRU88ZzJNZFfi8M8G0prkop04xw4j3JCKzAc3mudW9HaOAORXjs
         cA10TjEjWiStsISFECsel1MJBaxR0ZDQIso24NGPtNhVUeZNvACRhkU7bHo3F4lxki
         rEjwHBlV2oKA0AfvlTdqj7+6swCcFnMLDOkvyE6zSiOF7OlnINSnG8k3ZVH6jWfhs9
         0ZaHqGEedQazA==
Date:   Tue, 28 Jul 2020 18:32:04 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com
Subject: Re: [PATCH 0/6] l2tp: tidy up l2tp core API
Message-ID: <20200728173158.GA4582@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On  Tue, Jul 28, 2020 at 18:20:27 +0100, Tom Parkin wrote:
> This short series makes some minor tidyup changes to the L2TP core API.

I'm sorry, I forgot the "net-next" prefix in the subject line.

Please let me know if I should resubmit.

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl8gYQsACgkQlIwGZQq6
i9COdQf8Dgy0UzX9YK7AAVBRfAwEiXfQO6eQYQ/H7Gn8OzGbEeT00x2HGtTDXjvV
f7t6P7Y7yxLc3ztUZ2EEGF+bYCIaQ1KsYGwvQ9VwgZk2NOY7OgGIK3Q+lltoI7tV
dneG7FM4C169012vpMuNjqFkC+DrIDckGcNFpd7zKjXA9ziqi+3rKVSO96aV2gdi
86GlVDsJU9aFRT/h1yEyxlYjGuT/tHq5L3UP31tiZJr/0RkSCY056mOqDcPE6kuz
4bdge1NmEyiblrjSt3sBk5xdjfVl1cBG5/PNmw504o+1ZQHCQDEjb74eZoW7Es/B
J5ayiJTuN8y8P6U39uvnw4+sWe3dpA==
=EPVK
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

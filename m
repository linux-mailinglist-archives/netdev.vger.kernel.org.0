Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FF112DFE2
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgAASHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 13:07:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34426 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgAASHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 13:07:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so37417571wrr.1
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 10:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tSsf8/xfqPdJeJctKG6h41zZ7/8fVKylPwotO+3zUKk=;
        b=S4AQ2erYci9i4NPiYYSGCIYHliClRirW2aO8Vn9w31MwiBjTZ9QGm3RRn+BeR00uEC
         xOqVVTVGasaHzcOAj76wbTo6flK2vD4qsq+UQwxPndGDKxBclE/bgw/o65otNVMqvl1d
         /Yt5Um+szDDxv36EBTFPjsZUajuykSFTcNsZnXnPOuJr4zeDaJLdvgDDFXKna3wYvrwI
         UNiMo+apX7t6V7llO5qiBmCIlvk+6AehK6AxQ0yIwuCs65MmzdqiKcf5fx0X8n0bkdeo
         5Vygp7Yz5OiDfKbKyFZUCr6ZUWzs+jZl68UtZwCtMpJDblFgnLMRyX3vyJVRftghki//
         i8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tSsf8/xfqPdJeJctKG6h41zZ7/8fVKylPwotO+3zUKk=;
        b=LET5JKVpJCzmntrIlOtKf7mQqtt9cBI/BSIHPQ4Tnn5lg/AOGYtsJAnmxn/2lW0O79
         +3Ccr+X4+tSnYLzynKW63Ps6BehE7kmyRDTb6H9tvavzya57t/mPeKQji7OQapwQm1hl
         Mufg9AVMB6is09yC9QIywls7jAsLeHAQ73P+uvcKBnzh7puZxvq7mGKJtuui3L3FCyKt
         BlINqUM6sTHYsxseZxPM21rlvTN2NwGu//mJdp2ceYRwfk5FgNcGz7CRFZ1WadR/50Ux
         cOZG5y9KWalifFnhsMXhEQsQ34AH8yEHphjTxLI6gSV54IBjEYNM0DuzJFAnPa/HMJWf
         ADiw==
X-Gm-Message-State: APjAAAX3idlatxrtxKjHLLnHoOymKQM9CyuHoDBteycrRZGk7QcoZjID
        ccx/jTUxQTV5OF5OAR1Rf6g=
X-Google-Smtp-Source: APXvYqxSf0BzWFmD0FdkiKf3w+knekYUd24pqHzU0YB9sfijn3/1CeWdYramJC+G9wIGQY8mYcKUHA==
X-Received: by 2002:a5d:6886:: with SMTP id h6mr65676477wru.154.1577902056410;
        Wed, 01 Jan 2020 10:07:36 -0800 (PST)
Received: from pali ([2a02:2b88:2:1::5cc6:2f])
        by smtp.gmail.com with ESMTPSA id i16sm6149586wmb.36.2020.01.01.10.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 10:07:35 -0800 (PST)
Date:   Wed, 1 Jan 2020 19:07:27 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200101180727.ldqu4rsuucjimem5@pali>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali>
 <20191231180614.GA120120@splinter>
 <20200101011027.gpxnbq57wp6mwzjk@pali>
 <20200101173014.GZ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="j2uayulgwrv3uiyz"
Content-Disposition: inline
In-Reply-To: <20200101173014.GZ25745@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--j2uayulgwrv3uiyz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wednesday 01 January 2020 17:30:14 Russell King - ARM Linux admin wrote:
> I think the most important thing to do if you're suffering problems
> like this is to monitor and analyse packets being received from the
> DSA switch on the host interface:
>=20
> # tcpdump -enXXi $host_dsa_interface

Hello Russell! Main dsa interface for me is eth0 and it does not see any
incoming vlan tagged packets. (Except that sometimes for those 5 minutes
periods it sometimes see them. And when tcpdump saw them also they
arrived to userspace.)

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--j2uayulgwrv3uiyz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCXgzf3QAKCRCL8Mk9A+RD
UkmbAKDFHDgOJLTv2xyx7hqgsZXVM/M15QCgtgP0R0Wwom/vShGFeSwDvt162Lc=
=zeb+
-----END PGP SIGNATURE-----

--j2uayulgwrv3uiyz--

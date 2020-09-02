Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A62D25A542
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 07:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIBF72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 01:59:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44782 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgIBF71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 01:59:27 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599026365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2DtcQZHiBztwViPAkP9SEgvU8iSvhfwyZ7xLX0oKsM=;
        b=Dc9RdkXiFO8JbqFMOr8j2muc3LOsNllnmeyag8dgRvaH2MhfI5lNl/Zl1yaEJ564dOq/Y+
        6vMHyP6ekSghpHS/tB6JBJ051b//F9eFv09bOG0RZLJOWMw/DXivQqLkY6Kww0dq4QccCT
        IGaxKAqqAgNEM7v8hcVT4noLADHMZup86BK1YYzGpdgHVre3LNWGfSMo86LglvS+eWcYMs
        PyGQcje9iIptdD5c0xwVi+4BI9ELjKNedL8aiC8KxMHvhCjV+1BNY7m6RdaHcql0tqNBP9
        PR91/eecpCSgkDSG6pEgFqTMmSjCnwIN1mWZVxjgx5XR86iti649s14HGQRUUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599026365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2DtcQZHiBztwViPAkP9SEgvU8iSvhfwyZ7xLX0oKsM=;
        b=pBt1gXIr07Z3eWoySTRdqCSB98BxEJMxdaZ74t/WrFe8mT0mKtIDMjRjBgJNp6SwPjEMQp
        nK9anSRWCifr1aBw==
To:     David Miller <davem@davemloft.net>, richardcochran@gmail.com
Cc:     andrew@lunn.ch, olteanv@gmail.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        bigeasy@linutronix.de, kamil.alkhouri@hs-offenburg.de,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200901.115338.1041117882209940166.davem@davemloft.net>
References: <20200901142243.2jrurmfmh6znosxd@skbuf> <20200901155945.GG2403519@lunn.ch> <20200901163610.GD22807@hoboy> <20200901.115338.1041117882209940166.davem@davemloft.net>
Date:   Wed, 02 Sep 2020 07:59:12 +0200
Message-ID: <87zh68afdb.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Sep 01 2020, David Miller wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> Date: Tue, 1 Sep 2020 09:36:10 -0700
>
>> On Tue, Sep 01, 2020 at 05:59:45PM +0200, Andrew Lunn wrote:
>>> Maybe, at the moment, RTNL is keeping things atomic. But that is
>>> because there is no HWMON, or MDIO bus. Those sort of operations don't
>>> take the RTNL, and so would be an issue. I've also never audited the
>>> network stack to check RTNL really is held at all the network stack
>>> entry points to a DSA driver. It would be an interesting excesses to
>>> scatter some ASSERT_RTNL() in a DSA driver and see what happens.
>>=20
>> Device drivers really aught to protect their state and their devices'
>> state from concurrent access.
>
> Completely agreed.

OK. So I'll keep the locking as is.

Since I have to have to prepare another version due to the compiler
warnings, I'll wait a bit for more comments and send the next version
after.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9PNLAACgkQeSpbgcuY
8Ka72A//T43wAj1saWZmigcl2adbajYE8guEWofJY+m6T2lGnWgrb6vtpeS+85LJ
0DORtHw63zuUDwYh4Zn9+nCuLUI3BrZsNoSsp9TrOau6apdfUKAS+oOFfPFxtyhg
kxAJjW/rcKFtCD8K4UDuFBp5+kF2l6916Y4WjVXr0AJZ9BIUqdRP6Yh6qIRzqR14
Xw6GhX6LMFZynrbiFZV7Yc5T2tDag/Jr+dil8JkDRxFCxX/zyeu51w084i3KuWQJ
g+AL0yyxLt5LeC/0Wf5pULnwyxtwMUOXtmHn/kldWckz16u/EdxVbSA8TvHXzV5v
HYBy2fHIKCHfAfLxR9+PGTW1DSTtZ9XlwPzv71kfoR/p6klcjIXSN/4a97fOlsSn
+1aliYEzuvRvotd5CwtG3NyFtDxSlOPlwNmFD3uraGPYETG2L6Lih7Rf2sokVpIO
wXZIgFgMn2HA1kgk/hiSFwMf+pZStk8Nn4pnEvGyz2HQy/rAMGG/4FSvTF0Z1nBu
w7QT2ufmZMCrYNdc8MeM/OLQvRQ3CSDm9AhdMTub6pKWtqZB1ZeR9sPv0wg6vJou
oZJRsljtmTcySq/0NtEdPJFhsJ+UUnjuAj4M0sIjB5MdaUgseNBvbCJpxRZv/ldD
bEMbxQr+KZFsT+QZMylB143Ff/87sa2Ewj9c+K+KqQKs+sJDfxo=
=l1Qh
-----END PGP SIGNATURE-----
--=-=-=--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5F733B5E9
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhCONzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:55:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35186 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhCONzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:55:23 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615816522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/yubD74MW5D1zcwRiZXO9Zd4JifHmAfbH1Y+i/qQ2nU=;
        b=40Fy0dsE7bfPmRdOinrWBwla4fPYpofkjjEQeBewt70zQyMU+yoV6VK2ZES3sOc9vQRIcF
        SHRCIXwUtlio/IoJwxnXVo0oMO+JVRUDuEs/JTRzxqTAcrltTBnPDRE9bJT2Dp2A1ZXlQr
        AsuMYtQvFVBZINkHK14f9Ba9zhySA2+N8tmtaFOGf6lwEqquuLITv8UKXDxDHCmCrGJU2r
        quZMEptfYVIoXvxgVDfH5AzB6gHSZQUWrOADdKmiKi/Ue5gc1S6ruSZCZTMM9xVa8UulHC
        0DNhSgQdq7d/8Hp8MHfdUIR79cJDcVNF3ccwEscnXTbcjneixWBohB/zeEEp9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615816522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/yubD74MW5D1zcwRiZXO9Zd4JifHmAfbH1Y+i/qQ2nU=;
        b=T1QP1N5kVMCWSn7oXBHwYC3OjGLNfFef1KBegEGNLZrskfF2L1lx7Tg8XxaL2GrUR6aX4I
        F9kXshiowgKvoaBA==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] taprio: Handle short intervals and large packets
In-Reply-To: <87wnucktw1.fsf@vcostago-mobl2.amr.corp.intel.com>
References: <20210312092823.1429-1-kurt@linutronix.de> <87wnucktw1.fsf@vcostago-mobl2.amr.corp.intel.com>
Date:   Mon, 15 Mar 2021 14:55:12 +0100
Message-ID: <87tupccyin.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Mar 12 2021, Vinicius Costa Gomes wrote:
> My first worry was whether the segments had the same tstamp as their
> parent, and it seems that they do, so everything should just work with
> etf or the txtime-assisted mode.
>
> I just want to play with this patch a bit and see how it works in
> practice. But it looks good.

OK, thanks for testing. Most likely the segmentation can be skipped with
full offloading applied.

I'll also test a bit more, before sending a non-RFC version.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmBPZ0AACgkQeSpbgcuY
8Ka9HxAAzvyU+DikoSaoT7014cUANn11SxpIKpcJAkWsH8vFDzWLrI9EoSFfZ/Qb
d3hivbTt10e7ReUfvhVgRkeW2E01x82E5g1/IUFKhdZ5HYPg/PWt3P6CVW0RQqeX
eTL0Yypfel6z5ZJKDcwXBbebpP2TTbV35H+424DfljVa1Xt9ZMwR6yh7E7+QgP2m
MurbjQLvLmlM5A6rk0JCK233nJGIRDg1OzwQsUC/QqFgrSLtA99XOMRYXzb7J2sO
EaIl6Fc9tDxTJ3+8YnoWe6jhkeToO0EnGbM4Zr3okcbKLSBN012fv89G9aWCmIlL
Cmc1U3W0j1FCyZubdNqvCv/i5d5Z0NGgkv2KKH9GyfGvWYUZ1IhDn3d0FYJG0DEg
YMJrnJH8HJ0nb5ngzxf3fjcxhn/SY7Yngey4DQvMvS3CE86xqoGUIuIhLi08H92C
FH8mZMAIhMK6J2QLNAPnyuM2j3nQmCf+Bx/f8Mknjyy01QMEBmCqZg7kf3o0p6J7
ytuRPyL2cysGDdtmkB4j3IY50+L8vwGHy6wyFxC0XP8bRA/9MOP6jJxS2OZFOqvK
kwbs8Q0/3JE1JvEUzsZ7yCv1RBp2KQrNplTfBzHTyAvMVs/XoFW9ZcN0RZhKaQmL
6v+1xEaN1UPVJiPfOM7bjyY/GiZz2W4UaE/0Txmp0GqLgcY+zmM=
=+W7g
-----END PGP SIGNATURE-----
--=-=-=--

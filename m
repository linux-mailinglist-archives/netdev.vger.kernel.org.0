Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF545B942C
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiIOGQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIOGP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:15:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C5466108;
        Wed, 14 Sep 2022 23:15:58 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663222556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16EkOxJWOJ2VYr1fBeCMv5EVP+eK/aR5IZaZqnAsUIs=;
        b=Jo8DAk+8XrNoO7qyclUY85EEstbXluGvNbeLjVv0bmnHJBXpHyemrxgzapTX9LAwxcq9F7
        YaTbyvayjfjFZcRRxwqY9JjSqi6bWAa3ZIZ9U/zpeW2P3VoRsuTJwvaLrfA992648tagko
        vrfx5TvArtJwnj+td0JluzwC1HdIGZ5pyA+DvAdVZrYsBXHsTvFI8mVeqC1y1V5B0Kil74
        hIa2oCgO3zt7KISU9Tq5hh4CdimcCGzcB2HFM59DeUrsigtrTVaEiQLF1nILyGTMxc45Jz
        Qzbd4sZmeTHv0RihaKBUM6nvHPs1JTq3yad76jSVmkW8uQHv5hsz8PFYo7XySA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663222556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16EkOxJWOJ2VYr1fBeCMv5EVP+eK/aR5IZaZqnAsUIs=;
        b=DdTVkZycJlCNKiaDfqsVG7UN73DsE5FEavr2HXLbrbqdTrrTADF8xbscteukrg32W2lW42
        +hZBDt1u3ep4OrAg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
In-Reply-To: <20220914184051.2awuutgr4vm4tfgf@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf>
Date:   Thu, 15 Sep 2022 08:15:54 +0200
Message-ID: <87r10dxiw5.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Sep 14 2022, Vladimir Oltean wrote:
> On Wed, Sep 14, 2022 at 08:13:53PM +0200, Kurt Kanzenbach wrote:
>> I'd rather like to see that feature implemented :-). Something like belo=
w.
>>=20
>> From 3d44683979bf50960125fa3005b1142af61525c7 Mon Sep 17 00:00:00 2001
>> From: Kurt Kanzenbach <kurt@linutronix.de>
>> Date: Wed, 14 Sep 2022 19:51:40 +0200
>> Subject: [PATCH] net: dsa: hellcreek: Offload per-tc max SDU from tc-tap=
rio
>>=20
>> Add support for configuring the max SDU per priority and per port. If not
>> specified, keep the default.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>
> Nice :) Do you also want the iproute2 patch, so you can test it?

Sure. I see you posted that patch already.

>
>>  drivers/net/dsa/hirschmann/hellcreek.c | 61 +++++++++++++++++++++++---
>>  drivers/net/dsa/hirschmann/hellcreek.h |  7 +++
>>  2 files changed, 61 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hi=
rschmann/hellcreek.c
>> index 5ceee71d9a25..1b22710e1641 100644
>> --- a/drivers/net/dsa/hirschmann/hellcreek.c
>> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
>> @@ -128,6 +128,16 @@ static void hellcreek_select_prio(struct hellcreek =
*hellcreek, int prio)
>>  	hellcreek_write(hellcreek, val, HR_PSEL);
>>  }
>>=20=20
>> +static void hellcreek_select_port_prio(struct hellcreek *hellcreek, int=
 port,
>> +				       int prio)
>> +{
>> +	u16 val =3D port << HR_PSEL_PTWSEL_SHIFT;
>> +
>> +	val |=3D prio << HR_PSEL_PRTCWSEL_SHIFT;
>> +
>> +	hellcreek_write(hellcreek, val, HR_PSEL);
>> +}
>> +
>>  static void hellcreek_select_counter(struct hellcreek *hellcreek, int c=
ounter)
>>  {
>>  	u16 val =3D counter << HR_CSEL_SHIFT;
>> @@ -1537,6 +1547,42 @@ hellcreek_port_prechangeupper(struct dsa_switch *=
ds, int port,
>>  	return ret;
>>  }
>>=20=20
>> +static void hellcreek_setup_maxsdu(struct hellcreek *hellcreek, int por=
t,
>> +				   const struct tc_taprio_qopt_offload *schedule)
>> +{
>> +	int tc;
>> +
>> +	for (tc =3D 0; tc < 8; ++tc) {
>> +		u16 val;
>> +
>> +		if (!schedule->max_sdu[tc])
>> +			continue;
>> +
>> +		hellcreek_select_port_prio(hellcreek, port, tc);
>> +
>> +		val =3D (schedule->max_sdu[tc] & HR_PTPRTCCFG_MAXSDU_MASK)
>> +			<< HR_PTPRTCCFG_MAXSDU_SHIFT;
>> +
>> +		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
>
> So the maxSDU hardware register tracks exactly the L2 payload size, like
> the software variable does, or does it include the Ethernet header size
> and/or FCS?

This is something I'm not sure about. I'll ask the HW engineer when he's
back from vacation.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMiwxoTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgjmEEACRHYyHMI670c5W4f+UhOMFFjlsRN71
CHM/yAlx/EIdMHAdiEXhHNU3qs7zGYVP8Lg4/ZKzN1gwzb6Phujs9R/7Phr+Brle
ukNjrm+bZHQojiVfh4ZtuvMdEiycia8DQUHBuLv8ZZ8wSBYACCqQVpNMTKclIBR/
J59EhDB+CFWTEhLx9VnmS9ee9kk3VcPl49J97svnG5bjbebvAFNER5oeqryKwQDd
CmkDOh1CA/vPp71QcOrtrOjAdldCd3cvoC+GeKdGFmeDRHOKaiXc8DFxQjISLNo6
KrG/frMVm8YLSwifkNvHol4gRem81pBjGGhcnGxu5V4dFOwThEdt7hek44ySYFOc
oXTYhUl3A1w54xeSinJ2m3Isyt54iLPL4PnqVvl3Sa/4/LYEFrVCYbuHIO8rmMUS
TwPQPPICJvdIsCuNmVKH1F720t7hR4AZ76UoaR7mCBeMicqRanb1qoMZWoFr6LMC
/0zhzT7oZkBJekAuBkb0nVCgrMARjlhDb9Ciqupp9gX4Wgogk5udHHocHEXFVko+
gUtiNc2K+Dc5iK2iW3lULiPjjcvkdY4N2bIP4tA+O5MstJlQivAFOU+qQOdiEB3d
kpP8RKJRC/viM0sCoIhKE7eHz/mcd+GYYjQ3miyxi299SwUYneRczQ3tjQcCBPMa
rPKxH9J0HJksNg==
=38X1
-----END PGP SIGNATURE-----
--=-=-=--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692744F1E71
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243077AbiDDVym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384453AbiDDVfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 17:35:45 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE8A48335;
        Mon,  4 Apr 2022 14:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649107514;
        bh=Ro4B9BImMndeuI5KT1TcwaX2nQXOXMqp5IujRLN9o60=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Q+UG0XJUFefJviD9xFpD2w/hLKt8PtLpC5JXKtomSoqPbnaKMOdUdjI2aXg5odyYO
         HoE4i99Gu85QGXAD+TQHdZJLZn3inhtM8KHDu+pgqooCSjhqaZyn3NFR0ZfmPnhcOO
         Iix0rQ4oyJEYp2RVJqrJtGELhsv6dsSWIRzqv0X8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.4]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqJm5-1oNB4T0I9z-00nPsq; Mon, 04
 Apr 2022 23:25:14 +0200
Date:   Mon, 4 Apr 2022 23:25:12 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v1 2/2] mac80211: minstrel_ht: fill all requested rates
Message-ID: <20220404232512.4fdd7eb9@gmx.net>
In-Reply-To: <87fsmseml7.fsf@toke.dk>
References: <20220402153014.31332-1-ps.report@gmx.net>
        <20220402153014.31332-2-ps.report@gmx.net>
        <87fsmseml7.fsf@toke.dk>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KZKJ2B/82F/1PI1nVtiO1SFg08+X1scy2oosau6ElqX5HcXlYRR
 7aFO78O4JQX2wXL16Pd8iuXAZDyrfMiHqzbgKpRmhhLmpnSwS85TVVBGUzBl/OvVTKZ9qvJ
 cyibel71SBEkWUsQdvmwnLlP6vdkMo1IWaN82rtvcpe+9p+kD7wNrZzfn5ejPrVV4+GUnYE
 hlb1aWqtyKSmDYu47Eo2Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SzPVeetkwDI=:aW9kEi57qgJAIiTgaZjWIL
 V8gq/L9Adw4YrEXegqCIVPfMJt6qi/lM5lQWYUdYzDajnOaa1DGNHPIONZriS/mOAHVSoS3P7
 CgzUJtdenZx/F6f1IOy/XutSWCVWh9qsS8+7Olv0uG+5DSLe0AQpjb0agSP3oMRQbCcKlUvku
 u5DO5+foiEeeWAO2C+GJzyBDoozcMNo8xovd9FK+GbdSYr88rAU+sjoa1GymiBo53J5fUVUq/
 X6gkNs4VcFqs9nvz4E1HUfVWGXqqEzCjaVYFmRbEsrnizQ2J7zX0RSPYawPyr7+nHoTXfteOH
 mKB7z4TIUBo8ssLX+3kJzUQpx1JJxiAPfwxbM7bzUdOWLZbLV4D+jvwCM9gjKz5tVwhWqmtso
 BV6tUNQT1KtzuLaZ05OKbsJCIJJ2n8GizzjUkvTOfK2POZ0CJPxach1mFOJQ2nn9UVA9p/f9s
 P58I9IFiP1eWuFl6xD1veWMm5B4qeYUNEvA+1kUV/N6zOwZwwWZov3hSD+yKdLApz+gQYapy7
 O4gkkPutObcAeZkDPmAYsjgj+LvZGpyLtNXyk7Fx8PUf8YLlkG4Lj+mAARnQFSSHRoDow+IeJ
 YUE0FETs0sG90g3TUsMnou8LAqWVY8BJj2o7Vc++WgT4laPg16Jlw1vbDiYFfUx3/9C+UXIxp
 aUJjp32KcH9/5GhUdBpSil28uKj1h2d/V6/aIvssuRiAxjEaAKNj9XAvsCc/O+ls3eTtML+Y9
 q03+UM2QaMzbR6uqAWoT0uNboM/h1Zotje1FpiTNt4lDdSaXEb6L5zvQqLthNAfcU5tf6RIwB
 U+CPNEPhvRpgrwvDqv8xru8hvwp5kJAP59WNS4qv//rwI8FSzbYwH3e9RB8Xo5jDkZaEq4unw
 gY/EEPGoclZZLMqBtceH6/+RE1JDIsu4wwnXO5MuZACpFwiF1srhB43UP2vyijLzl3IW42Ldr
 g0OuDqJwRm4tZQkb8ly7Rek/O+JhKGEh7hDxLqCkZzYEn1kN/IeQ79aF8msjiZQN8R1nLsR+o
 j95FjOePmEakOLJxi1wa5/GOwPphWWbruk0GKh8ditPIa4XD8967KdJIUT2em00hqO93Quijl
 51HtC25MRhq59Q=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Toke, Felix,

On Mon, 04 Apr 2022 20:21:24 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:

> +Felix
>=20
> Peter Seiderer <ps.report@gmx.net> writes:
>=20
> > Fill all requested rates (in case of ath9k 4 rate slots are
> > available, so fill all 4 instead of only 3), improves throughput in
> > noisy environment. =20
>=20
> How did you test this? Could you quantify the gains in throughput you saw?

Investigating some performance degradation of a wifi system original with a=
th5k
cards using a legacy kernel and madwifi driver compared against the=20
performance using a ath9k card running IBSS mode over long distance/with
additional amplifier and using iperf for measurement...

With the ath5k cards under bad conditions the throughput is going down below
10 Mbits/s but with stable throughput..., with the ath9k card and the exact=
 same
setup there are short periods with good throughput values and periods up to=
 10-15
seconds with 0 Mbits/s...

The actual in-door/laboratory test setup is a wired connection between the
two wifi systems (with fixed attenuators in between) and an adjustable nois=
e/
disturb signal induced by a signal generator...

Without this patch the 0 Mbits/s periods from the field test are reproducib=
le,
with this patch applied we see a more or less stable throughput of 1-5 Mbit=
s/s...

Regards,
Peter

>=20
> -Toke
>=20
> > Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> > ---
> >  net/mac80211/rc80211_minstrel_ht.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_=
minstrel_ht.c
> > index 9c6ace858107..cd6a0f153688 100644
> > --- a/net/mac80211/rc80211_minstrel_ht.c
> > +++ b/net/mac80211/rc80211_minstrel_ht.c
> > @@ -1436,17 +1436,17 @@ minstrel_ht_update_rates(struct minstrel_priv *=
mp, struct minstrel_ht_sta *mi)
> >  	/* Start with max_tp_rate[0] */
> >  	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[0]);
> > =20
> > -	if (mp->hw->max_rates >=3D 3) {
> > -		/* At least 3 tx rates supported, use max_tp_rate[1] next */
> > -		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[1]);
> > -	}
> > +	/* Fill up remaining, keep one entry for max_probe_rate */
> > +	for (; i < (mp->hw->max_rates - 1); i++)
> > +		minstrel_ht_set_rate(mp, mi, rates, i, mi->max_tp_rate[i]);
> > =20
> > -	if (mp->hw->max_rates >=3D 2) {
> > +	if (i < mp->hw->max_rates)
> >  		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate);
> > -	}
> > +
> > +	if (i < IEEE80211_TX_RATE_TABLE_SIZE)
> > +		rates->rate[i].idx =3D -1;
> > =20
> >  	mi->sta->max_rc_amsdu_len =3D minstrel_ht_get_max_amsdu_len(mi);
> > -	rates->rate[i].idx =3D -1;
> >  	rate_control_set_rates(mp->hw, mi->sta, rates);
> >  }
> > =20
> > --=20
> > 2.35.1 =20


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C00453B7F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhKPVNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:13:49 -0500
Received: from mout.gmx.net ([212.227.15.19]:33995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhKPVNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 16:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637097043;
        bh=9FHexJsQQi5EAXe0TPRjZEvuF2/loC9zFCJlzIclsf8=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=TVSayi3685hj2NFsMeEwFBz5WU0Znzp9/FbWhdHBLuPNYn1y+HnmOif+kwt43Wzr7
         AxY9Wga0BUanI6df/W0J6+tcNpt5JSF6DKpJkRwAtechSkA8A5C1oCPXCNxxJEuuSs
         ewYcxK1HurBu+wTOylNVTFlfik8APdYlrTxcOV8I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.243]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mel7v-1mDCg21E1N-00ap5o; Tue, 16
 Nov 2021 22:10:43 +0100
Date:   Tue, 16 Nov 2021 22:10:41 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v1] mac80211: minstrel_ht: respect RTS threshold setting
Message-ID: <20211116221041.040c0fdb@gmx.net>
In-Reply-To: <20211026204144.29250-1-ps.report@gmx.net>
References: <20211026204144.29250-1-ps.report@gmx.net>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Dy15umDskKaeojcGgNpv4KuNZX9z67eJHP9GYod4i8u7OyCChSl
 bG4pW3Ht5snXQAgiFrzRzOuUDdxYGqOtM7YC4oXDClkMdnYUbKuoGQqTzrfqIenCHwR+7SY
 C9YSs5xaDAZ7LwnEVUtJIoCFdrdci+F5RFS670dJH+wYwQbFzebcjWDvlWHP4NmPLo53H5p
 SWPPajrFqeXB12XtDXs4A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:O31DY/JiVSM=:Y2YIrqGv/GgfDUX7lmUVfB
 NJuvGWKglvua3UYtIES6cQzui/0GdQhQqtm3xsWtdi0ANEZ/fwW0BpvG01YVQf/yzDVAWPcJP
 FNR6wNaCJOl+gQMM5Myl5Il1+mlJQL4joqRDPl9hCUziR2jLedQ5nP6YCFi7odz3n91uluxmk
 cSxNLM3+aCFJq9VmpYHp/shhVq/wPDPzqto+OxxU3CvfXuzYyQq2Ux9npbPVvAV3CbpPGMcmV
 RJFxVkmKizBdIBwRKIJlXnU901O9wllC+4VSAKheTto5Bwh33+J+50ESTiJheOUaHo71C0SZL
 vBFhiBaW7yOHr5E0w5pXcVZ4VYLUigmR38tZ1K3FPC8VUZLBXqNJMPoocb0qly3ykxYlrxU0i
 o6TmLlIJzlPHHa+KKMVzPyTjjMpW0HWguCx8c66Sh7+mAZvfl3U1lBARLMlwIffLSsMiYynD6
 0KKKCvG8gA7JlF7Gyu4IhANA1JYvu6x3M8BokoYTZNhkLh+rhQweLTbE/T5ScdA7LQfqv8Ee1
 LKkMbL2bF6RFDbGKS/fgye8+Q2WwAjY5Ea2Fa1qCwOt6jd4Woz+cWvtIbxVce5JJolcB8K7aY
 ukjytFlvZL87i/IeSBNl1HRMIctwfVWbIX8+s54bB0tYhrbJhZotPpbxa7GEh/tomT2pNGenx
 wGF6mSew6meMuPQAKN+KgiRHSnjlIV/cCgmFtFTUpaC3WEBMxa/yn+TTXfaJ/aX4L8MFD1gtE
 i2+xjZOHMoppmdT5wOUV0jnAgdNZDnhhGLqRw/mptUXj2SdUt+IsoYVimFkDqkVB8M/pJ8YwR
 H/4MwiYV0fOpKrQPwhm9PBB79mFIuyOCl+1N2EB4wRuU2fCGyLcNWJ0g+5xtdxvFPJW0CvN13
 fepu4mI6HM3tWBtRLLdV8sG1LyeWX1SIOqdKTeXcdEOQvidj6p7b4je3jP5iwaAA8c+9gu70u
 6gjLK19IpjTsALwLEv/BiUSimG5Ukyv9WpjcRBbIVHBuG9f1xI0LtLzAtBGixWEeD8hzCU1T4
 Sc6ZczxiSwbJTaufvzUPn/c4/KtVSB03K36TGHKWI/1WQdcvjNSdx+KzJV/v6mAjcTkSrz5Rb
 Vc4umRkhke7wV4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 22:41:44 +0200, Peter Seiderer <ps.report@gmx.net> wro=
te:

> Despite the 'RTS thr:off' setting a wireshark trace of IBSS
> traffic with HT40 mode enabled between two ath9k cards revealed
> some RTS/CTS traffic.
>
> Debug and code analysis showed that most places setting
> IEEE80211_TX_RC_USE_RTS_CTS respect the RTS strategy by
> evaluating rts_threshold, e.g. net/mac80211/tx.c:
>
>  698         /* set up RTS protection if desired */
>  699         if (len > tx->local->hw.wiphy->rts_threshold) {
>  700                 txrc.rts =3D true;
>  701         }
>  702
>  703         info->control.use_rts =3D txrc.rts;
>
> or drivers/net/wireless/ath/ath9k/xmit.c
>
> 1238                 /*
> 1239                  * Handle RTS threshold for unaggregated HT frames.
> 1240                  */
> 1241                 if (bf_isampdu(bf) && !bf_isaggr(bf) &&
> 1242                     (rates[i].flags & IEEE80211_TX_RC_MCS) &&
> 1243                     unlikely(rts_thresh !=3D (u32) -1)) {
> 1244                         if (!rts_thresh || (len > rts_thresh))
> 1245                                 rts =3D true;
> 1246                 }
>
> The only place setting IEEE80211_TX_RC_USE_RTS_CTS unconditionally
> was found in net/mac80211/rc80211_minstrel_ht.c.
>
> Fix this by propagating the calculated use_rts value to the
> minstrel_ht_set_rate() function and evaluate it accordingly
> before setting IEEE80211_TX_RC_USE_RTS_CTS.

Despite my believe after code review the use_rts value is only calculated
after hitting the minstrel_ht code, so my preferred alternative solution
would be to NOT requesting RTS/CTS from the minstrel_ht code (for the
fallback rates case)...., updated patch will follow...

Regards,
Peter

>
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
>  net/mac80211/rc80211_minstrel_ht.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_m=
instrel_ht.c
> index 72b44d4c42d0..f52edef443fa 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -276,7 +276,8 @@ static const u8 minstrel_sample_seq[] =3D {
>  };
>
>  static void
> -minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_s=
ta *mi);
> +minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_s=
ta *mi,
> +			 bool use_rts);
>
>  /*
>   * Some VHT MCSes are invalid (when Ndbps / Nes is not an integer)
> @@ -1254,7 +1255,7 @@ minstrel_ht_tx_status(void *priv, struct ieee80211=
_supported_band *sband,
>  	}
>
>  	if (update)
> -		minstrel_ht_update_rates(mp, mi);
> +		minstrel_ht_update_rates(mp, mi, info->control.use_rts);
>  }
>
>  static void
> @@ -1319,7 +1320,8 @@ minstrel_calc_retransmit(struct minstrel_priv *mp,=
 struct minstrel_ht_sta *mi,
>
>  static void
>  minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *=
mi,
> -                     struct ieee80211_sta_rates *ratetbl, int offset, i=
nt index)
> +		     struct ieee80211_sta_rates *ratetbl, int offset, int index,
> +		     bool use_rts)
>  {
>  	int group_idx =3D MI_RATE_GROUP(index);
>  	const struct mcs_group *group =3D &minstrel_mcs_groups[group_idx];
> @@ -1357,7 +1359,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, str=
uct minstrel_ht_sta *mi,
>  	 *  - if station is in dynamic SMPS (and streams > 1)
>  	 *  - for fallback rates, to increase chances of getting through
>  	 */
> -	if (offset > 0 ||
> +	if ((offset > 0 && use_rts) ||
>  	    (mi->sta->smps_mode =3D=3D IEEE80211_SMPS_DYNAMIC &&
>  	     group->streams > 1)) {
>  		ratetbl->rate[offset].count =3D ratetbl->rate[offset].count_rts;
> @@ -1426,7 +1428,8 @@ minstrel_ht_get_max_amsdu_len(struct minstrel_ht_s=
ta *mi)
>  }
>
>  static void
> -minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_s=
ta *mi)
> +minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_s=
ta *mi,
> +			 bool use_rts)
>  {
>  	struct ieee80211_sta_rates *rates;
>  	int i =3D 0;
> @@ -1436,15 +1439,15 @@ minstrel_ht_update_rates(struct minstrel_priv *m=
p, struct minstrel_ht_sta *mi)
>  		return;
>
>  	/* Start with max_tp_rate[0] */
> -	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[0]);
> +	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[0], use_rts);
>
>  	if (mp->hw->max_rates >=3D 3) {
>  		/* At least 3 tx rates supported, use max_tp_rate[1] next */
> -		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[1]);
> +		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[1], use_rts)=
;
>  	}
>
>  	if (mp->hw->max_rates >=3D 2) {
> -		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate);
> +		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate, use_rts);
>  	}
>
>  	mi->sta->max_rc_amsdu_len =3D minstrel_ht_get_max_amsdu_len(mi);
> @@ -1705,7 +1708,7 @@ minstrel_ht_update_caps(void *priv, struct ieee802=
11_supported_band *sband,
>
>  	/* create an initial rate table with the lowest supported rates */
>  	minstrel_ht_update_stats(mp, mi);
> -	minstrel_ht_update_rates(mp, mi);
> +	minstrel_ht_update_rates(mp, mi, false);
>  }
>
>  static void


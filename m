Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E20402EED
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346069AbhIGTY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:24:29 -0400
Received: from mout.web.de ([212.227.15.3]:51897 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346052AbhIGTY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 15:24:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1631042581;
        bh=C3Kava3hgepg/XaIDROu8dHiXBxSSlrzwnw2BXTTxu8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=F34+gslEYeoBXcN3bghzku+i7clvDzh2RBQ/M9jbz3bg03teZgpsI4NW81YdcuyJq
         x4PhmsRc9ZlbTjbgWwetsSS8H67vwHi4EXSBk8FFm1x5IxabxDT49WtY+jtxR+bha6
         A7n6Kkda9oCzBMhyGdsAJgV7wu5onSx+PNC5xqpc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.27] ([89.12.22.161]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MLUDi-1mN8ic3ogc-000aA6; Tue, 07
 Sep 2021 21:23:01 +0200
Subject: [BUG] Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as
 fallback
To:     Shawn Guo <shawn.guo@linaro.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
From:   Soeren Moch <smoch@web.de>
Message-ID: <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de>
Date:   Tue, 7 Sep 2021 21:22:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210425110200.3050-1-shawn.guo@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:slohztXf3BTkkoBYuYLA1V9JVQKp3w602USBrAoPIC4BUO/YYP+
 hWpggc/Wu4nzDjc19d/6TODSknsPsfXprnkl0AzalPdCdzyTA7uIXePKNmM7F8GcqwPxNEK
 cfAr9EY79iuOr1onVlEU5TWlPVawIrX1VV9fBBw3tjBZXMm8SacELYdtKlxbq5GXpfss8Q8
 KE924fHKVxJVVFjoHrwng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ExnSiwBjD2s=:IA5XJh8uKbl+uI+OZe3887
 DbkIFzvC2TdLGsbchBIXFrCH4Oaz6fvoE8KuiltMJ/vVCXrxDo3qzWRab41lOIqwH4lNJN289
 q+gnRP+OcQPOAj6A6IYwGBxzomSK2vvnP53zlNMq60Nf3OEmKfYR2F0XU6sM6/7DIC0YBbLyV
 MX5QFbLCyDudiLvss8fGCQD32CXo8e4nYfx1JBumTV/w/X77mfbY6UyebZYNi21m08QE64l3U
 VTdgBtblvLXtu4TWaZqj6Y/q4LZXbpPUgphps4vK/BEMjrS4LW+anUKD29c0yS8NC3AHHm3KR
 xzTHFGU/Q4VvyKRKaONJffM3AxNmFjBoUH5v2apmiwjF7iXDm5ypXC/Rn2onUU8rXAEkwVrbT
 Fbm/Ex9TppX/xuEMOb9VFYOIqMTJ8QcRvoGjWq0/dsWFxgcdasmTX73ucPPiZ2Vsy8y1iCS0Z
 1fll7/6xnuYB4FKgGBhSMK+XcnVWrNcaN4pROPoA7HGlQwnCPTKzWpkNtKs+/FtdY8rjGWvTG
 avYXyV269I85+BT2ZyM33gQBOw25Syf0G/bAyj+z2hawZjQvWG+fQ6Lc3xl0ZStjE5hgLiQHa
 qM8hElmc+rcefhEiYv9JQTyF9jgSNYfxa05pWhDX0qc03YCm8td/EbgiUwrB7MAc2/RdPq/on
 9F7zWNixLWmoXLusSuGUNzIbNKoPxRzbOKVOQ+IVgEPq9aqofQ2+EGn9e71hwg9/zFqXdTaod
 JOg7s/YiRKOh2BxzY/F8dTRk3JeKyju1gHBPgd3BIPJ4huuC4y6xM+BNjPRpzBnIn3+Pee1Wa
 YzNxaz0TH+L7VUl1DUVQtcdbtJahFyA4c3778PlMNy/ktkM/NRHs2KWfAYz+sOflJkOMGuuQa
 iQxZHFVdN5nzTqQfLE27ES4cLDV/d0soNsopLAYSqlyeuvtrqm3YMdp8cbKjhYykbzOk0XCkP
 yvjHyS9n0YDH0FBMHDB6zA5eLh1UGRf0qxGZZvg9SioQuXGO6sFrEd2sa9wcspeUIsN6aUYNC
 tIEevqAgNLcN6oyVuRMhy07phv5JAfz3fp4ZUQ9EpGLd8DiKlGO0z20IhizluBxMhJmAPFR62
 fqYJnRwJCy6P4Q=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.04.21 13:02, Shawn Guo wrote:
> Instead of aborting country code setup in firmware, use ISO3166 country
> code and 0 rev as fallback, when country_codes mapping table is not
> configured.  This fallback saves the country_codes table setup for recen=
t
> brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
> revision number.
This patch breaks wireless support on RockPro64. At least the access
point is not usable, station mode not tested.

brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4359/9 wl0: Mar=C2=A0 6 2017
10:16:06 version 9.87.51.7 (r686312) FWID 01-4dcc75d9

Reverting this patch makes the access point show up again with linux-5.14 =
.

Regards,
Soeren
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c      | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index f4405d7861b6..6cb09c7c37b6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -7442,18 +7442,23 @@ static s32 brcmf_translate_country_code(struct b=
rcmf_pub *drvr, char alpha2[2],
>  	s32 found_index;
>  	int i;
>
> -	country_codes =3D drvr->settings->country_codes;
> -	if (!country_codes) {
> -		brcmf_dbg(TRACE, "No country codes configured for device\n");
> -		return -EINVAL;
> -	}
> -
>  	if ((alpha2[0] =3D=3D ccreq->country_abbrev[0]) &&
>  	    (alpha2[1] =3D=3D ccreq->country_abbrev[1])) {
>  		brcmf_dbg(TRACE, "Country code already set\n");
>  		return -EAGAIN;
>  	}
>
> +	country_codes =3D drvr->settings->country_codes;
> +	if (!country_codes) {
> +		brcmf_dbg(TRACE, "No country codes configured for device, using ISO31=
66 code and 0 rev\n");
> +		memset(ccreq, 0, sizeof(*ccreq));
> +		ccreq->country_abbrev[0] =3D alpha2[0];
> +		ccreq->country_abbrev[1] =3D alpha2[1];
> +		ccreq->ccode[0] =3D alpha2[0];
> +		ccreq->ccode[1] =3D alpha2[1];
> +		return 0;
> +	}
> +
>  	found_index =3D -1;
>  	for (i =3D 0; i < country_codes->table_size; i++) {
>  		cc =3D &country_codes->table[i];


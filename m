Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56794033A5
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 07:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhIHFJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 01:09:36 -0400
Received: from mout.web.de ([212.227.15.4]:46897 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232364AbhIHFJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 01:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1631077692;
        bh=HD5Uo5oy545G/HclCWF9thUZO6gf1AG7l8gK2j59nkw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=UZ4Xg8zzaFYEWVmwBd64DmSA4V/oAdDY0rl8eZCZYB6v2QsaBzqIa6wQ8gP48NuDI
         AlygNmOWrKdbQIUYcuXW1tEzrEP6z2Bf2Yymgxo4c33xLoDoYc5zNXAFpKVVXBNazp
         DlnTw+YVUUciREC3CQ8hZRsko4rcMD9b0EMbyCK8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.27] ([77.183.4.164]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MJlCO-1mOvkG2CG4-0019nN; Wed, 08
 Sep 2021 07:08:12 +0200
Subject: Re: [BUG] Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as
 fallback
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
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
 <cb7ac252-3356-8ef7-fcf9-eb017f5f161f@web.de> <20210908010057.GB25255@dragon>
From:   Soeren Moch <smoch@web.de>
Message-ID: <100f5bef-936c-43f1-9b3e-a477a0640d84@web.de>
Date:   Wed, 8 Sep 2021 07:08:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210908010057.GB25255@dragon>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:rnZXS+qjfSYuAJB7XUhJsPzp8AYNANO+cxeRGgt00dy1YHCZ5sS
 TFrQkZ63oekGGXn2gipiOTZKBV6oxMU2jgrLlZoMB1OUD17c7HUbYh9p5iW0KmCDbMqPZ0D
 rLIg4tmlPdV1zAwftoNdIBT/GZ8jA+1wFAO+OGtsZ7zZHahY2WnR40ECo//4+IhunhyJi+O
 QvxWy06jDGAjqf5KixroQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MXNMcLnxsX8=:ZvyzPEHMhk5vuazE/XgT66
 xgMYtPgiYFhGbV8SdlbvszMyxr+jydbD14GpeT2jaL4UAZITdWQgs689rUH9QNrFap5w6ppzB
 LqlG77M0Lm0c/VuOJ86vfsgnXsrG6ASpGrlaEKliFe1zkWUQoRs9CeCKLvCBclg0uUkfTb6ks
 P1X2CcGQ9DSldGwMgL68gs2/DYskkWpl+Vkl21JLQP3//Q2p1KD/WBeTvajWcnT/tslAVM0FF
 dDF2f0Lel0TDM6QSsvqc9xGwebwpH+bgm9dMpw/DeKnPHE5x0BYuAiNFtniW8gAG9NBeoTcd0
 4ay0LUADL2zJLQgG7MZ1KMX91UasnCt59K8C9flGd4DEgeVjT/NMjYH1/CH7Ykth1uRqWyeGu
 AGbQ975YMoAsPV/zQRwe5xCiEbBPAm4dn46eRGGVlsIow3xAoqW38VBGFtYHon3B4a4Fq4YLJ
 3lwHmy22AgGplb3h/8dYVBF2PFyCgpHsiP8UFhZUJ368FamUD5GEkCYzXnIzRfNOAHQGMh9JC
 Xu02B8rlzXO4B/y9d194MXl5iPCmOM15kWXm5sd3VHel3gab/EPG6FcM3ibyFdnbT9BY6dgbF
 nXSPVKINBLT7ToRAwwKZ5qYKImncr7ThnU+OTSLc7eI9kF0RAI6hQWrCASlVcyKcJpNRp3gd2
 P2LdOzzMDfN0iIZuiKBkCvmZ/3q1RSYlEesoj1NyppQzfydx2/807bMkKD2/dIr64hlLp7vsb
 IDYMKTAd7RTAzVf+FnUSQ13x9mYP9aUdZjZciAd0OIn7godoMdTihwPAeQ6falShfdP+sYDwK
 ZLI1HVOJgq3w7Q6SqQa9a9LhX7r6IBRECT+9KuklbiX8iY4xSrgmzxXcLYvQ+rkwE3QNNjOYC
 uMEGGJr09TRqB0bWgI/iRVBzLMgEyl1KC+9UZwphB5dg4lfcRbKnFRsMKqGLVQUJWAqUFndBl
 s+ZwadzXL+RInVIa5lVENjD0cJpnzXFjsxuErD3gKOgc8ZTCAHqZidrjUu6BI4/SYATLffTvU
 dGntLsDT1MVZptWsQJiosZD7XV/tkYSabt3FMgcKa6I5EGExhmg4sDGg/VS4hDDtxds1BVyIj
 cHZOR3GwXUlgyzkDrjcZHgSAQbA9gSmj0CF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shawn,

On 08.09.21 03:00, Shawn Guo wrote:
> Hi Soeren,
>
> On Tue, Sep 07, 2021 at 09:22:52PM +0200, Soeren Moch wrote:
>> On 25.04.21 13:02, Shawn Guo wrote:
>>> Instead of aborting country code setup in firmware, use ISO3166 countr=
y
>>> code and 0 rev as fallback, when country_codes mapping table is not
>>> configured.  This fallback saves the country_codes table setup for rec=
ent
>>> brcmfmac chipsets/firmwares, which just use ISO3166 code and require n=
o
>>> revision number.
>> This patch breaks wireless support on RockPro64. At least the access
>> point is not usable, station mode not tested.
>>
>> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4359/9 wl0: Mar=C2=A0 6 2=
017
>> 10:16:06 version 9.87.51.7 (r686312) FWID 01-4dcc75d9
>>
>> Reverting this patch makes the access point show up again with linux-5.=
14 .
> Sorry for breaking your device!
>
> So it sounds like you do not have country_codes configured for your
> BCM4359/9 device, while it needs particular `rev` setup for the ccode
> you are testing with.  It was "working" likely because you have a static
> `ccode` and `regrev` setting in nvram file.
It always has been a mystery to me how country codes are configured for
this device. Before I read your patch I did not even know that a
translation table is required. Is there some documentation how this is
supposed to work? Not sure if this makes a difference, BCM4359/9 is a
Cypress device I think, I added mainline support for it some time ago.

I have installed different firmware files, brcmfmac4359-sdio.clm_blob,
brcmfmac4359-sdio.bin, brcmfmac4359-sdio.txt, the latter also linked as
brcmfmac4359-sdio.pine64,rockpro64-2.1.txt. This probably is the nvram
file. ccode and regrev are set to zero, which probably means
'international save settings".
> But roaming to a different
> region will mostly get you a broken WiFi support.  Is it possible to set
> up the country_codes for your device to get it work properly?
In linux-5.13 it worked, probably with save settings (not all channels
selectable, limited tx power), with linux-5.14 it stopped working, so it
is a regression.
I personally would like to learn how all this is configured properly.
For general use I think save settings are better than no wifi at all
with this patch. This fallback to ISO CC seams to work with newer
(Synaptics?) devices only.

Soeren
>
> Shawn
>
>> Regards,
>> Soeren
>>> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>>> ---
>>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c      | 17 +++++++++++-----=
-
>>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211=
.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> index f4405d7861b6..6cb09c7c37b6 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> @@ -7442,18 +7442,23 @@ static s32 brcmf_translate_country_code(struct=
 brcmf_pub *drvr, char alpha2[2],
>>>  	s32 found_index;
>>>  	int i;
>>>
>>> -	country_codes =3D drvr->settings->country_codes;
>>> -	if (!country_codes) {
>>> -		brcmf_dbg(TRACE, "No country codes configured for device\n");
>>> -		return -EINVAL;
>>> -	}
>>> -
>>>  	if ((alpha2[0] =3D=3D ccreq->country_abbrev[0]) &&
>>>  	    (alpha2[1] =3D=3D ccreq->country_abbrev[1])) {
>>>  		brcmf_dbg(TRACE, "Country code already set\n");
>>>  		return -EAGAIN;
>>>  	}
>>>
>>> +	country_codes =3D drvr->settings->country_codes;
>>> +	if (!country_codes) {
>>> +		brcmf_dbg(TRACE, "No country codes configured for device, using ISO=
3166 code and 0 rev\n");
>>> +		memset(ccreq, 0, sizeof(*ccreq));
>>> +		ccreq->country_abbrev[0] =3D alpha2[0];
>>> +		ccreq->country_abbrev[1] =3D alpha2[1];
>>> +		ccreq->ccode[0] =3D alpha2[0];
>>> +		ccreq->ccode[1] =3D alpha2[1];
>>> +		return 0;
>>> +	}
>>> +
>>>  	found_index =3D -1;
>>>  	for (i =3D 0; i < country_codes->table_size; i++) {
>>>  		cc =3D &country_codes->table[i];


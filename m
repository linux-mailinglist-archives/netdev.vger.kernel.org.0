Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA4F404725
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhIIIll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:41:41 -0400
Received: from mout.web.de ([212.227.15.4]:34745 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231281AbhIIIlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 04:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1631176809;
        bh=TDYtB2JcYZdl2exMRt0DaFOKdnm/cLDcrA9GN52GAs0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fSfy+5e1UPRsu1uF5sKdX2j2N0MwJp8oKakSA3Ghq6orbX06lTOtPVkiWJ99uuhZ0
         NaXpF3Ivxq9zMQqXvRpAqqBJoRl7cYTTVwILl0SIyZaf7l7p0BWVAkvzZ0XJ1Plitt
         UJvfR2yjurGaWnUlIemidx0jAf3QYSK4IYIwIUpg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.27] ([89.14.20.203]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lp7Lg-1mu27Z2Gcm-00esRM; Thu, 09
 Sep 2021 10:40:09 +0200
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
 <100f5bef-936c-43f1-9b3e-a477a0640d84@web.de> <20210909022033.GC25255@dragon>
From:   Soeren Moch <smoch@web.de>
Message-ID: <56e9a81a-4e05-cf5e-a8df-782ac75fdbe6@web.de>
Date:   Thu, 9 Sep 2021 10:39:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210909022033.GC25255@dragon>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:vnwaoO3CKyw/+P4arC4J3P4RilNP9UxvfkXbCFPrAJIrWhE4fas
 zfTZToRbEd21n7qaSwo4h+jRz9xC+YhpWn/OS1t3M8iT/0zs6uO3+S73pyeuhEFRB0IvOU8
 I/94oMJXXOT0uxGH7UlbWA0XteN5tflAjhTgaPnMOWuINuz1mje6JORCp/jsjdKWz5YmVRS
 j9WpQeEtbJMRd8sn+9QrQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cjiZyj6VQ8M=:tS9nCgiRMtk20B3olBKG1G
 i7vEnrFk/td2e6qasyeRW+yOOPCSHYwaz4rHirW+lqUs9RWqgA3bqShbDqrizKkQ8d2BEAMGY
 7p322fSSqg0IybRkY3mvn7LlxG2vO/RoXYw84rGUukD1ui1vjmKHBoK30/m3UGs3k2qoTsVOv
 phcAp28BivYXyRd9qBxIZWvCsh0I6p10x36LC1hioLlglqYS4Og0tJ2lAzJwuqqFd+uxRur6D
 FZS4dpVXZKVaO2qwn9plD7sCxjdFl4ZgmnxoKNg4Mt61kjzeq+L7hhbYn1SwtvC+2gxCRpjI1
 DcO9w8RQC+Nnh8DGzMuS/uF1zhbxQIWrGE6NUCIrLktrwG+8AbMKDPTUJI0wjjCWFVwc3LSF9
 zTBpleJ/25MDG+kWSUHWWdlh+Cmr6KjJzbtK2a4Ot9AQO9TlFy0dM4QmRELgyEkExpF6MNWfU
 KQb/PdJfLxT4VBB0gh44zbC5qf29bgf2z4weP3AMBM0t/PPmCLKtjVTBCP5nzOOd2CHp6cqQb
 lypkay97BJ/w2aTojQ0Mzq4nk9/qaXiayn8ejES+MDrk06mEu+Ujwfxff88o53Zcd8FDnxQuH
 PDDrM9wdxmRScumrFQ2WUL2FZ27hQR+xzz7J4V9jQfn7Z3/FDHb8lQRCrx8EhxDmkx0aaetSK
 lU815ldge1H70AojNkvUpzT2I2uith2lQlmYLyw9kX0EyqzHBEY/2EaPvcmNBi5mgSyyd3jQZ
 xEo5sTR7T8UhLJk1GOkGUxv0dUiMp3fQ8ANdpf3zO4nox5cr56qoNKuzWY8ZjudvMsrg7gw/3
 5BlNOo6DoxMd5OzDRgaXXEht3oRST9umn+9WU4HKVEGcjJHsxlMG9394naDrDaMmRmnsa9Fjs
 U+U4HciMWGkFI9CAJ1UZzunqT56R/ngnqIQbmgLctn7Ds9k1PBj7KYdzc5SxVAqu2P5vf69P+
 5s4IGfTtIXskEft6YUOIFz8I5wW5jrBkiFF1Sy9KWmO+M9M5An4H0uqtfTNvJYNmwAlxgM6YE
 oHxFB1SB9LR8b0enkJDUl3IP+c9SvO8HlhF2RHf3Tp/G9hmsI21jsaN6mMtb5fkbkPV/mPrTf
 TXF4lrIgIyKIz8=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shawn,

On 09.09.21 04:20, Shawn Guo wrote:
> On Wed, Sep 08, 2021 at 07:08:06AM +0200, Soeren Moch wrote:
>> Hi Shawn,
>>
>> On 08.09.21 03:00, Shawn Guo wrote:
>>> Hi Soeren,
>>>
>>> On Tue, Sep 07, 2021 at 09:22:52PM +0200, Soeren Moch wrote:
>>>> On 25.04.21 13:02, Shawn Guo wrote:
>>>>> Instead of aborting country code setup in firmware, use ISO3166 coun=
try
>>>>> code and 0 rev as fallback, when country_codes mapping table is not
>>>>> configured.  This fallback saves the country_codes table setup for r=
ecent
>>>>> brcmfmac chipsets/firmwares, which just use ISO3166 code and require=
 no
>>>>> revision number.
>>>> This patch breaks wireless support on RockPro64. At least the access
>>>> point is not usable, station mode not tested.
>>>>
>>>> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4359/9 wl0: Mar=C2=A0 6=
 2017
>>>> 10:16:06 version 9.87.51.7 (r686312) FWID 01-4dcc75d9
>>>>
>>>> Reverting this patch makes the access point show up again with linux-=
5.14 .
>>> Sorry for breaking your device!
>>>
>>> So it sounds like you do not have country_codes configured for your
>>> BCM4359/9 device, while it needs particular `rev` setup for the ccode
>>> you are testing with.  It was "working" likely because you have a stat=
ic
>>> `ccode` and `regrev` setting in nvram file.
>> It always has been a mystery to me how country codes are configured for
>> this device. Before I read your patch I did not even know that a
>> translation table is required. Is there some documentation how this is
>> supposed to work? Not sure if this makes a difference, BCM4359/9 is a
>> Cypress device I think, I added mainline support for it some time ago.
> One way to add the translation table is using DT.  You can find more
> info and example in following commits:
>
> b41936227078 ("dt-bindings: bcm4329-fmac: add optional brcm,ccode-map")
> 1a3ac5c651a0 ("brcmfmac: support parse country code map from DT")
OK, thanks.
When one way is to use DT, what is the 'traditional way' to add such table=
?

And maybe the more interesting question, where can these settings be
obtained from? The tweaked device specific settings probably from the
device vendor, good luck!
But the general country specific settings, as you are obviously
interested in with your trivial mapping, shouldn't they go into driver
directly? Only to be overruled when device specific settings are
available via DT? And of course only for device/firmware combinations
that support this general mapping, so that other devices with 'unknown
mapping' are not broken by this enhancement?
>> I have installed different firmware files, brcmfmac4359-sdio.clm_blob,
>> brcmfmac4359-sdio.bin, brcmfmac4359-sdio.txt, the latter also linked as
>> brcmfmac4359-sdio.pine64,rockpro64-2.1.txt. This probably is the nvram
>> file. ccode and regrev are set to zero, which probably means
>> 'international save settings".
> I'm not sure how this 'international save settings' works for brcmfmac
> devices.  Do you have more info or any pointers?
The correct term in this context probably is 'world regulatory domain',
the most restrictive wifi settings that can be used all over the world.
This usually is taken as default by cfg80211, apparently also for
(some?) brcmfmac devices/firmwares.

These 'world' settings can be replaced by more permissive country
specific regulatory domain settings, but for brcmfmac devices this seems
to be firmware specific and requires this country mapping.

I have seen a country code "00" for the world regulatory domain in the
past, not sure if this is standard or a device/driver/software specific
hack and if this can be used for brcmfmac (mapping from string "00" to
country_code=3D0 ?). For sure here are more experienced wifi developers
who know better.
>>> But roaming to a different
>>> region will mostly get you a broken WiFi support.  Is it possible to s=
et
>>> up the country_codes for your device to get it work properly?
>> In linux-5.13 it worked, probably with save settings (not all channels
>> selectable, limited tx power), with linux-5.14 it stopped working, so i=
t
>> is a regression.
>> I personally would like to learn how all this is configured properly.
>> For general use I think save settings are better than no wifi at all
>> with this patch. This fallback to ISO CC seams to work with newer
>> (Synaptics?) devices only.
> I do not mind you send a reverting if you have problem to add a proper
> translation table for your device.  But that would mean I have to add
> a pretty "meaningless" translation table for my devices :(
>
Is this not the usual DT policy, that missing optional properties should
not prevent a device to work, that old dtbs should still work when new
properties are added?

I'm not sure what's the best way forward. A plain revert of this patch
would at least bring back wifi support for RockPro64 devices with
existing dtbs. Maybe someone else has a better proposal how to proceed.

Regards,
Soeren


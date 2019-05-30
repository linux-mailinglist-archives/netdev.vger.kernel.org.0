Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D502FF59
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfE3PWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:22:33 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:36002 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfE3PWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1559229750;
        s=strato-dkim-0002; d=romanh.de;
        h=Date:Message-ID:Subject:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=rLWvWEwDWT/aCVeMJ94Q7phuV+T2pDmK5wi2NVP8ZaQ=;
        b=SmYC3lvN2ddfCheqpDPAoZ2b9pDSU+zfxiLmYYT2gdAihS8zRQzWJZufVQgq0s2C9W
        /3YB71TZ8N3+1cvb8EYB5it6FeRknN3bA9tNRraswS/4nISpE1hBItMUrEejGA9+is0A
        7WP7evDsc19QeepEl/pYYcCWT/KHVBPa3v+Tm26Oe1TquvSh2oTBqhE/cQjYzEXdyloe
        203yyNRVF3e3UsYDvJNQenbqs2twIbGyLk9F9wM+a4ZM2m7impRexXaAEMsVIehori4g
        UDL2OGO7QWStQXeeFyyxrtHwb1fI10A8FU38qIyMcIS84vrXgDl3JZVENM3ekE7txucH
        o8uA==
X-RZG-AUTH: ":IW0NeWC6dPKGmaqnvJQvmGcPCmfSXfuocDNyu8aIRIC/sau4VPmRAYfaAZyQfAmjdTI="
X-RZG-CLASS-ID: mo00
Received: from [192.168.0.100]
        by smtp.strato.de (RZmta 44.21 SBL|AUTH)
        with ESMTPSA id J004c3v4UFJExeC
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <netdev@vger.kernel.org>;
        Thu, 30 May 2019 17:19:14 +0200 (CEST)
From:   Roman Hergenreder <mail@romanh.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mail@romanh.de; keydata=
 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
To:     netdev@vger.kernel.org
Subject: Gigabit Ethernet r8168/r8169
Message-ID: <9e29fadf-a440-b67e-80b9-989760daea0b@romanh.de>
Date:   Thu, 30 May 2019 17:19:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: multipart/encrypted;
 protocol="application/pgp-encrypted";
 boundary="iXysAAY3oeQ1BwSLUvlArsyVVe6PFXlGe"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME encrypted message (RFC 4880 and 3156)
--iXysAAY3oeQ1BwSLUvlArsyVVe6PFXlGe
Content-Type: application/pgp-encrypted
Content-Description: PGP/MIME version identification

Version: 1

--iXysAAY3oeQ1BwSLUvlArsyVVe6PFXlGe
Content-Type: application/octet-stream; name="encrypted.asc"
Content-Description: OpenPGP encrypted message
Content-Disposition: inline; filename="encrypted.asc"

-----BEGIN PGP MESSAGE-----

hQIMA+lU2JtPBAmOAQ//cX+0Bb7oMumwj8a5iOGWUfFV0cUBzSc6zRUJIDZFvqF+
VzROt4I1SUYmzlcmRZ/wfu5CvRgZwb2hqFU60adMzigVKWIRNYYbl0mWFpM20z9a
cT6TRCiCcAe9BWFzC9UHnYxRtiZhRiKk01JSabTU0u39jLEJnXcmrxtamhmcGmMT
lsTMmaBzqYZwewPlcYdi96VEEz5DHvdppV0HaaWIsK40FbQkrEu0IMTE7bjYNmLE
fKC0D1FLcVsxPQ/yhdHqe7vf95hADrh0dN3AuUccw6boTMOcAf8mzE19APMBnxlf
R+gqPJ6SUWAzEZcQeoE5WqPsUVmSUhHa3Y21Kb93CqQd27mpByJNsuH7rXk6l6x3
M0mb0RmnkIfVlROFBdAclX2oAGgLoED7D9Y9QkIYMIkJJTa2S6eH0pyMJ06Urq8V
KBUdAK9IfAk7UTiz+7nvg9wm5IIg21ABv/UcZA35AMbmExY0yct/BpyPk1IgsKO7
FlxShwwCzb6OQ+ahC7HUhvZL7/vif05CVBKoj8KLP/3qqqFiZdW5bLWaK1hhCj30
eMBrZdhfmzNYUKqI4OvRTK1YGu0qVY8xTfHLcbuDLO5KQLmMUDmhSqDPuiyMbmfj
z6j0fKNpQPx3/pYu8lw0HsQPwauHBv5uqc1LszxEkziMU47KlFJrEK9dKaFqzv7S
6gFsJ4zXRVxj4KRHjOay6aIoye0Aaj/5XBg4kqxsGOHAHONgACVZzdyA86SqN7O2
GC1XtxE88L4xzxf6s2bz08rcuoMdnLqx77OzQOBT6JTi61hP0BWC3na2PcEpaHX8
Jr6IgTKTkO0jHJ0i9iKq42PIKTykk4mPxzcZc1lO3raNzBUBeaxKXYppSybRBHu/
Q/j+3KayGan793CAsgoyq2w56E3DZhIPWZzaykVMFbuFdOR5jVPXFJWMnr79Nd92
psMdj83Lwrq8JL3/tgoRAJWcYUD2uRYWmGF5JlvWwRENS/kCbKHvQ7bUn/PdQ/Vw
ARyAwcv/m3xaUm4TbVB2xLfP0JWPyQYK9cfnYFDXeygH+TUpLldGuk4/u2fcZ9++
AUK1hFOoOhrBmtqLwa3tfGm2ciFpmb7QiRtm2WBOlm79UfuVN/AEBxY9HAfo2kPP
CE17YXBDMzI8n78UczSs2KfCy4QiSVN7TQUD0EqGXHPXSTt4S0egWzhUidY3ADhb
TvO8HjF90KkfqAqC0O0yEj47RafQviAUtymr2KwcmiHwJLvFleXAAjctd+biuoVH
WA9f2x9wcFIqaKjhdpaDPdijAWcJiZV6g1MbPJyuuG5So898I8FxqADumDSma+4d
KRkegiQl9jdF66Ek6tj+SALyv/oveoKQoIKHxjHG6/Df3mBlIYy/PhYdj+EFG78d
j9X//OCjFzwloEfH2mRM/jUtBTqW1zD27sELE5Y61sJ0GGUb1zdH6hU/Nzm+CfDH
BkbBrTXAxWbO93AYi6rcb2FV+jp3yknjZhKiQI+FtqW+Lwx2D0IA85ZstUz+UtTz
PeyC5bE5c6JMMMvYhsEquVJPkxnzhfzqNVTdrP0/5xfOm9fRSf2aVLHJMXVzL5Th
VUEl5yxGFmme8PAUr3FtIOkXm5ntHH2eyNDOWVXU5AK+lhhFEAUMVGKTY72oydPY
PEI65rYpey2f07PjhgzwWGcOo+rFJHQTow0V6qIdsUFM/3eJF7fNQLFYyRQX9Tis
8hBCkAkRpXuqCtUBtkD1L1M0/SHWjm9X6L67Q8i+BYlTHsRfkN9bQgEMym/wbEP+
4ppWykJmLFgJna1IoiDqus/I8o4ouORHYgs6Xbkk5hdOltRvakMhLVsYNR7s+fK8
A3dnliztBudxdtjWsLzmjlmhc2DvFu83a6WI8NgrmhEPcXjRmnWf0fOPgSv3CP2t
Dbl8PzeHQ6GL5+XlYbMBeVpwUFj8O38/HIKX3gIWJeRXKs9kLsycqZKD7A9i+ULG
p6qPiFAZdyeEvTn2SzYzRvKNs486LgbTAFfBODLLB60BjFVqK9i+Hi4lQybyEL5k
+nQEqDjd36ZmHjZ7fB48yDHA+09Dbm6HA2T/Ajsd4rbSTfkN/wlxxojuky+lcaT9
mTSMdhreGEb9AcM+OeFl3XKoD0O7oAwbXE3WtNyfMxiU7S2ekCv+bQSnq33HG5o8
ru4SKbZDXMVkEcnrbWYbKJbnOYCKyfzsEGnKVkKnZnno2qUR9Sw34MjCrFsN3WBs
Nz5XHHHcuerYeRqgHTHiWPNL+eZ8sY8Clsno7zmwj/QsibgSBB1//gQqYTW/oBIg
5i7zLJewOFHbpoMrwxKhebeZJVq0gc/lu7CzGpG5sUg2NezuRpNLSQk/57L0BDrR
7icHKU7VMvtYbjaCgwOD7YgAobjpgcfgfUVZY6LIzWIrmLr5v3wugILk/Ad7YsLg
wbXYqz6k+6NAOCSCxskQCa9/jwuq1nVqWIGQbnaPu8UJYImmd7ofQoi0lihJ+HDu
USikBQ0KGslKRBdSLfV+2hG4ZHMS1vzYpsMliWS53RJaGHMNPX04yixtK3KTrnSk
T9X+hibaCDJJh+ARvQyK7jwGp8XzLfc3dpLlpAFU0m//7B1lm+7+GK02IRW/2k7r
lZKWHZR8xBu03ByEF0p08JjIhakXlA3Pt7IoQrE/
=J6b7
-----END PGP MESSAGE-----

--iXysAAY3oeQ1BwSLUvlArsyVVe6PFXlGe--

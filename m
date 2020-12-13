Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BC42D8E71
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393408AbgLMPyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 10:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgLMPyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 10:54:47 -0500
X-Greylist: delayed 956 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Dec 2020 07:54:06 PST
Received: from netz.smurf.noris.de (dispatch.smurf.noris.de [IPv6:2001:780:107:b::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3844C0613CF;
        Sun, 13 Dec 2020 07:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=urlichs.de;
         s=20160512; h=Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
        Cc:From:References:To:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LJWXCEfxtI2qDeR9POKxoNUdzhb5BH2bTWUe2QtE1lM=; b=aR//YVsVdq12wxfympYi3GfKQE
        GGp0DR743GDZYoYwXKavhPnN5dqpZCpLVX+xD9uGPEZ3fYpg6Vss7demctLh+mNSvp0ou9vJSksZO
        Bm1bTJlA+5bSB+xHbXz6f1vy/jrOu1luyp+ttObAGlM5Z0+Ll3I4HhRVuqpVGkYjQM8PAkPFEVPz+
        ttPIpX5piIClNVfzgL+no2zlJjcUKzeOnUGBI9mLMbZZv/BrI21JymOYYSpmT14IAJqrg2Op6Zakv
        +ktVDLNrRvp3qsDCLs/IHX8y1r+pnkpGdxTrqPituHLWJegB+X2bR/Cil+0sSNdn6pca7YBjfyIs3
        4+r5a8taN1sGLqAPAxtTEX5+MVRNR2B/JoagcoWyclyt7sOXYMpML+XYjAc5v8/H63Q2KL08Dhbiz
        VuEtQelaYvFYASrBjkQE5lk0dZqPgYwCLfVg0he21btNOtVrpkN6O4g5qpbJZq+IsflHuv2bFL5rZ
        oAIgNosJ9NKpSsglpThWhfm/WLxPT/oH+SXfJ4wG8Q+VvNERkZaq51MdZ1l29w5D8hCb+VQu7dxBc
        S43FUHOrc1Ff6ue12UnN1YDfVggDWfSoEbpA6gVrrQWD5Ojryn31LoL3p8EUDznZKLP0SXIoZHv/4
        nh+yWdBMCyVLP41wph2gBGr+je4+ibLl9WU6BAPQ8=;
Received: from asi.s.smurf.noris.de ([2001:780:107:200::a])
        by mail.vm.smurf.noris.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <matthias@urlichs.de>)
        id 1koTRI-000BBG-93; Sun, 13 Dec 2020 16:37:36 +0100
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20201128193335.219395-1-masahiroy@kernel.org>
 <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>
From:   Matthias Urlichs <matthias@urlichs.de>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
Message-ID: <f5c2d237-1cc7-5a78-c87c-29b7db825f68@urlichs.de>
Date:   Sun, 13 Dec 2020 16:37:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0bdZizaKkR1RRcy81CAwRurahlx0BShKc"
X-Smurf-Spam-Score: 0.0 (/)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0bdZizaKkR1RRcy81CAwRurahlx0BShKc
Content-Type: multipart/mixed; boundary="UUmMppQ0TtM1nbyb9GJXrF53J0jYOCzmm";
 protected-headers="v1"
From: Matthias Urlichs <matthias@urlichs.de>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Greg KH <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Masahiro Yamada
 <masahiroy@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Nathan Chancellor <natechancellor@gmail.com>,
 Nick Desaulniers <ndesaulniers@google.com>, Shuah Khan <shuah@kernel.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>, wireguard@lists.zx2c4.com
Message-ID: <f5c2d237-1cc7-5a78-c87c-29b7db825f68@urlichs.de>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
References: <20201128193335.219395-1-masahiroy@kernel.org>
 <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>
In-Reply-To: <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>

--UUmMppQ0TtM1nbyb9GJXrF53J0jYOCzmm
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: de-DE

Miguel Ojeda wrote:
> I think we can fix them as they come.

If your change to a function breaks its callers, it's your job to fix=20
the callers proactively instead of waiting for "as they come" bug=20
reports. (Assuming, of course, that you know about the breakage. Which=20
you do when you tell us that the bad pattern can simply be grepped for.)

If nothing else, that's far more efficient than [number_of_callers]=20
separate patches by other people who each need to find the offending=20
change, figure out what to change and/or who to report the problem to,=20
and so on until the fix lands in the kernel.

Moreover, this wouldn't leave the kernel sources in a non-bisect-able=20
state during that time.

--=20
-- Matthias Urlichs



--UUmMppQ0TtM1nbyb9GJXrF53J0jYOCzmm--

--0bdZizaKkR1RRcy81CAwRurahlx0BShKc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEENzGcEL8EYxehRDgJ+GyybHbBwWUFAl/WNT8FAwAAAAAACgkQ+GyybHbBwWWQ
/Q/5Admk46b0U6/UaWBUvAy/2onXR+LSpg8kaKfHNHgWtiBlVCLskfttGkO7vkAlF7chabDO425F
JIa+zZmAelvHYTsKXba5xLmuX4CyA/tUUgBJH5l4f31Ywev0NyOd/tHaXstN1YgCXRNuiVLPrMU2
nAIhS2F+cX37C6jl8SayIy8+PKfSUR3sshRnIceEW8cTeqvnogGxr++UJKE8ShUTdgg4BVqIvJ6r
K39mfn/kAFtVQ9aT5vFHuvJJDUn+el4fQlkID77uWgIPBHqEBUuQQkxV3JCWH8rdgKXlowdlqHWU
m7ID6nhnJy0h+GfZTJhj1MQuO92M2lRq5x1aeQMP2EVp3n+fIzrjharn1CJerFRuv7aymt+QF8ZH
EUga+0tMg+DFGsQaQcFbyWwflluKj6++KSH69Bfh7ZFxop9X4v1aPO1GALUymM4CwcC9KO2hpMG9
q0iZWUu/nw7yJo30b8wrjQykL0xRonbrHYrkhbMy1v6DsZdvk4wdsuQUu76OSs+eYzY9VZv9vLKE
LOHQiHjKRndnm871eDFw0W17avE6MxLlMRaW6Qk1YnkTuuywih8XFdddTJuuMf0eFU/GdYbyo6Pa
rmiaTWPRHvwVYYq5h8jrnDSz1TpZGqSFcfE+2ZtLu3bUfj+NsGymwUI4/IegRlmkJ6uaEd7p4rB+
SUM=
=vTgV
-----END PGP SIGNATURE-----

--0bdZizaKkR1RRcy81CAwRurahlx0BShKc--

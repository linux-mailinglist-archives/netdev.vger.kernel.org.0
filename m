Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E45C6AC119
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjCFNcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjCFNcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:32:10 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36C42F789;
        Mon,  6 Mar 2023 05:32:01 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so5644464wms.0;
        Mon, 06 Mar 2023 05:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678109520;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63Ix+yRqI271KmuKByZdgzfOI0reMM5z9wla+hPerdw=;
        b=ElqWY+dKygPyFaXXLubo0Hn4m/HOQfIiNaCG8L3/oYg8hDAkXnCqOqIDlanWZa8Ad8
         ptttH+zgHnDKH4AAhbHlCwHToJKGdOScuqW6sEX4Q7sDu+EBe+QWfYyeyxyECA+tOSgt
         eKXOTE2M8ihOKjOKfcJyc3vbzQ+FDGl0aFvtSnjV09AkqPcRH+zwgpjvkd9vdnHtKhQe
         91ReEJ8IsPrkED/vO1/5Ah9YSOENa5IJg/PCmyWMyz4pchj+fcSDEnY01CcCCypYsRJA
         MRbZmvWRCY74ESAqJ2nHEJgcatOeaAlgKlazExKM/+066qDJhFPG+/q//Se8gJ+w1o67
         bL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678109520;
        h=in-reply-to:references:cc:to:from:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=63Ix+yRqI271KmuKByZdgzfOI0reMM5z9wla+hPerdw=;
        b=jUYlPZ6Ftkpjd9rIiXnv6tSfi/+lLcVIm92p8cfZli8LdAxyOG5RpUD9dsdd1rDsC6
         nZjTKTAdon7aQausw/4kP9DEVXhMKY2Rg5PzoxC64E3ykjlQQK6i/Li63idcz2Pnd+go
         BoOP1CvB/h0HRrjMEhKevuxYGDwr6Jq85j0nrybMwoAWk5uB+k2MLnppQ/CLVARCPMRc
         l3EM4A2/PytKihu3P1Rg72y1Ibg4WM9yB6TUO2M+im0mUCiCVT8D1AvuHIt8WWeVZRlO
         6SSYIx2sUZzSvy7/21ykBIDtYtOeAkUW7XVEeBWp2zCXPno7FJgJphVQYSE+DXbCqQFu
         3aqw==
X-Gm-Message-State: AO0yUKWCdVSm3QWv7pENmjL5/QEdMek7zgJXWzPzN/oDTCh3Xs0aH57N
        0qovuHsIRZh+MM6vLQKinao=
X-Google-Smtp-Source: AK7set9MNEbTf9I01LS3aiPmmUNVd61QtAtliFJe1ly9z5+eyb3wt7hbVt/mPih8YR+xj8BowASakQ==
X-Received: by 2002:a05:600c:4449:b0:3df:e659:f9d9 with SMTP id v9-20020a05600c444900b003dfe659f9d9mr8600677wmn.34.1678109520335;
        Mon, 06 Mar 2023 05:32:00 -0800 (PST)
Received: from [192.168.0.160] ([170.253.51.134])
        by smtp.gmail.com with ESMTPSA id n5-20020a5d4c45000000b002c55306f6edsm9557273wrt.54.2023.03.06.05.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:32:00 -0800 (PST)
Message-ID: <c78f6a59-dac4-e5ce-cef6-533ad0cdbcac@gmail.com>
Date:   Mon, 6 Mar 2023 14:31:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
Content-Language: en-US
From:   Alejandro Colomar <alx.manpages@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-man@vger.kernel.org
Cc:     pabeni@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
 <d204f477-2655-57f6-c44c-cbe15f991933@gmail.com>
In-Reply-To: <d204f477-2655-57f6-c44c-cbe15f991933@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0g0urM1vIn0lnB1KzMJZgUmr"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0g0urM1vIn0lnB1KzMJZgUmr
Content-Type: multipart/mixed; boundary="------------xBdePX8SQIfKy9dKkObel3Ve";
 protected-headers="v1"
From: Alejandro Colomar <alx.manpages@gmail.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 linux-man@vger.kernel.org
Cc: pabeni@redhat.com, netdev@vger.kernel.org,
 Willem de Bruijn <willemb@google.com>
Message-ID: <c78f6a59-dac4-e5ce-cef6-533ad0cdbcac@gmail.com>
Subject: Re: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
 <d204f477-2655-57f6-c44c-cbe15f991933@gmail.com>
In-Reply-To: <d204f477-2655-57f6-c44c-cbe15f991933@gmail.com>

--------------xBdePX8SQIfKy9dKkObel3Ve
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 3/6/23 14:30, Alejandro Colomar wrote:
> Hi Willem,
>=20
> On 3/2/23 16:48, Willem de Bruijn wrote:
>> From: Willem de Bruijn <willemb@google.com>
>>
>> UDP_SEGMENT was added in commit bec1f6f69736
>> ("udp: generate gso with UDP_SEGMENT")
>>
>>     $ git describe --contains bec1f6f69736
>>     linux/v4.18-rc1~114^2~377^2~8
>>
>> Kernel source has example code in tools/testing/selftests/net/udpgso*
>>
>> Per https://www.kernel.org/doc/man-pages/patches.html,
>> "Describe how you obtained the information in your patch":
>> I am the author of the above commit and follow-ons.
>>
>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>>
>=20
> It doesn't apply.  Can you please rebase on top of master?

Oops, sorry, I tried to apply 1/2 twice, instead of 1/2 and 2/2 :-)
Ignore that.

Cheers,

Alex
>=20
> Thanks,
>=20
> Alex
>=20
>> ---
>>
>> Changes v1->v2
>>   - semantic newlines: also break on comma and colon
>>   - remove bold: section number following function name
>>   - add bold: special macro USHRT_MAX
>> ---
>>  man7/udp.7 | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/man7/udp.7 b/man7/udp.7
>> index 5822bc551fdf..6646c1e96bb0 100644
>> --- a/man7/udp.7
>> +++ b/man7/udp.7
>> @@ -204,6 +204,34 @@ portable.
>>  .\"     UDP_ENCAP_ESPINUDP draft-ietf-ipsec-udp-encaps-06
>>  .\"     UDP_ENCAP_L2TPINUDP rfc2661
>>  .\" FIXME Document UDP_NO_CHECK6_TX and UDP_NO_CHECK6_RX, added in Li=
nux 3.16
>> +.TP
>> +.BR UDP_SEGMENT " (since Linux 4.18)"
>> +Enables UDP segmentation offload.
>> +Segmentation offload reduces
>> +.BR send (2)
>> +cost by transferring multiple datagrams worth of data as a single lar=
ge
>> +packet through the kernel transmit path,
>> +even when that exceeds MTU.
>> +As late as possible,
>> +the large packet is split by segment size into a series of datagrams.=

>> +This segmentation offload step is deferred to hardware if supported,
>> +else performed in software.
>> +This option takes a value between 0 and
>> +.BR USHRT_MAX
>> +that sets the segment size:
>> +the size of datagram payload,
>> +excluding the UDP header.
>> +The segment size must be chosen such that at most 64 datagrams are se=
nt in
>> +a single call and that the datagrams after segmentation meet the same=
 MTU
>> +rules that apply to datagrams sent without this option.
>> +Segmentation offload depends on checksum offload,
>> +as datagram checksums are computed after segmentation.
>> +The option may also be set for individual
>> +.BR sendmsg (2)
>> +calls by passing it as a
>> +.BR cmsg (7).
>> +A value of zero disables the feature.
>> +This option should not be used in code intended to be portable.
>>  .SS Ioctls
>>  These ioctls can be accessed using
>>  .BR ioctl (2).

--=20
<http://www.alejandro-colomar.es/>
GPG key fingerprint: A9348594CE31283A826FBDD8D57633D441E25BB5

--------------xBdePX8SQIfKy9dKkObel3Ve--

--------------0g0urM1vIn0lnB1KzMJZgUmr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6jqH8KTroDDkXfJAnowa+77/2zIFAmQF604ACgkQnowa+77/
2zL13Q/+N760EX/S7Gswn2PaEDl0RzaqgWak1Qh+iyrgCxSrbko/4b4qcKsBsjD9
VPKCxB2WVF1HbRX9EjD6sM1mjHyeAaeSmn0IMsp9tO/o5a4bX45cfxjOcjtCCBDa
caGSSt7QAyMrLssFP/L7qEmlki6gdo3fPY33CrFubtbfHYv4Vdqx2LYdNR4j64lL
Tla6+dRUByvznvomHg77s0rR1IBCsiykZTgJJ3vxCLI56Aw6OVJBnlCzoawuofFs
Xwa02oH/bFy2eDXwS2BWWUzSuaJNFzgVH5kcIbows8pA+CmFh8o8v0TYbrwDnjpk
gR+isV0BhWkoKH5FmQfaXJqwvJex8rCCB6q7O57+rraYCohC/Ph9lVQcTVbZkGhI
6/umBpSBaTe6lz1Nm1FjPC2HKgLVuDRoiN3ghAZBQqXaSNt6Z8x8rltJDJnx999C
E5OxKab+U0f3s5esPiL8SeO7SAJPm2RRd3onRHbbbgtRhcdkRijb6G5toFC9qd99
fzsYQH4u3dfVnOhp8rBmcwic3c1BOlYd1al9C7UD0Q8kRN0aLhjtaTnP8pO0cKZW
8mRh5T9RQ7f0CxcgPXoAtlQgH3hifbN12ArA0MXbu+NDZztWlq2MACBJkhhFVK3w
O//hFpq8L/ez+0ykj0zCFFxdHzcvNUCbSkiQVJV+6Y1AbcxqAMU=
=fIcH
-----END PGP SIGNATURE-----

--------------0g0urM1vIn0lnB1KzMJZgUmr--

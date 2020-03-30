Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27FA197497
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgC3Gez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:34:55 -0400
Received: from unicom145.biz-email.net ([210.51.26.145]:4492 "EHLO
        unicom145.biz-email.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgC3Gey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:34:54 -0400
Received: from ([60.208.111.195])
        by unicom145.biz-email.net (Antispam) with ASMTP (SSL) id WJM24249;
        Mon, 30 Mar 2020 14:34:49 +0800
Received: from jtjnmail201605.home.langchao.com (10.100.2.5) by
 jtjnmail201601.home.langchao.com (10.100.2.1) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1591.10; Mon, 30 Mar 2020 14:34:47 +0800
Received: from jtjnmail201605.home.langchao.com ([fe80::8d20:4cc5:1116:d16e])
 by jtjnmail201605.home.langchao.com ([fe80::8d20:4cc5:1116:d16e%8]) with mapi
 id 15.01.1591.008; Mon, 30 Mar 2020 14:34:47 +0800
From:   =?utf-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
To:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
CC:     "yang_y_yi@163.com" <yang_y_yi@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "u9012063@gmail.com" <u9012063@gmail.com>
Subject: =?utf-8?B?562U5aSNOiBbdmdlci5rZXJuZWwub3Jn5Luj5Y+RXVJlOiBbdmdlci5rZXJu?=
 =?utf-8?B?ZWwub3Jn5Luj5Y+RXVJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldC8gcGFja2V0?=
 =?utf-8?B?OiBmaXggVFBBQ0tFVF9WMyBwZXJmb3JtYW5jZSBpc3N1ZSBpbiBjYXNlIG9m?=
 =?utf-8?Q?_TSO?=
Thread-Topic: =?utf-8?B?W3ZnZXIua2VybmVsLm9yZ+S7o+WPkV1SZTogW3ZnZXIua2VybmVsLm9yZw==?=
 =?utf-8?B?5Luj5Y+RXVJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldC8gcGFja2V0OiBmaXgg?=
 =?utf-8?Q?TPACKET=5FV3_performance_issue_in_case_of_TSO?=
Thread-Index: AQHWA+aSLN6AksYfW02nnu4zyQBP0ahdq27AgAAmOICAAQLmoIABCQSAgADSWRA=
Importance: high
X-Priority: 1
Date:   Mon, 30 Mar 2020 06:34:47 +0000
Message-ID: <934640b05d7f46848ba2636fcc0b1e34@inspur.com>
References: <2786b9598d534abf1f3d11357fa9b5f5@sslemail.net>
 <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
 <25b83b5245104a30977b042a886aa674@inspur.com>
 <CAF=yD-LAWc0POejfaB_xRW97BoVdLd6s6kjATyjDFBoK1aP-9Q@mail.gmail.com>
 <31e6d4edec0146e08cb3603ad6c2be4c@inspur.com>
 <CA+FuTSfG2J-5pu4kieXHm7d4giv4qXmwXBBHtJf0EcB1=83UOw@mail.gmail.com>
 <de32975979434430b914de00916bee95@inspur.com>
 <CA+FuTSe6vkWNq03zxP9Cbx4oj38sf1omeajh5fZRywouyADO6g@mail.gmail.com>
 <d81dbd7adfbe4bf3ba23649c5d3af59f@inspur.com>
 <CA+FuTScQfrHFdYYuwB6kWezPLCxs5dQH-hk7Vt9D4SQLzcbLXg@mail.gmail.com>
In-Reply-To: <CA+FuTScQfrHFdYYuwB6kWezPLCxs5dQH-hk7Vt9D4SQLzcbLXg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.1.52]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=SHA1; boundary="----=_NextPart_000_04F5_01D606A0.5C1CBE90"
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

------=_NextPart_000_04F5_01D606A0.5C1CBE90
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

-----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
=E5=8F=91=E4=BB=B6=E4=BA=BA: Willem de Bruijn =
[mailto:willemdebruijn.kernel@gmail.com]=20
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B43=E6=9C=8830=E6=97=A5 =
9:52
=E6=94=B6=E4=BB=B6=E4=BA=BA: Yi Yang =
(=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 =
<yangyi01@inspur.com>
=E6=8A=84=E9=80=81: willemdebruijn.kernel@gmail.com; yang_y_yi@163.com; =
netdev@vger.kernel.org; u9012063@gmail.com
=E4=B8=BB=E9=A2=98: Re: [vger.kernel.org=E4=BB=A3=E5=8F=91]Re: =
[vger.kernel.org=E4=BB=A3=E5=8F=91]Re: [PATCH net-next] net/ packet: fix =
TPACKET_V3 performance issue in case of TSO

> iperf3 test result
> -----------------------
> [yangyi@localhost ovs-master]$ sudo ../run-iperf3.sh
> iperf3: no process found
> Connecting to host 10.15.1.3, port 5201 [  4] local 10.15.1.2 port=20
> 44976 connected to 10.15.1.3 port 5201
> [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
> [  4]   0.00-10.00  sec  19.6 GBytes  16.8 Gbits/sec  106586    307 =
KBytes
> [  4]  10.00-20.00  sec  19.5 GBytes  16.7 Gbits/sec  104625    215 =
KBytes
> [  4]  20.00-30.00  sec  20.0 GBytes  17.2 Gbits/sec  106962    301 =
KBytes

Thanks for the detailed info.

So there is more going on there than a simple network tap. veth, which =
calls netif_rx and thus schedules delivery with a napi after a softirq =
(twice), tpacket for recv + send + ovs processing. And this is a single =
flow, so more sensitive to batching, drops and interrupt moderation than =
a workload of many flows.

If anything, I would expect the ACKs on the return path to be the more =
likely cause for concern, as they are even less likely to fill a block =
before the timer. The return path is a separate packet socket?

With initial small window size, I guess it might be possible for the =
entire window to be in transit. And as no follow-up data will arrive, =
this waits for the timeout. But at 3Gbps that is no longer the case.
Again, the timeout is intrinsic to TPACKET_V3. If that is unacceptable, =
then TPACKET_V2 is a more logical choice. Here also in relation to =
timely ACK responses.

Other users of TPACKET_V3 may be using fewer blocks of larger size. A =
change to retire blocks after 1 gso packet will negatively affect their =
workloads. At the very least this should be an optional feature, similar =
to how I suggested converting to micro seconds.

[Yi Yang] My iperf3 test is TCP socket, return path is same socket as =
forward path. BTW this patch will retire current block only if vnet =
header is in packets, I don't know what else use cases will use vnet =
header except our user scenario. In addition, I also have more =
conditions to limit this, but it impacts on performance. I'll try if V2 =
can fix our issue, this will be only one way to fix our issue if not.

+
+       if (do_vnet) {
+               vnet_hdr_ok =3D virtio_net_hdr_from_skb(skb, &vnet_hdr,
+                                                     vio_le(), true, =
0);
+               /* Improve performance by retiring current block for
+                * TPACKET_V3 in case of TSO.
+                */
+               if (vnet_hdr_ok =3D=3D 0 && po->tp_version =3D=3D =
TPACKET_V3 &&
+                   vnet_hdr.flags !=3D 0 &&
+                   (vnet_hdr.gso_type =3D=3D VIRTIO_NET_HDR_GSO_TCPV4 =
||
+                       vnet_hdr.gso_type =3D=3D =
VIRTIO_NET_HDR_GSO_TCPV6)) {
+                       retire_cur_frame =3D true;
+               }
+       }
+


------=_NextPart_000_04F5_01D606A0.5C1CBE90
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
SIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQUwS9Wt2AmUPVKr98VTbaf
wjdIUXAwHwYDVR0jBBgwFoAUXlkDprRMWGCRTvYetaU5pjLBNWowgdEGA1UdHwSByTCBxjCBw6CB
wKCBvYaBumxkYXA6Ly8vQ049SU5TUFVSLUNBLENOPUpUQ0EyMDEyLENOPUNEUCxDTj1QdWJsaWMl
MjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWhvbWUsREM9
bGFuZ2NoYW8sREM9Y29tP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFz
cz1jUkxEaXN0cmlidXRpb25Qb2ludDCBxAYIKwYBBQUHAQEEgbcwgbQwgbEGCCsGAQUFBzAChoGk
bGRhcDovLy9DTj1JTlNQVVItQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENO
PVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y0FD
ZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwQwYDVR0R
BDwwOqAjBgorBgEEAYI3FAIDoBUME3lhbmd5aTAxQGluc3B1ci5jb22BE3lhbmd5aTAxQGluc3B1
ci5jb20wDQYJKoZIhvcNAQELBQADggEBAApWKZfwQ5Gbpv3Pg2mJyUz8jhno5OBy2Hdku/euDQfD
aOOPsUxsvr8ZnWU03E9rwTAHgD9oB10Oe27CNeS6G/kqJubOZt5Emrw9EJBA6NMz4GLZYPmm82ph
l+1iajL8+U2fINJbqvTlj9Dv0VOzW+952fk9K5JiArDhWskKRLnO31YAESFfUUKaHe54l2u+2+cn
MeuQyyNOGXu2zT0XicYRUsZBOCisXzLD6I9/LgyBcqWcpLBdRK1JdO/oih2/uznyWUp1pCvpi89r
SmyUUdbfFd/FN0j8Qok4ZdKwoHNj3oi+vLaN8SHmUNHISOuUZyWcmfVzd7c5ydIDB9nQiHoxggOT
MIIDjwIBATBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZFghsYW5nY2hh
bzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgAAPxhfXKY27C7W
sQAAAAA/GDAJBgUrDgMCGgUAoIIB+DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMDAzMzAwNjM0NDZaMCMGCSqGSIb3DQEJBDEWBBSaZAcVUkBRSyIE6XMqUvNQLIZo
XDB/BgkrBgEEAYI3EAQxcjBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZ
FghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgAA
PxhfXKY27C7WsQAAAAA/GDCBgQYLKoZIhvcNAQkQAgsxcqBwMFkxEzARBgoJkiaJk/IsZAEZFgNj
b20xGDAWBgoJkiaJk/IsZAEZFghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNV
BAMTCUlOU1BVUi1DQQITfgAAPxhfXKY27C7WsQAAAAA/GDCBkwYJKoZIhvcNAQkPMYGFMIGCMAsG
CWCGSAFlAwQBKjALBglghkgBZQMEARYwCgYIKoZIhvcNAwcwCwYJYIZIAWUDBAECMA4GCCqGSIb3
DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCGjALBglghkgBZQMEAgMwCwYJYIZIAWUDBAIC
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB//pV/xfglfKxrxkKtd+4TG9d+ECtyBc1Z
9VgXU0eGZ+7/7mN/yGAEh4Cj2bU2B6pQM7SYwsCISoyrjW4+oYlJn7XAQIa/U1ihA7mwJJWl9/WK
KtaSnxuoPPlLjFYxtkKkpLqNCvE6QXL+YV7O2IjtBmUggpQl2WbpB6O6lZnZPU/5RSc7tx6sJWS1
4ZycbQ0YpcbFeI2A58po8bPmCeZD0I3Yi8orPhD9N6nUo/imtsoUHZbsBqMYZJihZnhzMQSQirxU
0YuDhKs9pxwYivh3qJLCvRx1m4RlrQJongO1S8a6ocoFu60yVRjAjuu1AKiNQ/Re+vxdyXZ2iuDh
in4hAAAAAAAA

------=_NextPart_000_04F5_01D606A0.5C1CBE90--

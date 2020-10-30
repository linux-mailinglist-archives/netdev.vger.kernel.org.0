Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA2729F9EC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgJ3An2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:43:28 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:5244 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgJ3An1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:43:27 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09U0bhHk002974;
        Fri, 30 Oct 2020 00:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 mime-version; s=jan2016.eng;
 bh=afaf8H/9NntXyxDaPemUbkl9XLWn+VEawelRyRZu+K8=;
 b=G4tbx+URgU0IVSZ/Dbyulf+EAd5v8D6PpEfnvhO7FM5f3Xa89n4ECj9N/osqs84YHxAM
 KN+X2UD3NIM9CJKZGO9oUh6pKwggpLGcv3QB7f4E1NAFhT7bgAU0GuuLcbkKyaESvUjn
 tIp2XZMe22E3cB97baEBdRatIyzWe0fmg0lr8iDpmNUTV/eN9iVaB8cYFiEb8DkSXtEo
 VZvhMhuc0wvhFVvWi+fvwuTCL8Qi74o9Raq8r7zhByXZcJa/1k7WVVeDLB197f9nw7Zu
 5ylrYlsQJ3l0eoNlIqdfxDYS+HBTF50L2YqkvyG/gQYxjFy+261Pd52Z8O9OC0EP0RI+ +g== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 34g6pyvmya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 00:42:24 +0000
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09U0XoMR032203;
        Thu, 29 Oct 2020 20:42:23 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.115])
        by prod-mail-ppoint7.akamai.com with ESMTP id 34f1qgausu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 20:42:23 -0400
Received: from USTX2EX-DAG1MB2.msg.corp.akamai.com (172.27.165.120) by
 ustx2ex-dag1mb6.msg.corp.akamai.com (172.27.165.124) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 29 Oct 2020 19:42:22 -0500
Received: from USTX2EX-DAG1MB2.msg.corp.akamai.com ([172.27.165.120]) by
 ustx2ex-dag1mb2.msg.corp.akamai.com ([172.27.165.120]) with mapi id
 15.00.1497.007; Thu, 29 Oct 2020 19:42:22 -0500
From:   "Sharma, Puneet" <pusharma@akamai.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] tc: add print options to fix json output
Thread-Topic: [PATCH iproute2] tc: add print options to fix json output
Thread-Index: AQHWrjB/0TuzeLcgzEKK9J0/UiymBKmvajaAgAAgVwCAABfyAA==
Date:   Fri, 30 Oct 2020 00:42:22 +0000
Message-ID: <F6349CB8-670F-4CE1-AFFB-A446D311EA42@akamai.com>
References: <20201028183554.18078-1-pusharma@akamai.com>
 <20201029131718.39b87b03@hermes.local>
 <2B38A297-343E-4DD0-93E2-87F8B2AC1E26@akamai.com>
 <20201029161640.3a9c4da5@hermes.local>
In-Reply-To: <20201029161640.3a9c4da5@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.19.42.152]
Content-Type: multipart/signed;
        boundary="Apple-Mail=_301517A4-7A37-4E47-9BBC-A8CA8316F2B3";
        protocol="application/pkcs7-signature"; micalg=sha-256
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_12:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300001
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_12:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300001
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.33)
 smtp.mailfrom=pusharma@akamai.com smtp.helo=prod-mail-ppoint7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_301517A4-7A37-4E47-9BBC-A8CA8316F2B3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Because basic match is made of multiple keywords and parsed and handle =
differently
example:
	$ tc filter add dev $eth_dev_name ingress priority 20000 =
protocol ipv4 basic match '(cmp(u8 at 9 layer network eq 6) or cmp(u8 at =
9 layer network eq 17)) and ipset(sg-test-ipv4 src)' action pass

and if jsonw_string used then it will double-quote every string passed =
and

prints something like this:
	 "ematch": "("cmp(u8 at 9 layer 1 eq 6,")","OR "cmp(u8 at 9 =
layer 1 eq 17,")",") ","AND "ipset(sg-test-ipv4 src,")",

instead of like this:
	"ematch": "(cmp(u8 at 9 layer 1 eq 6)OR cmp(u8 at 9 layer 1 eq =
17)) AND ipset(sg-test-ipv4 src)=E2=80=9D,

Hope I explained it right.


> On Oct 29, 2020, at 7:16 PM, Stephen Hemminger =
<stephen@networkplumber.org> wrote:
>=20
> On Thu, 29 Oct 2020 21:20:55 +0000
> "Sharma, Puneet" <pusharma@akamai.com> wrote:
>=20
>> I did provide an example to better explain what patch is doing.
>>=20
>> Sorry for long paste.
>>=20
>> So, with current implementation output of command:
>> $ tc -s -d -j filter show dev <eth_name> ingress
>>=20
>> would contain:
>> [{
>>        "protocol": "ip",
>>        "pref": 20000,
>>        "kind": "basic",
>>        "chain": 0
>>    },{
>>        "protocol": "ip",
>>        "pref": 20000,
>>        "kind": "basic",
>>        "chain": 0,
>>        "options": {handle 0x1
>>  (
>>    cmp(u8 at 9 layer 1 eq 6)
>>    OR cmp(u8 at 9 layer 1 eq 17)
>>  ) AND ipset(sg-test-ipv4 src)
>>=20
>>            "actions": [{
>>                    "order": 1,
>>                    "kind": "gact",
>>                    "control_action": {
>>                        "type": "pass"
>>                    },
>>                    "prob": {
>>                        "random_type": "none",
>>                        "control_action": {
>>                            "type": "pass"
>>                        },
>>                        "val": 0
>>                    },
>>                    "index": 1,
>>                    "ref": 1,
>>                    "bind": 1,
>>                    "installed": 2633,
>>                    "last_used": 2633,
>>                    "stats": {
>>                        "bytes": 0,
>>                        "packets": 0,
>>                        "drops": 0,
>>                        "overlimits": 0,
>>                        "requeues": 0,
>>                        "backlog": 0,
>>                        "qlen": 0
>>                    }
>>                }]
>>        }
>>    }
>> ]
>>=20
>> Clearly this is an invalid JSON. Look at =E2=80=9Coptions"
>>=20
>>=20
>> With patch it would look like:
>> [{
>>        "protocol": "ip",
>>        "pref": 20000,
>>        "kind": "basic",
>>        "chain": 0
>>    },{
>>        "protocol": "ip",
>>        "pref": 20000,
>>        "kind": "basic",
>>        "chain": 0,
>>        "options": {
>>            "handle": 1,
>>            "ematch": "(cmp(u8 at 9 layer 1 eq 6)OR cmp(u8 at 9 layer =
1 eq 17)) AND ipset(sg-test-ipv4 src)",
>>            "actions": [{
>>                    "order": 1,
>>                    "kind": "gact",
>>                    "control_action": {
>>                        "type": "pass"
>>                    },
>>                    "prob": {
>>                        "random_type": "none",
>>                        "control_action": {
>>                            "type": "pass"
>>                        },
>>                        "val": 0
>>                    },
>>                    "index": 1,
>>                    "ref": 1,
>>                    "bind": 1,
>>                    "installed": 297829723,
>>                    "last_used": 297829723,
>>                    "stats": {
>>                        "bytes": 0,
>>                        "packets": 0,
>>                        "drops": 0,
>>                        "overlimits": 0,
>>                        "requeues": 0,
>>                        "backlog": 0,
>>                        "qlen": 0
>>                    }
>>                }]
>>        }
>>    }
>> ]
>>=20
>> Now it=E2=80=99s handling the =E2=80=9Chandle=E2=80=9D and =
=E2=80=9Cematch=E2=80=9D inside =E2=80=9Coptions" depending on context.
>>=20
>> Hope it=E2=80=99s more clear now.
>>=20
>> Thanks,
>> ~Puneet.
>>=20
>>> On Oct 29, 2020, at 4:17 PM, Stephen Hemminger =
<stephen@networkplumber.org> wrote:
>>>=20
>>> On Wed, 28 Oct 2020 14:35:54 -0400
>>> Puneet Sharma <pusharma@akamai.com> wrote:
>>>=20
>>>> Currently, json for basic rules output does not produce correct =
json
>>>> syntax. The following fixes were done to correct it for extended
>>>> matches for use with "basic" filters.
>>>>=20
>>>> tc/f_basic.c: replace fprintf with print_uint to support json =
output.
>>>> fixing this prints "handle" tag correctly in json output.
>>>>=20
>>>> tc/m_ematch.c: replace various fprintf with correct print.
>>>> add new "ematch" tag for json output which represents
>>>> "tc filter add ... basic match '()'" string. Added print_raw_string
>>>> to print raw string instead of key value for json.
>>>>=20
>>>> lib/json_writer.c: add jsonw_raw_string to print raw text in json.
>>>>=20
>>>> lib/json_print.c: add print_color_raw_string to print string
>>>> depending on context.
>>>>=20
>>>> example:
>>>> $ tc -s -d -j filter show dev <eth_name> ingress
>>>> Before:
>>>> ...
>>>> "options": {handle 0x2
>>>> (
>>>>   cmp(u8 at 9 layer 1 eq 6)
>>>>   OR cmp(u8 at 9 layer 1 eq 17)
>>>> ) AND ipset(test-ipv4 src)
>>>>=20
>>>>           "actions": [{
>>>> ...
>>>>=20
>>>> After:
>>>> [{
>>>> ...
>>>> "options": {
>>>>   "handle": 1,
>>>>   "ematch": "(cmp(u8 at 9 layer 1 eq 6)OR cmp(u8 at 9 layer 1 eq =
17)) AND ipset(test-ipv4 src)",
>>>> ...
>>>> ]
>>>>=20
>>>> Signed-off-by: Puneet Sharma <pusharma@akamai.com>
>>>> --- =20
>>>=20
>>> What is the point of introducing raw string?
>>> The JSON standard says that string fields must use proper escapes.
>>>=20
>>> Please  don't emit invalid JSON. It will break consumption by other =
libraries. =20
>>=20
>=20
>=20
> I agree that the existing output is wrong. But your patch introduces
>=20
> +void jsonw_raw_string(json_writer_t *self, const char *value);
>=20
> Why?
>=20
> You should just use jsonw_string() which already handles things like =
special
> characters in the string. In theory, there could be quotes or other =
characters
> in the ematch string.


--Apple-Mail=_301517A4-7A37-4E47-9BBC-A8CA8316F2B3
Content-Disposition: attachment; filename="smime.p7s"
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCBSEw
ggUdMIIEw6ADAgECAhMXAAUB4xHes0QfoprNAAAABQHjMAoGCCqGSM49BAMCMDwxITAfBgNVBAoT
GEFrYW1haSBUZWNobm9sb2dpZXMgSW5jLjEXMBUGA1UEAxMOQWthbWFpQ2xpZW50Q0EwHhcNMTkw
NDMwMTcxOTQyWhcNMjEwNDI5MTcxOTQyWjBSMRkwFwYDVQQLExBNYWNCb29rIFByby1KRzVMMREw
DwYDVQQDEwhwdXNoYXJtYTEiMCAGCSqGSIb3DQEJARYTcHVzaGFybWFAYWthbWFpLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALGUxmT6MNEszVCxqy9NzXBqc6Bnlnupe3XcGsOm
aCOGlObPqskc3RwjZ9QFWxrbXikn5lCSazKAoK4Fhp2JwYtW4Knzx/N685CIyGgCD/HUsPfmUYrb
T2rhodb3Zkx55JFLOauNPeOqIUHC38+NP39qPCSCHzvxuCZbHBuXI5vxHDcnUjWroMNi74C3I5sD
lDjfAyEPZZIMnbSn8Rp78Gi3o7BCgp8eKdSZyR6YE9NkRKE56SCetZcrSoikS4nG6+wfwAtNRoj0
CM2qAbiBNw1VEYvzhgtoLRtzgOYwDCceK8pPCOvobzZMFseCbgqfQe9asCBJE4ldtiZsjk7jx0UC
AwEAAaOCAsEwggK9MAsGA1UdDwQEAwIHgDApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQG
CisGAQQBgjcKAwQwHQYDVR0OBBYEFDht0usfKc45ObPIx4dau73+l6UeMEgGA1UdEQRBMD+gKAYK
KwYBBAGCNxQCA6AaDBhwdXNoYXJtYUBjb3JwLmFrYW1haS5jb22BE3B1c2hhcm1hQGFrYW1haS5j
b20wHwYDVR0jBBgwFoAUk4erMWaQ2spNFgOM5MMPveYNLAwwegYDVR0fBHMwcTBvoG2ga4YuaHR0
cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNsaWVudENBLmNybIY5aHR0cDovL2FrYW1h
aWNybC5kZncwMS5jb3JwLmFrYW1haS5jb20vQWthbWFpQ2xpZW50Q0EuY3JsMIHCBggrBgEFBQcB
AQSBtTCBsjA6BggrBgEFBQcwAoYuaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNs
aWVudENBLmNydDBFBggrBgEFBQcwAoY5aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFrYW1h
aS5jb20vQWthbWFpQ2xpZW50Q0EuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFpb2NzcC5h
a2FtYWkuY29tL29jc3AwOwYJKwYBBAGCNxUHBC4wLAYkKwYBBAGCNxUIgs7lOoe41C2BhYsHouMh
htIPgUmFpcMQmtV/AgFkAgFTMDUGCSsGAQQBgjcVCgQoMCYwCgYIKwYBBQUHAwIwCgYIKwYBBQUH
AwQwDAYKKwYBBAGCNwoDBDBEBgkqhkiG9w0BCQ8ENzA1MA4GCCqGSIb3DQMCAgIAgDAOBggqhkiG
9w0DBAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcwCgYIKoZIzj0EAwIDSAAwRQIgQ5/Gqxo9ewgR
3WkfAFwRL4pDhWr8u1VsbXxDald3WPcCIQDZJ4CoudRQaXfgbgA0d6NBtpg5zNUM2461mlTQX+AK
mjGCAekwggHlAgEBMFMwPDEhMB8GA1UEChMYQWthbWFpIFRlY2hub2xvZ2llcyBJbmMuMRcwFQYD
VQQDEw5Ba2FtYWlDbGllbnRDQQITFwAFAeMR3rNEH6KazQAAAAUB4zANBglghkgBZQMEAgEFAKBp
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIwMTAzMDAwNDIyMlow
LwYJKoZIhvcNAQkEMSIEIFtkAUgcuTvWF1PqvoTNRZYIMR1gjZIktNhhSRzw6KPNMA0GCSqGSIb3
DQEBAQUABIIBAGpGEBu66ustOQy9E3Xxs39ueZKf212Y57AvMQXhEdFmrE1lqXfEKl8EFCWOg1/w
Ln1Xld2CbARi/neivdIu0+xm+lRfeHWxgHePq7+2kmOJMGzxTurFSHYZHFWu1pDHhB6WASdbFTb3
2B8JaN7k76dFHwobBXsZoZ1IFwxrv6/F6Tvvevu9gym13OG7FlZp9y/5Ahp0sTOwZCxJ0Be+XXBS
D2lqKmf6w44IlDVwSdHh9oeL3UDDqAJGtYaxxh4frEWCyHiGfxlyJPrI/6lMXPAM/fMjiV89lI7c
ODCMgvXPej4pgAtQoySn6HZQuTAwt5nyfPJyCVUVXiYOS/WlqmMAAAAAAAA=

--Apple-Mail=_301517A4-7A37-4E47-9BBC-A8CA8316F2B3--

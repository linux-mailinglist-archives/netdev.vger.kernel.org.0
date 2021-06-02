Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B6A398FA9
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFBQK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:10:28 -0400
Received: from mx1.uni-rostock.de ([139.30.22.71]:56242 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhFBQK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:10:26 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2021 12:10:25 EDT
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmze; 
 t=1622649819; bh=smZfdV41W4TMQe5xQ8spUW2jcQMkQt+0sp0F3+PPUFo=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=ed25519-sha256; b=
 f+FcYaE5QMShGniiW4tgx/esc+4CyHMWymVwiAX96+xyq7jJ4uHuc5CZyNGf3Idh5w7NVGvMVtmy5aVdMNJDCQ==
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1622649819; bh=smZfdV41W4TMQe5xQ8spUW2jcQMkQt+0sp0F3+PPUFo=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=rsa-sha256; b=
 cxMx9ZkSf8fh1VbeI82vXZ0N5EHEv7E3NUYr1naplJgdBkVpuklsNh9Jw1Fnog0LJtSntwgbG5MePJltG8Ccak2zCOvU0PgdTm6Nx9Ku9JJ0C88wbhdHhCHp0kePxBKZfF0MU+l6VkWg6r8pmm+XFvayOLn4/kfJcnK2fwXwDtU=
Received: from 139.30.22.81 by mx1.uni-rostock.de (Tls12, Aes256, Sha384,
 DiffieHellmanEllipticKey384); Wed, 02 Jun 2021 16:03:39 GMT
Received: from [192.168.0.200] (31.17.41.18) by email1.uni-rostock.de
 (139.30.22.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12; Wed, 2 Jun 2021
 18:03:38 +0200
Subject: Re: [syzbot] general protection fault in mac80211_hwsim_tx_frame_nl
To:     syzbot <syzbot+3a2811a83af0f441ef5f@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <johannes@sipsolutions.net>,
        <kuba@kernel.org>, <kvalo@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
References: <0000000000000ff96b05c3c30a16@google.com>
From:   Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Organization: =?UTF-8?Q?Universit=c3=a4t_Rostock?=
Message-ID: <aa113e56-e0be-c5da-993e-e5f4b02a0047@uni-rostock.de>
Date:   Wed, 2 Jun 2021 18:03:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <0000000000000ff96b05c3c30a16@google.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
        micalg=sha-256; boundary="------------ms050505030408050001010104"
X-Originating-IP: [31.17.41.18]
X-ClientProxiedBy: email3.uni-rostock.de (139.30.22.83) To
 email1.uni-rostock.de (139.30.22.81)
X-TM-AS-Product-Ver: SMEX-14.0.0.3080-8.6.1012-26196.001
X-TM-AS-Result: No-10--9.957100-8.000000
X-TMASE-MatchedRID: DuKherWvI/szGbGLN/HsO26gACfxmWhEhj5Ec98sEUSqvcIF1TcLYHN8
        LqnPuFqMdT86lTeOQqzy9zcRSkKatcWo6kJnduXJCL8RFER/j9P4qCLIu0mtIObnFWpNX1DBie3
        MY7Xv0pj7nGGoxPDfnnrqJSe7KQ/speAIK6XfhPqqFx2c/3V5cSXZp8eIhCoj31GNm6M+JKSGfs
        i8fVvWQRtRS6ZBlZfUX/2LEuUC/9qmO6U9OrWUyCFcmxL76KeOLlUSE1jiIXHC9DxHKrnk8p/Dt
        W4Yzan7dyMT8Pi4jmz8Fo9uhLtNhXFXmAqsdcFcMHJATJcPoDwEbATG004AD+yyjNE5tHtLXa3q
        Dl7ir0T7gKFaH59PE/IJkbMX4M4JB81uozkhVuoWqJ/PBjhtWv/68utbcN7JJpM1uBurbkVBs1O
        wil9bHUszbsTB6rnY5g9P5/Zr/nfXaqCzZeQl280oj1/HMbKZ8B937B5os5RQKAQSutQYXIaeEk
        If7bS38Z5fKpgDJPDWzXRIAdWbmNg0S4KWRIlGhDVhTvRRn6jUoio6unGrT2mgGrIHW5uQqe78R
        N9JFu3HmpCSwEe85QveFwnuz1/EoEHVUttGvH0GCPfJHGcqQfVyxeTOBKrUzAKTiuEfBeJ/ynUz
        uF1K7ob2rWI73Rda1j0gZbTTiWOtyaYPv+ErX0pZ1N/CwmPL7Tc/WGKLayS51H80nDYkd+Kv6ok
        qI6i3V0vN9JEbVSMojN1lLei7RZ1U4R5ZodNbHgUm4PC0BtLHQ9EOHbFIJYlXLO0txQbY76xkxw
        nqlePMLJkuvP+rZ9KD9rtNYvDd9u332aw7Rf+EQtbMjKs9Z+WD+aYfezL0JRwq1lVELWHtbXCVI
        XFji/9cM09CDJEQ
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.957100-8.000000
X-TMASE-Version: SMEX-14.0.0.3080-8.6.1012-26196.001
X-TM-SNTS-SMTP: E271B9CED1D77F901287E2F06B785B37F5CDCE7478FA741F68991F0C4578ADEA2002:8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------ms050505030408050001010104
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Hi Johannes,

I coincidentally picked up this one and had a quick look into it.

Am 02.06.2021 um 09:02 schrieb syzbot:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    05924717 bpf, tnums: Provably sound, faster, and more p=
rec..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D15a3b90bd00=
000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D7b1a53f9a0b=
5a801
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D3a2811a83af0f=
441ef5f
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> Reported-by: syzbot+3a2811a83af0f441ef5f@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc00=
00000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 31562 Comm: kworker/u4:6 Not tainted 5.12.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 01/01/2011
> Workqueue: phy89 hw_scan_work
> RIP: 0010:mac80211_hwsim_tx_frame_nl+0x3fd/0xdb0 drivers/net/wireless/m=
ac80211_hwsim.c:1315

Actually, the syzbot becomes more aggressive, and found more races. From
my understanding the error is triggered by a netlink message stuck in
tx_frame_nl, when in between the underlying hwsim interface is
deleted/changed (and therefore the channel or data ptr in 1315 becomes
stale).

The message "[ 2019.982886][ T5462] mac80211_hwsim: wmediumd released
netlink socket, switching to perfect channel medium" directly before the
bug, seems also very fishy.

This substantiate your last findings, about the inconsistent locking in
hwsim. The configuration of interfaces or state of the wmediumd hook
should not change while we are in tx_frame_nl. But of course tx_frame_nl
is on a hot path.

Maybe you already got this, but I wanted to throw in my thoughts,
although I'm currently not able to create fixes to this.

=2E..

> Call Trace:
>  mac80211_hwsim_tx_frame+0x10d/0x1e0 drivers/net/wireless/mac80211_hwsi=
m.c:1773
>  hw_scan_work+0x7be/0xc20 drivers/net/wireless/mac80211_hwsim.c:2331
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> Modules linked in:
> ---[ end trace bd7d02fa1bf956f5 ]---
>

--=20
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrote=
chnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/



--------------ms050505030408050001010104
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
EIMwggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWsMIIElKADAgECAgcbY7rQHiw9MA0GCSqGSIb3DQEBCwUAMIGVMQswCQYD
VQQGEwJERTFFMEMGA1UEChM8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hl
biBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLEwdERk4tUEtJMS0wKwYDVQQDEyRE
Rk4tVmVyZWluIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IDIwHhcNMTYwNTI0MTEzODQwWhcN
MzEwMjIyMjM1OTU5WjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ07eRxH3h+Gy8Zp1xCeOdfZojDbchwFfylf
S2jxrRnWTOFrG7ELf6Gr4HuLi9gtzm6IOhDuV+UefwRRNuu6cG1joL6WLkDh0YNMZj0cZGnl
m6Stcq5oOVGHecwX064vXWNxSzl660Knl5BpBb+Q/6RAcL0D57+eGIgfn5mITQ5HjUhfZZkQ
0tkqSe3BuS0dnxLLFdM/fx5ULzquk1enfnjK1UriGuXtQX1TX8izKvWKMKztFwUkP7agCwf9
TRqaA1KgNpzeJIdl5Of6x5ZzJBTN0OgbaJ4YWa52fvfRCng8h0uwN89Tyjo4EPPLR22MZD08
WkVKusqAfLjz56dMTM0CAwEAAaOCAgUwggIBMBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0P
AQH/BAQDAgEGMCkGA1UdIAQiMCAwDQYLKwYBBAGBrSGCLB4wDwYNKwYBBAGBrSGCLAEBBDAd
BgNVHQ4EFgQUazqYi/nyU4na4K2yMh4JH+iqO3QwHwYDVR0jBBgwFoAUk+PYMiba1fFKpZFK
4OpL4qIMz+EwgY8GA1UdHwSBhzCBhDBAoD6gPIY6aHR0cDovL2NkcDEucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDBAoD6gPIY6aHR0cDovL2NkcDIu
cGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDCB3QYIKwYB
BQUHAQEEgdAwgc0wMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1T
ZXJ2ZXIvT0NTUDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwt
cm9vdC1nMi1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSgYIKwYBBQUHMAKGPmh0dHA6Ly9j
ZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtZzItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0
MA0GCSqGSIb3DQEBCwUAA4IBAQCBeEWkTqR/DlXwCbFqPnjMaDWpHPOVnj/z+N9rOHeJLI21
rT7H8pTNoAauusyosa0zCLYkhmI2THhuUPDVbmCNT1IxQ5dGdfBi5G5mUcFCMWdQ5UnnOR7L
n8qGSN4IFP8VSytmm6A4nwDO/afr0X9XLchMX9wQEZc+lgQCXISoKTlslPwQkgZ7nu7YRrQb
tQMMONncsKk/cQYLsgMHM8KNSGMlJTx6e1du94oFOO+4oK4v9NsH1VuEGMGpuEvObJAaguS5
Pfp38dIfMwK/U+d2+dwmJUFvL6Yb+qQTkPp8ftkLYF3sv8pBoGH7EUkp2KgtdRXYShjqFu9V
NCIaE40GMIIFuTCCBKGgAwIBAgIMHzcR9GUQSZTV7S+BMA0GCSqGSIb3DQEBCwUAMIGNMQsw
CQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRz
Y2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQD
DBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBMB4XDTE4MDYwNjA3NTkzNVoXDTIxMDYw
NTA3NTkzNVowSDELMAkGA1UEBhMCREUxHTAbBgNVBAoMFFVuaXZlcnNpdGFldCBSb3N0b2Nr
MRowGAYDVQQDDBFCZW5qYW1pbiBCZWljaGxlcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALuftKh7NruuRpqq2hZC//IEU0nxsDVyj2IoSxZovDDzJCYSbQwKDLgIfRDWB2s+
jSPLg9CBO5HCE/dsn3KIaoh71gp8YhS26zhdclOIMVgq+R0G7DD4jL4s6ukwfUFJMAOi+j5w
eqsLGS/e6XGhIX7GzsoE1SQCG53yHfI0c9FGYFBHUCfJLWriUHkxeIHOe6JuV7O0jfJGn4CN
PY4XYRQmC+tvBIKuY1fwG5f22yadcAQ+QFLJZJ5S+DSo3GWgGyICdr+1askRlV92xGoYi/8Q
c4rGwQYxPPgfXuQVQqGLy9MUPdBjF+yUiFpakAcrjgOZ9b8VrFxZZOMUIjWD0hkCAwEAAaOC
AlswggJXMEAGA1UdIAQ5MDcwDwYNKwYBBAGBrSGCLAEBBDARBg8rBgEEAYGtIYIsAQEEAwgw
EQYPKwYBBAGBrSGCLAIBBAMIMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUJi1HPMHnCZxlOz2mHkickZ2UgYAw
HwYDVR0jBBgwFoAUazqYi/nyU4na4K2yMh4JH+iqO3QwKwYDVR0RBCQwIoEgYmVuamFtaW4u
YmVpY2hsZXJAdW5pLXJvc3RvY2suZGUwgY0GA1UdHwSBhTCBgjA/oD2gO4Y5aHR0cDovL2Nk
cDEucGNhLmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcyL3B1Yi9jcmwvY2FjcmwuY3JsMD+gPaA7
hjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2Rmbi1jYS1nbG9iYWwtZzIvcHViL2NybC9jYWNy
bC5jcmwwgdsGCCsGAQUFBwEBBIHOMIHLMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2Eu
ZGZuLmRlL09DU1AtU2VydmVyL09DU1AwSQYIKwYBBQUHMAKGPWh0dHA6Ly9jZHAxLnBjYS5k
Zm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSQYIKwYBBQUH
MAKGPWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0
L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBABxvHDDKL1V4FphT0/B57zajl7iqEjSN
Ia2Wbov9/+iNWB9HTSYFjiyMA8XZgktJ3dUnUSefaYqei2CeSvdK7zGEFHy5dgLpaFd7B2F1
FUQgb7ZCgWPFb5hhpWg0Iavqewq9w+s4LYHIDNxaQdIp0QXegKww20n+fC2b6HnpbO8U1XiG
HMn9xz2qaB0hDoKnwULUwCa1IBPR1SVoUURX/8g9/HvWWyMLq8k3f334zHVH/DYBtN25BZsu
OaQ3luA8+Sedlj0LuKohNHHKN5ALe4uWnBkK0aXNZ85chm7etca6acv9d4s41i+Adg8frhu7
9lKTz0szPdDUmVswjxPvqbwxggQLMIIEBwIBATCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNV
BAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25l
dHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQQIMHzcR9GUQSZTV7S+BMA0GCWCGSAFlAwQCAQUAoIICPTAYBgkqhkiG
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA2MDIxNjAzMzdaMC8GCSqG
SIb3DQEJBDEiBCCnFBMGdCO7MSBTiYNRn5sOusZhb8QmYTmbHhklTkbAxTBsBgkqhkiG9w0B
CQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcN
AwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGvBgkrBgEE
AYI3EAQxgaEwgZ4wgY0xCzAJBgNVBAYTAkRFMUUwQwYDVQQKDDxWZXJlaW4genVyIEZvZXJk
ZXJ1bmcgZWluZXMgRGV1dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsM
B0RGTi1QS0kxJTAjBgNVBAMMHERGTi1WZXJlaW4gR2xvYmFsIElzc3VpbmcgQ0ECDB83EfRl
EEmU1e0vgTCBsQYLKoZIhvcNAQkQAgsxgaGggZ4wgY0xCzAJBgNVBAYTAkRFMUUwQwYDVQQK
DDxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVuIEZvcnNjaHVuZ3NuZXR6
ZXMgZS4gVi4xEDAOBgNVBAsMB0RGTi1QS0kxJTAjBgNVBAMMHERGTi1WZXJlaW4gR2xvYmFs
IElzc3VpbmcgQ0ECDB83EfRlEEmU1e0vgTANBgkqhkiG9w0BAQEFAASCAQAIiwy7Opbbdbm1
lV0eUveyr1KPASqTOtu+62YIX+Wug65dFvplC5f6AQcow82Sv26U5yaOiNf7kg8QGf5aobz9
Ea0Ov4Q3Q2f417w4hnJ6lxXnRif79itFGTq9ymJqaw6RunLkscfeIBhfaKjpSj6lxEqKvXdM
3GGLuJqsVZ77qkSOLSnATUop89INsyLy1G0MLeuzOHMaxip0S3trUks8VzXgblehfTaCKu42
DmFalHr2lMEmuc2NL99n18l9DuU/xboUrSgm7XrjUwDLASRdQhvpERjdRGPoETN3RzIPKY6n
q+SE7ngcLXawjJN4A9kHN5/uvA8Ezb+DUAinIpyBAAAAAAAA
--------------ms050505030408050001010104--


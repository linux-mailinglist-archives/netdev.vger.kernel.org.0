Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3AD8A1F8
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfHLPHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:07:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:34398 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbfHLPHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 11:07:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 08:07:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,377,1559545200"; 
   d="p7s'?scan'208";a="193986657"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga001.fm.intel.com with ESMTP; 12 Aug 2019 08:07:10 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 12 Aug 2019 08:07:09 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.85]) by
 ORSMSX155.amr.corp.intel.com ([169.254.7.26]) with mapi id 14.03.0439.000;
 Mon, 12 Aug 2019 08:07:09 -0700
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Tieman, Henry W" <henry.w.tieman@intel.com>
Subject: Re: [net-next 01/15] ice: Implement ethtool ops for channels
Thread-Topic: [net-next 01/15] ice: Implement ethtool ops for channels
Thread-Index: AQHVTuC3HE5wxf7L2Uqpc1QipS81DKbzxq4AgARQHgA=
Date:   Mon, 12 Aug 2019 15:07:09 +0000
Message-ID: <8a72e5d0ee26743dc5a896a426a55e6e9660f4d2.camel@intel.com>
References: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
         <20190809183139.30871-2-jeffrey.t.kirsher@intel.com>
         <20190809141518.55fe7f8a@cakuba.netronome.com>
In-Reply-To: <20190809141518.55fe7f8a@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.166.244.155]
Content-Type: multipart/signed; micalg=sha-1;
        protocol="application/x-pkcs7-signature"; boundary="=-hyyQEtEOEmELbcO/6URO"
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-hyyQEtEOEmELbcO/6URO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-08-09 at 14:15 -0700, Jakub Kicinski wrote:
> On Fri,  9 Aug 2019 11:31:25 -0700, Jeff Kirsher wrote:
> > From: Henry Tieman <henry.w.tieman@intel.com>
> >=20
> > Add code to query and set the number of queues on the primary
> > VSI for a PF. This is accessed from the 'ethtool -l' and 'ethtool
> > -L'
> > commands, respectively.
> >=20
> > Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>=20
> If you're using the same IRQ vector for RX and TX queue the channel
> counts as combined. Looks like you are counting RX and TX separately
> here. That's incorrect.

Hi Jakub,

The ice driver can support asymmetric queues.  We report these
seperately, as opposed to combined, so that the user can specify a
different number of Rx and Tx queues.

Thanks,
Tony

--=-hyyQEtEOEmELbcO/6URO
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
UDSWFPJn1IonMumCuP0DYWGYiGS8dKTJMMh2WA2XVewXVn0JQTWQDpckAOkmi+A0RwpZzYJ0Y3gT
AgMBAAGjggI2MIICMjAdBgNVHQ4EFgQUydTU8+nnPeJE0ndEkV7rlhV6p30wHwYDVR0jBBgwFoAU
HmkqtNwo/kcYTiELP7ysES/wmPUwZQYDVR0fBF4wXDBaoFigVoZUaHR0cDovL3d3dy5pbnRlbC5j
b20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENB
JTIwNEEuY3JsMIGeBggrBgEFBQcBAQSBkTCBjjBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRl
bC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIw
SXNzdWluZyUyMENBJTIwNEEuY3J0MCEGCCsGAQUFBzABhhVodHRwOi8vb2NzcC5pbnRlbC5jb20w
CwYDVR0PBAQDAgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OC
kcAJZ4HevTmV8EMCAWQCAQkwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMMFEGA1UdEQRKMEigKgYKKwYBBAGC
NxQCA6AcDBphbnRob255Lmwubmd1eWVuQGludGVsLmNvbYEaYW50aG9ueS5sLm5ndXllbkBpbnRl
bC5jb20wDQYJKoZIhvcNAQEFBQADggEBALLF5b7PLd6kEWuQRkEq6eZpohKWRkfC9DyLiwS+HaeH
9euNcIqpV4xrMXM6mPqs3AHRb9ibqUPo3wQMtHph35RRsmY7ENk9FxF/W8Ov5ZVPyW0rFiRsnr1C
QVc08YqXp1dlbQGf8nvJn8ryCwjNpw0CTQcGHXrL/YnboLu8+R9RdBue/HIlP4g0pyAC/8YOie04
PVo4flU2CGMYilm1euQ6OV8WRA2CKgvRVp/DZEzTqnmDvy12efG74bmMzXAvDv2I53TR5ltDpx5X
B8uO1XlhOrj+Z3mSi85eblWWhJlq6+TQH/hZWSiyZH2lo3J49oHClTlk86GUEIUp/sf5v5cxggIX
MIICEwIBATCBkDB5MQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFDASBgNVBAcTC1NhbnRhIENs
YXJhMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwg
QmFzaWMgSXNzdWluZyBDQSA0QQITMwAA0J5PWjT/SLEH2wAAAADQnjAJBgUrDgMCGgUAoF0wGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTkwODEyMTUwNzA2WjAjBgkq
hkiG9w0BCQQxFgQUC+9rrtpPM7e9BMFfc6efar6M5hQwDQYJKoZIhvcNAQEBBQAEggEA4wRXTl3u
0dOErFLQg0a5MAk/hQI9FHSQnw7mXpfgywB5QUqHFMcg4yIdhH2+FKMltwDHd5msE3yeU1oHAXLs
2WEibg48wfVh4/HQ+2J3dTaqM2kgpICFskS+xlfzohmUW8ld97OC7IKVcFWuXWf6HWu/WbzdeWXd
81M6NrL9RwQsuA5PAOs4Y6iRtskZ2Z6Qf1Cql8cjWaHPRjxRs5riCw78ttaLGJkogUlKU9SCA9FS
WPMS64h1JHV/R8mPyiFfZVftsQ0I0AfR5Fqzvr/EPXGpqOxvdFZVTHJm80PyNP/wKAh4+OOp3MKQ
3CCu2P5CuAuXl+9biNkQQQjkCMjxNAAAAAAAAA==


--=-hyyQEtEOEmELbcO/6URO--

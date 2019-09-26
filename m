Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A84EBFC01
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 01:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbfIZXjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 19:39:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:7656 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbfIZXjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 19:39:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 16:39:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="p7s'?scan'208";a="389788596"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga005.fm.intel.com with ESMTP; 26 Sep 2019 16:39:23 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 16:39:22 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.232]) by
 ORSMSX113.amr.corp.intel.com ([169.254.9.232]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 16:39:22 -0700
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Thread-Topic: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Thread-Index: AQHVdInWt0NTAJCEIEqQg3Y1OkbYY6c+tloAgABdJwA=
Date:   Thu, 26 Sep 2019 23:39:22 +0000
Message-ID: <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
         <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
         <20190926180556.GB1733924@kroah.com>
In-Reply-To: <20190926180556.GB1733924@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.166.244.155]
Content-Type: multipart/signed; micalg=sha-1;
        protocol="application/x-pkcs7-signature"; boundary="=-a1EaP/4SM51eBVg0Nwrv"
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-a1EaP/4SM51eBVg0Nwrv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-09-26 at 20:05 +0200, Greg KH wrote:
> On Thu, Sep 26, 2019 at 09:45:00AM -0700, Jeff Kirsher wrote:
> > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> >=20
> > The RDMA block does not advertise on the PCI bus or any other bus.
>=20
> Huh?  How do you "know" where it is then?  Isn't is usually assigned
> to
> a PCI device?

The RDMA block does not have its own PCI function so it must register
and interact with the ice driver. =20

>=20
> > Thus the ice driver needs to provide access to the RDMA hardware
> > block
> > via a virtual bus; utilize a multi-function device to provide this
> > access.
> >=20
> > This patch initializes the driver to support RDMA as well as
> > creates
> > and registers a multi-function device for the RDMA driver to
> > register to.
> > At this point the driver is fully initialized to register a
> > platform
> > driver, however, can not yet register as the ops have not been
> > implemented.
> >=20
> > We refer to the interaction of this platform device as Inter-Driver
> > Communication (IDC); where the platform device is referred to as
> > the peer
> > device and the platform driver is referred to as the peer driver.
>=20
> Again, no platform devices, unless it REALLY IS a platform device
> (i.e.
> you are using device tree or platform data to find it.)  Is that what
> you are doing here?
>=20

Sorry, this was an oversight.  When I was changing the wording in the
commit message away from platform device, I missed this one.

I will rewrite the commit message to make things clearer and correct
the platform device reference.

Thanks,
Tony

--=-a1EaP/4SM51eBVg0Nwrv
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
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTkwOTI2MjMzOTIwWjAjBgkq
hkiG9w0BCQQxFgQUoM6lWPWGOzBGlsM+GKqniaeu80UwDQYJKoZIhvcNAQEBBQAEggEABJHMg9ss
260p68+HBkE4s/SfRiM5Tj3JzpJQcSESWRL54fruYXXDZya9GHozL6dGhzVIfS+G5TzkPiBXC5aa
ekqLzEiN+SqAdNnPjLCQg+kAlaF7qdsLfmFUSlF1pMWa4TQTXtt1JjmfvbxsBdZip4UE4neFYpo5
IaKb5KAqoVpgAH7xDW3m+D8FCiZkWgnlyY3+cbitx41LD3DJaT7vTLJ6cOxe2NWPALRGMwOENg7s
Lk/0V9jJEVx5UBQgq/zrayifjImdrX6Hq0miXh7KbtcuVPnleJBYe/w/D40vkPTKQ2/eBSVYpL5N
QHBz2q9iDx4JJ1T0DhHTY6GIZM1quQAAAAAAAA==


--=-a1EaP/4SM51eBVg0Nwrv--

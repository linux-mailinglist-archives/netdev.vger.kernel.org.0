Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185D886732
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389966AbfHHQgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:36:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:54174 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfHHQgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 12:36:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 09:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="asc'?scan'208";a="374911747"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 08 Aug 2019 09:36:23 -0700
Message-ID: <78d50c6e7615efa07af54642c4b1b8f0c426a3c7.camel@intel.com>
Subject: Re: [net] ixgbe: fix possible deadlock in ixgbe_service_task()
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Taehee Yoo <ap420073@gmail.com>, David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, nhorman@redhat.com,
        sassmann@redhat.com, andrewx.bowers@intel.com
Date:   Thu, 08 Aug 2019 09:36:23 -0700
In-Reply-To: <CAMArcTXWBHUpy+p18UJ6RZm2W=vhnLRezste=kHSSv=dyd0kBA@mail.gmail.com>
References: <20190805200403.23512-1-jeffrey.t.kirsher@intel.com>
         <20190806.145104.1044990165298646882.davem@davemloft.net>
         <CAMArcTXWBHUpy+p18UJ6RZm2W=vhnLRezste=kHSSv=dyd0kBA@mail.gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cO63puCndKipuwIfO2M2"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-cO63puCndKipuwIfO2M2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-08-07 at 15:08 +0900, Taehee Yoo wrote:
> On Wed, 7 Aug 2019 at 08:36, David Miller <davem@davemloft.net>
> wrote:
>=20
> Hi David
> Thank you for the review!
>=20
> > From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Date: Mon,  5 Aug 2019 13:04:03 -0700
> >=20
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > index cbaf712d6529..3386e752e458 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > @@ -7898,9 +7898,7 @@ static void ixgbe_service_task(struct
> > > work_struct *work)
> > >        }
> > >        if (ixgbe_check_fw_error(adapter)) {
> > >                if (!test_bit(__IXGBE_DOWN, &adapter->state)) {
> > > -                     rtnl_lock();
> > >                        unregister_netdev(adapter->netdev);
> > > -                     rtnl_unlock();
> > >                }
> >=20
> > Please remove the (now unnecessary) curly braces for this basic
> > block.
> >=20
>=20
> I will send a v2 patch.
> Thank you!

I have already created a v2 on your behalf Taechee and will submit to
Dave here shortly.

--=-cO63puCndKipuwIfO2M2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1MT4cACgkQ5W/vlVpL
7c7jeQ/9FSX+LDzkKn768Oz7SccC18inC6x4NqX3eo8YyfSxxNM9sUnGZb5yFOeT
R5QjathMMccwnMNn9glX5igXZuHrGBzWegzKs/pXhG7VvXtGefIxpwxvFAmFSR6h
u4ftlAVMevrT9TjiPUVlDesOddpaOehVsPq17tB7blCFf4Xd7OkYgUMvWZjR/pXO
1LnIFPdhVapKvBjoIFTGL1PziGCfSW/qstjJ70pPuBy5QllYuYtcaOvLG79qCV6a
Je1kmYn5UZeaiE5vG1YbABs31XD1JlFQwdBWVZoeJ+lqa7GOHOQJ/KgrVY5ITWGl
PAIxAXBbALuY0hEfKjgfZaXyU52wsxgYlK6IOSqRgC2nz3VcgiWVJyWMsoryAmGB
rS3c/ujw72+9yqumGM2GZjufq+GLgk475OR0ZeRt4VHQoajCSV42rCRMDPubIZxA
zujZADi/tbSKywg0jJXEg6ZcuPeb/NgkQqLiDqGcw/mflv6WR9x89t0QXx5fpE0m
rsY3AWAb6UEWaV+TIU0eSJSn/kF6w8J3mEB3l5xR1M/ujUbXbxz8FZ5WgbUuis43
ur/nQfKzg21w8znwv81Ixlru96OeVq7p39fezdmXfL2EgPmfTUY22rZjFezTW83L
+PMvIVC7QcUh7ZWqX6Op52sp2Gc+b1YDj+Zib3Hfns2D6zDvokk=
=+s9e
-----END PGP SIGNATURE-----

--=-cO63puCndKipuwIfO2M2--


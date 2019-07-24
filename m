Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CF7724AE
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 04:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfGXCaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 22:30:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:42413 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbfGXCaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 22:30:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 19:30:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="asc'?scan'208";a="253455319"
Received: from kitaracr-mobl.amr.corp.intel.com ([10.254.89.138])
  by orsmga001.jf.intel.com with ESMTP; 23 Jul 2019 19:30:22 -0700
Message-ID: <08bfd370e195b648b9cb4a9d9e31fb4189a374c1.camel@intel.com>
Subject: Re: [net-next 6/6] e1000e: disable force K1-off feature
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     kai.heng.feng@canonical.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, aaron.f.brown@intel.com
Date:   Tue, 23 Jul 2019 19:30:21 -0700
In-Reply-To: <20190723.140444.1126474066269131522.davem@davemloft.net>
References: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
         <20190723173650.23276-7-jeffrey.t.kirsher@intel.com>
         <20190723.140444.1126474066269131522.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-xpt2Y6BLXD7NOaG2WRaL"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-xpt2Y6BLXD7NOaG2WRaL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-07-23 at 14:04 -0700, David Miller wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Tue, 23 Jul 2019 10:36:50 -0700
>=20
> > diff --git a/drivers/net/ethernet/intel/e1000e/hw.h
> > b/drivers/net/ethernet/intel/e1000e/hw.h
> > index eff75bd8a8f0..e3c71fd093ee 100644
> > --- a/drivers/net/ethernet/intel/e1000e/hw.h
> > +++ b/drivers/net/ethernet/intel/e1000e/hw.h
> > @@ -662,6 +662,7 @@ struct e1000_dev_spec_ich8lan {
> >  	bool kmrn_lock_loss_workaround_enabled;
> >  	struct e1000_shadow_ram shadow_ram[E1000_ICH8_SHADOW_RAM_WORDS];
> >  	bool nvm_k1_enabled;
> > +	bool disable_k1_off;
> >  	bool eee_disable;
>=20
> I don't see any code actually setting this boolean, how does it work?

I am trying to find the answer Dave.  The original author of the code
change is no longer with Intel and the notes point to this being set via
the NVM, but I am confirming with the client engineers.

--=-xpt2Y6BLXD7NOaG2WRaL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl03wr0ACgkQ5W/vlVpL
7c4TBQ//ToFfY0qsuIxX6GGQjtnGDyNGNK3vjQKla8wfw9bepp4VSxk4+WtnygG4
yyPK78gfjL2K+wsgCbEYBQwBl9+ITcHielXyM3wK8nbGWVQuJbRE7RnAlOCBJhG5
CNWtkaZtAhycgF60+rvEewo1eoOjigsaE7lh1eemrpr0yy4InDuim13/B1GPxy2n
Oo+hGRPIfdsWf+IXSpIrakiHrL2HWdhWAtsOxWayS7FSf1oOScc2JTshXskJiCNI
ZlBExMqKv24KvxRWOEKr7rh3bHByX3OY83WF70LA+wEZxsGkRjRQhOiPQP5Mp2kw
FZ8K8TIYj7Kp96IAh8nrKFgW9gNzpb6qO2cH8hnrRV6D5jAY4jIrOSyFGJUwLxNN
E8pxmLAhnYXiO+af8iFUNj8fcMZNRJEbWMjIhmb6CdRyNxPUh07glxShTX1VZv2i
iVl/MEu2DFqW7upd7gyGc9P6ddoYIS/rg6gwsOpU8ORODxpa2zyx5SbDH6lXqVql
sFhA/BDfQyJ/ecQZRhlXHXa6f3oGrsIkQkgn76P1l9c2FoAOifldYOGByz/A50EJ
Z0zwiCwZT78WwoPTfpEyltVktwxrj0DGergFwjW8MqC+xs3MVZ0fojT7ZnmeC9bw
rKb7S7vt96nrSxAUze5uuzPRLO/RMdXKvbkl7De9Sm2zR+Gk09M=
=iANw
-----END PGP SIGNATURE-----

--=-xpt2Y6BLXD7NOaG2WRaL--


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31E39F921
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfH1ERt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:17:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:45925 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfH1ERt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 00:17:49 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 21:17:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,439,1559545200"; 
   d="asc'?scan'208";a="171417145"
Received: from orparaju-mobl.amr.corp.intel.com ([10.252.137.75])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 21:17:48 -0700
Message-ID: <fe43e2c9815e2d355eac2b9876ab9bc4fb002bac.camel@intel.com>
Subject: Re: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-08-26
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Date:   Tue, 27 Aug 2019 21:17:47 -0700
In-Reply-To: <20190827210928.576c5fef@cakuba.netronome.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
         <20190827210928.576c5fef@cakuba.netronome.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-XxJ9lxDf3E7Ko/4RUAJN"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-XxJ9lxDf3E7Ko/4RUAJN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-27 at 21:09 -0700, Jakub Kicinski wrote:
> On Tue, 27 Aug 2019 09:38:17 -0700, Jeff Kirsher wrote:
> > This series contains updates to ice driver only.
>=20
> Looks clear from uAPI perspective. It does mix fixes with -next,=20
> but I guess that's your call.

Yeah, I always debate about sending the fixes to net, but many of them do
not apply cleanly or at all to the previous kernel version since we are
actively adding new features and functionality to this driver.

Once this device gets released, I will be more concerned about getting
fixes into older kernels.

>=20
> Code-wise changes like this are perhaps the low-light:
>=20
> @@ -2105,7 +2108,10 @@ void ice_trigger_sw_intr(struct ice_hw *hw, struct
> ice_q_vector *q_vector)
>   * @ring: Tx ring to be stopped
>   * @txq_meta: Meta data of Tx ring to be stopped
>   */
> -static int
> +#ifndef CONFIG_PCI_IOV
> +static
> +#endif /* !CONFIG_PCI_IOV */
> +int
>  ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
>  		     u16 rel_vmvf_num, struct ice_ring *ring,
>  		     struct ice_txq_meta *txq_meta)


--=-XxJ9lxDf3E7Ko/4RUAJN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1mAGwACgkQ5W/vlVpL
7c5NWA//dmH9Xyf1PohGeVjNF2eeLPk/hEPEu5zQ4OgfnuLDrC0Kyg56aL/aTJew
yl03sDCck93tKseBGk8henr9nqNPW6RfFQbBMf0xJnrsL7sfYqHdtz28HDMlJRB+
OS1mDvi/37pNj7FvKZKCEW/PtcTfYw4CJul7chQd1bmLwuwSuChv0Uh+P6k9+kdt
1Rdl228FSIZ3iEl8KtsC6YLjABvouGHAyxHU0zgTzkr4agR7gjmdTkNqE9uhU3Xl
KTnsvuU1Fm5b6k23Q3CFnXOO1FBUPxLbV3KAdtVMPY8+w6YGeRH1Hdi09FoxRWM4
gbzAJZk1IHAis/b48SIayqIIIriDegyvvRmJItm66curZqw/PabjgYsCP49xTD8e
jvSTa8PIhax5s9X42wDGjJLGO79r1sH0BdQ0UGGuXprSa+CYnMi7b9pwXOG1JGE2
LkIeJrcElNEXpBkJJN+1qEQvHv893G6DqcSMe8xsdT5jvM7Rtf7fHt1s4gpa1oUK
Q/LkDAw5ELfQauH0CLviObq95yvH5T92ZLWaCIDwsjG6sk0J9CVhGANsGGGXskRO
9a9VMCWgnbhEuktaFOF4NYWjGiKzvMZeaAI6RQ53O2aG5ztUT2sC9ymX5D74OlsI
787e1G0D1dQbOC+EJmShNPNgL7xHtkx0u0aiN4AHfynS3fc4CrQ=
=okAh
-----END PGP SIGNATURE-----

--=-XxJ9lxDf3E7Ko/4RUAJN--


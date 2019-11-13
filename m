Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F87FB7FF
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKMSrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:47:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:58598 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfKMSrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 13:47:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 10:47:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="asc'?scan'208";a="235375560"
Received: from jcesana-mobl1.amr.corp.intel.com ([10.255.89.181])
  by fmsmga002.fm.intel.com with ESMTP; 13 Nov 2019 10:47:38 -0800
Message-ID: <ab2d5acc31f94ecc97e412d286c375cee9640722.camel@intel.com>
Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface between
 VF and PF
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Arkady Gilinsky <arcadyg@gmail.com>
Date:   Wed, 13 Nov 2019 10:47:38 -0800
In-Reply-To: <1573544002.10368.34.camel@harmonicinc.com>
References: <1572845537.13810.225.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B3936D@ORSMSX113.amr.corp.intel.com>
         <1572931430.13810.227.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B39863@ORSMSX113.amr.corp.intel.com>
         <1573018214.10368.1.camel@harmonicinc.com>
         <d078d3efc784805a67ba1a1c6e94fb4ec1c0aec6.camel@intel.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B3EB75@ORSMSX113.amr.corp.intel.com>
         <1573544002.10368.34.camel@harmonicinc.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-cS1q6XGYtvjZoQ2pnC0a"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-cS1q6XGYtvjZoQ2pnC0a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-12 at 07:33 +0000, Arkady Gilinsky wrote:
> Hi All,
>=20
> Jeffrey/Brett: I did re-submit the patch as "[v2,net] i40e/iavf: Fix msg
> interface between VF and PF"
> Please review.

Sorry, Brett is on vacation for a couple of weeks.  Before he left, he
provided an alternative patch, which I will be submitting later today.

>=20
> On Fri, 2019-11-08 at 16:43 +0000, Creeley, Brett wrote:
> > > -----Original Message-----
> > > From: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > > Sent: Thursday, November 7, 2019 11:39 AM
> > > To: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>; Creeley, Brett
> > > <brett.creeley@intel.com>; intel-wired-lan@lis
> > > ts.osuosl.org;
> > > netdev@vger.kernel.org
> > > Cc: Arkady Gilinsky <arcadyg@gmail.com>
> > > Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface
> > > between VF and PF
> > >=20
> > > On Wed, 2019-11-06 at 05:30 +0000, Arkady Gilinsky wrote:
> > > > On Tue, 2019-11-05 at 16:55 +0000, Creeley, Brett wrote:
> > > > > > -----Original Message-----
> > > > > > From: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
> > > > > > Sent: Monday, November 4, 2019 9:24 PM
> > > > > > To: Creeley, Brett <brett.creeley@intel.com>;
> > > > > > intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org;
> > > > > > Kirsher,
> > > > > > Jeffrey T
> > > > > > <jeffrey.t.kirsher@intel.com>
> > > > > > Cc: Arkady Gilinsky <arcadyg@gmail.com>
> > > > > > Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg
> > > > > > interface
> > > > > > between VF and PF
> > > > > > > static bool i40e_vc_verify_vqs_bitmaps(struct
> > > > > > > virtchnl_queue_select
> > > > > > > *vqs)
> > > > > > > {
> > > > > > >    /* this will catch any changes made to the
> > > > > > > virtchnl_queue_select
> > > > > > > bitmap */
> > > > > > >    if (sizeof(vqs->rx_queues) !=3D sizeof(u32) ||
> > > > > > >         sizeof(vqs->tx_queues) !=3D sizeof(u32))
> > > > > > >            return false;
> > > > > >=20
> > > > > > If so, then is it better to check the type of the fields in
> > > > > > compile-
> > > > > > time rather than in runtime ?
> > > > > > Something like this:
> > > > > > BUILD_BUG_ON(sizeof(vqs->rx_queues) !=3D sizeof(u32));
> > > > > > BUILD_BUG_ON(sizeof(vqs->tx_queues) !=3D sizeof(u32));
> > > > > > This is not required comparison each time when function is
> > > > > > called and
> > > > > > made code more optimized.
> > > > >=20
> > > > > I don't think this is required with the change you suggested
> > > > > below.
> > > >=20
> > > > Agree.
> > > > If other code in driver not need to be adjusted/verified, then this
> > > > check
> > > > is not needed.
> > > > > > >    if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) |=
|
> > > > > > >          hweight32(vqs->rx_queues) > I40E_MAX_VF_QUEUES ||
> > > > > > >          hweight32(vqs->tx_queues) > I40E_MAX_VF_QUEUES)
> > > > > > >            return false;
> > > > > >=20
> > > > > > Again, from optimization POV it is better to have constant
> > > > > > changed
> > > > > > than variable,
> > > > > > since it is compile time and not run time action:
> > > > > >      if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) |=
|
> > > > > >            vqs->rx_queues >=3D (BIT(I40E_MAX_VF_QUEUES)) ||
> > > > > >=20
> > > > > >       vqs->tx_queues >=3D (BIT(I40E_MAX_VF_QUEUES)))
> > > > > >              return false;
> > > > >=20
> > > > > This seems much better than my solution. It fixes the original
> > > > > issue,
> > > > > handles if the
> > > > > vqs->[r|t]x_queues variables have changed in size, and the queue
> > > > > bitmap
> > > > > comparison
> > > > > uses a constant. Thanks!
> > > >=20
> > > > Thanks to you for feedback.
> > > > I am trying to understand if this patch will enter into official
> > > > kernel
> > > > tree
> > > > and, not less important from my POV, to official Intel drivers.
> > > > Brett/Jeffrey, could you, please, assist to make sure that this
> > > > fix, or
> > > > fix suggested by Brett,
> > > > will be integrated into Intel i40e/iavf drivers ?
> > > > Or may be I should write mail straight to Intel support ?
> > >=20
> > > As Brett pointed out, there are issues with this patch. Please make
> > > the
> > > suggested changes and re-submit the patch to
> > > intel-wired-lan@lists.osuosl.org
> >=20
> > Jeff/Arkady: I have already submitted patches for this internally for
> > official Intel drivers. Apologies for the delayed response.


--=-cS1q6XGYtvjZoQ2pnC0a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3MT8oACgkQ5W/vlVpL
7c6hNw//d73sfHPkXkKxBklmGsor6VgGrdzgXaZK/cNFxL0g8W/WibA/E5fRdZer
8rxYCY5Ug7YFAXB4WJd4J8aez4gl1pYr4v18mTvht5/s3ayLE5sLMQZ3Smg+lWPN
ALQytUnZhH5SuzxtWs73tioyn9nekyzaPM5lNWSJaHFA7S+KqSDyIjoJZoTky6Er
qf67tI/N53H/iFhtYrwzr+mxdKAF7Cli+E12HB9eciH9nvEC6ziWmSLr67881ZbP
xR1JSnsBAQR61Y3RUCt/I/Yfd4tluCi4uf0WBVD1A1Io8tEa/Cg0yaQxLbqKndz7
XN07p8AauQvbbj9Jlh8cKYrBKI1IIiazk4LK/fT+1mXHOok4h6m2Veeznbij079J
/yro0Fh8DRovRM9fsQXucfP+TDIBM32spHJb1zkpvnPt1l8IOORAc6EAsElpu72/
wpIyZxeJ20boMCMrugDfjj34j++iTKSxTtor8wq/aiq/nGC8L0X8p4xMQjAgu7IH
zHOECneJCGW8LEc1eFSW4s/MO7gWMzDV2vxVeg5UVuYe0URdlw2xN5bCp06NXryM
7gb5bwjNNGkmFw00QJO5MpIXI/4xBFb47/f2NqwsCWjR/kGISsA9pK6YUIDjt5LE
ZYnRIXorIEN5m4T7fJZ9/XuzmHiAmX5JxEoZtJ7ijOoTnCaGObU=
=skKm
-----END PGP SIGNATURE-----

--=-cS1q6XGYtvjZoQ2pnC0a--


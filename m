Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FE9D1239
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbfJIPPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbfJIPPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 11:15:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C35D3084032;
        Wed,  9 Oct 2019 15:15:08 +0000 (UTC)
Received: from localhost (ovpn-116-110.ams2.redhat.com [10.36.116.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 649F960167;
        Wed,  9 Oct 2019 15:15:05 +0000 (UTC)
Date:   Wed, 9 Oct 2019 16:15:03 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/11] VSOCK: add AF_VSOCK test cases
Message-ID: <20191009151503.GA13568@stefanha-x1.localdomain>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-8-sgarzare@redhat.com>
 <CAGxU2F4N5ACePf6YLQCBFMHPu8wDLScF+AGQ2==JAuBUj0GB-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <CAGxU2F4N5ACePf6YLQCBFMHPu8wDLScF+AGQ2==JAuBUj0GB-A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 09 Oct 2019 15:15:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 09, 2019 at 12:03:53PM +0200, Stefano Garzarella wrote:
> Hi Stefan,
> I'm thinking about dividing this test into single applications, one
> for each test, do you think it makes sense?
> Or is it just a useless complication?

I don't mind either way but personally I would leave it as a single
program.

Stefan

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d+XcACgkQnKSrs4Gr
c8iLyQf/Zhb+RZJm3omrM8JeMvDADeG1HsilYyQHLlWrpKPJHyQVtNqGNx9bJxd+
Eq68BTkMmICqtmYwilCPPVlrx8et8zehRq871XzI6O/sXIme49zDJ056dPX1R1Gb
+HAyhD9QD3YqFicOy1eA7YAtT8/VsQdXMQTUVkwcv/Nzi37O0xyd7KVV0TJvBVka
0NwoQYWegJqj48HghPtJrhr6xjOjj2xbBgW2AI9SFwSYNW9asQeEgfWbYAZZU/Ri
Q2/xQjZbaaEKRhiIw+WoWJ4eXSZXzAzqh4cnyHVvJnoyLnO0Ed7qEUf4tcwFS1Eu
KaaYezbOhj4tIKbacDvJ5+HM6M2QYA==
=fCBd
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--

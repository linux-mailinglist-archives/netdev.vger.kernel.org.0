Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4927DD5C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgI3A0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbgI3A0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 20:26:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9B52071E;
        Wed, 30 Sep 2020 00:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601425595;
        bh=0bMJw/5kfjpnnOZiR5Ko/PacF64q5h8FnDceq8ZaLpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTLSSUUTtFjxLxDNzLTae/Im284tZSlfVNQ5xWiM2ty5Zqxqd/WouVVlD52aLdFes
         ttX3qo/XCZmMgKss7z61D+dZ7I56RFxqyGI/9p5EcQiW0JR/TmU/Zwvs1pZro7wD5n
         SjfZvI0fIpfilWO4dACt2wejWoPGff6GoOibddaE=
Date:   Tue, 29 Sep 2020 17:26:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 2/2] ionic: prevent early watchdog check
Message-ID: <20200929172633.0d78fd23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ace43069-fb8e-a4e8-af96-30d59c5e86d3@pensando.io>
References: <20200929221956.3521-1-snelson@pensando.io>
        <20200929221956.3521-3-snelson@pensando.io>
        <20200929171521.654fdef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ace43069-fb8e-a4e8-af96-30d59c5e86d3@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 17:17:45 -0700 Shannon Nelson wrote:
> On 9/29/20 5:15 PM, Jakub Kicinski wrote:
> > On Tue, 29 Sep 2020 15:19:56 -0700 Shannon Nelson wrote: =20
> >> In one corner case scenario, the driver device lif setup can
> >> get delayed such that the ionic_watchdog_cb() timer goes off
> >> before the ionic->lif is set, thus causing a NULL pointer panic.
> >> We catch the problem by checking for a NULL lif just a little
> >> earlier in the callback.
> >>
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io> =20
> > Hah, I should have looked at the second patch :D =20
>=20
> Am I making my patches too small now?=C2=A0 :-)

Just right :)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E11E2F1CB5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389666AbhAKRmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732509AbhAKRmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 12:42:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA37B20738;
        Mon, 11 Jan 2021 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610386899;
        bh=j6xfXS8oW2JdaRWnqOmNWEJhmbqEB0MNLOUSkRTysxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sJRX6J1fKKvqxtME4qgyLgY/P4hRE2uAHdD7fKJzwTuanoUeycoQI009xKNHbbW5Q
         4IJc0IB9paCDskbMT7X1pdzl+NXLO/CMAVUNMvm5MRQpKaXFlKYe7b8wb189PuX0eY
         0Ct+PEpywuWRhPpRVjWQ2byl1TjrX/MkSfY5vP7aLey4l9mOgFo1ygSMJEampIeTd6
         JreSmlxpdWBig2bprafIyxiIkRu6zOfP7o98OIz7wTmi/dS5aHmiWp1KRV1dQNubzU
         WmwMzj3+Ui0qRc7vcjdiMUWHBNLUCr3aQg3cTdVpZBZpdWll8o1nbNpwi6LutNDMen
         6E4BHPS+r3gxQ==
Date:   Mon, 11 Jan 2021 09:41:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Subject: Re: [PATCH net 6/9] MAINTAINERS: mtk-eth: remove Felix
Message-ID: <20210111094137.0ead3481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c5d10d66321ee8b58263d6d9fce6c34e99d839e8.camel@perches.com>
References: <20210111052759.2144758-1-kuba@kernel.org>
        <20210111052759.2144758-7-kuba@kernel.org>
        <c5d10d66321ee8b58263d6d9fce6c34e99d839e8.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 21:45:46 -0800 Joe Perches wrote:
> On Sun, 2021-01-10 at 21:27 -0800, Jakub Kicinski wrote:
> > Drop Felix from Mediatek Ethernet driver maintainers.
> > We haven't seen any tags since the initial submission. =20
> []
> > diff --git a/MAINTAINERS b/MAINTAINERS =20
> []
> > @@ -11165,7 +11165,6 @@ F:	Documentation/devicetree/bindings/dma/mtk-*
> > =C2=A0F:	drivers/dma/mediatek/
> > =C2=A0
> >=20
> > =C2=A0MEDIATEK ETHERNET DRIVER
> > -M:	Felix Fietkau <nbd@nbd.name>
> > =C2=A0M:	John Crispin <john@phrozen.org>
> > =C2=A0M:	Sean Wang <sean.wang@mediatek.com>
> > =C2=A0M:	Mark Lee <Mark-MC.Lee@mediatek.com> =20
>=20
> I think your script is broken as there are multiple subdirectories
> for this entry and=20

Quite the opposite, the script intentionally only counts contributions
only to the code under the MAINTAINERS entry. People lose interest and
move on to working on other parts of the kernel (or maybe were never
that interested in maintaining something in the first place?).=20

We want to list folks who are likely to give us reviews.

> Felix is active.

Which I tried to state in the commit message as well :)

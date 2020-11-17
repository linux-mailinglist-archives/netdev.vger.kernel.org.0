Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2C62B7072
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgKQUp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgKQUp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:45:28 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E862922447;
        Tue, 17 Nov 2020 20:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605645927;
        bh=rmHbBvn/5GjL0guuhglqskv2bi1ACkIvY69RRv8+g60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=khqgduffyUL/VOQD0sqFsXXpod9e1vVeii9LpmcML5RW6gOo5JwaLNIyCt5fhrxLH
         oJkoVabx8/KO2WUg6ANs+6a0la87zXu7ts0Z+6ePh+ZdoG9MKcaUlIFpd8qMa0LZ9w
         KU1Do9qQqtO3GlU728KEgXZDwIPS2nay1FI0O46k=
Date:   Tue, 17 Nov 2020 12:45:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>, jcliburn@gmail.com,
        chris.snook@gmail.com, davem@davemloft.net, hkallweit1@gmail.com,
        yanaijie@huawei.com, mst@redhat.com, leon@kernel.org,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] atl1c: fix error return code in atl1c_probe()
Message-ID: <20201117124525.5c4b28b0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <83ee32e6-9460-a1f1-8065-6e737edb5402@wanadoo.fr>
References: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
        <83ee32e6-9460-a1f1-8065-6e737edb5402@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 21:39:05 +0100 Marion & Christophe JAILLET wrote:
> Le 17/11/2020 =C3=A0 03:55, Zhang Changzhong a =C3=A9crit=C2=A0:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API") =
=20
> Hi, should it have any importance, the Fixes tag is wrong.
>=20
> The issue was already there before 85eb5bc33717 which was just a=20
> mechanical update.

Can you provide the correct one, then?

I can switch it when applying.

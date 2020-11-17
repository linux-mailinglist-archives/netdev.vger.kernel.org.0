Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C294D2B6ADC
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgKQQ6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgKQQ6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 11:58:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDB2E22447;
        Tue, 17 Nov 2020 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605632316;
        bh=9D9KLBbNdlCkaxUhqcf7t/poQPWOEDlB0CngkcYgA5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nzZ3bmLdkZoZU3/NyqtZIKPGJCGRn8lZ0JyZ4xfiyXJ9koJI+M8/AT7k7sxp5qZfh
         aoPnRTFvV/+uBiAXUhsNFkq6qIe2zRkDTKA9G4PK7CK9j44uzzRLTgKPKTUtuP1Svo
         h+99mbBKtP74Tt1S7G1+QldqEp6PStnR75Ra3DBo=
Date:   Tue, 17 Nov 2020 08:58:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        "Lukas Bartosik [C]" <lbartosik@marvell.com>
Subject: Re: [PATCH v9,net-next,12/12] crypto: octeontx2: register with
 linux crypto framework
Message-ID: <20201117085834.77f5a038@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR18MB27910E1BA481946189F00766A0E20@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201109120924.358-1-schalla@marvell.com>
        <20201109120924.358-13-schalla@marvell.com>
        <20201111161039.64830a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113031601.GA27112@gondor.apana.org.au>
        <20201113084440.138a76fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116062606.GA29271@gondor.apana.org.au>
        <BYAPR18MB27910E1BA481946189F00766A0E20@BYAPR18MB2791.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 07:59:56 +0000 Srujana Challa wrote:
> > On Fri, Nov 13, 2020 at 08:44:40AM -0800, Jakub Kicinski wrote:  
> > >
> > > SGTM, actually everything starting from patch 4 is in drivers/crypto,
> > > so we can merge the first 3 into net-next and the rest via crypto?  
> > 
> > Yes of course.
> >   
> Thanks I will resubmit patches 4-12 on crypto-2.6 in the next release cycle.
> Should I re-submit patches 1-3 on net-next now?

Yes, please!

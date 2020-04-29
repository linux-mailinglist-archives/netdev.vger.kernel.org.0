Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631B81BE273
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgD2PWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:22:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgD2PWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 11:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5uO653nHnG/4hJnyU2CEzLdMTrPNF9NuNoUERL8DTQM=; b=IIPZvgod1VnhUzX/VKF2938Xd8
        4RS5iXH7UYsJCPoyi1H6YGdmh7PKXSLlcuRT/wE16bMAXBBRPfiRec2BpcmEktz4OIdz1zjN1emTp
        Q0VTQOId5fB+pKl/bjhq2FWk95Pok0qSj6qvM75p+VPXQLrEYs+tCY8N/xTcVV67sxgI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jToXY-000HjF-2Z; Wed, 29 Apr 2020 17:22:24 +0200
Date:   Wed, 29 Apr 2020 17:22:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Zigotzky <chzigotzky@xenosoft.de>
Cc:     Darren Stevens <darren@stevens-zone.net>, madalin.bacur@nxp.com,
        netdev@vger.kernel.org, mad skateman <madskateman@gmail.com>,
        oss@buserror.net, linuxppc-dev@lists.ozlabs.org,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        "contact@a-eon.com" <contact@a-eon.com>
Subject: Re: [RFC PATCH dpss_eth] Don't initialise ports with no PHY
Message-ID: <20200429152224.GA66424@lunn.ch>
References: <20200429131253.GG30459@lunn.ch>
 <77E4A243-F90A-45A9-B8D3-0F7785C158C7@xenosoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77E4A243-F90A-45A9-B8D3-0F7785C158C7@xenosoft.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 03:55:28PM +0200, Christian Zigotzky wrote:
> Hi Andrew,
> 
> You can find some dtb and source files in our kernel package.
> 
> Download: http://www.xenosoft.de/linux-image-5.7-rc3-X1000_X5000.tar.gz

I have the tarball. Are we talking about
linux-image-5.7-rc3-X1000_X5000/X5000_and_QEMU_e5500/dtbs/X5000_20/cyrus.eth.dtb

I don't see any status = "disabled"; in the blob. So i would expect
the driver to probe.

    Andrew



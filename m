Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340454961B1
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 16:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381458AbiAUPFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 10:05:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbiAUPFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 10:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=33YBlbwO5zvqlDbvVnjxNrIOMbXq0H1Ta2wkH12gzfM=; b=YF+VZVS87QSVrAHZqL8jd64NYl
        AsQjsAZ/eWKGpd4UqVNxVS6iiF9dzRyu/iWqScsv3FF9MVYW2+zE5MZuoT6u0scvknbjCbByjPo9k
        VaW7uWBD0ZKAiIUNS1heSNnyfm0ybMLuYWujqZxgApKv4Zk8sjbQt2d8IxNRQWlK8SGM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAvTS-00269S-7c; Fri, 21 Jan 2022 16:05:10 +0100
Date:   Fri, 21 Jan 2022 16:05:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <YerLpnXa25jBKzvp@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <Yelnzrrd0a4Bl5AL@lunn.ch>
 <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
 <Yeqve+KhJKbZJNCL@lunn.ch>
 <CAAd53p7of_W26DfZwemZjBYNrkqtoY=NwHDG=6g9vvZfDn3Wwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p7of_W26DfZwemZjBYNrkqtoY=NwHDG=6g9vvZfDn3Wwg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The dwmac-intel device is an integrated end point connects directly to
> the host bridge, so it won't be in a form of PCIe addin card.

But is there anything stopping the owner adding another PCIe Ethernet
card?

Please remember, you are not adding a solution here for one specific
machine, you are adding a general infrastructure which any machine can
use, for any MAC/PHY combination. It simply does not scale adding
hacks for random machines. So you always need to keep the big picture
in mind.

	Andrew

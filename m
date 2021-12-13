Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDF5473072
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbhLMP1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:27:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234672AbhLMP1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 10:27:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tNx28Q3CDvse1uQz8pHopU8Cr2rZJSaSkY4hEnwxs6g=; b=Whkj9aUmBvsmnNOKQV+Hw/EGnT
        5FjNDK4/yPqTjaPBex2+PfSh3FlhlVeWmRkfC+tA7liseYrDMb54cyLC7uF4dEBygkvxVl+4pQVsc
        Of41wOr7QlcHaSgj9dudTDBw2ni/O/TxG4/tX4VGbKHUd/Egdh8tGl9Z+hEGKOsqfVVY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mwnEH-00GPKJ-JV; Mon, 13 Dec 2021 16:27:05 +0100
Date:   Mon, 13 Dec 2021 16:27:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <YbdmSbuhuuWqt3P8@lunn.ch>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
 <20211213121045.GA14042@hoboy.vegasvil.org>
 <20211213123147.2lc63aok6l5kg643@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213123147.2lc63aok6l5kg643@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  I think this isn't even specific to DSA, the same thing would
> happen with software bridging

And pure switchdev switches. I wonder what the Mellanox switch does in
this case?

     Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858CA39A2E2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFCOSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:18:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhFCOSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 10:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9K3l5Is1F/Gf6aPY+mEemNuQ3FPsfGCFymAKHEh5Mqw=; b=3wf8r88fz7ZB340fyjJLD8DgJ5
        vAbOo69iBzAK7z2beYHdBOyx/djt/8QI7yMTmaIdO7UEFB7sZE/A0yofRRxlZk3I2dFCb0HtzPPpp
        xKeLLNH/bpONcvs2bOXbrS994b817Mg5c4WXJnC7niI7/SXX4d18laExA91WeYNL1lUU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loo8x-007dCr-7e; Thu, 03 Jun 2021 16:16:19 +0200
Date:   Thu, 3 Jun 2021 16:16:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: /sys/class/net/eth0/name_assign_type -> EINVAL
Message-ID: <YLjkMw/TUYmuckzv@lunn.ch>
References: <1b61b068cd72677cf5f0c80b82092dcb1684fa9d.camel@infinera.com>
 <5922a590219f3940a7ce94901b8d916daee31d3a.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5922a590219f3940a7ce94901b8d916daee31d3a.camel@infinera.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 01:12:16PM +0000, Joakim Tjernlund wrote:
> Seems like old eth interface names cannot read name_assign_type:
> cat /sys/class/net/eth0/name_assign_type
> cat: /sys/class/net/eth0/name_assign_type: Invalid argument

Have you done a git bisect to figure out which change broke it?

The 5.10 kernel on my Debian desktop has this issue. So it is older
than that.

     Andrew

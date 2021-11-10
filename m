Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2FB44CC4A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhKJWPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:15:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234634AbhKJWN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 17:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4JJ183ZSCSPehwDFiVhoJd/om2oqhPzMnUIvClUVvXM=; b=CQiAQf96L9el5s53Ega5jBp64p
        rqxUkcoxb2GdmRLSF/pY0Zxv7hNX7hAHSUUuik5O5NRcm3UPwBYTZCjQbXghegD70dkQKxvnwgagr
        RfQF9N/G3CP9Oa5wkiFsDW+f3ypH0yt5qQk3cp++evn/9WzMC7VR6TbI8MnfjhDViiy0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkvoC-00D8z6-Bv; Wed, 10 Nov 2021 23:11:08 +0100
Date:   Wed, 10 Nov 2021 23:11:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Apeksha Gupta <apeksha.gupta@nxp.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com
Subject: Re: [PATCH 5/5] arm64: dts: imx8mm-evk-dpdk: dts for fec-uio driver
Message-ID: <YYxDfHx0KHYYr3pr@lunn.ch>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
 <20211110054838.27907-6-apeksha.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110054838.27907-6-apeksha.gupta@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 11:18:38AM +0530, Apeksha Gupta wrote:
> New DTS file 'imx8mm-evk-dpdk.dts' is added to support fec
> ethernet device detection in user space DPDK application via
> fec-uio driver.

Isn't DPDK in its own parallel universe? It is not in mainline?  A
quick grep of drivers/net does not find anything. I think you are
submitting this to the wrong universe. You should be using XDP with
mainline.

	   Andrew

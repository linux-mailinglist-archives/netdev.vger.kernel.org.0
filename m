Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1449CA61
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbiAZNII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:08:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237285AbiAZNIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 08:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=irXwZIV7ke6SpUmJoQHqsbQUk4O+rPey+s7vhsF7z+I=; b=0MYu4r4276Pu3XJXo3uJN03BQg
        Orpm6ZOMtbz7hah0m8U3mo83UMAj2YCq0nVisusTW4jf2GR44V+5IbqIKJPYG6Bs8cDGl9CZUJ4xT
        K5tC2WrwC8mdQwcAoQBWqaQWWpl7mprPBmVwlEZt2Q70tiEKimezY297a/7v0ezNCbm8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCi1r-002oAQ-5z; Wed, 26 Jan 2022 14:08:03 +0100
Date:   Wed, 26 Jan 2022 14:08:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] net/fsl: xgmac_mdio: Use managed device
 resources
Message-ID: <YfFHs3zI5MXx/WGX@lunn.ch>
References: <20220126101432.822818-1-tobias@waldekranz.com>
 <20220126101432.822818-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126101432.822818-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:14:29AM +0100, Tobias Waldekranz wrote:
> All of the resources used by this driver has managed interfaces, so
> use them. Heed the warning in the comment before platform_get_resource
> and use a bare devm_ioremap to allow for non-exclusive access to the
> IO memory.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

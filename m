Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7003049CFD8
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiAZQjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:39:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243194AbiAZQjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 11:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6u3wvIVb4V8Jn2wbO9+riux8gKvmh8oD2yRHBWD4JkY=; b=1hNQq+QqsYWaBuhwP80NP3m3C8
        +/Pzy5HiMEgvHXBHhhfmV7kst+LEgbiygSw6hu/QoUPGn4qN+ZAwwXXovec1pfrHfSI2lWMNI1RNd
        DuwNxYQMZHsVu0R0armknRCjgnfYgKKr44DgvWjfajbSS7uePnI2SVy3QU2sHi64CwTg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nClJr-002pty-OF; Wed, 26 Jan 2022 17:38:51 +0100
Date:   Wed, 26 Jan 2022 17:38:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Markus Koch <markus@notsyncing.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/5] net/fsl: xgmac_mdio: Support setting the
 MDC frequency
Message-ID: <YfF5G00weEWojL72@lunn.ch>
References: <20220126160544.1179489-1-tobias@waldekranz.com>
 <20220126160544.1179489-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126160544.1179489-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 05:05:42PM +0100, Tobias Waldekranz wrote:
> Support the standard "clock-frequency" attribute to set the generated
> MDC frequency. If not specified, the driver will leave the divisor
> bits untouched.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

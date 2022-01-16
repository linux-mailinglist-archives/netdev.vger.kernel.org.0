Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750E748FF5E
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbiAPV4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:56:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39530 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233689AbiAPV4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jan 2022 16:56:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sRsITLO5u/pAQ1Z0Am0m1XUSe/AdN8DsI20qxqEL8YY=; b=JvdGu9kxitbSrUVCv5eEE9qaFX
        A7Q3oEa7bDSmRD501rse9cz01KSGAr6/far+2kA42XJA14k1QoRNod0FInePb3+OydE2n+stnjTO3
        rcq54CEiJjYbSQF+O1mIzxw6rEgK7EMFXSV1BQYFI3pls4nPvXUTq5YmIO2JFPmEV6Ig=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9DVR-001Yvk-Ii; Sun, 16 Jan 2022 22:56:09 +0100
Date:   Sun, 16 Jan 2022 22:56:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, madalin.bucur@nxp.com,
        robh+dt@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 2/4] dt-bindings: net: Document fsl,erratum-a009885
Message-ID: <YeSUeURzYvX27eT7@lunn.ch>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220116211529.25604-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 10:15:27PM +0100, Tobias Waldekranz wrote:
> Update FMan binding documentation with the newly added workaround for
> erratum A-009885.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

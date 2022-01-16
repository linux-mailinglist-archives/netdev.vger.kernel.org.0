Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4541248FF58
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbiAPVyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:54:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233774AbiAPVyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jan 2022 16:54:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y62WBf7WncHPVF1rPc3S4E5knHjrE+JJV2IuxkQAh3U=; b=fmxgnOFptHQcJCqzjXWVmbFkm9
        VO8Lo4wAfNHSboCGaSwhYHYTx29Y24Kn/kw5WUZtK0DSSLWxwGufDNVsbrqkJnHTj4CggAeMRx7jr
        TUlEkB0mudzVRSGnykFM10wFkj7THfBq3UPX86tuG1HAuogm/HSeMweyC6BiDPPOOMqo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9DTN-001Yup-Iv; Sun, 16 Jan 2022 22:54:01 +0100
Date:   Sun, 16 Jan 2022 22:54:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, madalin.bucur@nxp.com,
        robh+dt@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 4/4] net/fsl: xgmac_mdio: Fix incorrect iounmap when
 removing module
Message-ID: <YeST+TAREKIh2RXp@lunn.ch>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220116211529.25604-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 10:15:29PM +0100, Tobias Waldekranz wrote:
> As reported by sparse: In the remove path, the driver would attempt to
> unmap its own priv pointer - instead of the io memory that it mapped
> in probe.

Hi Tobias

The change itself is O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

But you could also change to devm_ so the core will handle the unmap,
it is very unlikely to unmap the wrong thing.

     Andrew

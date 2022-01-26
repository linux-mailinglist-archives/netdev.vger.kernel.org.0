Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4249CA64
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbiAZNId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:08:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233873AbiAZNIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 08:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Oc23iIjolgjRyBQNjWnqbvRUDIyvRNxEks6h47cmzVc=; b=V2aES6bta83JwTOjvuG43dkYRj
        nmr5BEdtsFj84SAv5BCXCU3v8eRFLkasgMARx8mb/FbCDNwSFw3pzXhp181cp5NaBE4vCFGlhy07I
        9kxdhPaFqkddUUpojLdQYjeaeBB2DtpAs/wcAVGDL7CqZFRyHRPqTeMqB95vfATwOldw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCi2F-002oBA-1M; Wed, 26 Jan 2022 14:08:27 +0100
Date:   Wed, 26 Jan 2022 14:08:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Markus Koch <markus@notsyncing.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net/fsl: xgmac_mdio: Support preamble
 suppression
Message-ID: <YfFHyyAgy7l51FW6@lunn.ch>
References: <20220126101432.822818-1-tobias@waldekranz.com>
 <20220126101432.822818-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126101432.822818-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:14:30AM +0100, Tobias Waldekranz wrote:
> Support the standard "suppress-preamble" attribute to disable preamble
> generation.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

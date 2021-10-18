Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24444326C5
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhJRSoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:44:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhJRSoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 14:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iADVlLM+P+WGkfoOL+bFx/zqJkYOwIaHuDIOQrS5prg=; b=nn4ZuSGVynhc5aYdc6w6cTGUAh
        95vJs+BHy3LwUtgTzkpuHMiMzhama839f+gPS4MbAt12NCFWaRwxIhhhVtq5JL/0Gb6wzgJnETJ+Y
        Y29uuSyRSBabPyR0XVs3pysR+el6wcj/DV0WL2yrQvlWRSfiUiXlKHIJG6WwkaADIbeY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcXa8-00Azop-7Y; Mon, 18 Oct 2021 20:41:56 +0200
Date:   Mon, 18 Oct 2021 20:41:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 04/13] net: phy: at803x: use GENMASK() for speed status
Message-ID: <YW2/9PAK+zZ2orlN@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-5-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-5-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:33:24AM +0800, Luo Jie wrote:
> Use GENMASK() for the current speed value.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

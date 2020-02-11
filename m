Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DAE159CED
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 00:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgBKXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 18:10:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727330AbgBKXKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 18:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EADiutNYON1txB2uWM+IBLUwdCX8YZbgl+kWHeATei8=; b=uq1zH5RoFabM15deoawkPQCRgo
        1t7RsuzB5FmvJ7WPYviSqZO8fr169+r5U68ZkaQWIZQTKK14LojKbJXvr17cpY5AxmL3lNE1hfGfj
        nrVrRycmAPMQBTSJLykBXkhTx/oxG/nIbkwoiNcBRwpOUmfzCySsDoJ/619/NorKBnaU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j1efj-0003U6-V3; Wed, 12 Feb 2020 00:10:27 +0100
Date:   Wed, 12 Feb 2020 00:10:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next V3 11/13] ethtool: Add support for low latency RS FEC
Message-ID: <20200211231027.GQ19213@lunn.ch>
References: <20200211223254.101641-1-saeedm@mellanox.com>
 <20200211223254.101641-12-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211223254.101641-12-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 02:32:52PM -0800, Saeed Mahameed wrote:
> From: Aya Levin <ayal@mellanox.com>
> 
> Add support for low latency Reed Solomon FEC as LLRS.
> 
> The LL-FEC is defined by the 25G/50G ethernet consortium,
> in the document titled "Low Latency Reed Solomon Forward Error Correction"
> 
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> CC: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

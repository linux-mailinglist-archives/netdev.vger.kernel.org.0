Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982B3FBCD7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 01:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKNAG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 19:06:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfKNAG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 19:06:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oYauWHVDMgKjfE6gHfNdSG584tFCGCUIZrOcPaQwcF0=; b=jEFFKoE4bF8nqNxol51ILDhF9/
        fPXKoFHuosU9hop0c6rD30gFhnxwTJWIjNaXgQ1Sv7/NJlbMHRr3liTn47blJenpVoxcX2JVv8RRx
        RFVcnsWQOvxTmzqah2YJPMjA76AHjj2G+0aqFHSSC+91x6IkczrHJmNHl7SJuC/TL/2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iV2eX-0001I6-Jb; Thu, 14 Nov 2019 01:06:25 +0100
Date:   Thu, 14 Nov 2019 01:06:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: mvneta: fix build skb for bm capable
 devices
Message-ID: <20191114000625.GD27785@lunn.ch>
References: <2369ff5a16ac160d8130612e4299efe072f53d80.1573686984.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2369ff5a16ac160d8130612e4299efe072f53d80.1573686984.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 01:25:55AM +0200, Lorenzo Bianconi wrote:
> Fix build_skb for bm capable devices when they fall-back using swbm path
> (e.g. when bm properties are configured in device tree but
> CONFIG_MVNETA_BM_ENABLE is not set). In this case rx_offset_correction is
> overwritten so we need to use it building skb instead of
> MVNETA_SKB_HEADROOM directly
> 
> Fixes: 8dc9a0888f4c ("net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine")
> Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reported-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

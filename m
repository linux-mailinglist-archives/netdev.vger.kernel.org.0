Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D60F17B7
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 14:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfKFNzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 08:55:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfKFNzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 08:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wl4BihEvs6may9vk5zmwNj97KJn8JPzMVVm4fA3Tqoo=; b=ee5ieYrPsHovYusNnaXG+Bwvy7
        6rHkf3H6XYriSPwsJNEaqk/7ScooDBBFUNU9N3QUVbXeXw39RjQd7Wqtv6HVWjTbNTd2lbdhq+QnV
        kMelow+1i4YG8SFaHtc5wW+vhCV0Xw1Jrw+Y9AZx82MFv6r/se9G0FBUruoc8QCC3MeA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSLmR-00081C-VV; Wed, 06 Nov 2019 14:55:27 +0100
Date:   Wed, 6 Nov 2019 14:55:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH net-next 0/5] mv88e6xxx ATU occupancy as devlink resource
Message-ID: <20191106135527.GA30762@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
 <20191105.181001.647775687319656442.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105.181001.647775687319656442.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 06:10:01PM -0800, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Tue,  5 Nov 2019 01:12:56 +0100
> 
> > This patchset add generic support to DSA for devlink resources. The
> > Marvell switch Address Translation Unit occupancy is then exported as
> > a resource. In order to do this, the number of ATU entries is added to
> > the per switch info structure. Helpers are added, and then the
> > resource itself is then added.
> 
> Series applied, thanks Andrew.

Hi David

I will send a fix for the build error ASAP. It should not affect
normal builds, just random configs.

       Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6231D9936
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgESOPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:15:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgESOPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 10:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SNJKCzo3Gvo+txcRHFyy2c2XfxcWs6zOQk/X7lteHrk=; b=MVn3h9diIuLW2Uy/4SKnGiSPbP
        py2zMElbOv4lWvO6rFlL2ZKuCYHk7sTC7Q/ZbD6FJSjAceD7GsPs0GBdqiQXhyOY858AE5DzY64j+
        a8Snov7NoNwlxYg6yXiKacXVfBGvspPI3i0mNB7meipQ2kPjBa5YciKybjtHKSvu2cYs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jb31x-002iMB-9e; Tue, 19 May 2020 16:15:41 +0200
Date:   Tue, 19 May 2020 16:15:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: net: Add port split test
Message-ID: <20200519141541.GJ624248@lunn.ch>
References: <20200519134032.1006765-1-idosch@idosch.org>
 <20200519134032.1006765-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519134032.1006765-4-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +# Test port split configuration using devlink-port width attribute.
> +# The test is skipped in case the attribute is not available.
> +#
> +# First, check that all the ports with a width of 1 fail to split.
> +# Second, check that all the ports with a width larger than 1 can be split
> +# to all valid configurations (e.g., split to 2, split to 4 etc.)

Hi Ido

I know very little about splitting ports. So these might be dumb
questions.

Is there a well defined meaning of width? Is it something which can be
found in an 802.3 standard?

Is it well defined that all splits of the for 2, 4, 8 have to be
supported? Must all 40Gbps ports with a width of 4, be splitable to 2x
20Mps? It seems like some hardware might only allow 4x 10G?

If 20Gbps is supported, can you then go recursive and split one of the
20G ports into 2x 10G, leaving the other as a 20G port?

	Andrew

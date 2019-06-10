Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA32A3B664
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390387AbfFJNsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:48:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41462 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390306AbfFJNsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 09:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M/Y1xId2yU1k2DH3g2umLF6LppwXSeJem24YfY7EfxQ=; b=NdSPbiY5C93bJQ4l3AlkDOv9AR
        olllCROC0MyLGzq04TQbGCv0vHtjrYyqK0cMhDbQ1wNtH0r5QzO3QepNv1W25x7fhwtaUnGOMHo/h
        XBUCb7YF3e/xRnC1VHm7CSBmhdFn89QY0Ow/fhZ6vkFfLmyrLdUfl6aKlMZYcGAUnvyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haKeq-00072t-EZ; Mon, 10 Jun 2019 15:48:20 +0200
Date:   Mon, 10 Jun 2019 15:48:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: mlxsw: Add speed and
 auto-negotiation test
Message-ID: <20190610134820.GG8247@lunn.ch>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610084045.6029-4-idosch@idosch.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		# Skip 56G because this speed isn't supported with autoneg off.
> +		if [[ $speed == 56000 ]]; then
> +			continue
> +		fi

Interesting. How is 56000 represented in ethtool? Listed in both
"Supported link modes" and "Advertised link modes"?

Thanks
	Andrew


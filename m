Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD8B3B617
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390071AbfFJNfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:35:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389373AbfFJNfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 09:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h8K3U6LjzZw2+tq094b2Eh4SuR1JeSkYjwZbihO/Eqk=; b=Qg/nuJUGe3NHZ3HtxngBHTp09n
        z3HQRyHmYxVOsPPJdGa82HNHMx88MQWPTm8HShb7/QB5knZoJVk2+/j2VeAUC3WM8ZNJZ2sWoPI70
        NY2r1msCWPYouZQAoWEJBF80DRE68P5ZG8zbWO96mg/u95cpx+Wqrkv09Vp1FWZ5HWF4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haKSY-0006wh-2g; Mon, 10 Jun 2019 15:35:38 +0200
Date:   Mon, 10 Jun 2019 15:35:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
Message-ID: <20190610133538.GF8247@lunn.ch>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610084045.6029-2-idosch@idosch.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:40:43AM +0300, Ido Schimmel wrote:
> From: Amit Cohen <amitc@mellanox.com>
> +declare -A speed_values
> +
> +speed_values=(	[10baseT/Half]=0x001
> +		[10baseT/Full]=0x002
> +		[100baseT/Half]=0x004
> +		[100baseT/Full]=0x008
> +		[1000baseT/Half]=0x010
> +		[1000baseT/Full]=0x020

Hi Ido, Amit

100BaseT1 and 1000BaseT1 were added recently.

	  Andrew

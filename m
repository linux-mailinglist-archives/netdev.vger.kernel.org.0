Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDC03B7BF
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390924AbfFJOvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:51:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389123AbfFJOvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hU0iozrzpA8nEmkFLp4q0wiwhEKL6W96WVhhzzxGiQI=; b=XDlU5+Qy7yYuzHIKkY/hWDoPUC
        6DX4tvYZqMNPej5ECb3KHHKMfsdaRLb//JU3M1q4NAAA0SiBzxq8bv/WotLLf8kVelOdCZXPv7MB1
        H4EBu467BVj/a0auq9m79kGEqP/uNw4g5gdFmrOZHQS56claTpejTOTb5HpXm+LPhaCA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haLdX-0007uq-Uk; Mon, 10 Jun 2019 16:51:03 +0200
Date:   Mon, 10 Jun 2019 16:51:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
Message-ID: <20190610145103.GI28724@lunn.ch>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-2-idosch@idosch.org>
 <20190610135914.GH8247@lunn.ch>
 <20190610143157.GA20333@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610143157.GA20333@splinter>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, are you suggestion to split speeds_get() into
> supported_speeds_get() and advertised_speeds_get() and use each where
> appropriate? Note that not all the tests are testing with autoneg on.

Hi Ido

Yes.

You should be able to force all speeds in supported speeds. But if you
try to auto-neg an speed which is not listed in advertised speeds when
all are enabled, i would expect an error.

    Andrew

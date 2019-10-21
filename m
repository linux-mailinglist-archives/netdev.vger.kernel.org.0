Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABC7DECC4
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfJUMus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:50:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfJUMus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hCz1XnlwXOazUEksJt+dr0h2g4hMQZittAlRgyU0lQc=; b=uodSl0zqkczf1xnirDYCTK/PWz
        vpW7kO06uE7Ka2rrteremAzNlU7B7tefPfXKLqndCejH1WfigqSJ3qcG3adbVAtPPtQj9u0nsCM7F
        mM+b81362LLNPWEtm2Bi3UyZVaNF6SyrmpGrMXrWCdTkmMc70l4x3iLaAXdoBD2YG6uQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMX91-0004Pe-AJ; Mon, 21 Oct 2019 14:50:43 +0200
Date:   Mon, 21 Oct 2019 14:50:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 06/16] net: dsa: use ports list for routing
 table setup
Message-ID: <20191021125043.GG16084@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-7-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020031941.3805884-7-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 11:19:31PM -0400, Vivien Didelot wrote:
> Use the new ports list instead of accessing the dsa_switch array
> of ports when iterating over DSA ports of a switch to set up the
> routing table.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

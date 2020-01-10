Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C23137759
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgAJTkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:40:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgAJTkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 14:40:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WlPNc0IApWTQ9YLSaEpP2QUSavNX3euCIRf3LT4SKP0=; b=KC//4915q4GYTIfKAIExwZBhjw
        Cx7V18fcoED7O89gIU8p6LM2O0eu9qYXbj7HH2tXFJMJv2uWugn5l9J7ZC0eAS1/ocjg35Cc48tAr
        Wb1iy5VhhUzkrtVnD4X09648c2XBb5R5gdn9Lbwdzv/vWkbWab3R7aoM2qQsOr7qR+WI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iq08h-00040I-N4; Fri, 10 Jan 2020 20:40:11 +0100
Date:   Fri, 10 Jan 2020 20:40:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] TI DP8382x Phy support update
Message-ID: <20200110194011.GT19739@lunn.ch>
References: <20200110184702.14330-1-dmurphy@ti.com>
 <20200110192524.GO19739@lunn.ch>
 <2e9333e1-1ee7-80ce-fab4-a98a9f4b345f@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e9333e1-1ee7-80ce-fab4-a98a9f4b345f@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You mean separate series between fixes and functionality?
> 
> Sure I can separate them but they are dependent on each other.

Send 1 and 2 first. After about a week, David will merge net into
net-next, and then you can submit 3 and 4.

	  Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2061376F2
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgAJTZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:25:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60530 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbgAJTZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 14:25:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VeAF7kIPHmz5D92LYg39J7zZehUDxqe+O04AMdHzzQg=; b=0Q0k1JGHSvl1WRisv/SaIZ6779
        6/escUAYK8/hDLyen/evY4/3aKF+ZsQEuvpKw3yUQkntu0L7HEXZNLVd29O+tyecgOr3mnsLw801A
        gbdWRTjI3bufMC+pQWVxGlt6ldXOAHyTpmAed5wLNV0Os9Br7kcKUCu7cXUnAQjv+Kns=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipzuO-0003jt-PO; Fri, 10 Jan 2020 20:25:24 +0100
Date:   Fri, 10 Jan 2020 20:25:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] TI DP8382x Phy support update
Message-ID: <20200110192524.GO19739@lunn.ch>
References: <20200110184702.14330-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110184702.14330-1-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 12:46:58PM -0600, Dan Murphy wrote:
> Hello
> 
> These patches update and fix some issue found in the TI ethernet PHY drivers.

Hi Dan

Please could you separate fixes from new functionality. Have the fixes
based on net, and new functionality on net-next.

      Thanks
		Andrew

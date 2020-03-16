Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCBA1866A4
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgCPIjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:39:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730048AbgCPIjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 04:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3DP+sd7j/ZzTQQA7FONRN+KtsAjsjix8FVp93YaNriU=; b=DqG8FnLtpeAGJ3ywim5K/6XLR8
        KJKW2ANqD9R5c5BIyyf0I6y8xuf2QXqo76vZxNUG5if+MiPqe2YGXKltmG+qXfLJGp20v+wfzkXpi
        9q8Xk+fLg8JWmSsRgYIjKqWUKh1LepfNq+29d65MyaFVdEZgg/TZXsG8LLXQTi4/E6bg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDlHF-0005ox-7G; Mon, 16 Mar 2020 09:39:13 +0100
Date:   Mon, 16 Mar 2020 09:39:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
 memac_adjust_link()
Message-ID: <20200316083913.GC8524@lunn.ch>
References: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1584101065-3482-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20200314211601.GA8622@lunn.ch>
 <DB8PR04MB69859D7B209FEA972409FEEBECF90@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB69859D7B209FEA972409FEEBECF90@DB8PR04MB6985.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Madalin
> > 
> > You can use phy_interface_mode_is_rgmii()
> > 
> >     Andrew
> 
> I have that on the todo list for all the places in the code, but that's
> net-next material.

I don't see why it cannot be used here, for this case, now.

  Andrew

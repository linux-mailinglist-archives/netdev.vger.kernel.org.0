Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58D357225
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfFZUBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:01:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZUBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 16:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JJMeWxm/xaxRc9qFKp93QUqmWLZydNIdKPO3b1FAYzM=; b=T2gPMGqLp35DP4lEy2PDrJEzR8
        1qbec2hAd2TOCocm1oXGxvhgkRDIoXzwMRWZoza7BE+df0ekDE4J4AOH1JOoMussGcSf5pog4bTO+
        GA1HoZZiTDDL7a5SnpXnqwmhjw0CURoLMHEGTOdj4hQcpiHmfR6l2nKu1uRpzq6bPopc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgE6i-0003sn-Co; Wed, 26 Jun 2019 22:01:28 +0200
Date:   Wed, 26 Jun 2019 22:01:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if
 everything else fails
Message-ID: <20190626200128.GH27733@lunn.ch>
References: <cover.1561556555.git.joabreu@synopsys.com>
 <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 03:47:44PM +0200, Jose Abreu wrote:
> On PCI based setups that are connected to C45 PHY we won't have DT
> bindings specifying what's the correct PHY type.

You can associate a DT node to a PCI device. The driver does not have
to do anything special, the PCI core code does all the work.

As an example look at imx6q-zii-rdu2.dts, node &pcie, which has an
intel i210 on the pcie bus, and we need a handle to it.

   Andrew

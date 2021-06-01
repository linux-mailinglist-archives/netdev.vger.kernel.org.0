Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8D6397C4C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhFAWNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:13:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234740AbhFAWNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:13:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=y8LwDyWYmv5YNXiWo6XrFDujLoYra5BDGywMvk5NFl4=; b=jlhGbIHApiEzg8PFSvdCwdNYui
        KPnwoVWetNNnsKN60MmkBoMmIIb87Wbd+txqaGZbkddmlO6FSTdIkZUY7ha14fhKxWuBm056Lphz3
        EEq5Wg42Q4Glb60n0KCgtfJBUyFVsJ0w42esrPhiOxu7RuUo0bVQ+9ybBIPvwXWIkB+g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loCc9-007M0b-84; Wed, 02 Jun 2021 00:11:57 +0200
Date:   Wed, 2 Jun 2021 00:11:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: stmmac: enable platform specific
 safety features
Message-ID: <YLawrTO4pkgc6tnb@lunn.ch>
References: <20210601135235.1058841-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601135235.1058841-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 09:52:35PM +0800, Wong Vee Khee wrote:
> On Intel platforms, not all safety features are enabled on the hardware.

Is it possible to read a register is determine what safety features
have been synthesised?

     Andrew

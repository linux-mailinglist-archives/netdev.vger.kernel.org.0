Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D7718996
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfEIMV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 08:21:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59283 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfEIMV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 08:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zXNw1jQmPkUYW9nKNn/nGeP66jxj6hzctxtN7sOHYPs=; b=xv2GeDY/coNUvzDqOj1BXTYa24
        0DA9NVQNEsOJASSSxvSQTUlZByj1O9bGQcHUD35VKtSzug4JT2KhqwOcpL+P74KbYR/PmqNxBdAj9
        W3AQnp8TsEzzD+SaKuMS73Hc+F/7jh1qyw2kpBTC75bYt9Hvjt/jRdbY6627UoGjO6Bw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOi34-0001QE-U3; Thu, 09 May 2019 14:21:18 +0200
Date:   Thu, 9 May 2019 14:21:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 10/11] net: stmmac: Introduce selftests support
Message-ID: <20190509122118.GA4889@lunn.ch>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <be9099bbf8783b210dc9034a8b82219984f03250.1557300602.git.joabreu@synopsys.com>
 <20190509022330.GA23758@lunn.ch>
 <78EB27739596EE489E55E81C33FEC33A0B47AB21@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B47AB21@DE02WEMBXB.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You also seem to be missing a test for adding a unicast address via
> > dev_uc_add() and receiving packets for that address, but not receiving
> > multicast packets.
> 
> Hmm, what if interface was already configured to receive Multicast before 
> running the tests ?

The kernel keeps a list of unicast and multicast addresses, which have
been added to the filters. You could remove them all, do the test, and
then add them back. __dev_mc_unsync(), __dev_mc_sync() etc.

     Andrew

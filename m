Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F709F6AB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfH0XLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:11:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfH0XLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 19:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3EsfI+W1oV7QWg4ZZxNuGEuDrIF6A4ENQKc29P+ljHw=; b=4tst8DncPBLrZpJMt03E+A0Deu
        uojRabxbKHTkvQaLmolcXqrNoLPeNgYczFpE28s4qWp8W3VBrlJR0zPsyjT24TK9U53PGmPTYDIcF
        zpfhvPdL6pZuFnOfb1DjTko+4zsAVw4THvFvetYMGXcpzJzHel4Obl6gTSs3hltuU9No=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2kcr-0007EK-Qa; Wed, 28 Aug 2019 01:11:45 +0200
Date:   Wed, 28 Aug 2019 01:11:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v2 1/3] dpaa2-eth: Remove support for changing
 link settings
Message-ID: <20190827231145.GB26248@lunn.ch>
References: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 05:15:49PM +0300, Ioana Radulescu wrote:
> We only support fixed-link for now, so there is no point in
> offering users the option to change link settings via ethtool.
> 
> Functionally there is no change, since firmware prevents us from
> changing link parameters anyway.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

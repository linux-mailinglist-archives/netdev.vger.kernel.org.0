Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07F9F6B1
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfH0XMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:12:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35962 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfH0XMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 19:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fMdQDnlb7IIwDkIa2yf+qCFAH7cMdzYspx7zvfbq1Qg=; b=RXg+cQduKUi7douVIZoqhrnfLS
        RUG13n/5N+cXHiRl4Jf2w7EsxiKIfPQRQx8rq2aOg5aUvOLc/ALUxUeQxCWnYmMkUle4Rux+3U3Lw
        k5vQJ9XfdrbwQuxrwmRiAbJcllgM/HSnclxvrCPSQAg8vLyeaAEYfS7aVWfCkEp05DQI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2kdx-0007Fp-7r; Wed, 28 Aug 2019 01:12:53 +0200
Date:   Wed, 28 Aug 2019 01:12:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v2 2/3] dpaa2-eth: Use stored link settings
Message-ID: <20190827231253.GC26248@lunn.ch>
References: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
 <1566915351-32075-2-git-send-email-ruxandra.radulescu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566915351-32075-2-git-send-email-ruxandra.radulescu@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 05:15:50PM +0300, Ioana Radulescu wrote:
> Whenever a link state change occurs, we get notified and save
> the new link settings in the device's private data. In ethtool
> get_link_ksettings, use the stored state instead of interrogating
> the firmware each time.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

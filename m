Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1433D39
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFDCer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:34:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDCer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W4Nd3rZa8hbiXCs8eXcQdSzCJyL5prZ2g7Cam2r7J5s=; b=uaLC1fQ5rJeQnPyBDN2o2DZYYQ
        fsmmxIbE8DdoyK3ynku4Zc0sKI3RZL+GWsj4VzWi3qSOJK6tbROk3u41NagD40keWc8d1aLgc/JaR
        mHodr6Z7eBV4kL5ISC02NgRgVZGP+Q40m0ivKOK7njknQQXhDBFcy2qt8bJWJVbgfwa4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXzHh-0001aZ-Qi; Tue, 04 Jun 2019 04:34:45 +0200
Date:   Tue, 4 Jun 2019 04:34:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 06/18] net: axienet: fix teardown order of MDIO
 bus
Message-ID: <20190604023445.GL17267@lunn.ch>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
 <1559599037-8514-7-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559599037-8514-7-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:57:05PM -0600, Robert Hancock wrote:
> Since the MDIO is is brought up before the netdev is registered, it
> should be torn down after the netdev is removed. Otherwise, PHY accesses
> can potentially access freed MDIO bus references and cause a crash.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

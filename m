Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5327569CC
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfFZMzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:55:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfFZMzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yT0rn71eJrhNpfTMWEQZBj+UoXHe3mCcO0rpDnUXHfI=; b=wM7IIzVfkAcMWl/r01gnBjtAtd
        u4DFFqSkq89KtiYEKu6z8o3MreVw37EceFAzNVljrcdcTWs70kKWfr/xJisQ1M9L5NFsUv6T+IvkP
        uDxoV/XGWrcvzNJDA+oz2EKzxSrgdqtfen22jIqDuWLdRCm+9rIleddlfCrTWXAPj14s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hg7SH-0001GD-2A; Wed, 26 Jun 2019 14:55:17 +0200
Date:   Wed, 26 Jun 2019 14:55:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Pfahl <tpf@thorsis.com>
Subject: Re: net: never suspend the ethernet PHY on certain boards?
Message-ID: <20190626125517.GA3115@lunn.ch>
References: <4693980.Yko7hG0E1C@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4693980.Yko7hG0E1C@ada>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What I could do:
> 
> 1) Revert that change on my tree, which would mean reverting a generic bugfix
> 2) Patch smsc phy driver to not suspend anymore
> 3) Invent some new way to prevent suspend on a configuration basis (dt?)
> 4) Anything I did not think of yet

5) Enable WoL?

There are other boards which have PHY clock issues. Let me check how
they work around this.

     Andrew

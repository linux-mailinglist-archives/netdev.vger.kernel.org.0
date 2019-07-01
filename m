Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2517F5C20F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfGARfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:35:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbfGARfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E1UmLl82OoKQ8ZBmKYRHk0N/r3DegGvS2akN2XkPkfY=; b=TLL8uKSHII/YR/WtzpqI0R8aij
        lWeYHrqI/se04EBoo+ZWPBHsLE/4LI3MmKvDQGdrdNYG/BWhbUTuBjyBMEDR7Pq9DCSeemD+mDPHt
        2kq50IHFkoDQsJqZxK/vViobPIZY2slTYeMrpVMZUh17Jdaz70flG5z7NoK8HqxB3wuQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hi0DW-0000Su-TC; Mon, 01 Jul 2019 19:35:50 +0200
Date:   Mon, 1 Jul 2019 19:35:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH v2 2/2] Documentation: net: dsa: b53: Describe b53
 configuration
Message-ID: <20190701173550.GH30468@lunn.ch>
References: <20190701154209.27656-1-b.spranger@linutronix.de>
 <20190701154209.27656-3-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701154209.27656-3-b.spranger@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Configuration without tagging support
> +-------------------------------------

How does this differ to the text you just added in the previous patch?
Do we need both?

   Andrew

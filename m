Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B002F2ED3
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388532AbfKGNGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:06:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbfKGNGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 08:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MC3k/ZlIufIsGFUpbpNOqcs8bvxICl+BRLbngbZ0kAI=; b=FolTZ1fJXJarQtz+Z12aaaorms
        Qab7cv0dRQ8rCI3LcNi3KvFs1sSkl4v0IhLrRAQfjoMZ78gnQIrMFi7iFN4XgDnJx2nbTU+c8BQaf
        sSKRYiGYkkXkRhvKx2Q5MMqCP+kjoU6rPxyizRIIeksbN5sxDI3xzj1/sLf5kMLK01LA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iShUm-00066t-8L; Thu, 07 Nov 2019 14:06:40 +0100
Date:   Thu, 7 Nov 2019 14:06:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] dpaa2-eth: add ethtool MAC counters
Message-ID: <20191107130640.GE22978@lunn.ch>
References: <1573123488-21530-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573123488-21530-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 12:44:48PM +0200, Ioana Ciornei wrote:
> When a DPNI is connected to a MAC, export its associated counters.
> Ethtool related functions are added in dpaa2_mac for returning the
> number of counters, their strings and also their values.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

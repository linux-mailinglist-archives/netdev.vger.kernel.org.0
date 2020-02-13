Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF45215BF0D
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgBMNSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:18:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgBMNSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 08:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BzwddgjsofKJ+h5tzY+03c9BFb4cCZNjQhJ2QKP7wMg=; b=hvWYeCvTGm0c5Vddea7ZtngDb7
        ie7nTOXuBCMjFidq3TPOnIW1xBPHBHvUQSlgYE8z4+nuFpTW/OQ7IlALun8Ab+jGhGt3tLbaYzPCU
        TYAc/B+ONeFJawPpo0LlaiOVAnMpfmSuIGF69IoWl9IYGqm0Iuis4KY77kUGMXBCRUS4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2ENc-00037Q-Sm; Thu, 13 Feb 2020 14:18:08 +0100
Date:   Thu, 13 Feb 2020 14:18:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Per@axis.com
Cc:     netdev@vger.kernel.org, o.rempel@pengutronix.de,
        davem@davemloft.net, Per Forlin <per.forlin@axis.com>,
        Per Forlin <perfn@axis.com>
Subject: Re: [PATCH 2/2] net: dsa: tag_ar9331: Make sure there is headroom
 for tag
Message-ID: <20200213131808.GC11855@lunn.ch>
References: <20200213090707.27937-1-per.forlin@axis.com>
 <20200213090707.27937-2-per.forlin@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213090707.27937-2-per.forlin@axis.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 10:07:07AM +0100, Per@axis.com wrote:
> From: Per Forlin <per.forlin@axis.com>
> 
> Passing tag size to skb_cow_head will make sure
> there is enough headroom for the tag data.
> This change does not introduce any overhead in case there
> is already available headroom for tag.
> 
> Signed-off-by: Per Forlin <perfn@axis.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

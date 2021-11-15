Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9384517D4
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345378AbhKOWpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:45:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242809AbhKOW1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:27:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pt182shO8dQapsSmI/meQKt0JUpU9jN/PCfuHBtBK74=; b=uSWjVW+AAccSxsbeusfhFdOruY
        coctEW05x5qkmOQrlUZ3Sl8p1GfMOtENKhp2FQLxJseh4nm7+0JSLkB1esYY4OP3UrWfUFPPA3Dce
        7yOfT6R5bCpJoXm3YTC1vjOWJJImAPL+e2AGsv5YkdUVWbSwSSd+H9W7PkH4H5OzZOts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmkP5-00DXMr-N1; Mon, 15 Nov 2021 23:24:43 +0100
Date:   Mon, 15 Nov 2021 23:24:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next v5 1/3] dt-bindings: Add vendor prefix for
 Engleder
Message-ID: <YZLeK5flfAdbxcQF@lunn.ch>
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
 <20211115205005.6132-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115205005.6132-2-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 09:50:03PM +0100, Gerhard Engleder wrote:
> Engleder develops FPGA based controllers for real-time communication.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

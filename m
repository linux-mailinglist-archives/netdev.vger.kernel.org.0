Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004324517C1
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351511AbhKOWqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:46:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349865AbhKOW2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:28:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6YviG/4kpdlHAG3ayBznpj/afXHLHv9VMBPfsKUX+0E=; b=GRUPWwvC/QmCvDJxFk6FLJ+ctr
        uKpzNXyVYPRpseWrmKAj2I1fmA8REII256GqOoVI6i4ZyDsxO/U2kiGjdqFBBMLc/4nczmfRBw72M
        rjLvMwQvEJHz7TtLTIO0mlJD07wKrH4jZG5pun9zDB394aq8HvkEZ1w942Av3w8eA5PQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmkQ1-00DXND-CW; Mon, 15 Nov 2021 23:25:41 +0100
Date:   Mon, 15 Nov 2021 23:25:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next v5 2/3] dt-bindings: net: Add tsnep Ethernet
 controller
Message-ID: <YZLeZaeruHyFQxN3@lunn.ch>
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
 <20211115205005.6132-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115205005.6132-3-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 09:50:04PM +0100, Gerhard Engleder wrote:
> The TSN endpoint Ethernet MAC is a FPGA based network device for
> real-time communication.
> 
> It is integrated as normal Ethernet controller with
> ethernet-controller.yaml and mdio.yaml.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

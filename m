Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4557E3D3B60
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhGWNFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:05:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235280AbhGWNFw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 09:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CmXWj2ABPqg7RX0vUEbBpvnD+N3bC87TMH6iFSWsAyw=; b=Ouz+oerYnlrUb2wjHcQBvfVjwO
        HSulFfWZ4IskJWLSbgD/9Yn4y5trGx8NEW7eKwL+Wt6Xb/+7KeRWl32yVE9921/R3guLcmMhZKsqk
        k2F2WECEB9vg1m7MbDCB4Q2uJKru0vZTAgEt75Jrj95saRlQkSavrzeHKzWidxN0tPZk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6vVM-00EV2u-Nt; Fri, 23 Jul 2021 15:46:20 +0200
Date:   Fri, 23 Jul 2021 15:46:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2] docs: networking: dpaa2: add documentation
 for the switch driver
Message-ID: <YPrILGYhg/8vwEyH@lunn.ch>
References: <20210723084244.950197-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723084244.950197-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:42:44AM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Add a documentation entry for the DPAA2 switch listing its
> requirements, features and some examples to go along them.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

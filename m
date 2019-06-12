Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFE5427F5
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436898AbfFLNtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 09:49:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436750AbfFLNtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 09:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=26lC4u1mGzTrFbxBa1LHdt26klqvOKqg9m2EWgNfPJA=; b=xGaR8d62T7u2Gi8ZgrpggbgK6u
        7q97IU4YmT7eD+NbgyKPIUUDyZ2nxV1G2KdmwBqEv8xF4ct7RJS7yyBqLZGJjsHojoTBp8+l/x4it
        pMxYdzWrdnK/Hl/4DkVNo21eyKvWdQjJNltjPLwOJImtAZrBvgQgjXlKciFiPq2CDJn4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb3cs-0004zh-PW; Wed, 12 Jun 2019 15:49:18 +0200
Date:   Wed, 12 Jun 2019 15:49:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next] net: axienet: move use of resource after
 validity check
Message-ID: <20190612134918.GA18923@lunn.ch>
References: <1560272162-14856-1-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560272162-14856-1-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:56:02AM -0600, Robert Hancock wrote:
> We were accessing the pointer returned from platform_get_resource before
> checking if it was valid, causing an oops if it was not. Move this access
> after the call to devm_ioremap_resource which does the validity check.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

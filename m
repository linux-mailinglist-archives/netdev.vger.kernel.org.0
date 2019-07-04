Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1535FC9F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGDRqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:46:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54452 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbfGDRqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 13:46:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zmJ1Ky3mXPAEfU6qoexSxRPZl5T9f2Uc56rmlTX8GqI=; b=GT6NxME7VLBqKZ3YNW3raJILm4
        +fCKm7SXEN/mI62E7athTo75xx4kBV3BGJS5haBafsDXljoCrBW6rWdWpucfsQya7cgOpqecH0/BI
        tacwTzmSeYBUuiw0O1yVgGM2DVpOYQfNCEZ8RuawX1zomyMhcLl6L6r6GcxrcJ5Ri5Y4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hj5o5-0005M3-NW; Thu, 04 Jul 2019 19:46:05 +0200
Date:   Thu, 4 Jul 2019 19:46:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     James Feeney <james@nurealm.net>
Cc:     netdev@vger.kernel.org
Subject: Re: "local" interfaces, in forwarding state, are mutually "blind",
 and fail to connect
Message-ID: <20190704174605.GF13859@lunn.ch>
References: <a56eee49-49dc-1e61-19a4-6dfb6bd66f3e@nurealm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a56eee49-49dc-1e61-19a4-6dfb6bd66f3e@nurealm.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 11:11:21AM -0600, James Feeney wrote:
> I have a question - maybe someone can point me in the right direction?
> 
> When there exist two or more "local" interfaces

Hi James

What exactly do you mean by a 'local' interface? The IP address on the
interface has scope local?

	  Andrew

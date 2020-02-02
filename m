Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8892E14FF18
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 21:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgBBUWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 15:22:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgBBUWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 15:22:39 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1682020658;
        Sun,  2 Feb 2020 20:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580674959;
        bh=n6DMAWVz8TW+A/9HqaSIwWSTE9GZEUMZvHkmuPlJkXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NZl/pfkvwbx0177FKMLGGNUcn/RJtNfI/GIVrT847YwlNgjDOWHYp3oQIYbAGG+fA
         TqNjEwp/R0A7825ADlIa9ASjkTABbWILLXmT/l8J1/oAe595Cav3WYQHEFO077qHyT
         Cj15jeaVMa1KY/jXwE4W7Ma3CIwLqCLsQNgmJiWA=
Date:   Sun, 2 Feb 2020 12:22:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: mdio: of: fix potential NULL pointer
 derefernce
Message-ID: <20200202122238.5b30526e@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <71c69df848b37e3cc3db43fc27598484@walle.cc>
References: <20200130174451.17951-1-michael@walle.cc>
        <20200131074912.2218d30d@cakuba.hsd1.ca.comcast.net>
        <71c69df848b37e3cc3db43fc27598484@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 02 Feb 2020 21:13:53 +0100, Michael Walle wrote:
> Am 2020-01-31 16:49, schrieb Jakub Kicinski:
> > On Thu, 30 Jan 2020 18:44:50 +0100, Michael Walle wrote:  
> >> of_find_mii_timestamper() returns NULL if no timestamper is found.
> >> Therefore, guard the unregister_mii_timestamper() calls.
> >> 
> >> Fixes: 1dca22b18421 ("net: mdio: of: Register discovered MII time 
> >> stampers.")
> >> Signed-off-by: Michael Walle <michael@walle.cc>  
> > 
> > Applied both, thank you.  
> 
> Just for completeness, the subject should have to be [PATCH net], 
> because its a fix, correct?

Yup.

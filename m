Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A2E14F211
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgAaSUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaSUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:20:46 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB8A20707;
        Fri, 31 Jan 2020 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494292;
        bh=gQno9C8p/R8VNXviQsvTyedgYHZxejFQg8eaD99IcSw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gqHXgQ6QYuxFgykHeqKwbiu9BqIB8i++0YkKIbyp8HuV2VvRxhjAZEXOdrTpYAyFb
         2xa15SknxDnFoJg6pqSN97HzhKDhD2BApDYKOqMjTZIiW5aRBmbJ56KVphXSFJxYB3
         K9jHLCQHIcgfuo2G9Yw0zK7sdyrpneLkXxtx9VGQ=
Date:   Fri, 31 Jan 2020 10:11:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed
 optimization feature
Message-ID: <20200131101130.1b265526@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <6b4bb017-de97-0688-47c5-723ec4c3a339@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
        <20200131151110.31642-2-dmurphy@ti.com>
        <20200131091004.18d54183@cakuba.hsd1.ca.comcast.net>
        <6b4bb017-de97-0688-47c5-723ec4c3a339@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 11:14:05 -0600, Dan Murphy wrote:
> On 1/31/20 11:10 AM, Jakub Kicinski wrote:
> > While we wait for the PHY folk to take a look, could you please
> > provide a Fixes tag?  
> 
> Hmm. This is not a bug fix though this is a new feature being added.
> 
> Not sure what it would be fixing.

I see, you target the patch at net which is for fixes, so I
misinterpreted this:

> This feature can also be strapped on the 64 pin PHY devices
> but the 48 pin devices do not have the strap pin available to enable
> this feature in the hardware.

as you fixing 48 devices or such.

So please correct the tree to net-next and since net-next is now closed:
http://vger.kernel.org/~davem/net-next.html
only post as RFC until net-next opens back up.

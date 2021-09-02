Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07213FF7C7
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347999AbhIBXYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:24:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347957AbhIBXYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 19:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+yKR/riTYqXSZVtoHVvEoomy76pMk4BtqdFgkCWw18A=; b=vOJcrdzerYzK9Z/Q+B1TRwOLiP
        L83zgu1Cp5KE3U0unUQHf7Yt9aHz1iV+gbOQqKuy+fR8Vj4BNypiad8WwANpDvJoK0MYPY3COzIFs
        xNg4jN6YBEMDLMXYngXdU7g4CPFBjuf/Ab2syNirzuY3KU+FpZqW+5mHfMtd/nk9wyAo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLw3G-0053yD-H9; Fri, 03 Sep 2021 01:23:22 +0200
Date:   Fri, 3 Sep 2021 01:23:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     hnagalla@ti.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, geet.modi@ti.com,
        vikram.sharma@ti.com
Subject: Re: [PATCH] net: phy: dp83tc811: modify list of interrupts enabled
 at initialization
Message-ID: <YTFc6pyEtlRO/4r/@lunn.ch>
References: <20210902190944.4963-1-hnagalla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902190944.4963-1-hnagalla@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 02:09:44PM -0500, hnagalla@ti.com wrote:
> From: Hari Nagalla <hnagalla@ti.com>
> 
> Disable the over voltage interrupt at initialization to meet typical
> application requirement.

Are you saying it is typical to supply too high a voltage?

    Andrew

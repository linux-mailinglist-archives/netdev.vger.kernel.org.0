Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF24145A93
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVRGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:06:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50306 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgAVRGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 12:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wg/FZ/p++mWNp6tHKGsdPRuUHhT0drRrVjgg/6KXKZY=; b=OxehdDJMqIi9U9+qV70rfRVbcs
        SrJrR/M3mPFkpCgq2JxYD5zFQM0Xm80vJVYKD8u/s33Yj3I/DVZqdhgsvHq0BMzPtjbHVSvdu0OfU
        lxLchD8LmMYSXaRXf6uMfFrI0qLs3YZxTKDhNIwoUlYWQh4c/wuXjx4+ScjyiX7gjTts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iuJSk-0002zX-Bs; Wed, 22 Jan 2020 18:06:42 +0100
Date:   Wed, 22 Jan 2020 18:06:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, bunk@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] phy: dp83826: Add phy IDs for DP83826N and
 826NC
Message-ID: <20200122170642.GB10587@lunn.ch>
References: <20200122153455.8777-1-dmurphy@ti.com>
 <20200122153455.8777-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122153455.8777-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 09:34:54AM -0600, Dan Murphy wrote:
> Add phy IDs to the DP83822 phy driver for the DP83826N
> and the DP83826NC devices.  The register map and features
> are the same for basic enablement.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

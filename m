Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC8145A99
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgAVRHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:07:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgAVRHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 12:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Hwv8i3IjkxkJKU9S0gMYWlC44G0pjbeMXhIjqeml7ds=; b=aTrZhMiFHgGqJSmA3kwjdz2mp4
        lWCBD+rhiqvrJvSMIZ1v9nkmW1Gyc9YITBwhz1aSllAO+fusTMvIP0kjvQqToudhVCaIm5DwxMh6Z
        1HmpCBQfzrxnQsDPnUqKNqBX6SMgo6P44mK/rE8JqAp+WY/yQw/lPe3tWfy0iz85Yvfc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iuJT9-00030G-44; Wed, 22 Jan 2020 18:07:07 +0100
Date:   Wed, 22 Jan 2020 18:07:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, bunk@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: DP83822: Add support for
 additional DP83825 devices
Message-ID: <20200122170707.GC10587@lunn.ch>
References: <20200122153455.8777-1-dmurphy@ti.com>
 <20200122153455.8777-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122153455.8777-3-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 09:34:55AM -0600, Dan Murphy wrote:
> Add PHY IDs for the DP83825CS, DP83825CM and the DP83825S devices to the
> DP83822 driver.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

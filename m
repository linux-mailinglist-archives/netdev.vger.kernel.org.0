Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6746E18E928
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 14:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCVNdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 09:33:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgCVNdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 09:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yoaq8CUg0a/6ZyM8CeF2w4rPGEc4RYKWlnI0CXYHgX8=; b=nJbDRtVR9zsqTO7BLmzvZZyABJ
        /h5sVa+LvNyJxR7jTpmOCCYuZhK80euKCIa6cspkohL0KI4MgHUNgoL6UN9gpc+VawXnkfHn02wGN
        BBpu6mhPaFmS8jv5ZePCgUYs10yiqvV21+GP3PL4okaCQahQU3DvDdOnbYO4mZXPl8vA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG0iv-0008MQ-4a; Sun, 22 Mar 2020 14:33:05 +0100
Date:   Sun, 22 Mar 2020 14:33:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: add marvell usb to mdio bindings
Message-ID: <20200322133305.GC11481@lunn.ch>
References: <20200321202443.15352-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321202443.15352-1-tobias@waldekranz.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 09:24:42PM +0100, Tobias Waldekranz wrote:
> Describe how the USB to MDIO controller can optionally use device tree
> bindings to reference attached devices such as switches.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8728018E92A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCVNft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 09:35:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgCVNft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 09:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ii1YFKw819yMHAI8XHEcZpSUF6LTxCmduFns+LATn0M=; b=k9/MXEutAuL9L6sRD8hUo7aHGw
        tZY50ma5mP0YDxv8FrFygp1Iv8vJwPBnEiyk7wcQW+AX2AvzOSvGMnJKO+xwtb7awLcIkajSzxo7S
        MIR1kFl7uL5zO2b5oLPb4SoxQGXSDk50xc/yM54HDXc0GUeF7dY1+ejOxUh7f0fb8RJo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG0lW-0008NK-Td; Sun, 22 Mar 2020 14:35:46 +0100
Date:   Sun, 22 Mar 2020 14:35:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: add marvell usb to mdio bindings
Message-ID: <20200322133546.GD11481@lunn.ch>
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

Hi Tobias

A few process things.

The subject line should be "[PATCH net-next] ..." to indicate which
tree this is for.

For a patch set, please always include a cover note. git format-patch
will generate the template and then include text about the patch
series as a whole.

https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

	Andrew

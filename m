Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A75C225E
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbfI3NpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:45:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730266AbfI3NpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 09:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TX9wnU6GxjpTdVTIs1I3fh3Nz1Y0r7P36wX0FrGUkm0=; b=i9thRDs/NMXBRSmsuxCAOWgMbn
        n0ratjB7P952gSbn3B3I4Z3Zf7ZtQaGLVS5YKHMgPIrE3MD9UCacT6CNqCbdQM8epLMD7DBDWZjpm
        aSF4VKMT2Qatvai7rYAAU1eRAhdTVc4MRcJTXjhUts0T/AUEseKid358w+Ac9qwWIHsQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iEvzD-0003w6-Oq; Mon, 30 Sep 2019 15:45:11 +0200
Date:   Mon, 30 Sep 2019 15:45:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Fink <pedro@pixelbox.red>
Cc:     netdev@vger.kernel.org, pfink@christ-es.de, davem@davemloft.net,
        linux@christ-es.de
Subject: Re: [PATCH net-next] net: usb: ax88179_178a: allow optionally
 getting mac address from device tree
Message-ID: <20190930134511.GC14745@lunn.ch>
References: <1569845043-27318-1-git-send-email-pedro@pixelbox.red>
 <1569845043-27318-2-git-send-email-pedro@pixelbox.red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569845043-27318-2-git-send-email-pedro@pixelbox.red>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 02:04:03PM +0200, Peter Fink wrote:
> From: Peter Fink <pfink@christ-es.de>
> 
> Adopt and integrate the feature to pass the MAC address via device tree
> from asix_device.c (03fc5d4) also to other ax88179 based asix chips.
> E.g. the bootloader fills in local-mac-address and the driver will then
> pick up and use this MAC address.
> 
> Signed-off-by: Peter Fink <pfink@christ-es.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

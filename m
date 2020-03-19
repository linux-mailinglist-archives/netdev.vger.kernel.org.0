Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEFE18C01D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCSTLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:11:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSTLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 15:11:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=arSNPRnbelSZM05feK81NZFDXprlN+HxeU2O7Gchwh4=; b=JeT+3A/JPXIawcNQCYBxTObVb5
        cY6nXRT1MU/eZ4On+vjJy4EfmkT2KUQNOVM/CXGbvbCejUVi97Y9YhCNCv+KZ5PTQPopdWq7H8hOn
        UUg2Yp/njWGvspvDYRZtnkKfVbWzdSxtd+fR1OBvQ9KQTSV//hCplSb+EaLhKwZ+6On0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jF0ZH-0000NS-F1; Thu, 19 Mar 2020 20:10:59 +0100
Date:   Thu, 19 Mar 2020 20:10:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 1/2] net: dsa: add a dsa_port_is_enabled helper
 function
Message-ID: <20200319191059.GL27807@lunn.ch>
References: <20200319185620.1581-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319185620.1581-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 08:56:19PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Sometimes drivers need to do per-port operation outside the port DSA
> methods, and in that case they typically iterate through their port list
> themselves.
> 
> Give them an aid to skip ports that are disabled in the device tree
> (which the DSA core already skips).

Hi Vladimir

Why not dsa_is_unused_port()?

    Andrew

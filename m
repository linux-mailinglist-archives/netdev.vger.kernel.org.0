Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732F31E0FDA
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 15:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403923AbgEYNvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 09:51:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48118 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403912AbgEYNvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 09:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n4Hcu/XRHflYCp2TxqUSLVLdPJzrZab4RenrXRass2A=; b=xT18/pBD89exWXmFn6J7S9I0I/
        BsPv3JqfeRRpbWOHcIxLVniHX4fOVjAmg4XtOm96KhbZvH/o96ivbmvLSFFpPFKuapdKVfkM3563k
        J1/S9s7gl/1P5z/kE7rx1mcJFkywyw3Oy5SHOgp8ClFhWlfOGG0hGndxG9/bMljU7gHI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdDVQ-003C3d-Ax; Mon, 25 May 2020 15:51:04 +0200
Date:   Mon, 25 May 2020 15:51:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     fugang.duan@nxp.com
Cc:     martin.fuzzey@flowbird.group, davem@davemloft.net,
        netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net v2 3/4] ARM: dts: imx: add ethernet stop mode property
Message-ID: <20200525135104.GB752669@lunn.ch>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
 <1590390569-4394-4-git-send-email-fugang.duan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590390569-4394-4-git-send-email-fugang.duan@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 03:09:28PM +0800, fugang.duan@nxp.com wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> - Update the imx6qdl gpr property to define gpr register
>   offset and bit in DT.
> - Add imx6sx/imx6ul/imx7d ethernet stop mode property.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

Thanks for adding a user.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

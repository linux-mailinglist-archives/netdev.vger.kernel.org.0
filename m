Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC49326A9A
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfEVTKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:10:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43689 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729018AbfEVTKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:10:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PNJRWxFcaaesA5/A+f/to33ahDt1v6pVFQ28V94qaf0=; b=3k97Aq5Vwj5fDIf7enemRmJSfh
        WxPFG8l6+0ig/GZlwirMLQdc0E1woYvfGbBuBZ16uU2IkUvwy2nWMWcgmmugXRRhXGAfEyyfL40fM
        x6RyskxnorKPDin8xEqSbqvpqcCvHUp57ZEOrE1AibtEyiEz9pqeskVVmLb0icDZ082g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWdL-0002VG-7f; Wed, 22 May 2019 21:10:39 +0200
Date:   Wed, 22 May 2019 21:10:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Trent Piepho <tpiepho@impinj.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH net-next v2 1/8] dt-bindings: phy: dp83867: Describe how
 driver behaves w.r.t rgmii delay
Message-ID: <20190522191039.GG7281@lunn.ch>
References: <20190522184255.16323-1-tpiepho@impinj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522184255.16323-1-tpiepho@impinj.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Wed, May 22, 2019 at 06:43:19PM +0000, Trent Piepho wrote:
> Add a note to make it more clear how the driver behaves when "rgmii" vs
> "rgmii-id", "rgmii-idrx", or "rgmii-idtx" interface modes are selected.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

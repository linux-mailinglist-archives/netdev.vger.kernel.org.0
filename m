Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE71492F73
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349272AbiARUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:34:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44688 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349270AbiARUeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:34:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA1F3612E6;
        Tue, 18 Jan 2022 20:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0977C340E2;
        Tue, 18 Jan 2022 20:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642538055;
        bh=a7eQGTBopVPgvTw08Y5Ltm/FC6r6uVERo3wx+LCHqWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K0kYcIC+ocHAeSmsVl5YVeilSsemMYVs/7FnVOTdy8BPKTGJ0+XeIO4zdy6Oyx6J4
         gvmGdbYRFnOthooppITBIhCdgyz5VMNlhhPtotsk+8FANRexcxQrlneor5Q2YVcE2F
         CmHCmSMPnhWzE9kVLRBpaoU+vVjlqjj6+4M9qvrYzNkQs/td0XTy0Bw7vukTm1DuZ+
         SN2TmF8RV4lIv/wxA8jYDpsa4ge4URHBtKkAxkKFeQV2nAfFxcr1+2Y1zvV8+ahhP4
         QoUxZxdOFmz9pOqWtG70nLueeiGO/5s15fwqtda/mpO/a215vJJb9Loz0TvuLidvAw
         7Zp0zPFUZfPHQ==
Date:   Tue, 18 Jan 2022 12:34:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        madalin.bucur@nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 1/4] net/fsl: xgmac_mdio: Add workaround for erratum
 A-009885
Message-ID: <20220118123413.70f469bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <YeV2idN2wPzrHI0n@lunn.ch>
References: <20220116211529.25604-1-tobias@waldekranz.com>
        <20220116211529.25604-2-tobias@waldekranz.com>
        <YeSV67WeMTSDigUK@lunn.ch>
        <87czkqdduh.fsf@waldekranz.com>
        <YeV2idN2wPzrHI0n@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 15:00:41 +0100 Andrew Lunn wrote:
> > Should I send a v2 even if nothing else
> > pops up, or is this more of a if-you're-sending-a-v2-anyway type of
> > comment?  
> 
> If you reply with a Fixes: patchwork will automagically append it like
> it does Reviewed-by, Tested-by etc.

That part is pretty finicky, it's supposed to work but when I apply
these I only get review tags from Andrew and a Fixes tag already
present on the last patch :(

A v2 with Fixes tags included in the posting would be best after all.
Thanks!

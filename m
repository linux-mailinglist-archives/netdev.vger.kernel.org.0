Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB68F6632F6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbjAIVdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237838AbjAIVdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:33:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C51E1FF
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 13:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fm1MlWLSpUG1NuLCilrirA36h/5EAuNH/F/tsJkFXBs=; b=VRt3yruiR5GJQ5zLmKIIqvHpsW
        aWI8ZDNtTN0X0ehu6GLgswQagfT4M2tqAUwFOiqWys8Lq/X97DZe+ei1h6ZiJiX8i1pRDc+7Txtpx
        fZr0wgF+wb+TdNDC+7gp45WAsTTRo53PAMJ+Gugyva2Yk84mB8bHSAsjiidrzFowejjw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEzlr-001cEW-Qz; Mon, 09 Jan 2023 22:33:31 +0100
Date:   Mon, 9 Jan 2023 22:33:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <Y7yIK4a8mfAUpQ2g@lunn.ch>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 09:40:06PM +0100, Angelo Dureghello wrote:
> Hi All,
> 
> using kernel 5.4.70,
> just looking for confirmation this layout
> can work:
> 
>    eth0 -> cpu port (port5, mii)  bridging port3 and 4
>    eth1 -> cpu port (port6, rgmii)  bridging port0, 1, 2
> 
> My devicetree actaully defines 2 cpu ports, it seems
> to work, but please let me know if you see any
> possible issue.

Dual CPU ports is not supported with 5.4.70. Everything will go over
the first cpu port in DT.

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812D943A946
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 02:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhJZAfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 20:35:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233957AbhJZAfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 20:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CH67qVBNSPsgCq2cZ+MyMsRC/HhwlUMoFtGRSFOT6/I=; b=1u0SN7M70TqRWJBNz5u5l51BJu
        bIY9XZE3h9gfBSQGdFwGW6Xk1FCl+Qy8fdqiJr+NP+45kBXIxdx3yzD1YLLEVh43g+wite2hYU52r
        3P11iuiv4SAdOmJR+3Ue161NgiSQLL+tsrhm+PDy+lUHHiVZwZ8iZDrOVwOB8DPw2DEc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfAOS-00BiAb-Oe; Tue, 26 Oct 2021 02:32:44 +0200
Date:   Tue, 26 Oct 2021 02:32:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Schlabbach <Robert.Schlabbach@gmx.net>
Cc:     netdev@vger.kernel.org
Subject: Re: ixgbe: How to do this without a module parameter?
Message-ID: <YXdMrL2ZEW5c+adB@lunn.ch>
References: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
 <87k0i0bz2a.fsf@toke.dk>
 <YXcdmyONutFH8E6l@lunn.ch>
 <trinity-b6836216-b49e-4e59-80af-7b9c48918b19-1635205677415@3c-app-gmx-bap12>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-b6836216-b49e-4e59-80af-7b9c48918b19-1635205677415@3c-app-gmx-bap12>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So I realize using ethtool is a viable solution after all and the module
> parameter is not needed. I'd still wish the ixgbe driver would default to full
> functionality and require the users with the "bad" switches in their networks
> to employ ethtool to cripple its function, but I suppose that'd be tough to
> sell to Intel...

Maybe, maybe not. Quoting the above message:

> This is the first time I've heard of anyone asking for 2.5G or 5G
> outside of the telecom space, so we went with the option of changing
> the default.

NBASE-T is no longer just telecom space. It is slowly becoming more
and more popular in general deployment.

At some point, there will be more standard conforming switches than
broken switches, and then it would make sense to enable the higher
speeds by default. Especially when everybody else is doing
NBASE-T. You see a lot of ARM SoCs with such ports, etc.

	 Andrew

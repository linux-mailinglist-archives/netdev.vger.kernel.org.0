Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E76E406535
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 03:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhIJBcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 21:32:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIJBcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 21:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sscp3Ut57K/BMlySkUoFVQ/C47t39TDAIX1UAj0bilQ=; b=bFBIJ3uVeWMhGUFUiLhnCthgoa
        982ogK0R7/ZfDkup/LGDoz/ir7CoqzNG+/z959BEQXwew3L1gBOvx7yxG6oxsxLVR3giSZJGiZTs0
        tOSEAoXuLbxMh3xD3GghyOWLlz7JfUOIDnPfASSc8WlAFpUdGygqZqx1RDxuesLlL3sI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOVNR-005zgL-02; Fri, 10 Sep 2021 03:30:49 +0200
Date:   Fri, 10 Sep 2021 03:30:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Modi, Geet" <geet.modi@ti.com>
Cc:     "Nagalla, Hari" <hnagalla@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sharma, Vikram" <vikram.sharma@ti.com>, dmurphy@ti.com
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy:
 dp83tc811: modify list of interrupts enabled at initialization
Message-ID: <YTq1SATpNvwo+ojg@lunn.ch>
References: <20210902190944.4963-1-hnagalla@ti.com>
 <YTFc6pyEtlRO/4r/@lunn.ch>
 <99232B33-1C2F-45AF-A259-0868AC7D3FBC@ti.com>
 <YTdxBMVeqZVyO4Tf@lunn.ch>
 <E61A9519-DBA6-4931-A2A0-78856819C362@ti.com>
 <YTpwjWEUmJWo0mwr@lunn.ch>
 <E3DBDC45-111F-4744-82A8-95C7D5CCEBE5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E3DBDC45-111F-4744-82A8-95C7D5CCEBE5@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 12:41:53AM +0000, Modi, Geet wrote:
> Hi Andrew,
> 
> As mentioned we want to do this in phases: 
> a) this patch to disable the Overvoltage driver interrupt
> b) After carefully considering other interrupts, plan a  follow-on patch to take care of other interrupts.

I still don't get it. Why just Over volt now and not the rest, which
are equally useless? It makes me think there is something seriously
wrong with over voltage, which you are not telling us about. Maybe an
interrupt storm? If there is something broken here, this patch needs
to be back ported to stable.

   Andrew

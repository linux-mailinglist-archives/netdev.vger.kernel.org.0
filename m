Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5280618AED9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 09:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCSI60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 04:58:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44632 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCSI60 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 04:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3qTNVfTalmQw4j9NwfoM927J2Yu1TVj9lFggc1wxXrM=; b=TH+EMnSqYlryYc/9Modbn0ujuk
        uQ3fMqCReDQHzRHrsLYK3/47CJnkiE8xAPUghz+XlvkiIt2Nd2vGZjxEKJvbVNa4XkXu8Je93DKPA
        jFc34UPG5EBfpluUVN2Vz1hKFrxRYI/2mIhz+PsEZek5ER/bFa7vBr2imsQNVvTE3Oe8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEr0G-0005Py-6I; Thu, 19 Mar 2020 09:58:12 +0100
Date:   Thu, 19 Mar 2020 09:58:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Message-ID: <20200319085812.GA20761@lunn.ch>
References: <20200319012940.14490-1-marek.behun@nic.cz>
 <d7cfec6e2b6952776dfedfbb0ba69a5f060d7cb5.camel@alliedtelesis.co.nz>
 <20200319052119.4e694c8b@nic.cz>
 <de28dd392987d666f9ad4a0c94e71fc0a686d8d6.camel@alliedtelesis.co.nz>
 <20200319053659.4da19ae0@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200319053659.4da19ae0@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 05:36:59AM +0100, Marek Behun wrote:
> On Thu, 19 Mar 2020 04:27:56 +0000
> Chris Packham <Chris.Packham@alliedtelesis.co.nz> wrote:
> 
> > On Thu, 2020-03-19 at 05:21 +0100, Marek Behun wrote:
> > > On Thu, 19 Mar 2020 02:00:57 +0000
> > > Chris Packham <Chris.Packham@alliedtelesis.co.nz> wrote:
> > >   
> > > > Hi Marek,
> > > > 
> > > > On Thu, 2020-03-19 at 02:29 +0100, Marek Behún wrote:  
> > > > > Commit e1f550dc44a4 made the use of platform_get_irq_optional, which can
> > > > > return -ENXIO when interrupt is missing. Handle this as non-error,
> > > > > otherwise the driver won't probe.    
> > > > 
> > > > This has already been fixed in net/master by reverting e1f550dc44a4 and
> > > > replacing it with fa2632f74e57bbc869c8ad37751a11b6147a3acc.  
> > > 
> > > :( It isn't in net-next. I've spent like an hour debugging it :-D  
> > 
> > I can only offer my humble apologies and promise to do better next
> > time. I did test the first minimally correct change, but clearly
> > stuffed up on v2.
> 
> That's ok, but this should be also in net-next as well. Has Dave
> forgotten to apply it there, or is there some other plan?

It probably went into net. It then takes around a week before net is
merged into net-next.

       Andrew

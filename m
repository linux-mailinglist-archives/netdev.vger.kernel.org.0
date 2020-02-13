Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0613A15BEBA
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 13:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgBMMxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 07:53:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbgBMMxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 07:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2g0pvuWrv1KU5lJi4yCwYmrRWsdmyZtd2imB0hK/muw=; b=PiRg9FVpPDv0wswVgCj3zQYnxm
        n4QbtznR/8nRMJFU/GlYoUNowK4mPekeJkN21yUdnNqhfOqccd5K/g/6iabKkMnreaeR26HT2Czod
        mID+SxoVsvmgMhjUjQtlL4YbctHZf/x3ONmR/0Lszvp/P2UiS6m/rUffkKHzXipqqlDg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2Dzo-0002VW-D3; Thu, 13 Feb 2020 13:53:32 +0100
Date:   Thu, 13 Feb 2020 13:53:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Per =?iso-8859-1?Q?F=F6rlin?= <Per.Forlin@axis.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [Question] net: dsa: tag_qca: QCA tag and headroom size?
Message-ID: <20200213125332.GA2814@lunn.ch>
References: <1581501418212.84729@axis.com>
 <20200212202332.GV19213@lunn.ch>
 <1581571438638.7622@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1581571438638.7622@axis.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 05:23:59AM +0000, Per Förlin wrote:
> 
> > > -     if (skb_cow_head(skb, 0) < 0)
> > > >  Is it really safe to assume there is enough headroom for the QCA tag?
> > >
> > > +     if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
> > > > My proposal. Specify QCA tag size to make sure there is headroom.
> > >
> > >               return NULL;
> > >
> > >       skb_push(skb, QCA_HDR_LEN);
> 
> > > Hi Per
> 
> > > Yes, your change looks correct. ar9331_tag_xmit() also seems to have
> > > the same problem.
> 
> >> Do you want to submit a patch?
> Thanks for your response,

> I can submit a patch on both drivers, however I only have hardware
> to perform an actual test on the QCA switch.

Hi Per

That is fine. This should be low risk. Cc: Oleksij Rempel
<kernel@pengutronix.de> when you post the patch, so he can review and
test it.

Thanks
	Andrew

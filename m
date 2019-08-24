Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F229BF14
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 19:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfHXRyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 13:54:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfHXRyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 13:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=r5FyHDMClQMYwLelZYXhXwtSAKOswSurUUfBfPAILWc=; b=2BeqUA73cCND6h7N/XqMl4ynjR
        PM/6KhbxJle+0IT81Y1MS3VBhIF+2EGEYMcGeS5p8VgrGk3YtuPiUcUFAk8RmIwcKeOedqlFbRfLC
        Hv1b1AR4akd1c53opDQSWbET2fpNQZDhNv0ggZ+9fS6+sOORNpPxkSoGiRnhcwZU3nq8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1aEm-000356-Hu; Sat, 24 Aug 2019 19:54:04 +0200
Date:   Sat, 24 Aug 2019 19:54:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190824175404.GE8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
 <20190824152407.GA8251@lunn.ch>
 <20190824194546.5c436bd6@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824194546.5c436bd6@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 24, 2019 at 07:45:46PM +0200, Marek Behun wrote:
> On Sat, 24 Aug 2019 17:24:07 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > So this is all about transmit from the host out the switch. What about
> > receive? How do you tell the switch which CPU interface it should use
> > for a port?
> 
> Andrew, we use the same. The DSA slave implementation of ndo_set_iflink
> will also tell the switch driver to change the CPU port for that port.
> Patch 3 also adds operation port_change_cpu_port to the DSA switch
> operations. This is called from dsa_slave_set_iflink (at least in this
> first proposal).

Yes, i noticed this later. The cover letter did not include a change
to a driver, so it was not clear you had considered receive, which is
very much in the hard of the switch driver, not the DSA core.

     Andrew

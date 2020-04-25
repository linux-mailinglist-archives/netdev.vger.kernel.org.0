Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3151B82A4
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgDYAK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:10:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgDYAK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 20:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ob1NXBZBB/TdDgKztYA6He/Fk+APvnOylQKu1hMTH+M=; b=rI/BJRTNqVy+NVyd7BqvWiEsXM
        zfrl32AEqeDlsarEfq1yg0fMt8sffr6sdbyHsSN+SfeMte5BPuk0Rc+CFMyErrHWbUlmI3wdIWhS/
        j9ZTN9s39ztp4eEr0jIsZsMB0WrwcsV0NPeLpF+HfPlQG42GozzQ30XM4nZnsIr5At2M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jS8Oj-004eAK-TP; Sat, 25 Apr 2020 02:10:21 +0200
Date:   Sat, 25 Apr 2020 02:10:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Darren Stevens <darren@stevens-zone.net>
Cc:     madalin.bacur@nxp.com, netdev@vger.kernel.org, oss@buserror.net,
        chzigotzky@xenosoft.de, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH dpss_eth] Don't initialise ports with no PHY
Message-ID: <20200425001021.GB1095011@lunn.ch>
References: <20200424232938.1a85d353@Cyrus.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424232938.1a85d353@Cyrus.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 11:29:38PM +0100, Darren Stevens wrote:
> Since cbb961ca271e ("Use random MAC address when none is given")
> Varisys Cyrus P5020 boards have been listing 5 ethernet ports instead of
> the 2 the board has.This is because we were preventing the adding of the
> unused ports by not suppling them a MAC address, which this patch now
> supplies.
> 
> Prevent them from appearing in the net devices list by checking for a
> 'status="disabled"' entry during probe and skipping the port if we find
> it. 

Hi Darren

I'm surprised the core is probing a device which has status disabled.
Are you sure this is the correct explanation?

    Thanks
	Andrew

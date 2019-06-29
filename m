Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1675ADAD
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 01:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfF2XGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 19:06:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfF2XGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 19:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HywV1+iXPJ5sYrhAg3Z+y7vjhrPFRiqulC5XvUoHrds=; b=w58Va2kPatUGzDPKoAmP9Ab9C5
        739oATzC08chxgzInbklJRtpy53TRSUd4yKk3Kr/dReqD38LOZyJEafsTFnEzQGus1xVk7bgOVTuZ
        xkBuuweFaYS4ZDGV3xCEV06QN+P0sA4nXl8UTco3YdSuG/HkKYF6NP5s9qRC2YgWXVUM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhMQL-0007Bx-3h; Sun, 30 Jun 2019 01:06:25 +0200
Date:   Sun, 30 Jun 2019 01:06:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190629230625.GB26554@lunn.ch>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190623064838.GA13466@splinter>
 <20190629153135.GA17143@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190629153135.GA17143@splinter>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We have some tests under tools/testing/selftests/net/forwarding/, but
> not so much for MC. However, even if such tests were to be contributed,
> would you be able to run them on your hardware? I remember that in the
> past you complained about the number of required ports.

Hi Ido

Most devices have 4 or 5 ports. Some have more, some less. Given that
the current tests need a second port for every port under test, this
limits you to 2 ports under test. For IGMP snooping and MC in general,
i don't think that is enough. You need one port as the source of the
MC traffic, one port with a host interested in the traffic, and one
port without interest in the traffic. You can then test that traffic
is correctly forwarded and blocked.

The testing we do with DSA makes use of a test host with 4 interfaces,
and connect them one to one to the switch. That gives us 4 ports under
test, and so that gives us many more possibilities for running
interesting tests.

      Andrew

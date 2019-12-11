Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E5B11AC21
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfLKNeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:34:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47388 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbfLKNeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 08:34:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5mrH73H8IK9PCLoNbfAeyMajTAOWJOgXGTCwDhw8YRM=; b=E5sw+O0i+JbR6CuiQPBxKMAPbL
        BfsuNXhPVsOpKRXRHp/0ZjPlOTgBZZ7CPjSzBQjiPPpVpSPY6DdsSJbj8Ep26qr38wXK4Aq4xi7fn
        PCXgH50sYMZVLD+23kGaqTjLNxI/GsB/5LybwUHMIsSDvH5YDkau6KMx6cx/3YRE+2YQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1if280-0004Ma-Du; Wed, 11 Dec 2019 14:34:08 +0100
Date:   Wed, 11 Dec 2019 14:34:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com,
        syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Subject: Re: [PATCH 4/4] [RFC] staging/net: move AF_X25 into drivers/staging
Message-ID: <20191211133408.GL16369@lunn.ch>
References: <20191209151256.2497534-1-arnd@arndb.de>
 <20191209151256.2497534-4-arnd@arndb.de>
 <m3d0cvjq1h.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3d0cvjq1h.fsf@t19.piap.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 08:10:34AM +0100, Krzysztof Hałasa wrote:
> Arnd,
> 
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > - Most other supported HDLC hardware that we supoprt is for the ISA or
> >   PCI buses.
> 
> I would be surprised if there is anybody left with ISA sync serial
> stuff, but the PCI hardware still has some users - these machines don't
> need to be upgraded yearly. Most people have migrated away, though.

Hi Krzysztof, Arnd

I have a use case for hdlc_cisco and hdlc_raw_eth. But it uses a lot
of out of tree code, the DAHDI driver framework for E1 cards, and an
E1 card which is not part of DAHDI.

Given how much of this is out of tree, i would understand if you
eventually decide to remove this HDLC code.

	   Andrew

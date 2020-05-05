Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0381C5685
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgEENPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:15:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgEENPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yegq8+UTtwGex5/e4DboLkpznYHgZqhMOzbQZjh5Rzo=; b=r5/hSQDUJ9lwpseOXp1+nd5ByE
        zypzD+YbqEgd0xGNtbVmAPelfaGV+BD725A7vcbebP/669r94Iywaepyq9lL9L28SE4676iyglNFJ
        GvwRGFg67GDbEgRdEqYqZ3xjws7k8P7XufOhh+03v1w4R2mKuJkE+4xygUIBSHKkF7+c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVxQK-000w2Y-7y; Tue, 05 May 2020 15:15:48 +0200
Date:   Tue, 5 May 2020 15:15:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 04/10] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200505131548.GE208718@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-5-andrew@lunn.ch>
 <20200505082838.GH8237@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505082838.GH8237@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > + +---------------------------------------------+--------+---------------------+
> > + | ``ETHTOOL_A_CABLE_TEST_HEADER``             | nested | reply header        |
> > + +---------------------------------------------+--------+---------------------+
> > + | ``ETHTOOL_A_CABLE_TEST_STATUS``             | u8     | completed           |
> > + +---------------------------------------------+--------+---------------------+
> > + | ``ETHTOOL_A_CABLE_TEST_NTF_NEST``           | nested | all the results     |
> > + +-+-------------------------------------------+--------+---------------------+
> > + | | ``ETHTOOL_A_CABLE_TEST_STATUS``           | u8     | completed           |
> > + +-+-------------------------------------------+--------+---------------------+
> 
> You have ETHTOOL_A_CABLE_TEST_STATUS both here and on top level. AFAICS
> the top level attribute is the right one - but the name is
> ETHTOOL_A_CABLE_TEST_NTF_STATUS.

Hi Michal

They need better names. The first one is about the test run
status. Started vs complete. A notification is sent when the test is
started, and a second one at the end with the actual test results. The
second status is per pair, indicating open, shorted, O.K.
Maybe this second one shouldd be ETHTOOL_A_CABLE_TEST_NTF_PAIR_STATUS.

There is also a cut/paste error, the second one should not have the
comment completed.

	Andrew

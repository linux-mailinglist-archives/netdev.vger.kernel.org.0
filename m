Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2105FC1A00
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 03:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfI3Bon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 21:44:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfI3Bon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 21:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mW0TnhxViDMRF32JyINwza8DeXTscacfY3iOF8nkMXM=; b=PPY17eJOmoM6W9EHNbw7QGLL8T
        nHwmro5yU4e2Sp4z2s5m4SXcQ18KH4jEKmbzRXf4Yg90dTI18wTpD18zeqVST+o3tUdFjNFyHQcPQ
        d6r1UzQFblvYQWonbF8YOIXHaXIMN+KrPdIwy0+e15569BKh4DeWbjUpa5Vor3wKwChI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iEkjw-0001da-J8; Mon, 30 Sep 2019 03:44:40 +0200
Date:   Mon, 30 Sep 2019 03:44:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
Message-ID: <20190930014440.GC6032@lunn.ch>
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
 <20190923191713.GB28770@lunn.ch>
 <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
 <20190926133810.GD20927@lunn.ch>
 <CAGAf8LxAbDK7AUueCv-2kcEG8NZApNjQ+WQ1XO89+5C-SLAbPw@mail.gmail.com>
 <20190928152022.GE25474@lunn.ch>
 <CAGAf8LzJ56wjWxywnGWB1aOFm9B8xQhMgHFQfkVgOFWePzDfsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAf8LzJ56wjWxywnGWB1aOFm9B8xQhMgHFQfkVgOFWePzDfsw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I wrote my (very first) public GIST about that. Please, could you
> review it, and point to the any logical bugs in there?
> https://gist.github.com/ZoranStojsavljevic/423b96e2ca3bd581f7ce417cb410c465

The very last line is wrong.

ifconfig eth0 192.168.1.4 up

You should put the IP address on the bridge, not the master device
eth0.

ip addr add 192.168.1.4/24 dev br0

FYI: ifconfig has been deprecated for maybe a decade?

   Andrew

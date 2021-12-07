Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E1C46C7CA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbhLGW5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:57:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44038 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhLGW5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Kn9xgmL7imDhKi1Cv5O5IlJlObS659m9nT1TrrcCZ7o=; b=VB11ZXs8Mbq0LscPYNMQhe0/0O
        EchcpX71VbfhwgAE3UOy3V9hkKG3pgbMdGSpJo1HGfMZmRVZ0GmjHNnEmY372aQr3Fm1F5hukOYJp
        jgqJNtDzhuWB3aHGN6LQkgxHaY9VKmc4I8Q3IKwCuq1nIbzL5/XcL2k5FhfNCQ93CYgo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mujLb-00FowQ-QU; Tue, 07 Dec 2021 23:54:07 +0100
Date:   Tue, 7 Dec 2021 23:54:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <Ya/mD/KUYDLb7qed@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207224525.ckdn66tpfba5gm5z@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I considered a simplified form like this, but I think the tagger private
> data will still stay in dp->priv, only its ownership will change.

Isn't dp a port structure. So there is one per port?

This is where i think we need to separate shared state from tagger
private data. Probably tagger private data is not per port. Shared
state between the switch driver and the tagger maybe is per port?

      Andrew

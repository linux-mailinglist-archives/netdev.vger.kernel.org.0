Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB63C5FBC
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhGLPww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:52:52 -0400
Received: from mail-proxyout-mua-31.websupport.eu ([37.9.172.181]:43203 "EHLO
        mail-proxyout-mua-31.websupport.eu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230228AbhGLPwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 11:52:51 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2021 11:52:51 EDT
Received: from in-6.websupport.sk (unknown [10.10.2.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail-proxyout-mua-31.websupport.eu (Postfix) with ESMTPS id C85D1C0015;
        Mon, 12 Jul 2021 17:41:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackhole.sk;
        s=mail; t=1626104461;
        bh=RWYhEtAwTgLXUQOVcWGtAxGzTFa/bMHHrTYq7ywzREE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=kwOYoP0vDwN7lEgYWF+w/8XPSj4+0UK18zCtnWvMuutSLKZR2tnK/ZAoGhV/ggRXp
         3QC1iQ3StGFLmXr+sLecOpX3rRWb99ntnpSzFpF0koTVkTJlyfu4OuDIy10i0TZ8p4
         go0HudYCEd+31SrgBXwYDhlOPrsaEVPNuJlTA3AU=
Received: from thinkpad (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kabel@blackhole.sk)
        by in-6.websupport.sk (Postfix) with ESMTPSA id 4GNnzd1fWGz12Nlk;
        Mon, 12 Jul 2021 17:41:01 +0200 (CEST)
Date:   Mon, 12 Jul 2021 17:40:59 +0200
From:   Marek Behun <kabel@blackhole.sk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [RFC PATCH v3 net-next 00/24] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Message-ID: <20210712174059.7916c0da@thinkpad>
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Out-Spamd-Result: default: False [1.90 / 1000.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCPT_COUNT_TWELVE(0.00)[15];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_NOT_FQDN(0.50)[];
         ASN(0.00)[asn:2852, ipnet:78.128.128.0/17, country:CZ];
         FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,davemloft.net,lunn.ch,gmail.com,resnulli.us,idosch.org,waldekranz.com,nvidia.com,networkplumber.org,lists.linux-foundation.org,ti.com];
         SUSPICIOUS_RECIPS(1.50)[]
X-Out-Rspamd-Server: mail-antispam-4
X-Out-Rspamd-Queue-Id: 4GNnzd1fWGz12Nlk
Authentication-Results: in-6.websupport.sk;
        auth=pass smtp.auth=kabel@blackhole.sk smtp.mailfrom=kabel@blackhole.sk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir, on what mv88e6xxx devices are you developing this stuff?
Do you use Turris MOX for this?

Marek

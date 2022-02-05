Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271384AA658
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbiBED7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:59:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43604 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiBED7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:59:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A99DB839A1
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 03:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFA6C340E8;
        Sat,  5 Feb 2022 03:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644033590;
        bh=vcaMbpyhEx14to54cPpx5Llf+WLQ2qo0L941x+3u7yI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kONGorbQHw4OlJvwk5NsknlC4xc2VryRfN/2T7aBGi/Up9eUMLdCQrpJiJ+WzP1KP
         kT17tLANDuLSO8xuVVKv2dDTdDoZv7y5LXbWYsUwMsCExGWCclPiwdEgQpu+JuMRZ9
         hB0dPn+cSGyyvaeFZVUZd8dNs9gbK/LCCgXOyebpGyRftOEJNFRlLvXmst8uLWbGv+
         SwH0wl4Gn2XKGJ8K2WqXi2ISQZ/Pxa6Ozwa9ZhPdqvpUZSjwVdNULKsuSkkINkMpq0
         XIAZ068AxDgSuFmBDuVOnIRRy480/KMkmr16Lqner7kceOrU/theLT0NRWFL4BOGzD
         JRn6xOouSkmlw==
Date:   Fri, 4 Feb 2022 19:59:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH v3 net-next] bonding: pair enable_port with
 slave_arr_updates
Message-ID: <20220204195949.10e0ed50@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20792.1643935830@famine>
References: <20220204000653.364358-1-maheshb@google.com>
        <20792.1643935830@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Feb 2022 16:50:30 -0800 Jay Vosburgh wrote:
> Mahesh Bandewar <maheshb@google.com> wrote:
> 
> >When 803.2ad mode enables a participating port, it should update
> >the slave-array. I have observed that the member links are participating
> >and are part of the active aggregator while the traffic is egressing via
> >only one member link (in a case where two links are participating). Via
> >krpobes I discovered that that slave-arr has only one link added while

kprobes
that that

The commit message would use some proof reading in general.

> >the other participating link wasn't part of the slave-arr.
> >
> >I couldn't see what caused that situation but the simple code-walk
> >through provided me hints that the enable_port wasn't always associated
> >with the slave-array update.
> >
> >Signed-off-by: Mahesh Bandewar <maheshb@google.com>  
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Quacks like a fix, no? It's tagged for net-next and no fixes tag, 
is there a reason why?

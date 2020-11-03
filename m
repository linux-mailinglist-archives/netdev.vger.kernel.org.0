Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C452A4C65
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgKCRM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728241AbgKCRM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:12:27 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEBC420E65;
        Tue,  3 Nov 2020 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604423547;
        bh=Fph78bsEIr9392d7yrLmYsMjPCfOLIDVlS9BPZ/XPYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NjvEkpyFMXpvzIbLS+y1sCoFpH8ojoFIkS77tspu5OqWRCT4HiGIgfvuHl3fjQDD8
         0PyIGqlcCl5gAE6TGFslQTQrRzx9hSFq4UTwZrWSBOkbmnCxiLRTVATg/qoe6abyz5
         owAIDUmK7ny2VAjQs/9V6GauhHtDfPi0IYcmxoXE=
Date:   Tue, 3 Nov 2020 09:12:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103091226.2d82c90c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <AM0PR04MB67540916FABD7D801C9DF82496110@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201029081057.8506-1-claudiu.manoil@nxp.com>
        <20201103161319.wisvmjbdqhju6vyh@skbuf>
        <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
        <AM0PR04MB67540916FABD7D801C9DF82496110@AM0PR04MB6754.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 17:08:43 +0000 Claudiu Manoil wrote:
> >> Still crashes for me:
> >>  
> >
> >Given the various skb modifications in its xmit path, I wonder why
> >gianfar doesn't clear IFF_TX_SKB_SHARING.  
> 
> Hi Vladimir,
> Can you try the above suggestion on your setup?

While it is something to be fixed - is anything other than pktgen
making use of IFF_TX_SKB_SHARING? Are you running pktgen, Vladimir?

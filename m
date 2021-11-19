Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA43845705A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbhKSONB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235201AbhKSONB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:13:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 264D461057;
        Fri, 19 Nov 2021 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637330999;
        bh=P+GR5hntqExn/4peKXBXLFMPWKyem5jd+n0GaTb2na8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c66Qc8QwRH6rEdSe1iAqfh76x/X2n25Gsona4WT5l+6ehwOlrskHPyrBxmCg1iTjD
         DeUYDMMaPWK16j9h8aX83iafAZsbESWMjJSGW3v3spQETAlIwuhRExeczsDmNUVRRp
         BIbENqrSKe1UN/u5mQ4BcTCxrJYm/yWI5XGkjx3LPrty88KOhQc0VXRKQ9j+JCOjFQ
         Euc+c7bVNG/j/MkiSOO3UbtJRhWUsix0qCb6tbZdVVgvztghfUfgbAFs6A3lQd7Y6g
         ys4NeWi12OYQcr3LQuTXjBgKFCOP3bnw3GsfglBVbw/W+91cyEOMpO6DQkaZ+tJt4U
         jWlEcE09ICB5Q==
Date:   Fri, 19 Nov 2021 06:09:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, argeorge@cisco.com
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <20211119060958.31782ca9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZura-Vav599FTVkMb33uY0xtpNkotxU-q8FUiBxoHqXh7Q@mail.gmail.com>
References: <YXmWb2PZJQhpMfrR@shredder>
        <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
        <YXnRup1EJaF5Gwua@shredder>
        <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
        <YXqq19HxleZd6V9W@shredder>
        <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
        <YYeajTs6d4j39rJ2@shredder>
        <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YY0uB7OyTRCoNBJQ@shredder>
        <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZDK6JxwcoPvk/Zx@shredder>
        <952e8bb0-bc1e-5600-92f2-de4d6744fcb0@nvidia.com>
        <20211115071109.1bf4875b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZura-Vav599FTVkMb33uY0xtpNkotxU-q8FUiBxoHqXh7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 16:17:53 +0530 sundeep subbaraya wrote:
> As said by Ido, ndo_change_proto_down with proto_down as
> on and off is sufficient for our requirement right now. We will use
> ndo_change_proto_down instead of devlink. Thanks everyone for
> pitching in.

ndo_change_proto_down is for software devices. Make sure you explain
your use case well, otherwise it's going to be a nack.

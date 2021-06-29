Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9813B7377
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhF2NuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:50:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33208 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233050AbhF2NuD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 09:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+zdXcOVpR4srko+modJqSdFPnMR5rbUZbl+o4MRo+PU=; b=Zp0vF02rO7aBPI4BcvsC8U8Hwf
        ytSh+v0vHA7+soSns8OfQMb6KLEK2PrC4QlmvSAFKDMn2uOIkU2Edn+DKIhUT/mPYczkeMMtHkcJ1
        UWY/CZaTJ4XUBV68S65SlHiShs9gbb5WPcNDJqoe2YiPFR2/f6BfRkkxfbY72r/q8L8g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lyE5N-00BXum-3V; Tue, 29 Jun 2021 15:47:33 +0200
Date:   Tue, 29 Jun 2021 15:47:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <YNskdT/FMWERmtF5@lunn.ch>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
 <YNTfMzKn2SN28Icq@shredder>
 <YNTqofVlJTgsvDqH@lunn.ch>
 <YNhT6aAFUwOF8qrL@shredder>
 <YNiVWhoqyHSVa+K4@lunn.ch>
 <YNl7YlkYGxqsdyqA@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNl7YlkYGxqsdyqA@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Even with the proposed approach, the kernel sits in the middle between
> the module and user space. As such, it can maintain an "allow list" that
> only allows access to modules with a specific memory map (CMIS and
> SFF-8636 for now) and only to a subset of the pages which are
> standardized by the specifications.

Hi Ido

This seems like a reasonable compromise. But i would go further. Limit
it to just what is needed for firmware upgrade.

   Andrew

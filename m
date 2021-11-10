Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3022E44C1FF
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhKJNVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:21:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54696 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhKJNVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 08:21:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YfXaoDwV35ES378yn23xNjciRgh4QPMwJMDoI7JEjr8=; b=154dVqzMtm5s07by6kw9SCEB/t
        EMq57O6SsEq7JSyyp7i9ZIakCgtm53Qe7xwgi6sXzzQp/nm3xmpCD0CBU0rDWsmAFPuV1fO0RvV6M
        CUP094asYX6g6UwJbEjYaKon9/JLOmI5RqTdw6hq+/ZF8H5F06HagxYnm64bk3VWzwEA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mknUQ-00D6kJ-WD; Wed, 10 Nov 2021 14:18:10 +0100
Date:   Wed, 10 Nov 2021 14:18:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net 1/3] net: dsa: mv88e6xxx: Fix forcing speed & duplex
 when changing to 2500base-x mode
Message-ID: <YYvGkogCe0XyFFjc@lunn.ch>
References: <20211110041010.2402-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110041010.2402-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek

Please always include a patch 0/X for a patchset explaining what the
patches as a whole do. The text should then be used as the merge
commit for the patchset.

    Andrew

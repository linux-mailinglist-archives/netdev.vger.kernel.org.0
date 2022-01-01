Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC1C482654
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 03:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiAAC0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 21:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiAAC0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 21:26:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08302C061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 18:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9946DB8119C
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 02:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFB0C36AEC;
        Sat,  1 Jan 2022 02:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641004004;
        bh=an7VSIGwWXGWTWNY7tc8WKiKYVjWeEOSOM+S7USpX+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EQ1FCZbNHKCQwS+rn07ObUkGo6Ln7c1ExtbnBlLtRFqWdA9uIn4T1NViRMD3pC7UG
         Sbe6rNixHKqJFTLp7wCrXNByltS7Q+PZ7+YXx7lOGU8JwN+tZLUjbk3eynhZl9o3q1
         IagqUJIO1kqt0kUDvtucbgEjGu+RrELoYFlgj4930i62nVCC3wycTSTHcuzPau4J+a
         nEhmO1gPnS3PN1DC9qk/Y0VCZhuvle8gTmaEb1V06ZJ1nkpIeQgafWj7WHTHBvCiX9
         qot4KDhKci0piDKct3eTPc9kUh7MAibzVLXJ8N5qbQ1lrqklV7l4DhSFj9neECswFO
         O+fh8dAyAEbWg==
Date:   Fri, 31 Dec 2021 18:26:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] new Fungible Ethernet driver
Message-ID: <20211231182643.3f4fa542@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211231090833.98977-1-dmichail@fungible.com>
References: <20211231090833.98977-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 01:08:25 -0800 Dimitris Michailidis wrote:
> This patch series contains a new network driver for the Ethernet
> functionality of Fungible cards.
> 
> It contains two modules. The first one in patch 2 is a library module
> that implements some of the device setup, queue managenent, and support
> for operating an admin queue. These are placed in a separate module
> because the cards provide a number of PCI functions handled by different
> types of drivers and all use the same common means to interact with the
> device. Each of the drivers will be relying on this library module for
> them.
> 
> The remaining patches provide the Ethernet driver for the cards.

Still fails to build for me, I use:

make C=1 W=1 O=build_allmodconfig/ drivers/net/ethernet/fungible/

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0094A4FBB
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244511AbiAaTxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiAaTxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:53:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E261C061714;
        Mon, 31 Jan 2022 11:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 009BDB82C0E;
        Mon, 31 Jan 2022 19:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A059C340E8;
        Mon, 31 Jan 2022 19:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643658821;
        bh=EDQuNJF48Jmdwz5qs4umub4BwHAxjhbYK2lLWFVQOR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WR+8Z21EAy8g6REqUmO4l7AQuL+VaV4qmdb04HA3CyVeYZhioHWKbfUFznrwU4ydH
         nDjULY3ZwZuNmRX4TePS9KKgR2/DxjNGh8ccpUX+twP8LoSUh+PU1AcWdA1PFu5A1+
         qxodfXsYNyaNQTKMnYw7rV2vv20ojazwWENyrEdwq/AxHgcuRYROtdYnsT+PRPs0xM
         hvcXzjlihpwMSSU3CshZF227ZUXOwai23pEgYTcEf1x9BY4IjiZeN3dSYfJwsledxU
         ScjMu1+5EmksyYAa89fgGSAs4slPs4SVCqoiE9qumZhMCKhaomLdeygvBRvLdw7DNy
         Sq5AvT+L/YteA==
Date:   Mon, 31 Jan 2022 11:53:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next, 0/3] net: mana: Add XDP counters, reuse
 dropped pages
Message-ID: <20220131115336.6b37cb43@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
References: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 18:03:35 -0800 Haiyang Zhang wrote:
> Add drop, tx counters for XDP.
> Reuse dropped pages

I believe this is now b43471cc1032 ("Merge branch 'mana-XDP-counters'")
in net-next, thanks!

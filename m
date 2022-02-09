Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8A14AE8C6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiBIFGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:06:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377890AbiBIEpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 23:45:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2592EC061578;
        Tue,  8 Feb 2022 20:45:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF97A614E5;
        Wed,  9 Feb 2022 04:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8D2C340E7;
        Wed,  9 Feb 2022 04:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644381919;
        bh=MigM4e2I9SxCmYff5CZMCtGW8ATdZxM0NZziFLgDXA0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gyfy/8TEYlULpyOQfCElearleDqUICc1GV5T0PFBSCR74TAZASmaTvxJCV6VEWYrt
         iiVI440o6RN6sytKGA3eG94Y/ecivV/bJTJ/CcF/m/Y3X7HpO1rPMIvewBaoPZOMez
         F3OpH33sFpoIns2zRNB9ND6YMVVqE+Uu6GcB6SZ7jsq6PJVvbds9kM7Y6Ci3oW8TNp
         7UW8apZEyjjFJAFJSLiSZCzmN7j6b4K/6ex/CY0uOOm4nLNBYdh+g8ZMbbrQvBCPI4
         XpXvvOOzhviwzsx1K84xmeiX7AtWnhzNOTlBML7x9Wmo3UDTASErFw/A0h1XDzIrTu
         XGTS3e7Udxelg==
Date:   Tue, 8 Feb 2022 20:45:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, jgg@nvidia.com, netdev@vger.kernel.org,
        david.m.ertman@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN
 Driver Updates 2022-02-07
Message-ID: <20220208204517.2ea80111@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
References: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Feb 2022 15:59:20 -0800 Tony Nguyen wrote:
> This pull request is targeting net-next and rdma-next branches. RDMA
> patches will be sent to RDMA tree following acceptance of this shared
> pull request. These patches have been reviewed by netdev and RDMA
> mailing lists[1].
> 
> Dave adds support for ice driver to provide DSCP QoS mappings to irdma
> driver.

Pulled thanks!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83466364D50
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbhDSVvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhDSVvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1E2A613B4;
        Mon, 19 Apr 2021 21:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618869051;
        bh=evaMLtccrnqOIDDF5gtHGiH65wCJKjRnN2VAF2VCRik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X+mA2dlzCAEmf5P32v43pTgdG5htsXhru5NbBzvpRTtv20GBWEg1SZYKVGvAiv3BL
         /uywKf1Pze5xZTfMDMP4wBGv4YlQVT7uJcwJ915vcLRoDH05rO6I/Muyg9jo15HaXK
         3UAyasKHp7rwv0sMAJNYB0PvMQZX9u02RVLz9umOLcbEx6KkWhCHJLs9P4Gii1CSXl
         vLXEUcDMGZq5HqyRIgNIx3DDECzi6M2T/owN+Ko2OG1lwxnYnFxMjZe0DaAoPoMn7J
         RhmPxe632BkZdGxPMkaN8FWU73LCIrRv0J4zHvzpovT/J1b9goGPpSKPB35CBxI1uY
         5/fu/87Q3thvw==
Date:   Mon, 19 Apr 2021 14:50:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        corbet@lwn.net, vladyslavt@nvidia.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: add missing EEPROM to list of
 messages
Message-ID: <20210419145049.2ab6edd7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YH357QLGqz6igLtc@lunn.ch>
References: <20210419212622.2993451-1-kuba@kernel.org>
        <YH357QLGqz6igLtc@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Apr 2021 23:45:17 +0200 Andrew Lunn wrote:
> > @@ -210,45 +210,47 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
> >    ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
> >    ``ETHTOOL_MSG_FEC_GET``               get FEC settings
> >    ``ETHTOOL_MSG_FEC_SET``               set FEC settings
> > +  ``ETHTOOL_MSG_MODULE_EEPROM_GET``	read SFP module EEPROM  
> 
> It looks like you used a tab, where as the rest of the table is
> spaces?

Ah.. after carefully adjusting _REPLY to use spaces.. :)
Sorry, v2 coming.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7DB3F84A1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhHZJfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:35:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58474 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbhHZJfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 05:35:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 67071222AF;
        Thu, 26 Aug 2021 09:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629970457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SJUUJzTKtratpLRRjwuwrEqhYsk2ZjSfpPlLvFc1gQk=;
        b=Cu3OtdagMJLTMHXi5U37bwEj0uFPgYuXSjPfa1BE5pbwI4Zy+4GBp6XXa6PFCyficGF9kv
        Zvr8bjic8Hcu08pVXhUjNhf8wGLrEgdrNPUDevYajTY7lUSveR1CJkqiAX6T6Ttq4gOi/E
        iI7JZKVV+xufVkzBp9ErBPwvKmLqUs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629970457;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SJUUJzTKtratpLRRjwuwrEqhYsk2ZjSfpPlLvFc1gQk=;
        b=hjgO3He3dNt0UHBNgeUts1zkJMAJ/qemmx7SOfA+Di3GSKX5UO8bwhDXnk/9IRnvFoski3
        YJwljxpdPnKL5XCw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 70D6AA3B97;
        Thu, 26 Aug 2021 09:34:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B21A3603F6; Thu, 26 Aug 2021 11:34:14 +0200 (CEST)
Date:   Thu, 26 Aug 2021 11:34:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, amitc@mellanox.com,
        idosch@idosch.org, andrew@lunn.ch, o.rempel@pengutronix.de,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        netdev@vger.kernel.org, lipeng321@huawei.com
Subject: Re: [PATCH V2 ethtool-next 2/2] netlink: settings: add two link
 extended substates of bad signal integrity
Message-ID: <20210826093414.e5ok2nihbuhe7zzt@lion.mk-sys.cz>
References: <1629877513-23501-1-git-send-email-huangguangbin2@huawei.com>
 <1629877513-23501-3-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1629877513-23501-3-git-send-email-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 03:45:13PM +0800, Guangbin Huang wrote:
> Add two link extended substates of bad signal integrity available in the
> kernel.
> 
> ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST means the input
> external clock signal for SerDes is too weak or lost.
> 
> ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS means the received signal for
> SerDes is too weak because analog loss of signal.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

Applied, thank you.

Michal

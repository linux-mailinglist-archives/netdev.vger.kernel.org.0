Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B306063B7AD
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbiK2COh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiK2COf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:14:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30F73D90F;
        Mon, 28 Nov 2022 18:14:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F6EB810E5;
        Tue, 29 Nov 2022 02:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C70C433C1;
        Tue, 29 Nov 2022 02:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669688072;
        bh=pp5kBYS+SdIZq3LxxO0vQWjVGYK070G5uJIuC33zD1Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tCwwQHO5uQd3eXuPQWcpT+JpfhG8LdjaRGY2es4BU+Y5N2L3a5hSGnD+laoAq7m9/
         9x2ZXjLEK6sQN9uzgGGuD/nPXTEKqeUuhTnQvmBsTrmndtgJxTgKouDZYkMSm9/dqG
         F+NAfQRQVDW6v9FnKIhNbjhEVeXe/eU6Mw0vBqhwxbhwbeL/M/7vvHF0Kv7TEoizNy
         XEg9PGMkw6Popo1UNr10g+fKnOhD5CEHXpPeTcbpSDGjaXmfYApjdwaB4UwV/31PSf
         k98OI4QzrteSBEUMOLMHIok5YDe5a/j3AscDg/3T97RG8mILdyWtCYxK3zI3yMMZOI
         idzKCHBKC5m6g==
Date:   Mon, 28 Nov 2022 18:14:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: devlink: add
 DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
Message-ID: <20221128181430.2390b238@kernel.org>
In-Reply-To: <20221129020151.3842613-1-mailhol.vincent@wanadoo.fr>
References: <20221129020151.3842613-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 11:01:51 +0900 Vincent Mailhol wrote:
> As discussed in [1], abbreviating the bootloader to "bl" might not be
> well understood. Instead, a bootloader technically being a firmware,
> name it "fw.bootloader".
> 
> Add a new macro to devlink.h to formalize this new info attribute
> name.
> 
> [1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

It's okay for this patch to go via the can tree, FWIW.
It may cause an extra delay for you if you have to wait
for the define to propagate.

Either way you should document the meaning of the parameter, 
however obvious it may seem:

 Documentation/networking/devlink/devlink-info.rst

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF094D0BA1
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 00:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbiCGXDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 18:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiCGXDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 18:03:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6BE329A6;
        Mon,  7 Mar 2022 15:02:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86E26611A9;
        Mon,  7 Mar 2022 23:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D472C340E9;
        Mon,  7 Mar 2022 23:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646694170;
        bh=PZV5P/VX4x5ATn7ldLKm4K3NSamKkdX6+zxYl97iE9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSrSJLxqcfNNpg0lY6SXymqhbRDj0o9ABw1HJ5Z49gMjyQ2SJk6dRyKT67r3RDu5l
         hNUzkB0xs6qKYf/Sz69SnMsyKQaa0wSXBulQDKlUMu/uTGQtAkyN8nExC5Dzf4veiJ
         xXhrlhA+mvWigoywd7TQBrRcikFAgdIcxV++wU9EbzJN/zzKkfDJtJBe0jX3AEfmrC
         ceyClnG8N2FOO/zz1GUIMt7D5WqlyRApQHfRsfbfe2Zyu8F4636cUy2MNWl34l6ygz
         CyUhnDTr7Z38VhEGI1Qqvbif/JT0NJxxcVJxtTtDtabLGfnG705qDSHvxcU7pwlWBL
         sbyhedPZyJANg==
Date:   Mon, 7 Mar 2022 15:02:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Message-ID: <20220307150248.388314c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220307072248.7435feed@canb.auug.org.au>
References: <20220307072248.7435feed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Mar 2022 07:22:48 +1100 Stephen Rothwell wrote:
> Hi all,
> 
> Commits
> 
>   c2b2a1a77f6b ("Bluetooth: Improve skb handling in mgmt_device_connected()")
>   ba17bb62ce41 ("Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt_device_connected()")
>   a6fbb2bf51ad ("Bluetooth: mgmt: Remove unneeded variable")
>   8cd3c55c629e ("Bluetooth: hci_sync: fix undefined return of hci_disconnect_all_sync()")
>   3a0318140a6f ("Bluetooth: mgmt: Replace zero-length array with flexible-array member")
> 
> are missing a Signed-off-by from their committer.

Would it be possible to add bluetooth trees to linux-next?

Marcel, Luiz, Johan, would it help?

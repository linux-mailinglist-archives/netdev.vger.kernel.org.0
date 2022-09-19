Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D205BD69E
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiISVuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiISVuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:50:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C24B3E763;
        Mon, 19 Sep 2022 14:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D3DEB80C9A;
        Mon, 19 Sep 2022 21:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24260C433C1;
        Mon, 19 Sep 2022 21:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663624202;
        bh=YjhFCbjQzUSrXxdUwrttST24fO5cqS2ALKtCxlBllvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t5j2gFeoaY/CEGtEYqIX8DZgUg3y5A+A6NOuW45gNegOGwHZ0czoelxNn7OlKS4C+
         6jh/KsRMCTn2BCTiH0pheLLX+Ax/NtVwGdeQHqCAcPEdeo8c9taLz8qLwrhkEN5aO7
         vrC7Z0bp3NuxWD1m8cilkl/toG4cNxFbK8I3VhdkGM6+jDV3T9cUvj9YEkEu4hpLQk
         3SRhHdlHdlpbjaWGQgBpzi7oQyfTbIBpiMcA3Bc1MIkEpGIk3aynxFxdlOYIfBezLS
         CynOoCh0p+7ZdQE55m6QHrQkukqrFVlff4PmV17TQNKKtWWHAmrK2aJ/JnGDpSxir9
         qzhdXi3nS7xKg==
Date:   Mon, 19 Sep 2022 14:50:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Panda <xu.panda@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] mlxsw: core: remove the unneeded result
 variable
Message-ID: <20220919145001.4aa47af1@kernel.org>
In-Reply-To: <20220912072933.16994-1-xu.panda@zte.com.cn>
References: <20220912072933.16994-1-xu.panda@zte.com.cn>
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

On Mon, 12 Sep 2022 07:29:34 +0000 cgel.zte@gmail.com wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> Return the value mlxsw_core_bus_device_register() directly instead of
> storing it in another redundant variable.

This patch does not apply cleanly to net-next, please rebase.

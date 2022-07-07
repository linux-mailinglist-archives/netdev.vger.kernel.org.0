Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318A456AF32
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbiGGXxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 19:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiGGXxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 19:53:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B127B60690
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 16:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB5760ECE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 23:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659D5C3411E;
        Thu,  7 Jul 2022 23:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657238022;
        bh=vQTJfcuAh9u0DytivO74B3essvVw2MBgYI+n8EZHcf4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V3mgDyTNbGQgZ19weglkSRG6xPWmbKRz8qxVWzdlAOg69gaYIEFoIPQmelQABQInY
         p3FEPg5oJND084BUjybBSPHmUckFgdQrY8z7SL4SK70Ur++i15VJ4oXgHMxWwm229H
         vjojkDRNyuphgZAEEu9faDvymU5xqfpr9PjPYBPvvCxAKo1xgxTcaCQx1Z7r4GQb2G
         I8o+93FxRpqj9sFkJB/LRO7KcoKP5lJd89QjqcDNYyHi5PGvLf2oIxgVXry37X6iuO
         QzbBn4T28weqGIMrFyF0ANz4Ffeu5CYp0roYx+6Y7FyKxwlm73CZGgVXf51lFJH5AZ
         VEBsXQiZ4VQoA==
Date:   Thu, 7 Jul 2022 16:53:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthias May <matthias.may@westermo.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated
 IP frames
Message-ID: <20220707165333.214e620d@kernel.org>
In-Reply-To: <8d767cb6-e2ed-670e-3afc-48e5190623d4@westermo.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
        <20220705182512.309f205e@kernel.org>
        <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
        <20220706131735.4d9f4562@kernel.org>
        <8d767cb6-e2ed-670e-3afc-48e5190623d4@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 13:57:11 +0200 Matthias May wrote:
> Again as with the above about IPv6.
> This seems to be kind of standalone. Should i integrate it into this
> patch, or send as a separate?

4 separate patches in one series would be best, I think.

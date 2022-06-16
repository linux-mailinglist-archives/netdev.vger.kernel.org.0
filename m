Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0299C54E93C
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiFPSVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiFPSVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:21:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E824EDFE;
        Thu, 16 Jun 2022 11:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 269A1B82529;
        Thu, 16 Jun 2022 18:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EDEC34114;
        Thu, 16 Jun 2022 18:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655403666;
        bh=rYFdR8j4Iyzn89X1Z6CTsw8dqXI8i2xORSz9kPccGd8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ug4jQHDnVfdYsftz2Lrp0gKpGoKpDyA7BfTO3JlG7GqJlmoo5sTi+LqFuIA6SVzOG
         LSBNHH+je4AkQwqOG1pwBpJgJReLejkQOLUoKksehgLgQnVtI8tzyqwEvVhHoIY5Xg
         CQfCyJ/rPxGxJw8V53kEjs5E0lbuZITGux6z35Q4jZVTS1Y2LBCF/hPIwHj11IvoQR
         bRm91ALO3CK39TEWpHPiZ7j3/cwC9j5bxwnfxiTEsWUuW2fO1fBU7DDZzJGMfwAXvd
         7wJ0qAux6ebenPBNTbokD7YTTw7xTZTSqKwBfjWnhoZ1KjsJCBqEaY2ZiMjMImpq38
         5zZx2JlVUUchg==
Date:   Thu, 16 Jun 2022 11:21:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH v4 bpf-next 02/10] ice: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <20220616112105.2c212e2a@kernel.org>
In-Reply-To: <20220616180609.905015-3-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
        <20220616180609.905015-3-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 20:06:01 +0200 Maciej Fijalkowski wrote:
> Add support for NETIF_F_LOOPBACK. This feature can be set via:
> $ ethtool -K eth0 loopback <on|off>
> 
> Feature can be useful for local data path tests.
> 
> CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

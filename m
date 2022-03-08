Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E552C4D104A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiCHGbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbiCHGbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:31:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A6D3CA66
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 22:30:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6919BB817CF
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 06:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C44C340EB;
        Tue,  8 Mar 2022 06:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646721042;
        bh=ltitFxVE3huIUNTbV+AaD6FBoRHy6h/JZMh8k4qN3sI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p1BjKKj8AynfttbaZYKhgJtMFRYzVjSe+tgYe7e+ruckokftPV8SASSi43AcVOU5c
         f1FI2vEpnEi4HWnsA1vIn9P7C7pr94hJLotUcndZLjtWNY9UlFu9rG/YchEYdpQnJX
         0n6CTAC/eSX3jKhXH7GZyEnUdIKILfkXEojrMhjGvnEEViP/jZ5Kk6hTzOIi7VRZKA
         7ZwuWm5fLP/xBEYI8l+5JMYDh6hVkk9K6d8WWm9efa+rb8hSO2/uqQEb/y9gDU5Xfa
         TwvrL7A6YTDWDmCPWYnvqgv7UPm70tbS4IpsMYbW4z67mrkLvQG5XAYpJbFAUpCSaT
         LP205lCC+u8Sw==
Date:   Mon, 7 Mar 2022 22:30:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH net-next] net/fungible: CONFIG_FUN_CORE needs SBITMAP
Message-ID: <20220307223040.26328a7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308045345.2899-1-dmichail@fungible.com>
References: <20220308045345.2899-1-dmichail@fungible.com>
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

On Mon,  7 Mar 2022 20:53:45 -0800 Dimitris Michailidis wrote:
> Fixes: 83622ae3989b ("net/fungible: Kconfig, Makefiles, and MAINTAINERS")

This sha does not exist upstream.

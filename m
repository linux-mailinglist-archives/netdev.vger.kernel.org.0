Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8662C7AA
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiKPSbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKPSbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:31:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3629D4731C;
        Wed, 16 Nov 2022 10:31:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDEF5B81DA8;
        Wed, 16 Nov 2022 18:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BE8C433C1;
        Wed, 16 Nov 2022 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668623478;
        bh=IUXZw5Jf+ZJoaP0nOLzVHcv0P0UtfnT7QlfdmVkh7Dk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mrgh/jsuDhZchUo9awDB7T8/8ocPWJN8KxPUvcji0KbyUaZDHwUJDe+EpAjX867d4
         Uoeva+y3oQqAiYQjKZI6BXU839uiATqGugKxzrBP3vYwrijyaFypgC05b1s1doDvnd
         6GU4ohmauqM47ffLcngU8w28yWAEtRrT3/W0p0rs/T7Z7nqeysO5MM8aPPx+AmJU1c
         GZORNKNvcM3yhIceAYboHMnmOS5aLWyr2U3dWWLi7vfxXZH6IY4vu8Dv2CpiKtJOsb
         lDHyn7ChW5zKn4bpZWTgSxXoQWKcsOkEJsCqzvaLLQFfw81vPn83TmfSenSfbaPJ1m
         7GHU4qchzjKBQ==
Date:   Wed, 16 Nov 2022 10:31:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     kernel-team@fb.com, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/3] io_uring: add napi busy polling support
Message-ID: <20221116103117.6b82e982@kernel.org>
In-Reply-To: <20221115070900.1788837-1-shr@devkernel.io>
References: <20221115070900.1788837-1-shr@devkernel.io>
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

On Mon, 14 Nov 2022 23:08:57 -0800 Stefan Roesch wrote:
> This adds the napi busy polling support in io_uring.c. It adds a new
> napi_list to the io_ring_ctx structure. This list contains the list of
> napi_id's that are currently enabled for busy polling. This list is
> used to determine which napi id's enabled busy polling.
> 
> To set the new napi busy poll timeout, a new io-uring api has been
> added. It sets the napi busy poll timeout for the corresponding ring.
> 
> There is also a corresponding liburing patch series, which enables this
> feature. The name of the series is "liburing: add add api for napi busy
> poll timeout". It also contains two programs to test the this.
> 
> Testing has shown that the round-trip times are reduced to 38us from
> 55us by enabling napi busy polling with a busy poll timeout of 100us.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

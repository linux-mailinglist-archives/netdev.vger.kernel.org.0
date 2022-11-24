Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FE6636FC7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 02:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKXBZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 20:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKXBZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 20:25:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03679111E;
        Wed, 23 Nov 2022 17:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93D0161F90;
        Thu, 24 Nov 2022 01:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC70EC433D6;
        Thu, 24 Nov 2022 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669253147;
        bh=BhD4v4hopU8vCegzK9pUd5aj04mnQ/I3a+N/9ByoM68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WZrg0xJ6qb3TvOEZVXaoyreAQHNlVE1ug+Oh94/zoZigPEEFMEHlFxeziNl99jBEm
         hetKH3KJ5pOO4Ce7QW31PzrsMtfsxPq5Do9IY7h0xAAisgDqhZj+I3xQuC7OEE2XBW
         OTni91PISf5nC0KMzWERobdy9DteOq1k2ElMUiUzAvJcX6toCBZx2tyF0tSahLBSIG
         4xJx8ICrINED5UIeBh5LaRz7h988JLnxKc4qLlG4viYNfAzAhlylhGQepUtEcUt3t7
         CrLi7Anavigl7pl8IfvHXIP36HmGWtGDvjsUohdS5KSVooTC+ajJT05oZn8T41RFyd
         8UtXNZHEPBZNg==
Date:   Wed, 23 Nov 2022 17:25:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>, Nir Levy <bhr166@gmail.com>
Cc:     grantseltzer@gmail.com, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Documentation: networking: Update generic_netlink_howto
 URL
Message-ID: <20221123172545.6d74e62d@kernel.org>
In-Reply-To: <878rk5b6o8.fsf@meer.lwn.net>
References: <20221120220630.7443-1-bhr166@gmail.com>
        <878rk5b6o8.fsf@meer.lwn.net>
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

On Sun, 20 Nov 2022 15:30:15 -0700 Jonathan Corbet wrote:
> Ah...it's not a proper LF URL if it doesn't break every year or so...
> this is a networking patch, though, so should go to the folks at netdev;
> I'll CC them now.

Applied, thanks!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48320559095
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 07:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiFXEsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiFXEro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA4B69A97
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 21:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B765460DEF
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 04:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF325C3411C;
        Fri, 24 Jun 2022 04:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656046026;
        bh=80kSek2vxLNNx/f/J+9EkyskplFSa16yG9aYmJ0BTSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gGa8JqdGw3zfuqIeicB9AjBlCknX9UR9NPzQryQA4jHNUpY9jC/UjqSR47QNt1YbV
         82Vh5KZyC4Aokth9XL/M3h0qx7c/l9aYjeAUHFk6KWEjenzYILkGMmGtOVC6vu2rTV
         Ew4WN3qRdg6EzRPjTgWMK+uNmHjHR8qx8/ZcWQEhFqNCnS6Ae1JfTvx0trRljLynvp
         FBLKgcF1BcyPskFRb24mt9w17/Ja/HRyBem8UQ+Qjez9etG93pkgJpeMS/ajEyUg50
         4Bs2Nci4rH6/l+irg+nrDJcK3HNG5/PPgvg/C8pqP9s+IapPafbyTe6QjpME4zw2an
         07LgZAgRC3dGw==
Date:   Thu, 23 Jun 2022 21:47:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: usb: ax88179_178a: corrects packet receiving
Message-ID: <20220623214705.2ac24b16@kernel.org>
In-Reply-To: <9a2a2790acfd45bef2cd786dc92407bcd6c14448.camel@gmail.com>
References: <9a2a2790acfd45bef2cd786dc92407bcd6c14448.camel@gmail.com>
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

On Thu, 23 Jun 2022 11:06:05 -0300 Jose Alonso wrote:
> +	 * In current firmware there is 2 entries per packet.

Do you know what FW version you have?
No need to repost we can add it to the commit msg when applying.

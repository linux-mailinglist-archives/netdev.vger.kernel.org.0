Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1757E698C94
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBPGGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBPGGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:06:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD2036FCD;
        Wed, 15 Feb 2023 22:06:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC6A4B825BC;
        Thu, 16 Feb 2023 06:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9E6C433D2;
        Thu, 16 Feb 2023 06:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527604;
        bh=f4lWCrirqvEWiwzfvEURJGOZXW84Gbah04Iq0ahGGWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oA+gWKWP/WU8xN+6D4DT6ydBSEQqUyAVQj0P5dETN8FdxXxS1NbQ7yQcwSSr+tgj+
         2mJ8hYXeCqyqgtQ360f0P3QiTkH9EQkL663FK5FkPoDLi9GSy3r0FNu2DT0a7tfgjg
         uNOx5dhARweLcB2CFzGhZNF2S2v7938zze95ynemcONLYEod0sMXQQFuo3DlWlyOzY
         TX6+C6nV7hFe9znkUUM6GfhxVjN0emG1CcnAZ0fPJExom7OgWkKhTBHxe+Iq5Vblei
         Y53KnducGm9Q4uIU0t/AyJqB87A8AzFy/QRYggQQne9yeElkSVHK3hL1kliX14qmB3
         y0MGXwHO4iYrQ==
Date:   Wed, 15 Feb 2023 22:06:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Juhl <jesperjuhl76@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Patch] [drivers/net] Remove unneeded version.h includes
Message-ID: <20230215220643.4936d610@kernel.org>
In-Reply-To: <f6b97db0-75a8-7daf-bd87-a43a8c20be69@gmail.com>
References: <f6b97db0-75a8-7daf-bd87-a43a8c20be69@gmail.com>
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

On Thu, 16 Feb 2023 01:48:50 +0100 (CET) Jesper Juhl wrote:
> From: Jesper Juhl <jesperjuhl76@gmail.com>
> To: linux-kernel@vger.kernel.org
> cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
> Subject: [Patch] [drivers/net] Remove unneeded version.h includes
> Date: Thu, 16 Feb 2023 01:48:50 +0100 (CET)
> User-Agent: Alpine 2.26 (LNX 649 2022-06-02)
> 
> From bb51298e935ded65d79cb0d489d38f867a22a092 Mon Sep 17 00:00:00 2001
> From: Jesper Juhl <jesperjuhl76@gmail.com>
> Date: Mon, 13 Feb 2023 02:46:58 +0100
> Subject: [PATCH 02/12] [drivers/net] Remove unneeded version.h includes
>   pointed out by 'make versioncheck'

You have the headers twice and no commit message.
Maybe try git send-email?

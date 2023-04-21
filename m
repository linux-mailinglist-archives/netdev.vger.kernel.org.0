Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B86EAD4B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjDUOmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjDUOmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:42:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBDE146D0;
        Fri, 21 Apr 2023 07:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB58365152;
        Fri, 21 Apr 2023 14:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B38CC43442;
        Fri, 21 Apr 2023 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682087975;
        bh=qfrWl+B2v1A7R31TzqbsKEL9h1M0TeCmWSIKZk2uNPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YIIlLuafhg0lV3iGVvYNBY+o2Qqzg/Gl5H/Ff7aktjPRZtaqRGv2YxuiABufWmb7F
         +VtNB3kApmE3Su7iRna8oac9IhJolFbBLgGlChauw1nZ7GbppqBHbO1txbqJlD4NCd
         eXY3itnFWyr+61IaI+GZ/2PQmGPjXdHjEt7F6d9BOiTV2IwBbOyBXGAcA/uUNY4MPq
         g04FTD/bI/9Gb0/lMlMsA/kK6LwQFkgBfZRfZg6vCIXV4bvhm2BHKr5Xiy3XDjY4q0
         U7tPL/WsvS5zhT+sxJHsNR/H/GlwcuSDzin5oDHZxUJ3cKSsubYCjgdwrcSYvwXGxY
         2jv07KOqgjCRw==
Date:   Fri, 21 Apr 2023 07:39:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: pull-request: wireless-next-2023-04-21
Message-ID: <20230421073934.1e4bc30c@kernel.org>
In-Reply-To: <20230421104726.800BCC433D2@smtp.kernel.org>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 10:47:26 +0000 (UTC) Kalle Valo wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.

Sparse warning to follow up on:

drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25: warning: invalid assignment: |=
drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25:    left side has type restricted __le32
drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25:    right side has type unsigned long

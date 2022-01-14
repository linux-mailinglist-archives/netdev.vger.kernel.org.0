Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D5348EF31
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 18:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbiANRXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 12:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiANRXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 12:23:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BA9C061574;
        Fri, 14 Jan 2022 09:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C415461FFF;
        Fri, 14 Jan 2022 17:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45B6C36AE5;
        Fri, 14 Jan 2022 17:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642180995;
        bh=8RDjIIimYFNcFf/LYpHmIeI22mGZukj9FZXbDY9ygZM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tccIOXWXAkjKgk4+zPtW1eF5fJGz+2bfLK2s+zC/XiieqS0LkNZIN5DE6cHKUA51d
         l/bUxurSmVfTKWhOFy+D74AibEekbUOixuXbhrKVT5+GbTD3HlA/pOnOP2QIb7Bjff
         iyzKapZEZc0/TS23+3gRN0hjO4TBLzlpPzXLHwbJMKdIy3ZgUXHPlnf2hzXvKxVekx
         5rrBX06Y0BL7w1SgLT/YKRxrCIzi+D3vvoK/m+FPAoTCtusRZW57CYBxRRpouP37YK
         Ymsiukb0UAsh2IvlXwEiluafIfHtuhhp2XnZz55fsNvZc4qM+4Czqdak6pFZ7aljgR
         LDh9IcdFrpBjg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lkp@intel.com
Subject: Re: [PATCH wireless] MAINTAINERS: add common wireless and wireless-next trees
References: <20220114133415.8008-1-kvalo@kernel.org>
        <20220114081932.475eaf86@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Fri, 14 Jan 2022 19:23:10 +0200
In-Reply-To: <20220114081932.475eaf86@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        (Jakub Kicinski's message of "Fri, 14 Jan 2022 08:19:32 -0800")
Message-ID: <87tue6s03l.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 14 Jan 2022 15:34:15 +0200 Kalle Valo wrote:
>> +Q:	http://patchwork.kernel.org/project/linux-wireless/list/
>
> nit: https?

Good point, I'll add that. I'll also change the existing links to use
https.

While looking at MAINTAINERS file more, I found this odd small entry in
the MAINTAINERS file:

NETWORKING [WIRELESS]
L:         linux-wireless@vger.kernel.org
Q:         http://patchwork.kernel.org/project/linux-wireless/list/

It seems to be an artifact from this commit:

0e324cf640fb MAINTAINERS: changes for wireless

I don't see how that section is needed so I'll remove that as well.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

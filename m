Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1AF46CCD9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhLHFRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:17:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52848 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhLHFRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:17:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6991CCE1FAC;
        Wed,  8 Dec 2021 05:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659FAC00446;
        Wed,  8 Dec 2021 05:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638940453;
        bh=IGUxtBlsOfhCTSD6x5jyNgTkYX51+25bV8oON+CM/l4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gG2+aDCRZcdSKZks0sHV9VrZnxhwog/t1xdwT0qQMyK3O5CeWKrQEIwXjzMBeQQ1J
         I7T3p4bFlLR7/zLgRBtwntL4bsftSPHazEoMWGg18nPCOSxs7lmx4R0aw/7LuGnLl1
         LJhBMgCFTRWqp8N3LyUgMNKQYZC9xJrdMxhVbnWSh9yV6Idlmu9dgpfeJCMwOdqZLq
         P8DYgDTh5/XN7TFCQ01INBcxoABNEW41H/fLflhkKcC+cwEc8EvTzTqWE8LExgSDbI
         n8Muh7q/TQ9qLzxz+rlBtlaU3z3QlmQEdfCB1XOLaKMuKuNolIN49db5sQuOl85DNp
         ChOWpJ40+ViaA==
Date:   Tue, 7 Dec 2021 21:14:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
Message-ID: <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207144211.A9949C341C1@smtp.kernel.org>
References: <20211207144211.A9949C341C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 14:42:11 +0000 (UTC) Kalle Valo wrote:
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.

Pulled, thanks! Could you chase the appropriate people so that the new
W=1 C=1 warnings get resolved before the merge window's here?

https://patchwork.kernel.org/project/netdevbpf/patch/20211207144211.A9949C341C1@smtp.kernel.org/

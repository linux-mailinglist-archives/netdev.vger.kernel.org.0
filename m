Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470682C3278
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 22:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgKXVSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 16:18:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730537AbgKXVSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 16:18:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56627206E0;
        Tue, 24 Nov 2020 21:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606252733;
        bh=txXwmwzb/F4mP91X80KyOzE5ENlGLrcCu0ybpkounLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lX/TdMzKAH+lM/vj3DLhJpShjLsEQm3I8LkgYXvJWzxs7j3+Ld7Y1PWRVYCbrU4zL
         DZpAaE5qTh1cWzOehenA33LrUDTKVUn14fF0QzH8A6IOyOVEP1FY9xxq1kiuFYzbRk
         RCfcpgXQsmGdWdYz5a/zPxwhFRCBiwBIW7HGlIgU=
Date:   Tue, 24 Nov 2020 13:18:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] devlink: Fix reload stats structure
Message-ID: <20201124131852.1316d6f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1606109785-25197-1-git-send-email-moshe@mellanox.com>
References: <1606109785-25197-1-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 07:36:25 +0200 Moshe Shemesh wrote:
> Fix reload stats structure exposed to the user. Change stats structure
> hierarchy to have the reload action as a parent of the stat entry and
> then stat entry includes value per limit. This will also help to avoid
> string concatenation on iproute2 output.
> 
> Reload stats structure before this fix:
> "stats": {
>     "reload": {
>         "driver_reinit": 2,
>         "fw_activate": 1,
>         "fw_activate_no_reset": 0
>      }
> }
> 
> After this fix:
> "stats": {
>     "reload": {
>         "driver_reinit": {
>             "unspecified": 2
>         },
>         "fw_activate": {
>             "unspecified": 1,
>             "no_reset": 0
>         }
> }
> 
> Fixes: a254c264267e ("devlink: Add reload stats")
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Applied.

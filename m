Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F689355B6B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhDFSbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233806AbhDFSbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 14:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2DD2613B3;
        Tue,  6 Apr 2021 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617733901;
        bh=dISaBcn1vJtzPODRN61E8eGsug/prLrZPnt1KfgLh84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t0GiWbqCoknhaNzxVO0u/y2QLzZRZuszE6ZLQgtE8KenBuOxD2DyAMgt6u2vf+G4+
         aomy4vdqCJE5HOhqbjhFlD82F5qp+BerkHeSog/0pUNO+Mrod/B3a0qCfs9XRwjgNl
         vScwu/RG2N3VI3TaY7XUrQkBxWb0RQ2ptYN1IM0c4J0RIeUgSX7o5gyWqYaEScpSsy
         ztDeyvXQAhvDnqkFkvcHhssaUWpIguXTNmDQX+PoRNWTGWQ1U0IpHqWccDyQS5g/6g
         pSPWk91RyW8WICXrUN00uyoEtl0n7FvduCzNz+cW9mqOdryqi79GS/tVxBg5fwfrZY
         2uoqkZcpuGyPg==
Date:   Tue, 6 Apr 2021 11:31:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: Re: [PATCH net-next v4] net: Allow to specify ifindex when device
 is moved to another namespace
Message-ID: <20210406113140.467a0cb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210406075448.203816-1-avagin@gmail.com>
References: <20210406075448.203816-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Apr 2021 00:54:48 -0700 Andrei Vagin wrote:
> v3: check that new_ifindex is positive.
> v4: - use ifla_policy to validate IFLA_NEW_IFINDEX.
>     - don't change the prototype of dev_change_net_namespace that is
>       used in many places.

I'm afraid v3 got merged before I sent my review, would you mind
rebasing on net-next and resending an incremental change?

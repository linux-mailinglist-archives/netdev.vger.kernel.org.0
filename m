Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF1F1DEE28
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgEVRYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730554AbgEVRYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:24:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99B1E206C3;
        Fri, 22 May 2020 17:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590168264;
        bh=a7vJfJIAv9McskG7MZDFR7GaC4IPsDA22S6x57C80aw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PDQBVXzM3edo57feQ1Q6kuVojMeW8eF2BksdqpCP5yf9MqcGq8jC67OeHo8z4z/ea
         1yG61ffQTc0AJlyKEz0Ns1YfcnEhqmuKinv8/8p+ENkrJJeQOiRoJeDVXI1+kc92Rv
         +ucAsUy4pl/FogwkvUFeSGi+pNBUYN3G0cilZU14=
Date:   Fri, 22 May 2020 10:24:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wu000273@umn.edu
Cc:     tariqt@mellanox.com, davem@davemloft.net,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kjlu@umn.edu
Subject: Re: [PATCH] net/mlx4_core: fix a memory leak bug.
Message-ID: <20200522102420.41c9637a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200522052348.1241-1-wu000273@umn.edu>
References: <20200522052348.1241-1-wu000273@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 00:23:48 -0500 wu000273@umn.edu wrote:
> From: Qiushi Wu <wu000273@umn.edu>
> 
> In function mlx4_opreq_action(), pointer "mailbox" is not released,
> when mlx4_cmd_box() return and error, causing a memory leak bug.
> Fix this issue by going to "out" label, mlx4_free_cmd_mailbox() can
> free this pointer.
> 
> Fixes: fe6f700d6cbb7 ("Respond to operation request by firmware")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>

Fixes tag: Fixes: fe6f700d6cbb7 ("Respond to operation request by firmware")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'

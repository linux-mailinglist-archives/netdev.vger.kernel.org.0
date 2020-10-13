Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9442928D6FE
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgJMX2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgJMX2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 19:28:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E30D20B1F;
        Tue, 13 Oct 2020 23:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602631683;
        bh=TzGIlJPXYuWhdamyfrVgSPXRDJwyAvqOAiI1x4o7tqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qva09PfUWZWlXKPl6OsRlfE3q+qeRuRutWIpO8lr77SXclsXt02mjw6+GYPYauPQG
         E7y4XkpB0bxaDZgvbfiWQxE6Gkr8zhYtKWaopbHe2dofwrRRb6YN4bxogoTF/MQPvA
         k2Kx0Gk8n570EQwX92OCazrvdTn8dZJ5LBUTS2H4=
Date:   Tue, 13 Oct 2020 16:28:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] docs: networking: update XPS to account for
 netif_set_xps_queue
Message-ID: <20201013162801.755932cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013194508.389495-1-willemdebruijn.kernel@gmail.com>
References: <20201013194508.389495-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 15:45:08 -0400 Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> With the introduction of netif_set_xps_queue, XPS can be enabled
> by the driver at initialization.
> 
> Update the documentation to reflect this, as otherwise users
> may incorrectly believe that the feature is off by default.
> 
> Fixes: 537c00de1c9b ("net: Add functions netif_reset_xps_queue and netif_set_xps_queue")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thank you!

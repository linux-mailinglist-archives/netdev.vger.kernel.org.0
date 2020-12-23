Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61ACC2E2198
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgLWUi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:38:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbgLWUi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:38:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51A8E224B1;
        Wed, 23 Dec 2020 20:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608755868;
        bh=pHaQlSiwAMJXPQbvVG+u7r5S1g8i2MYVmP/nBhTXTus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EYUCT4X6EiHONxFudNjNOimt5nt/ik0fwY3UvdIwhvg0PhjijVRJJRV4HAo1zEgKT
         S7YQ0XhJgAdt7dW9q3iCfiOquk6lHnt0koIfqS29kv3PM8k9v/4ifAPbA2LVlQABuu
         ABGxkB0LXg0Q7VqfufNrCbeoBoRcyEln/G+54echZClJMlAY2eixo8UGWtlK0Vl4TG
         DNs5blRLXwrqU/vvGFq3nKObB13zps4o9NtTiXgyTXdgqpFhX9raAJttbu7l1iepgI
         Y9r/9Eg0iliJC7VRMPs9AVBTSFnf7+QpqoCikWoraMqxw4IoIZtUnAsrDGRo4fg2jC
         MJs6Pm1cJDhKA==
Date:   Wed, 23 Dec 2020 12:37:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] enic: Remove redundant free in enic_set_ringparam
Message-ID: <20201223123747.6f506068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223123833.14733-1-dinghao.liu@zju.edu.cn>
References: <20201223123833.14733-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 20:38:33 +0800 Dinghao Liu wrote:
> The error handling paths in enic_alloc_vnic_resources()
> have called enic_free_vnic_resources() before returning.
> So we may not need to call it again on failure at caller
> side.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

But it's harmless, right? So the patch is just a cleanup not a fix?

In that case, could you please repost in two weeks? We're currently 
in the merge window period, we're only accepting fixes to the
networking trees.

Thanks!

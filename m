Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D4022195F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgGPBUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPBUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 21:20:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9278C20775;
        Thu, 16 Jul 2020 01:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594862439;
        bh=LB1IAxvKID4DrZllPjAHJpai4PgYVm2WsosilJHqUj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Js/uJ8k4alQHc7rce32oYrGKSRELWbWAfNFEBoUFc3TnECnNJgwU2Dx6HmB/wBCzT
         YvP5qUDUQSvZdCVs7mI7YJByefu4Snlb4ehYa6GESVrGrEAzjeJgHm+lpMMB5WpTyL
         OW0J9QTav+ctuMAhIseQrqysVPHV0B3fFHfaGeQY=
Date:   Wed, 15 Jul 2020 18:20:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     trivial@kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <snelson@pensando.io>,
        Colin Ian King <colin.king@canonical.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v2 3/8] drivers: net: wan: Fix trivial spelling
Message-ID: <20200715182036.0cd31e87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715124839.252822-4-kieran.bingham+renesas@ideasonboard.com>
References: <20200715124839.252822-1-kieran.bingham+renesas@ideasonboard.com>
        <20200715124839.252822-4-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 13:48:34 +0100 Kieran Bingham wrote:
> The word 'descriptor' is misspelled throughout the tree.
> 
> Fix it up accordingly:
>     decriptor -> descriptor
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Applied to net-next.

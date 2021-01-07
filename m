Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C352ED785
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbhAGTeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAGTeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:34:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AACF23443;
        Thu,  7 Jan 2021 19:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610048019;
        bh=GN66QiRPOa75+1AtjSyFVpxBR0qQOTALpEqWT5UlGJA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VzeUpHt7tm2D8RBwwcPvo68RsAT1EcxMnIBD6xaajF/RQYEQEkmlkIk2cgVnlYu2Z
         i3mZpQNrLX79VGESjdtOnpd/XzvS/qhOI93xG1qwEAq6Qq8djZQJYZnKEAsY/vgbNo
         Fqsfgjp67OJEGCg5UN7yR2xBqr+Gk0UtQ3b92yBquyisbLIHClMjO2tE8+3zcAD0jG
         UGlMcu2+NwqykPZOnO0CCNY3yaTtQWouuwuS4l9uynWsM+2eHr4SaoXhMr1xSwvgGS
         l6eRLFt1E/xMD0sKG3f0RhecV7LvsSCPeKQ64Z0ZTW0QMgEaYuv91rpbYdJBxOWTRU
         zSSg9w2EoKHyw==
Date:   Thu, 7 Jan 2021 11:33:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 0/2] Dissect PTP L2 packet header
Message-ID: <20210107113338.4f142954@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610023140-20256-1-git-send-email-eranbe@nvidia.com>
References: <1610023140-20256-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 14:38:58 +0200 Eran Ben Elisha wrote:
> Hi Jakub, Dave,
> 
> This series adds support for dissecting PTP L2 packet
> header (EtherType 0x88F7).
> 
> For packet header dissecting, skb->protocol is needed. Add protocol
> parsing operation to vlan ops, to guarantee skb->protocol is set,
> as EtherType 0x88F7 occasionally follows a vlan header.

Please make an effort to add people who can give you reviews on CC 
and repost.

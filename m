Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC4C315777
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhBIUHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233302AbhBITve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:51:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E0F64E7D;
        Tue,  9 Feb 2021 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612900214;
        bh=WnEjZy27F9yADXoqhKSmtQ+jDswgFtYGG63577vTwv8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FBub3Wbyg0FZMvO6f2hA+3JtZXbkD5h+eU3ZQuH570TPo/eWfAd76sZbo3efWT2S9
         NFd44Ksf4n1T14UahKBjBrgxl+c1Lfx4f9jQDJqGr9QAvULo6spkgY05wpwWoRV+G+
         nD4U7VD+BV+7qx6gvM2W67mir4KBqeoaEhsofC4p3MOJxiJPRKt2rmohuKmEuchLVF
         wJ0ISDQcXaYhq2LKbXyRxcVFEtqsGR5cB+q7cBJl13v2OKurM1wajj3wVTBLy8Pq43
         F2dfyj2isw4PwwNO34z1SNF17Oc9DwJ6XhQb1vJ9LOok/uUSSpyOqKE1PSn4xVtFVM
         1zg4sjcX3NC5A==
Date:   Tue, 9 Feb 2021 11:50:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210209115012.049ee898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ygnhlfbxgifc.fsf@nvidia.com>
References: <20210206050240.48410-1-saeed@kernel.org>
        <20210206050240.48410-2-saeed@kernel.org>
        <20210206181335.GA2959@horizon.localdomain>
        <ygnhtuqngebi.fsf@nvidia.com>
        <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ygnho8gtgw2l.fsf@nvidia.com>
        <20210209100504.119925c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ygnhlfbxgifc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 21:17:11 +0200 Vlad Buslov wrote:
> 4. Decapsulated payload appears on namespaced VF with IP address
> 5.5.5.5:
> 
> $ sudo ip  netns exec ns0 tcpdump -ni enp8s0f0v1 -vvv -c 3

So there are two VFs? Hm, completely missed that. Could you *please*
provide an ascii diagram for the entire flow? None of those dumps
you're showing gives us the high level picture, and it's quite hard 
to follow which enpsfyxz interface is what.

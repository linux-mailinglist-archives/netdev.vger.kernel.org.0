Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9177B1CC514
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgEIXFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgEIXFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 19:05:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 169CE21473;
        Sat,  9 May 2020 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589065516;
        bh=Fxpv0Prwn2P8/7JBxO1qZeR7M4UYc/Qs65WqOkOpc0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQn5zBgN3hNndvIdEoXysjsiWc0u/usRXZgkZo1NX+UGy7k5F9bLs8vlMe8skQ7mM
         HwjVDskT8gSQ/G65IlHcRcFN8ljc6EXfDqGs98hILGIYqiZpnuTIpx5+N0jveXIW+j
         cCRjj6Y7Z/OmNMhX/7hSh5w1U7omk/0PQ0bgr2fo=
Date:   Sat, 9 May 2020 16:05:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/9] mlxsw: spectrum: Enforce some HW
 limitations for matchall TC offload
Message-ID: <20200509160514.1074715c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509200610.375719-1-idosch@idosch.org>
References: <20200509200610.375719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 23:06:01 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jiri says:
> 
> There are some limitations for TC matchall classifier offload that are
> given by the mlxsw HW dataplane. It is not possible to do sampling on
> egress and also the mirror/sample vs. ACL (flower) ordering is fixed. So
> check this and forbid to offload incorrect setup.

Applied, thank you!

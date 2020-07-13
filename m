Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA9F21E325
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgGMWnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGMWnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:43:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 143E120DD4;
        Mon, 13 Jul 2020 22:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594680196;
        bh=AnC3NZYiL/LcnWfTibApAf7tMG+7rj1f+i3imenqQDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eVTCvIBnciV4TmwCXoEHUZOfE7+c514XyCJqphB63c/kX9TlewUgxFdC5+qyaJDtW
         R5OgdRrjVdbrRsx4hF/XPg2Kg5A7FIPvSuqhMfbLm2UifxSrpnJaDM+DN+GO2FTV3m
         UiulvFQubXW0JdHw1PhpwbfDteUk7j0zLLQAGXeA=
Date:   Mon, 13 Jul 2020 15:43:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        moshe@mellanox.com, vladyslavt@mellanox.com, cai@lca.pw,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next] devlink: Fix use-after-free when destroying
 health reporters
Message-ID: <20200713154314.4e6a3cd1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713152014.244936-1-idosch@idosch.org>
References: <20200713152014.244936-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 18:20:14 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Dereferencing the reporter after it was destroyed in order to unlock the
> reporters lock results in a use-after-free [1].
> 
> Fix this by storing a pointer to the lock in a local variable before
> destroying the reporter.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6702313D7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgG1U1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgG1U1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:27:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641DE2065E;
        Tue, 28 Jul 2020 20:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595968031;
        bh=n8EoazOPuaemu0s7mGNbS1nlC9zwObjZA++OgGk4ABQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m/4JlGwJzfcBO4GWW6/1IRieTtH45c822trVtyxg+h0t5s7csBEGE7NAY7YIKRZSn
         7S8HRD0pz22YRnYc2UMQYAyl3gpUEywlCJqBak1uwCwVeVmbG7Ke+KwjxGrxTAhcyX
         lJkd6asKewdCK3IZLHAvUSwf0cdjX2j5wUVzBrCM=
Date:   Tue, 28 Jul 2020 13:27:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/13] mlx5 updates 2020-07-28
Message-ID: <20200728132710.56132059@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 02:43:58 -0700 Saeed Mahameed wrote:
> Hi Dave, Jakub,
> 
> This series contains small misc updates to mlx5 driver.
> 
> Note that the pci relaxed ordering patch is now much smaller and 
> without the driver private knob by following the discussion conclusions 
> on the previous patch to only use the pcie_relaxed_ordering_enabled()
> kernel helper, and setpci to disable it as a chicken bit.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

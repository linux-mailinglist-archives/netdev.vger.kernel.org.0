Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BA122302F
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 03:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgGQBHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 21:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgGQBHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 21:07:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354DA207BC;
        Fri, 17 Jul 2020 01:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594948072;
        bh=E+JtmiTFalPyrgJePSuOO/wFCSD6oJUUdofO4HCq/3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1806oiDp8hV10jYxwQBlAXbVEijszff2JzJveTy8EVbzwLX3FtyMOSfZYYff2K1k
         Ep+a8t6OIMhfmWemKS6jDdOxgNOeyCklYhs9QXXuYyybNLP32NPDIy19v1kXs+NFDw
         L2lIw6oQvzxdSu+qnjAOGZMVQOUdyZ6v++Ml3cfE=
Date:   Thu, 16 Jul 2020 18:07:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V2 00/15] mlx5 updates 2020-07-16
Message-ID: <20200716180750.37a156a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 17:03:55 -0700 Saeed Mahameed wrote:
> Hi Dave, Jakub,
> 
> This patchset includes mlx5 RX XFRM ipsec offloads for ConnectX devices
> and some other misc updates and fixes to net-next.
> v1->v2:
>  - Fix "was not declared" build warning when RETPOLINE=y, reported by Jakub.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Patch 5 a little skimpy on the why, but:

Acked-by: Jakub Kicinski <kuba@kernel.org>

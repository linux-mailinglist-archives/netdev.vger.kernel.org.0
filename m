Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802FD21BEF8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgGJVFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgGJVFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:05:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1B7020748;
        Fri, 10 Jul 2020 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594415116;
        bh=lU385kgUQzcT5PTu69pzSVuNncb8V5jaig7bFtPpcwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SbBrPcSuTybnZ7cy36qB+2IEZJxiDgL3Jl21KhlyQNJWXAT1OQgfVGNuXBEha0jNd
         0dLcSgeN3MyaAijx+UEELPVR3hyR50W7C+7qerjTB3eXQaG/CV/VBbQ22fI/k3NAt/
         oNzABsyjEiTUzmW9fjhCO6N61v8+5E6Fq+smjpbM=
Date:   Fri, 10 Jul 2020 14:05:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net V2 0/9] mlx5 fixes 2020-07-02
Message-ID: <20200710140514.692f95f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 19:30:09 -0700 Saeed Mahameed wrote:
> V1->v2:
>  - Drop "ip -s" patch and mirred device hold reference patch.
>  - Will revise them in a later submission.

Acked-by: Jakub Kicinski <kuba@kernel.org>

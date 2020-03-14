Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7971D185407
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 03:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgCNChY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 22:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgCNChX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 22:37:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CAE92074B;
        Sat, 14 Mar 2020 02:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584153443;
        bh=wAoNaUUv4lp0Vl9MXOr/CoNP0YfqjwFj/AIPmCpjmJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=urspmVQ0ulvpCm4/Qt/TN04pJAgQg4FE6Df3ggZQvPQQfdipzXU/RN2WkWdqgHi3L
         Eqapm9gTxbzjYOxj64/uaO+5tYwCZHZX2vuYOiDR5kSAe/efSaEyGpB4yS4H9NXftT
         5gNtLsFlGxdHhrJ5PsncySJAjIk9Y6lUYD1UfQi0=
Date:   Fri, 13 Mar 2020 19:37:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/14] Mellanox, mlx5 updates
 2020-03-13
Message-ID: <20200313193721.40c78dbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 18:16:08 -0700 Saeed Mahameed wrote:
> Hi Dave,
> 
> This series adds misc updates to mlx5 driver
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

My questions on the patches are mostly curiosity, so:

Acked-by: Jakub Kicinski <kuba@kernel.org>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E047F47DC7F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbhLWBEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240675AbhLWBEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:04:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C972C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 17:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2674061D84
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 01:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ABDC36AEA;
        Thu, 23 Dec 2021 01:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640221444;
        bh=Tu3h2XJAzqVr26yk4JKEgrcPKtqSmpqIppDIT5P+/bw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZYDTa3AHGMfUfhJuydlTbcy92CMZ1swAZ3lRFEOOuRjIWB3OmnpAEocRPLKQPDuGg
         Sg1Krk7f1ORFuIAhmbAMWn46/Tv4ZLY8c9IGZGCGXyxfrHmb22X1bYIwa8mp7uWuu1
         VBM9qZQtvMKorRtZjHhc9FlSM5qX6rpGxcXc+2uoIVApGSU5s38m83noMv7nxdOMeQ
         IkFqFg70UPgSFJgfHjnGSPJNs1ND7LLPjyusG6T73BqlSGBqKKLuiyU1/oDYTyEVEP
         uScGNbr1JNc+ZU29+hR37shjIaUSd4t6auSRluNY/ocmdNk4ur4ym1nkfaMCIj6y5B
         rVAU4dTReZ2gw==
Date:   Wed, 22 Dec 2021 17:04:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Miaoqian Lin <linmq006@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 01/11] net/mlx5: DR, Fix NULL vs IS_ERR checking in
 dr_domain_init_resources
Message-ID: <20211222170403.3ec2fe91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222211201.77469-2-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
        <20211222211201.77469-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Dec 2021 13:11:51 -0800 Saeed Mahameed wrote:
> From: Miaoqian Lin <linmq006@gmail.com>
> 
> The mlx5_get_uars_page() function  returns error pointers.
> Using IS_ERR() to check the return value to fix this.
> 
> Fixes: 4ec9e7b02697("net/mlx5: DR, Expose steering domain functionality")

Do you mind fixing this missing space? I'll cherry pick the change from
net-next in the meantime.

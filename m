Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1871E4A902B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355496AbiBCVq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:46:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42152 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbiBCVq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:46:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B680B835B0;
        Thu,  3 Feb 2022 21:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF46FC340E8;
        Thu,  3 Feb 2022 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643924784;
        bh=cz9F09un3prr+okQMRs9hSqR+JLzwF/3XyJjh6bMmq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ss8fX1T2g1p/L/dzhXDdWiuuwWyp09UOTwgeXBU7cHN6RCDEJyg7BjikFC6ACtNg/
         0KgAI1836esegwzxz4zqX5FvPxotk3ToSJbnobRXgwfDze4R2wxMbaG9dbakH6lNHz
         l1RzxEJkQnv2q52uRTsK0qdqfg9UYnZzRf+87zp3BU4rWbDIz/Aw01gPjfItKXNpUS
         wj/Vy1+ImLQgm2sEVcgm3FAJUyhBLQk49o3my0IU48M2XOgZLaVg2/dTGFBuCVYdI2
         giq+NoJu/zuCrfHQqijNQyR8Da8h6YzGUTFsUEbhFvBrJEjKhtOfjaaVqyetNVwMZh
         V4edHyUMvD16Q==
Date:   Thu, 3 Feb 2022 13:46:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 05/52] netfilter: nf_conntrack_netbios_ns:
 fix helper module alias
Message-ID: <20220203134622.5964eb15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203202947.2304-5-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
        <20220203202947.2304-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Feb 2022 15:28:59 -0500 Sasha Levin wrote:
> Intentionally not adding a fixes-tag because i don't want this to go to
> stable. 

Ekhm. ;)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9768465BCE
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 02:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347629AbhLBBv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 20:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347291AbhLBBvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 20:51:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F26AC061574;
        Wed,  1 Dec 2021 17:48:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A141B821BB;
        Thu,  2 Dec 2021 01:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20E8C00446;
        Thu,  2 Dec 2021 01:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638409703;
        bh=rX6Hzb6QHB/vShLCZQuiRt4vZUktSxPTk8iSZdxIzrY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U1LTYfKULVcS40C1rBGuW/+sUUKw4ue2cnd0j0PRe9ZIUPbeYYrekO6RGNj9xd2Nw
         exNofflc5oLklBSM0h1S4icPNvdd3X0ORciFOigMbBTd6fzW50vm5hg8uL3Dq/82yl
         P0FizyUopCZsghMKm2lXrcSmQuDKkZeIUsjRhPmhapj+nyeWuCY+jts7JzvQhLpIEF
         L9wpxnjJpWKi92xAtH2YQzEljLSdi4wxGPU/lTnh11TtqUmV5idlkYqxfon6tYINEs
         Tb8joZPIIle6ovI/D6qzjvWIOrggSbiRCW6rEFGH+1ltfSr2ZihHVg8XXdaDR9kbSd
         odztmsbStbooA==
Date:   Wed, 1 Dec 2021 17:48:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] selftests: add option to list all avaliable tests
Message-ID: <20211201174821.2d40a3eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f4ebc027-5f5d-1a4a-8a33-964cd7214af8@fujitsu.com>
References: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
        <20211201111025.13834-2-lizhijian@cn.fujitsu.com>
        <f4ebc027-5f5d-1a4a-8a33-964cd7214af8@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 11:22:03 +0000 lizhijian@fujitsu.com wrote:
> sent V2 to fix a typo

You need to resend the entire series, patchwork does not understand
updating single patches:

https://patchwork.kernel.org/project/netdevbpf/list/?series=588501
https://patchwork.kernel.org/project/netdevbpf/list/?series=588507

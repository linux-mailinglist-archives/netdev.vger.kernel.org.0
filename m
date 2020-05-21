Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D6D1DD9D5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgEUWDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgEUWDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 18:03:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CF620748;
        Thu, 21 May 2020 22:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590098621;
        bh=8YzvsEBudI9FmM7eq24YeWrKs3KeKTCQVKa0SAoYxak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E5KvL/HNcO3/atipqFDSz/cGrr6vDGDsix7JCmZwv9GoKnEpeL9mj91EGOeveIynl
         2Lxc0CnXw0Y8lKmT79LAghm4J8cDgT+GnaRnUtHv5cz/dlQGjPiau8TvmQpxmMXQxX
         Lu9X/PwwAmsBAlMtH7YS3bQd+/9QSPzaj5Z24Vck=
Date:   Thu, 21 May 2020 15:03:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V1 net-next 00/15] ENA features and cosmetic changes
Message-ID: <20200521150339.43f309ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 22:08:19 +0300 akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> This patchset includes:
> 1. new rx offset feature
> 2. reduction of the driver load time
> 3. error prints
> 4. multiple cosmetic changes to the code 

Other than the nit on using better print functions looks good!

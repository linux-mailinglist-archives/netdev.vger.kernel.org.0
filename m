Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F5B1DEE99
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbgEVRs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgEVRs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:48:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D81C20738;
        Fri, 22 May 2020 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590169738;
        bh=A50r9yaTMV43qgVuo8HX9u/NrpakmrpkLdjTLbFvuDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dcu97u4ANN3MIS8ipVWh0iUOZ+B29Inkrd0qJgTTqgkAy9YWC8euN/O0NxOuK1csR
         YlWH41LaqvAtfZ9kWQSku0Ma1Job7ZyVxqPDNzeuZp5yX/XqdbmM3wRAjxh0jDnoWG
         jDzTOMzOM6lXt4CT+3r1pih6c0sBWMh5Vz50Rfx4=
Date:   Fri, 22 May 2020 10:48:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V2 net-next 00/14] ENA features and cosmetic changes
Message-ID: <20200522104856.03de8c92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 12:08:51 +0300 akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Diff from V1 of this patchset:
> Removed error prints patch
> 
> This patchset includes:
> 1. new rx offset feature
> 2. reduction of the driver load time
> 3. multiple cosmetic changes to the code

Acked-by: Jakub Kicinski <kuba@kernel.org>

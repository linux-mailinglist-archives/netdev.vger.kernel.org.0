Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F87355B60
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhDFS3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238579AbhDFS3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 14:29:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFAB4613D7;
        Tue,  6 Apr 2021 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617733755;
        bh=Jqh0mWbj0QGd0R9j8KK8zJBiArAHsedOZggpDYEzi1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KPgru9ZUrG8csTehClYo7qKCArJE1ZKO09fTuuGksROONLB9kYf8F+T2ErgvnrcWS
         zBsfVjZH/zQ4bRzhWawcFxvMb/67K6hePKEAsNPgWUwMBibRlNGDd6D8l3a+9jUWov
         k4bVsIB95BPO0OwRQjoQiEhmIvwhJRi8A0HYc1JBvFYUVNqSmv7bHrpV63AWcfLOgq
         Ot4n35PR4N6PHYEZrUvM9EQMGOFfGUuSgVl5nr5FfVPs/Zkys67Y/eN01rO4N8F0Tz
         udj0WCx53zjZHC8uHr3ab9ZKmmPNPITv9fk/o82dYpHy0ukpTd/EpKg3fBLeOT/5W7
         91CjCT/bNvdzw==
Date:   Tue, 6 Apr 2021 11:29:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] netdevsim: remove unneeded semicolon
Message-ID: <20210406112913.1b5d56a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210406031813.7103-1-linqiheng@huawei.com>
References: <20210406031813.7103-1-linqiheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Apr 2021 11:18:13 +0800 Qiheng Lin wrote:
> Eliminate the following coccicheck warning:
>  drivers/net/netdevsim/fib.c:569:2-3: Unneeded semicolon
> 
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

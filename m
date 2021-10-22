Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452104380B7
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhJVXlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhJVXlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:41:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 086506103E;
        Fri, 22 Oct 2021 23:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634945929;
        bh=olDPmhMrBudTdZteDXn1SDovIWktyk2aO/XmBRsIzkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AZq33Mfr4EBhn7MK3QdXpz8it4MYxCXGSh7ykgv801bYJ1Cv66/6vcP7WNuycrvzt
         LDCxgFFd2TspBqCD/8b2+WpZzaQehGPgySgannuw7cKcEMaZLrQ8nC/g5AxKC4qfcv
         804aWDrjsjObcuqq8egMBWpS+5v/0AUbFyVeqDjMg8MY8m6KqBpUZCsUhDbnAKLHbd
         B9M9wbbBmofkiTlISHZXbodswHLNY0CSeYgRruQNC/x/UT54hfKCEc7RmHyCS/OpV/
         0oCCjQO/ebmrZ1ZU/qUI6gdEmBcWMQOfXSmSpsEcrMdNDcUdjqqp6CW1tX87B/M7Tu
         M49hZGDUDQCWw==
Date:   Fri, 22 Oct 2021 16:38:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] net: dsa: sja1105: Add of_node_put() before return
Message-ID: <20211022163848.07aa8fd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211021094606.7118-1-wanjiabing@vivo.com>
References: <20211021094606.7118-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 05:46:06 -0400 Wan Jiabing wrote:
> Fix following coccicheck warning:
> ./drivers/net/dsa/sja1105/sja1105_main.c:1193:1-33: WARNING: Function
> for_each_available_child_of_node should have of_node_put() before return.
> 
> Early exits from for_each_available_child_of_node should decrement the
> node reference counter.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Applied, thanks.

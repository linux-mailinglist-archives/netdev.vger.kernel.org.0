Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C28B221909
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 02:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgGPAoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 20:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPAoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 20:44:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02A8A20714;
        Thu, 16 Jul 2020 00:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594860279;
        bh=XxJUj25bEZC1Nw7z/HTvzhxhfg//nK9VxxDdAhvvxoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pCsHMsfq1TmoVyaA4wwvHsSZJ6dq5czxy3DiL3eKoEEXc06+gI9HLjMwvottCykMo
         NVV7G3UlilMxssFs97VBZ3WHEtcpHYet1VL0LS8bezqPcCM2XZULFX7WhXb2s/aWKu
         eEtwoTNll0q6LNwwN7VO9UV7cO8kIr4uYhdx4fFo=
Date:   Wed, 15 Jul 2020 17:44:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     kda@linux-powerpc.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNDANCE NETWORK DRIVER: Replace HTTP links with HTTPS
 ones
Message-ID: <20200715174437.04890794@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709204925.27287-1-grandmaster@al2klimov.de>
References: <20200709204925.27287-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 22:49:25 +0200 Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Applied to net-next, but please find a better algorithm for generating
the subject prefixes. 

Thanks.

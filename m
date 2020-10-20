Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D5F294567
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439280AbgJTXUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410562AbgJTXUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:20:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34336223BF;
        Tue, 20 Oct 2020 23:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603236033;
        bh=Q85/d05cKGurx8pKbKuzqfLDJiG9q3R1L+LsBhDD5QA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oIHq5JH8rSZknDRah2xNSLmQK6WYZn2+SDu0T9Eun4hY5Mi8IdsKWpnngBgOhMUng
         OK2ykieHn72hDxpC1mxlGrKuqqN+qTnQ2g5LDRqPqbd+HgRyLIq2LyX+c5m9qopS/G
         f2uKDSeH7ttklgvcwYD2o2WgvohLcpj0RZhuvtFI=
Date:   Tue, 20 Oct 2020 16:20:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [PATCH net] net/sched: act_ct: Fix adding udp port mangle
 operation
Message-ID: <20201020162031.69292833@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019090244.3015186-1-roid@nvidia.com>
References: <20201019090244.3015186-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 12:02:44 +0300 Roi Dayan wrote:
> Need to use the udp header type and not tcp.
> 
> Fixes: 9c26ba9b1f45 ("net/sched: act_ct: Instantiate flow table entry actions")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>

Applied, thanks!

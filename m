Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E495A3EEDA6
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbhHQNpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237090AbhHQNpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:45:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248F760EE0;
        Tue, 17 Aug 2021 13:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629207882;
        bh=Zg5d4qyDM5hnQQs3cqRGKAQdN63bOdqnEl33KOcoO18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=heM0AeTnqC3y1Zn43MFukVCEDZwhWvMXAHSmRSGF7PqFS+OZctARMG8Bp1DlpWUiI
         sfa8UqDuZns0Pb1uoFD4qvdmH58xAnAHKLuAgTb5GwkbpYtd37tKXu8uWnlyLP2sob
         4870uF1ypYyvG5W9bpPJt1FN3vaeQj2M07Ck9rF/bCOLHC/LmnnW6+c9fROt2kWyof
         20EPf5+0MBj6zTuhygzVscc8rDgc71hIcpDEYHL4635cuE9qPm0zuUi11otMsRfAyp
         12bT+Ano4QKeb6Q0IpawG3jErzy6U6O/83NcaAltr8rPbAzUHus9KQ2z86CwJowN4v
         vCRvEPkYPkKcg==
Date:   Tue, 17 Aug 2021 06:44:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: net_namespace: Optimize the code
Message-ID: <20210817064441.61133532@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210817102001.1125-1-yajun.deng@linux.dev>
References: <20210817102001.1125-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 18:20:01 +0800 Yajun Deng wrote:
> Inline ops_free(), becase there is only one caller.
> Separate net_drop_ns() and net_free(), so the net_free() can be
> called directly.
> Add free_exit_list() helper function for free net_exit_list.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

This patch does not apply, please rebase.

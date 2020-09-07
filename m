Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD50D2606CC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 00:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgIGWEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 18:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgIGWEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 18:04:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9A8207DE;
        Mon,  7 Sep 2020 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599516277;
        bh=UdzuHe6K6g75hbOgfhYl0KET6rbVfBWggAqTTtLJBGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ujE4EnpBJ2uakz/lHWRjf0jqwZYSMBtMhFOHIeHR9UdiQgEMpMhFOcQO/53w3oRO8
         aKH3PoSfn18RYxIDtcVKgDUCr/MUwmyAo9rSLkY0T9KVdbcAhGCwajmMRl2Eur3mId
         rx6JsQ0ghOEfexK+qT8pWA/d2IQV2pe3Ekv7Q6ME=
Date:   Mon, 7 Sep 2020 15:04:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <dhowells@redhat.com>, <davem@davemloft.net>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] rxrpc: Remove unused macro rxrpc_min_rtt_wlen
Message-ID: <20200907150435.29dcd69f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904130837.20875-1-wanghai38@huawei.com>
References: <20200904130837.20875-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 21:08:37 +0800 Wang Hai wrote:
> rxrpc_min_rtt_wlen is never used after it was introduced.
> So better to remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied.

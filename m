Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF421D64A5
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgEPXKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 19:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgEPXKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 May 2020 19:10:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9269206D4;
        Sat, 16 May 2020 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589670630;
        bh=OJgqkK0rKAP+mwon52BaWOh3v322o3dOF5imDlRm2IE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w1yNczdk+bhXx0qPJVnr29TxeJolNtEt0Oj9mCsb+Cd3FdsKV7nKJ97DKj4p6JgcR
         0TtkLLmwXTfu7652sqC8cJsCX7hYS/0bRrSIHLZq4kxQA57dg8KXVrydAcKJzU06Xb
         tNQRX/nXebKrP7ZV8OBQqq7gcaOctJpZEpjLXMaM=
Date:   Sat, 16 May 2020 19:10:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     NeilBrown <neilb@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 26/35] SUNRPC: defer slow parts of
 rpc_free_client() to a workqueue.
Message-ID: <20200516231029.GI29995@sasha-vm>
References: <20200507142830.26239-1-sashal@kernel.org>
 <20200507142830.26239-26-sashal@kernel.org>
 <878si3cuki.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <878si3cuki.fsf@notabene.neil.brown.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 07:18:53AM +1000, NeilBrown wrote:
>On Thu, May 07 2020, Sasha Levin wrote:
>
>> From: NeilBrown <neilb@suse.de>
>>
>> [ Upstream commit 7c4310ff56422ea43418305d22bbc5fe19150ec4 ]
>
>This one is buggy - it introduces a use-after-free.  Best delay it for
>now.

I've dropped it, thanks!

-- 
Thanks,
Sasha

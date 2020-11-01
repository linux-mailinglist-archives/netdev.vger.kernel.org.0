Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA262A226E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgKAXwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:52:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgKAXwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 18:52:37 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2882076E;
        Sun,  1 Nov 2020 23:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604274757;
        bh=yQZClf+XZ9bBDhmoyVluAnr1PP6WVc2KC3dk/ifcgQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cjW0Lg12y2ExFO7hYR/2QYwZNM/JKunh+YhCPdFcfU1dLlEEoT+DRDyNOCRE21bBz
         6cUWcGVFY8eb4Z0nPQGHrVh0EaEh4KNrnGnkx95M33uiaT0BmzJHF3c+4++yQJ/Wfb
         SaWpu5N1wr5awLEczgL2wBk1IMdLRd8oN6qTj7FA=
Date:   Sun, 1 Nov 2020 18:52:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 054/147] sfc: add and use efx_tx_send_pending
 in tx.c
Message-ID: <20201101235235.GB2092@sasha-vm>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-54-sashal@kernel.org>
 <0507e2d9-6535-277c-bd9a-a009c11bf795@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0507e2d9-6535-277c-bd9a-a009c11bf795@solarflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 01:24:24PM +0000, Edward Cree wrote:
>On 26/10/2020 23:47, Sasha Levin wrote:
>> From: Edward Cree <ecree@solarflare.com>
>>
>> [ Upstream commit 1c0544d24927e4fad04f858216b8ea767a3bd123 ]
>>
>> Instead of using efx_tx_queue_partner(), which relies on the assumption
>>  that tx_queues_per_channel is 2, efx_tx_send_pending() iterates over
>>  txqs with efx_for_each_channel_tx_queue().
>That assumption was valid for the code as of v5.9; this change was only
> needed to support the extra queues that were added for encap offloads.
>Thus, this patch shouldn't be backported, unless -stable is also planning
> to backport that feature (e.g. 0ce8df661456, 24b2c3751aa3), which I
> doubt (it's nearly 20 patches, and can't be considered a bugfix).

Right, now dropped - thanks!

-- 
Thanks,
Sasha

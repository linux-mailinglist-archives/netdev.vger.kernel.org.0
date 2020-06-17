Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF6D1FD227
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgFQQ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgFQQ2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:28:24 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2899C208D5;
        Wed, 17 Jun 2020 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411304;
        bh=5Ub+KICIdK4W45sSWxWJs8h5B1Ics3JByQW+e6T6Xwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1Cn6OdUEu9xi5CMzccO9nVGArdk6UglGXBE5LmNNzw538M3NsVeIMt8U+LGFFjqqT
         V6X43/FPfsmNTvi5evQLU/4xsdH4WhXqeg+Q59yw/it9FMLFChQEZjED3B1eaoel0B
         qArbmGYZMEoSZelInpo1q7ZqXvLjeaEGPe1RjKGk=
Date:   Wed, 17 Jun 2020 12:28:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 264/274] vxlan: Avoid infinite loop when
 suppressing NS messages with invalid options
Message-ID: <20200617162823.GR1931@sasha-vm>
References: <20200608230607.3361041-1-sashal@kernel.org>
 <20200608230607.3361041-264-sashal@kernel.org>
 <20200609065548.GA2113611@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200609065548.GA2113611@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 09:55:48AM +0300, Ido Schimmel wrote:
>On Mon, Jun 08, 2020 at 07:05:57PM -0400, Sasha Levin wrote:
>> From: Ido Schimmel <idosch@mellanox.com>
>>
>> [ Upstream commit 8066e6b449e050675df48e7c4b16c29f00507ff0 ]
>
>Hi,
>
>In the same patch set I also included a similar fix for the bridge
>module:
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=53fc685243bd6fb90d90305cea54598b78d3cbfc
>
>But I don't see it in the patch sets you sent.
>
>Don't see it here as well:
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.7
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-5.7.y
>
>Did it get lost or it's just pending somewhere else?

AUTOSEL ignores net/ patches that are maintained by David Miller.

I can pick it up manually.

-- 
Thanks,
Sasha

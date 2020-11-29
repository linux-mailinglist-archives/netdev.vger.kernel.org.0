Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F6B2C777B
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 05:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgK2EN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 23:13:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgK2EN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 23:13:56 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667BC20795;
        Sun, 29 Nov 2020 04:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606623195;
        bh=K5FoQFGvvNLIFxwgaGQuC5JCNn9fVGY3KnfGk0sDLXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2U04zY4JE+cbtkq5mlJ8om2ytJ1uTm+UYGdu7RKAeHETNZNSc9gjOeQoL2a2K5IP+
         At+b2lF6KDCSuK4LDS8ZHnl8GzlEpSJWa07e00vFV6rl7G5e3EHGpYO2nBcInatl5V
         SM9vZI+yfGaBkEcNN4c2Q1ZRZdspjxO/7nReLN2s=
Date:   Sat, 28 Nov 2020 23:13:14 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Message-ID: <20201129041314.GO643756@sasha-vm>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 07:08:54PM +0100, Paolo Bonzini wrote:
>On 25/11/20 19:01, Sasha Levin wrote:
>>On Wed, Nov 25, 2020 at 06:48:21PM +0100, Paolo Bonzini wrote:
>>>On 25/11/20 16:35, Sasha Levin wrote:
>>>>From: Mike Christie <michael.christie@oracle.com>
>>>>
>>>>[ Upstream commit 18f1becb6948cd411fd01968a0a54af63732e73c ]
>>>>
>>>>Move code to parse lun from req's lun_buf to helper, so tmf code
>>>>can use it in the next patch.
>>>>
>>>>Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>>Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>Acked-by: Jason Wang <jasowang@redhat.com>
>>>>Link: https://lore.kernel.org/r/1604986403-4931-5-git-send-email-michael.christie@oracle.com
>>>>
>>>>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>>>Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>
>>>This doesn't seem like stable material, does it?
>>
>>It went in as a dependency for efd838fec17b ("vhost scsi: Add support
>>for LUN resets."), which is the next patch.
>
>Which doesn't seem to be suitable for stable either...  Patch 3/5 in 

Why not? It was sent as a fix to Linus.

>the series might be (vhost scsi: fix cmd completion race), so I can 
>understand including 1/5 and 2/5 just in case, but not the rest.  Does 
>the bot not understand diffstats?

Not on their own, no. What's wrong with the diffstats?

-- 
Thanks,
Sasha

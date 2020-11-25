Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBA42C472B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732404AbgKYSBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731310AbgKYSBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 13:01:04 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAAA6206F9;
        Wed, 25 Nov 2020 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606327264;
        bh=VO6ybE3NuVe6PVRuDIjXJ0fne429g7bckEdtC+7dzRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TyNnZNxWTrn8zjMyDucfA3WTp3zS1SWpriZSQ4kRhoMFHzamSoGd8WgPO2BHuQebR
         L8mp1SH0XOWwYVir5qnTdNDG8M10leWN1cdz+hwJxaGmJEydPnzLSvd0HQa3U7JTmC
         iDvZjXPGRpcVcfe8KIuGzeUuXn+otPZVWrGcAn4w=
Date:   Wed, 25 Nov 2020 13:01:02 -0500
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
Message-ID: <20201125180102.GL643756@sasha-vm>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 06:48:21PM +0100, Paolo Bonzini wrote:
>On 25/11/20 16:35, Sasha Levin wrote:
>>From: Mike Christie <michael.christie@oracle.com>
>>
>>[ Upstream commit 18f1becb6948cd411fd01968a0a54af63732e73c ]
>>
>>Move code to parse lun from req's lun_buf to helper, so tmf code
>>can use it in the next patch.
>>
>>Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>Acked-by: Jason Wang <jasowang@redhat.com>
>>Link: https://lore.kernel.org/r/1604986403-4931-5-git-send-email-michael.christie@oracle.com
>>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This doesn't seem like stable material, does it?

It went in as a dependency for efd838fec17b ("vhost scsi: Add support
for LUN resets."), which is the next patch.

-- 
Thanks,
Sasha

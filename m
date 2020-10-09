Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA63D2891C5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733261AbgJITeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731727AbgJITeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:34:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B51A922281;
        Fri,  9 Oct 2020 19:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602272058;
        bh=1dGIqFVRNnFW8wUJLkhBSKqmJt8SiOD+f9XAodF0ey0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lehppdF4KgboveYSdRj6wXNi3x/Jfvskx1PguWmy6Jj7rfHIwtbKwQ4EwTo7i56DR
         EkPdXt3+CdJ+u0CkjtwD8SlFUrJ5qIDHA5wMtQA8Tvqpa/2VpeYPaWdM3FHWE0/PZ7
         8J7ooGmbvI/AIWw2RDtHNvKr3YeB8SMGIb2BGr/s=
Date:   Fri, 9 Oct 2020 12:34:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manjunath Patil <manjunath.b.patil@oracle.com>
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, aruna.ramakrishna@oracle.com,
        rama.nichanamatlu@oracle.com
Subject: Re: [PATCH v3 1/1] net/rds: suppress page allocation failure error
 in recv buffer refill
Message-ID: <20201009123416.0ce3ae57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602019897-25904-1-git-send-email-manjunath.b.patil@oracle.com>
References: <1602019897-25904-1-git-send-email-manjunath.b.patil@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 14:31:37 -0700 Manjunath Patil wrote:
> RDS/IB tries to refill the recv buffer in softirq context using
> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
> refill the recv buffer with GFP_KERNEL flag. This means failure to
> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
> softirq context fails to refill the recv buffer. We will see the PAF
> warnings when worker also fails to allocate.
> 
> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>

Applied to net-next, thanks!

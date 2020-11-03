Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0612A3813
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKCA4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgKCA43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:56:29 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D50206BE;
        Tue,  3 Nov 2020 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604364989;
        bh=I7DInuAPJvZj6wWev2gcLyFliWasp3YEq2r3gTuSJFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ypd+hGjTz1TdRYhmq19lmBirx3OX2ZpkLUiUUtcRYO/wYPL1u+1rLlQZwNDnmkUhw
         KrOow+VHhpg7XWX0wQeMAZJJrAtQu9CNSVKNq6v4BXdzDljxe6o8dX1ncr8L7LxnUG
         ORHtzI+JYLBFuCpJ7dVHrsj2rwnIci+5wJk/wb6A=
Date:   Mon, 2 Nov 2020 16:56:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.vnet.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/1] powerpc/vnic: Extend "failover pending" window
Message-ID: <20201102165628.2fead733@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030170711.1562994-1-sukadev@linux.ibm.com>
References: <20201030170711.1562994-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 10:07:11 -0700 Sukadev Bhattiprolu wrote:
> Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
> the "failover pending window" - where we wait for the partner to become
> ready (after a transport event) before actually attempting to failover.
> i.e window is between following two events:
> 
>         a. we get a transport event due to a FAILOVER
> 
>         b. later, we get CRQ_INITIALIZED indicating the partner is
>            ready  at which point we schedule a FAILOVER reset.
> 
> and ->failover_pending is true during this window.
> 
> If during this window, we attempt to open (or close) a device, we pretend
> that the operation succeded and let the FAILOVER reset path complete the
> operation.

Applied, thanks!

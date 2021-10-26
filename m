Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C47D43BB61
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbhJZUHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239090AbhJZUHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 16:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49F7360F70;
        Tue, 26 Oct 2021 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635278730;
        bh=iEySxOppGo6+UznibHjveg231KMNTh2WuakeVeVhIkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cHL2PzXwrT4gnFkcs363P8beXzTxJlX6YQcEyyZl/D6DxOU8sFq3BLKV7Ax3fR2ie
         7tXpU8YuWPtl1YGYzWiJ2lO/kdtXWJacpn/HXxB46Syml0JJfJf7MQqSzqtY5x8K85
         1Uj4ZlfogAhR6lvTcZN3YhdBqTdLlWATG81TDIMM=
Date:   Tue, 26 Oct 2021 22:05:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org,
        aelior@marvell.com, skalluru@marvell.com, malin1024@gmail.com,
        smalin@marvell.com, okulkarni@marvell.com, njavali@marvell.com,
        GR-everest-linux-l2@marvell.com
Subject: Re: [PATCH net-next 2/2] bnx2x: Invalidate fastpath HSI version for
 VFs
Message-ID: <YXhfhll786/fGuur@kroah.com>
References: <20211026193717.2657-1-manishc@marvell.com>
 <20211026193717.2657-2-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026193717.2657-2-manishc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 12:37:17PM -0700, Manish Chopra wrote:
> Commit 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
> added validation for fastpath HSI versions for different
> client init which was not meant for SR-IOV VF clients, which
> resulted in firmware asserts when running VF clients with
> different fastpath HSI version.
> 
> This patch along with the new firmware support in patch #1
> fixes this behavior in order to not validate fastpath HSI
> version for the VFs.
> 
> Fixes: 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

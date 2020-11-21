Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFE72BC2A2
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgKUXTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:19:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKUXTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:19:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A9921D46;
        Sat, 21 Nov 2020 23:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606000793;
        bh=ybs2YhYmDs/f8E56sygvXFyrNxO4LzNuJCKiFRCMPTY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H6ziNHrAzFxFhyETUoA6SH+RR+7J/bFF+jv3Ha2H9o4YgVl60jUuvbWd+HhM2og+0
         1L51wThSab4XMB89+1fenT0/QjmKp5nImWcCaRVl5WRNLmKzZ5cSePnDE/2EadDlXT
         UEg9+zifHxiH/tO9NjE3KPMtyDA9nBoymy2L1fXg=
Date:   Sat, 21 Nov 2020 15:19:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH] tun: honor IOCB_NOWAIT flag
Message-ID: <20201121151952.6a0d9c46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e9451860-96cc-c7c7-47b8-fe42cadd5f4c@kernel.dk>
References: <e9451860-96cc-c7c7-47b8-fe42cadd5f4c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 07:59:54 -0700 Jens Axboe wrote:
> tun only checks the file O_NONBLOCK flag, but it should also be checking
> the iocb IOCB_NOWAIT flag. Any fops using ->read/write_iter() should check
> both, otherwise it breaks users that correctly expect O_NONBLOCK semantics
> if IOCB_NOWAIT is set.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Applied, thanks!

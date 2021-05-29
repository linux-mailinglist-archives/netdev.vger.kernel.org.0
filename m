Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416073949DA
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhE2Bgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhE2Bgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 21:36:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E356613F0;
        Sat, 29 May 2021 01:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622252116;
        bh=x8FCVKun51Tp5NkWRpmfVLtf1VLvPJJ8IcFTYhsbWiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TpesDuTxmzaF39oEWd4V3r899a/rVsS54Pdi7lZykZmRNn+nnoRyhvQgekeidk1qP
         pnmN/HixPC8Uc2bytJmdSn1TypF1vyrlvVn1ZxZY3yMgdTwblkhrNlV5JRODzvvvSy
         QAFubBFXJdd6dGXCXdHwdthGvViVdzgkFnCYxgbY/avuE+c93U2eyrxyXJ8Wc0KMkv
         M+BKiD2v1KTOfRO4cmWASXeoDWScag3dI+eafbf1qR2Z0ARUJpYlInxklMQEZLCxOz
         wl3AxmToUqH9p1wOkyrFDhlZ7aPgjoImRiNDBL9R9qgMmgvmX27FQ1gt74auzofAoQ
         rlMAcuDTyTW5w==
Date:   Fri, 28 May 2021 18:35:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next 3/7] bnxt_en: Add PTP clock APIs, ioctls, and
 ethtool methods.
Message-ID: <20210528183515.3c1b6320@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622249601-7106-4-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
        <1622249601-7106-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 20:53:17 -0400 Michael Chan wrote:
> Add the clock APIs to set/get/adjust the hw clock, and the related
> ioctls and ethtool methods.
> 
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

I think you're missing locking in all clock callbacks and timecounter
accesses from the data path.

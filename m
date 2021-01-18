Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E162FAC43
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394511AbhARVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388499AbhARVCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEE71207C4;
        Mon, 18 Jan 2021 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611003716;
        bh=Bm7CKNnmExyH8NOK5Om7FgoNXzBXiKHoU9UQOBSHszQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lu07LuTv4uHt9COUF2MO9KnqZrzqfxm4Z1VmEOswJF9v84CQi9etVGkbL63MxM3OW
         9dzJ+JljZO4GePPJV8Xc47Opqcfwfl5Xn4EfPpiSz+PLNaI5sdEpdBFltcPqJGWsm9
         Lq4A2Qn84HSmzvCgJjMO7fMzKaw2ZiRhoVwhZKqchrU+rkLmPTFF/iJnRbQutdaDm2
         CYERs1L+aktR8mjHUw6uT2sc4j19gImgj2CdlkxreS+kuTv1mnyxb/RcK3fNNksfDb
         c2iVardELUyJocdNLhHhtzlmMcWpaLj/E2aGceeRCH++U1kk1h0OGYX6UAcryNl7Kd
         274Mu/QtRvQVg==
Date:   Mon, 18 Jan 2021 13:01:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net] net: nfc: nci: fix the wrong NCI_CORE_INIT
 parameters
Message-ID: <20210118130154.256b3851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118205522.317087-1-bongsu.jeon@samsung.com>
References: <20210118205522.317087-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 05:55:22 +0900 Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Fix the code because NCI_CORE_INIT_CMD includes two parameters in NCI2.0
> but there is no parameters in NCI1.x.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

What's the Fixes tag for this change?

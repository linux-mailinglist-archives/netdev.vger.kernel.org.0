Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAABF158242
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBJS14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgBJS14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 13:27:56 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922A22080C;
        Mon, 10 Feb 2020 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581359275;
        bh=MsiLjdHsCfAqkZL4yKnHmAvUXIHHS+bk97cPqovFsqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0BGAh7Aq3gk2jSg9U76x7nO1HJFImAgGGDm9prbl64XE/YcnzdRZChCjFXMbW4Ddh
         zJrMQ9ECDXcW3xfryLL8OkoqiN10mqszoKEZT+vRLFvMdgPLP/cJQQhrrDpE/t8QpU
         mXL9/5kSFdHrHmqqk+60Hs7Y7PQ2FpXF49iVcJ5g=
Date:   Mon, 10 Feb 2020 10:27:55 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Pietro Oliva <pietroliva@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4/6] staging: rtl8723bs: Fix potential overuse of kernel
 memory
Message-ID: <20200210182755.GA1048334@kroah.com>
References: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
 <20200210180235.21691-5-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210180235.21691-5-Larry.Finger@lwfinger.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 12:02:33PM -0600, Larry Finger wrote:
> In routine wpa_supplicant_ioctl(), the user-controlled p->length is
> checked to be at least the size of struct ieee_param size, but the code
> does not detect the case where p->length is greater than the size
> of the struct, thus a malicious user could be wasting kernel memory.
> Fixes commit 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver").
> 
> Reported by: Pietro Oliva <pietroliva@gmail.com>
> Cc: Pietro Oliva <pietroliva@gmail.com>
> Cc: Stable <stable@vger.kernel.org>
> Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver").
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> -# Please enter the commit message for your changes. Lines starting
> ---

Funny line :)

I'll go edit it...

thanks,

greg k-h

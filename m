Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFCF3D09CF
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 09:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbhGUG4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 02:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234361AbhGUGzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 02:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE907606A5;
        Wed, 21 Jul 2021 07:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626852968;
        bh=KlmLkL59OiWSTy83kBXJsEldlUQA0yf4WquevwiPQnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUKzA/Q+07YyD48Aekk1WulMlHGmOFP4xtq0/4OAkFmryLTnrmKDKz7k66khqk2rC
         oO95Y+4krxmBfFk/jBHP3WsxmqMysPAcwSI3TM69ti/e8ZyHigNdqQjsOCKyUK1ZKI
         dtMENVDxIMvVcTXElA4HdS9bAPgWxeMTDN8XYHCw=
Date:   Wed, 21 Jul 2021 09:36:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] usb: hso: fix error handling code of
 hso_create_net_device
Message-ID: <YPfOZp7YoagbE+Mh@kroah.com>
References: <20210714091327.677458-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714091327.677458-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 05:13:22PM +0800, Dongliang Mu wrote:
> The current error handling code of hso_create_net_device is
> hso_free_net_device, no matter which errors lead to. For example,
> WARNING in hso_free_net_device [1].
> 
> Fix this by refactoring the error handling code of
> hso_create_net_device by handling different errors by different code.
> 
> [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe
> 
> Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
> v1->v2: change labels according to the comment of Dan Carpenter
> v2->v3: change the style of error handling labels
>  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)

Please resend the whole series, not just one patch of the series.
Otherwise it makes it impossible to determine what patch from what
series should be applied in what order.

All of these are now dropped from my queue, please fix up and resend.

thanks,

greg k-h

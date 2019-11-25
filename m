Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095641093F1
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKYTHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:07:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfKYTHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:07:10 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15AF71500C696;
        Mon, 25 Nov 2019 11:07:09 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:07:08 -0800 (PST)
Message-Id: <20191125.110708.76766634808358006.davem@davemloft.net>
To:     tranmanphong@gmail.com
Cc:     gregkh@linuxfoundation.org, oneukum@suse.com,
        alexios.zavras@intel.com, johan@kernel.org, allison@lohutok.net,
        tglx@linutronix.de, benquike@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: net: usbnet: Fix -Wcast-function-type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125145443.29052-2-tranmanphong@gmail.com>
References: <20191125145443.29052-1-tranmanphong@gmail.com>
        <20191125145443.29052-2-tranmanphong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 11:07:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>
Date: Mon, 25 Nov 2019 21:54:43 +0700

> @@ -1573,6 +1573,12 @@ static void usbnet_bh (struct timer_list *t)
>  	}
>  }
>  
> +static void usbnet_bh_tasklet (unsigned long data)
                                ^

Please remove this space and resubmit the patch series.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4C2A40D9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgKCJzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgKCJzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 04:55:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 633F82080C;
        Tue,  3 Nov 2020 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604397325;
        bh=BbJsCjFJLevMdoJHB4Z5uCMfmHDAE0eiDRnVczaq5uA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iOY0t65/MB44fqw06fHYEWykwbF1NDvtdiVH98cdRRovtg2vk2XAvc7nAq4kWROse
         GguIzednQO73SSb3Fs6bQhNjjOp7gMvB83Pj5aizBulVH7XTgn/vxP7I3rhbieI01w
         ZpQag6zhK/im8RNgtZHYMrr9HpACM+COwaoxILGU=
Date:   Tue, 3 Nov 2020 10:55:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org
Subject: Re: [PATCH net-next v3 1/2] include/linux/usb: new header file for
 the vendor ID of USB devices
Message-ID: <20201103095521.GA81899@kroah.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
 <1394712342-15778-389-Taiwan-albertk@realtek.com>
 <1394712342-15778-390-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-390-Taiwan-albertk@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 05:46:37PM +0800, Hayes Wang wrote:
> diff --git a/include/linux/usb/usb_vendor_id.h b/include/linux/usb/usb_vendor_id.h
> new file mode 100644
> index 000000000000..23b6e6849515
> --- /dev/null
> +++ b/include/linux/usb/usb_vendor_id.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +

<snip>

No, this is not ok, sorry.  Please see the top of the pci_ids.h file why
we do not do this.

There is nothing wrong with putting the individual ids in the different
drivers, we don't want one single huge file that is a pain for merges
and builds.  We learn from our past mistakes, please do not fail to
learn from history :)

thanks,

greg k-h

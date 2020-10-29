Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C200F29F18B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgJ2Qb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:31:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55981 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726323AbgJ2QaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 12:30:15 -0400
Received: (qmail 1330944 invoked by uid 1000); 29 Oct 2020 12:30:14 -0400
Date:   Thu, 29 Oct 2020 12:30:14 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] net: usb: usbnet: update __usbnet_{read|write}_cmd()
 to use new API
Message-ID: <20201029163014.GC1324094@rowland.harvard.edu>
References: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
 <20201029132256.11793-1-anant.thazhemadam@gmail.com>
 <d8417f98-0896-25d0-e72d-dcf111011129@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8417f98-0896-25d0-e72d-dcf111011129@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 08:46:59PM +0530, Anant Thazhemadam wrote:
> I had a v2 prepared and ready but was told to wait for a week before sending it in,
> since usb_control_msg_{send|recv}() that were being used were not present in the
> networking tree at the time, and all the trees would be converged by then.
> So, just to be on the safer side, I waited for two weeks.
> I checked the net tree, and found the APIs there too (defined in usb.h).
> 
> However the build seems to fail here,
>     https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/O2BERGN7SYYC6LNOOKNUGPS2IJLDWYT7/
> 
> I'm not entirely sure at this point why this is happening, and would appreciate it if
> someone could take the time to tell me if and how this might be an issue with my
> patch.

It's happening because the tree you used for building did not include 
the declarations of usb_control_msg_{send|recv}().

It's hard to tell exactly what that tree does contain, because the 
github.com links embedded in the web page you mention above don't work.

Alan Stern

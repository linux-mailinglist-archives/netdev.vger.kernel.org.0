Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95233277618
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgIXQAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:32952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgIXQAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 12:00:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ADA3235FD;
        Thu, 24 Sep 2020 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600963251;
        bh=r67kiC0WjaNVmOhYLjf6JYjUJqRLU6Z2/EyBhfyzyvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AwScAfRx9Njhn+CsDf0vIPl1vMTCryCGmJiCCir1LBP2pGPpRObRPiwsIoyRYH6N/
         xUCfZrh4aCjPZwNIHlxf0aMfv2SW539VKPcmv4ErcMaOcXInPHNESLWt4RHU02/Yyp
         fForhBgGlJDyPOtPYa/UHZ89hPiCuqNi9WgX4ljA=
Date:   Thu, 24 Sep 2020 18:01:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Himadri Pandya <himadrispandya@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        keescook@chromium.org, yuehaibing@huawei.com, ogiannou@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and
 usb_control_msg_send()
Message-ID: <20200924160107.GA1174357@kroah.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-4-himadrispandya@gmail.com>
 <1600856557.26851.6.camel@suse.com>
 <20200923144832.GA11151@karbon>
 <2f997848ed05c1f060125f7567f6bc3fae7410bb.camel@suse.com>
 <20200924154026.GA9761@carbon.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924154026.GA9761@carbon.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 06:40:26PM +0300, Petko Manolov wrote:
> On 20-09-24 13:09:05, Oliver Neukum wrote:
> > Am Mittwoch, den 23.09.2020, 17:48 +0300 schrieb Petko Manolov:
> > 
> > > One possible fix is to add yet another argument to usb_control_msg_recv(), 
> > > which would be the GFP_XYZ flag to pass on to kmemdup().  Up to Greg, of 
> > > course.
> > 
> > submitted. The problem is those usages that are very hard to trace. I'd 
> > dislike to just slab GFP_NOIO on them for no obvious reason.
> 
> Do you mean you submitted a patch for usb_control_msg_recv() (because i don't 
> see it on linux-netdev) or i'm reading this all wrong?

It's on the linux-usb list:
	https://lore.kernel.org/r/20200923134348.23862-1-oneukum@suse.com

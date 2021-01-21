Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96F2FE8A7
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbhAULXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbhAULWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 06:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 799F6238D7;
        Thu, 21 Jan 2021 11:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611228087;
        bh=p/F2cRf0JaXDMfcU39v/0M/n67VUPSyvsSPiFPPDGZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SFNEvmlLdERsubFDap97OvzqtzuAqvYcNmxYf+ejBCBz5MT8FT8HlXAaZh7bvyQ8P
         XnhG3BGAENw4E7/3Q1lfW775thc3Ek7LBmnrjIs1S/FZFxF5ks3OsbUuU3IvPTuheg
         GXHgvIuMEbI1CJMTs2z6B8+ioEB68Z6intIIQt0M=
Date:   Thu, 21 Jan 2021 12:21:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sgruszka@redhat.com
Subject: Re: [PATCH] rt2x00: reset reg earlier in rt2500usb_register_read
Message-ID: <YAljtMMV4oh5uAHC@kroah.com>
References: <20210121092026.3261412-1-mudongliangabcd@gmail.com>
 <YAlORNKQ4y7bzYeZ@kroah.com>
 <CAD-N9QXhD48-6GbpCUYuxPKEbkzGgGTaFKQ8TAaQ93WfD_sT2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-N9QXhD48-6GbpCUYuxPKEbkzGgGTaFKQ8TAaQ93WfD_sT2A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 06:59:08PM +0800, 慕冬亮 wrote:
> > >       rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
> > >                                     USB_VENDOR_REQUEST_IN, offset,
> > >                                     &reg, sizeof(reg));
> >
> > Are you sure this is valid to call this function with a variable on the
> > stack like this?  How did you test this change?
> 
> First, I did not do any changes to this call. Second, the programming
> style to pass the pointer of stack variable as arguments is not really
> good. Third, I check this same code file, there are many code snippets
> with such programming style. :(

I know you did not change it, what I am asking is how did you test this
change works?  I think the kernel will warn you in huge ways that using
this pointer on the stack is incorrect, which implies you did not test
this change :(

thanks,

greg k-h

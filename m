Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF832D17BF
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgLGRpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 12:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgLGRph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 12:45:37 -0500
Date:   Mon, 7 Dec 2020 18:46:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607363097;
        bh=e5lTukEfapziGOs1R9STsIF1JF8jqo6S/StsMlXhl30=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=QDdkGWHI28F1VPUUxCUSs6fIoxkOcSPhJo+UyuB3szLft7Tc3v5AkdJQjkbPopapJ
         mdun9/etQU9dnBEB5Fq+yqjeDUmSXjxPmKDwnu2sCC2fiDCvNoOsooJi6o2ddYNAAG
         3KvvCBs4P1LaViuZFjFSk1kkxxujqRWHTQyH/RvI=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
Message-ID: <X85qX19mo5XesW8b@kroah.com>
References: <20201204180622.14285-1-abuehaze@amazon.com>
 <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com>
 <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com>
 <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
 <05E336BF-BAF7-432D-85B5-4B06CD02D34C@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05E336BF-BAF7-432D-85B5-4B06CD02D34C@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 04:34:57PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> 100ms RTT
> 
> >Which exact version of linux kernel are you using ?
> On the receiver side I could see the issue with any mainline kernel
> version >=4.19.86 which is the first kernel version that has patches
> [1] & [2] included.  On the sender I am using kernel 5.4.0-rc6.

5.4.0-rc6 is a very old and odd kernel to be doing anything with.  Are
you sure you don't mean "5.10-rc6" here?

thanks,

greg k-h

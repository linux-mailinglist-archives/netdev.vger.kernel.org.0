Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CD139B636
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 11:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhFDJuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 05:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhFDJuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 05:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE6326023E;
        Fri,  4 Jun 2021 09:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622800101;
        bh=K/Vyl1hSa3J6uLFGe/60MlgbY2CmEQ5E1ho03Zn5iZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UP7J6m5qQDDBxUTV35zuTvUbNtiT02kANk8rWwRVpBO4Os5PQw7I1j7sXrK5a9B5M
         B3sL3x74ADZwlASjKwXBfzV801R3p3VNDCZjWMR6vbSUN4gmkO6Irx9hFWN7sUsk8O
         MCACtfSU+mIllQGxbP+8OZ5tVSVIpJpUBz7scXLc=
Date:   Fri, 4 Jun 2021 11:48:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ETenal <etenalcxz@gmail.com>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YLn24sFxJqGDNBii@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 02:50:03PM -0700, ETenal wrote:
> Hi,
> 
> This is SyzScope, a research project that aims to reveal high-risk
> primitives from a seemingly low-risk bug (UAF/OOB read, WARNING, BUG, etc.).

Who is working on and doing this "reseach project"?  And what is it
doing to actually fix the issues that syzbot finds?  Seems like that
would be a better solution instead of just trying to send emails saying,
in short "why isn't this reported issue fixed yet?"

thanks,

greg k-h

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716E63B0172
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhFVKhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFVKhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E29613B2;
        Tue, 22 Jun 2021 10:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624358104;
        bh=rC7iTfuqfxithGj800MLAMvYI4hAndnqKWFCUOS2D/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1xgQaFeTI4mSR5hgjPV706ED0MvvrSUmKaqqyZ7ofQcBTzfd1kxYP/UuTVigCPWQr
         P8ESpIKK62hQgfxWJ2GJ0H04N76rvKvnA4S5K06eHg+m2X8Bt6wAMP+cOQQe24UV0j
         S72313dyhfd4eJ5XMvRHx7JuMeaN3lqQf0fM+5qc=
Date:   Tue, 22 Jun 2021 12:35:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        edumazet@google.com, w@1wt.eu, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4.9] inet: use bigger hash table for IP ID generation
 (backported to 4.9 and 4.4)
Message-ID: <YNG81UEPz3/ajF45@kroah.com>
References: <60d1a5e9.1c69fb81.7f729.b892@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d1a5e9.1c69fb81.7f729.b892@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 01:57:13AM -0700, Amit Klein wrote:
> Subject: inet: use bigger hash table for IP ID generation (backported to 4.9 and 4.4)
> From: Amit Klein <aksecurity@gmail.com>
> 
> [ Upstream commit aa6dd211e4b1dde9d5dc25d699d35f789ae7eeba ]
>  
> This is a backport to 4.9 and 4.4 of the following patch, originally
> developed by Eric Dumazet.

That worked, now queued up, thanks!

greg k-h

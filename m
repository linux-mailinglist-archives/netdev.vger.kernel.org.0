Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7998688A93
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfHJKRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfHJKRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:17:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA2C20B7C;
        Sat, 10 Aug 2019 10:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565432249;
        bh=30gmXfhsXc6+py+zGDRZ7xjU6HftNKBVyFtIorMwFtk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XP+GAleouxftlk7QIsM14PqZG+kwZKhGypYM3oJHFBFpTjvK7dc4JTJWIK/Yerk1r
         +y6kVsHcG0kMylQPmg8ypQyigzo7Se4ozUYOyrySv+i54c9DImv4PolXQ4qJzNEbWr
         tFI7vY4lNZ7sCkuiv87XqEw0hTPG5edt/EL6jAnc=
Date:   Sat, 10 Aug 2019 12:17:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 00/17] Networking driver debugfs cleanups
Message-ID: <20190810101727.GA26438@kroah.com>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
 <20190809.112054.1126098316584513793.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809.112054.1126098316584513793.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 11:20:54AM -0700, David Miller wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Fri,  9 Aug 2019 14:30:51 +0200
> 
> > v2: fix up build warnings, it's as if I never even built these.  Ugh, so
> >     sorry for wasting people's time with the v1 series.  I need to stop
> >     relying on 0-day as it isn't working well anymore :(
> 
> One more try Greg:
> 
> drivers/net/wimax/i2400m/debugfs.c: In function ‘i2400m_debugfs_add’:
> drivers/net/wimax/i2400m/debugfs.c:192:17: warning: unused variable ‘dev’ [-Wunused-variable]
>   struct device *dev = i2400m_dev(i2400m);
>                  ^~~

It's as if I don't even know how to use a compiler anymore.  Ugh :(

v3 coming soon, sorry for the noise.

greg k-h

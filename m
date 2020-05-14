Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293D71D2CB9
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgENK2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbgENK1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:27:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21BAC20727;
        Thu, 14 May 2020 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589452075;
        bh=UVkexWXSk7D55Q+F3hBDCNoDXQXYDBpoqQ+P+4xna0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lh6kiO+mhflzQlaTQo3EmyOzwhQFe/513hif+1Oeb7GCApSDtWYYYS/inkXNQHxG1
         igyKuhbPMFp2s3HkEYitF7o1JT7/S6Zbl1LExgQ0ZOt5pd7yraCXpKqKJjyC9UMHCd
         0Ta6dzHMGtJePRTb5YsB40mhRz51f8bhYFE/u5Hk=
Date:   Thu, 14 May 2020 11:46:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        stable@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-5.4.y] net: dsa: Do not make user port errors fatal
Message-ID: <20200514094645.GA1700086@kroah.com>
References: <20200513174145.10048-1-f.fainelli@gmail.com>
 <20200513.125546.1487344805837197413.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513.125546.1487344805837197413.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:55:46PM -0700, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Wed, 13 May 2020 10:41:45 -0700
> 
> > commit 86f8b1c01a0a537a73d2996615133be63cdf75db upstream
> > 
> > Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
> > not treat failures to set-up an user port as fatal, but after this
> > commit we would, which is a regression for some systems where interfaces
> > may be declared in the Device Tree, but the underlying hardware may not
> > be present (pluggable daughter cards for instance).
> > 
> > Fixes: 1d27732f411d ("net: dsa: setup and teardown ports")
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Greg, please queue this up.

Now queued up, thanks.

greg k-h

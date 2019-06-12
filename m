Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41B141D33
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 09:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407944AbfFLHHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 03:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407185AbfFLHHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 03:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD5B205ED;
        Wed, 12 Jun 2019 07:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560323224;
        bh=GtigtzkEAHr+VEjATWqUUDT5Nt8U4B4G0dSmvG/CfD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9ZY+szQVuDeeYvSNyGaG6WXfZrwHvAkiNTdcNhJCvGNtkQZy7XsIlOzYpumLZxBa
         SmhNYffk8n3TlA8fYmSael5PHZyDaHygbZTycIRZRD9z+cpBHZFwYSO0zFJBKRMzow
         s1Gf4jbf7iY1fEGuyBkzQJrYjZ3h9uBRk2fZqx98=
Date:   Wed, 12 Jun 2019 09:07:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "Bluetooth: Align minimum encryption key size for
 LE and BR/EDR connections"
Message-ID: <20190612070701.GA13320@kroah.com>
References: <20190522052002.10411-1-anarsoul@gmail.com>
 <6BD1D3F7-E2F2-4B2D-9479-06E27049133C@holtmann.org>
 <7B7F362B-6C8B-4112-8772-FB6BC708ABF5@holtmann.org>
 <CA+E=qVfopSA90vG2Kkh+XzdYdNn=M-hJN_AptW=R+B5v3HB9eA@mail.gmail.com>
 <CA+E=qVdLOS9smt-nBxg9Lon0iTZr87kONSp-XPKj9tqB4bvnqw@mail.gmail.com>
 <723142BB-8217-4A01-A2B9-F527174FDC0F@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <723142BB-8217-4A01-A2B9-F527174FDC0F@holtmann.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 11:36:26PM +0200, Marcel Holtmann wrote:
> Hi Vasily,
> 
> > Can we get this revert merged into stable branches? Bluetooth HID has
> > been broken for many devices for quite a while now and RFC patch that
> > fixes the breakage hasn't seen any movement for almost a month.
> 
> lets send the RFC patch upstream since it got enough feedback that it fixes the issue.

According to Hans, the workaround did not work.

So can we just get this reverted so that people's machines go back to
working?

thanks,

greg k-h

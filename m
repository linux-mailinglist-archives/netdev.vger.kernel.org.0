Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5CC44452
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392109AbfFMQgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730693AbfFMHfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 03:35:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8159A20866;
        Thu, 13 Jun 2019 07:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560411350;
        bh=DNOPj2Yx04AnRxwW50GJD0lO1OKzC99KUz7kFws8Elg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=izsisZBJPQF0Ow37TFLvzUCps7FILRUBfislpzeHKcSh2hhVOGFiqSMjp4FBk+vju
         ldUg+bfSXVeMCRV+C0mBPVak5LTc6kSpsbIVMMXhB/LtDkC80UWFzRKENhUYz2z8P5
         f3u1IYdHXRXgpAjHbJn5NbkMKKKaHgjTpS2YpktM=
Date:   Thu, 13 Jun 2019 09:35:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "Bluetooth: Align minimum encryption key size for
 LE and BR/EDR connections"
Message-ID: <20190613073547.GB16436@kroah.com>
References: <20190522052002.10411-1-anarsoul@gmail.com>
 <6BD1D3F7-E2F2-4B2D-9479-06E27049133C@holtmann.org>
 <7B7F362B-6C8B-4112-8772-FB6BC708ABF5@holtmann.org>
 <CA+E=qVfopSA90vG2Kkh+XzdYdNn=M-hJN_AptW=R+B5v3HB9eA@mail.gmail.com>
 <CA+E=qVdLOS9smt-nBxg9Lon0iTZr87kONSp-XPKj9tqB4bvnqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+E=qVdLOS9smt-nBxg9Lon0iTZr87kONSp-XPKj9tqB4bvnqw@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 12:56:02PM -0700, Vasily Khoruzhick wrote:
> Greg,
> 
> Can we get this revert merged into stable branches? Bluetooth HID has
> been broken for many devices for quite a while now and RFC patch that
> fixes the breakage hasn't seen any movement for almost a month.

Now reverted as the bluetooth developers seem to be moving pretty slowly
on this :(

greg k-h

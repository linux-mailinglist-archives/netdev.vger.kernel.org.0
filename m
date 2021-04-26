Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2736AF5E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhDZH6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 03:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhDZH5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 03:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12662610A5;
        Mon, 26 Apr 2021 07:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619423810;
        bh=3LiMZGFepKvIzm/bqmRdPYR/t6k1/dDpozeArIOdCy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DoHR3O0Ib5grHn/719SjjpBBYdre7C8I9Na9pz6QbPhqgA98UBUQTWh/FvpiQWYug
         POo088jDvOgNWke+qafHc2FQsUv19SI5n37cVFj6OAgHTu7Md6dCQJIUKRUwI+K1cz
         Zvz9XXeyhBatMIHrDbkewLTR7ityNrw9O8XqcsfA=
Date:   Mon, 26 Apr 2021 09:32:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leonardo Antoniazzi <leoanto@aruba.it>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: hso driver kernel NULL pointer dereference
Message-ID: <YIZsnF7FqeQ+eDM0@kroah.com>
References: <20210425233509.9ce29da49037e1a421000bdd@aruba.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210425233509.9ce29da49037e1a421000bdd@aruba.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 11:35:09PM +0200, Leonardo Antoniazzi wrote:
> Hello,
> removing my usb-modem (option icon 226) i get this oops (i attached the dmesg output):
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000068
> 
> reverting this patch fix the problem on detaching the modem:
> 
> https://marc.info/?l=linux-usb&m=161781851805582&w=2
> 
> I'm not a developer, i hope the attached dmesg.txt will suffice

Ick, that's not good.

Anirudh, can you please look into this as it's caused by 8a12f8836145
("net: hso: fix null-ptr-deref during tty device unregistration") which
is merged into 5.12.

thanks,

greg k-h

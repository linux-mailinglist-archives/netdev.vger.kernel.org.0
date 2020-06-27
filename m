Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E710120C0D2
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgF0KrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgF0KrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 06:47:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57ED72137B;
        Sat, 27 Jun 2020 10:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593254834;
        bh=1rtJRr7/QYwETTIOCkQD0l88nYTT+cOmhg0Mk0eX6H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2QRv8i/V33OsxjU3E95V55C8EMqt2ybW3VAmht3U1L3gea3ifWphFa5anMmxMThub
         MAlHp77JCH7H5bRK6jYL8dpJJqiFmwIK4T1ps3KATrOQnbm2R+Jbb7wTVHicSGf+yK
         YI52utrFOedkzlCLwR10mq3YIJpxRjG05CSfJkog=
Date:   Sat, 27 Jun 2020 12:47:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        joe@perches.com, dan.carpenter@oracle.com
Subject: Re: [PATCH 1/4] fix trailing */ in block comment
Message-ID: <20200627104708.GA1581263@kroah.com>
References: <20200627101447.167370-1-coiby.xu@gmail.com>
 <20200627101447.167370-2-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627101447.167370-2-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 06:14:44PM +0800, Coiby Xu wrote:
> Remove trailing "*/" in block comments.
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>

The subject lines of all of your patches should match other patches for
this driver.  It should look like "staging: qlge: ..."

Please fix up and resend a v2 of this series.

thanks,

greg k-h

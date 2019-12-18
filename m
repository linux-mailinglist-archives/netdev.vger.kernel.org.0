Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEA4124A98
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfLRPE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbfLRPE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 10:04:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79E8820684;
        Wed, 18 Dec 2019 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576681496;
        bh=/Xwy0EYDAWm9IUmqarXi6RASHE7DRX2pjkg+940R3xc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TjnG36vCL53/t2504//iSgiNAM2/Nb8XGdqdkMkqNuLbwx0OAbgmdvZwdVXhj5B0y
         vNhc3zZjTbwHJZFlgrL4vdbLoSBKNy2CmrhB/0ecaApmQg2RnmRwWyYPEubtpUK3y8
         7JDRqjgC1xASB3MQ27ehzPSYiHnGPa+1EJU+BN0k=
Date:   Wed, 18 Dec 2019 16:03:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 00/55] Improve wfx driver
Message-ID: <20191218150346.GA431628@kroah.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 04:14:26PM +0000, Jérôme Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Hello all,
> 
> This pull request continue to clean up the wfx driver. It can be more or
> less divided in four parts:
>   - 0001 to 0009 fix some issues (should be included in 5.5?)
>   - 0010 to 0028 mostly contains cosmetics changes

I took the first 10 to staging-linus to get into 5.5-final.

>   - 0029 to 0043 re-work power save (in station mode) and QoS
>   - 0044 to 0054 re-work the scan process

all the rest of these I've queued up "normally" in staging-next.

And thanks for fixing up the mime issue, these applied with no problems
at all.

greg k-h

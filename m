Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A571E3BD7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgE0IWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgE0IWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 04:22:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 382D42078B;
        Wed, 27 May 2020 08:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590567755;
        bh=eXHQT/1Txk/LjuPuO/dUddJu7s+CPQcxAaC1arWn6HM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mvoZB9D4XfmNA8tN76taVyyTgErc2IyXhCR9MqyFHHrMMj3LYI6tpdzFYb/3+W3rk
         WpEc0HgBsz7HSzWGA//iHsFXf0uvxK3K9KZmG6gVg0Db9fdo+1DqzfsCJx3RDse3tW
         JKTzJW2K0P4ZPz1B2Iqz2ZClO7/7s5Q5EEkhIEiM=
Date:   Wed, 27 May 2020 10:22:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 00/10] staging: wfx: introduce nl80211 vendor extensions
Message-ID: <20200527082233.GA148298@kroah.com>
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 07:18:11PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Hello,
> 
> This series introduces some nl80211 vendor extensions to the wfx driver.
> 
> This series may lead to some discussions:

I've applied the first 6 patches here, until you get some answers from
the wifi developers about what to do with the rest.  Once you do, please
fix up / change them to meet their requirements, and then resend.

thanks,

greg k-h

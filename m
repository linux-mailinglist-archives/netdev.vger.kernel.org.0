Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF6F31C87C
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhBPKCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhBPKCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 05:02:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F04664DA1;
        Tue, 16 Feb 2021 10:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613469722;
        bh=QhTo5jdF8bFE9bfH83cy/ZMztDmZIcQflTrAZAn0SaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=srjJXlO6x9eRHLu0+cvLO+tBJjLbsHCJ1+wZQQvoCKSYeY8fHFOoj95WsSeRtisEl
         JULeTXoCMPZnDk6CK0TVzWIIHWaXiTo3xZXlHVOxWPFJVvaNO7WPm+ILvaQz5Wal6D
         g9rnA37kFWqVd2bkfe5JCR0ozKcT7zc9cw9diK00=
Date:   Tue, 16 Feb 2021 11:01:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] staging: qlge: fix comment style in qlge_main.c
Message-ID: <YCuYFz1vpgTEsjb/@kroah.com>
References: <20210216094012.183420-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216094012.183420-1-ducheng2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 05:40:12PM +0800, Du Cheng wrote:
> align * in block comments on each line

That says _what_ you did, not _why_ you did it.

And "each line"?  You only did this once.

> This series of patches is for Task 10 of the Eudyptula Challenge

This isn't a "series" of patches, it is a single patch.  And no one
cares about why you are doing this, this text isn't needed at all.

thanks,

greg k-h

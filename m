Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26830B7BE7
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbfISONv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732259AbfISONv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 10:13:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C49DF205F4;
        Thu, 19 Sep 2019 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568902430;
        bh=BdD80pmj8OEiXdds3pAcVPXZA1SBMt0ccW7USJtJk/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YLBbFv3hQPAC0oolCWy6NtzkSlSli7U0fJJIE2+9HhstuNZXa543Q406hpVAqOriz
         uMZ/TrHQeg22k82SUMYpPdEJo6FpsJS4kPskCeGMqa+HnZBFgJEMcHD8a4JRC9RjGo
         sXZwTCaNd7mIVfQlK0RSVusjNRVWY1tAdS0AATZY=
Date:   Thu, 19 Sep 2019 16:13:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: ELOed stable kernels
Message-ID: <20190919141347.GA3869723@kroah.com>
References: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 05:05:45PM +0300, Or Gerlitz wrote:
> Hi Greg,
> 
> If this is RTFM could you please point me to the Emm

https://www.kernel.org/category/releases.html

> AFAIR if a stable kernel is not listed at kernel.org than it is EOL by now.
> 
> Is this correct?

Yes.

thanks,

greg k-h

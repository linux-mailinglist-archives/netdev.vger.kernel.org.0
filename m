Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB87B7D1E
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389244AbfISOo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389098AbfISOo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 10:44:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 894F92067B;
        Thu, 19 Sep 2019 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568904269;
        bh=rdmSdQbLGLlnIz6yPLGof23szDKiKIBOyidKQ5o2vuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTTKrDddqFCfcoG473yDlPOC5+yT1djzmxYeYF/n583ssPs5zX5/xM3Hgf/GI7bZs
         FqOdnNNZe9tSc/oA1rZLSqTQloI+EpKtzvWvh/AS61pKMk5e4NjHPwVlkdSgB42HON
         KQbIRyhnwPsCf3hXsOHidU/AGhSbIXXv+KQSOE/o=
Date:   Thu, 19 Sep 2019 16:44:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias May <matthias.may@neratec.com>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: ELOed stable kernels
Message-ID: <20190919144426.GA3998200@kroah.com>
References: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
 <e8cf18ee-d238-8d6f-e25f-9f59b28569d2@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8cf18ee-d238-8d6f-e25f-9f59b28569d2@neratec.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 04:39:28PM +0200, Matthias May wrote:
> On 19/09/2019 16:05, Or Gerlitz wrote:
> > Hi Greg,
> > 
> > If this is RTFM could you please point me to the Emm
> > 
> > AFAIR if a stable kernel is not listed at kernel.org than it is EOL by now.
> > 
> > Is this correct?
> > 
> > thanks,
> > 
> > Or.
> > 
> 
> You can also look at the wikipedia page at
> https://en.wikipedia.org/wiki/Linux_kernel#Maintenance_and_long-term_support
> 
> I do the updates of the entries for each release once the release-announcement has been sent to the list.
> At least since I'm doing this (last ~5 years), the last release-announcement of a branch always contains a notice that
> this release is now EOL.
> I reference all these messages for each version.

Very nice, I never noticed that!

Also, you might want to use lore.kernel.org for the email archives,
don't know who runs those other sites you link to :)

thanks,

greg k-h

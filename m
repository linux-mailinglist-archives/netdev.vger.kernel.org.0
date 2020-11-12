Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095212B0318
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgKLKte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgKLKt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 05:49:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6481022203;
        Thu, 12 Nov 2020 10:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605178166;
        bh=ZDfCrvQ1jvggR0eQoP7Ar1+wJlpa2Z0nYaQ/4rIGgFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CuVYKylMiHtdgRHRIJ1E6pJ2hZG5olx2CRDLkM4l0H7ZOSuDfphjNW7pmx8/4ieKl
         utxIoq8sB4/QLW5zJAaqk9ag512v/A2drlthYfu5CznUzfrlwivihtZxAniFyOugBQ
         TA3uL4DBdcLqrcDFP78InWQAqleoxU1DUr/qpJfg=
Date:   Thu, 12 Nov 2020 11:50:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 04/30] net: wimax: i2400m: control: Fix some misspellings
 in i2400m_set_init_config()'s docs
Message-ID: <X60TcGK/oiA+QMHu@kroah.com>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
 <20201102114512.1062724-5-lee.jones@linaro.org>
 <20201112100445.GA1997862@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112100445.GA1997862@dell>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 10:04:45AM +0000, Lee Jones wrote:
> On Mon, 02 Nov 2020, Lee Jones wrote:
> 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/wimax/i2400m/control.c:1195: warning: Function parameter or member 'arg' not described in 'i2400m_set_init_config'
> >  drivers/net/wimax/i2400m/control.c:1195: warning: Excess function parameter 'arg_size' description in 'i2400m_set_init_config'
> > 
> > Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
> > Cc: linux-wimax@intel.com
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/staging/wimax/i2400m/control.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Any news on these i2400 patches?
> 
> Looks like the driver has been moved to Staging since submission.
> 
> Greg, shall I re-submit?

Please do as I don't have any pending from you at all.  And put
"staging:" as a prefix please.

thanks,

greg k-h

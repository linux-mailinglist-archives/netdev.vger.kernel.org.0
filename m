Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54A1C96A5
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEGQff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgEGQff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 12:35:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CABF920643;
        Thu,  7 May 2020 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588869333;
        bh=ftKzAclNdYnJO3VmiOnD3bLpHCmg3zx3FPWNVr0ERmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tt6zOSxYYKCZ/US+zVoiEaqNdp/S3UTLc98sD0nHpRaBJofsji6j53gKSe2dESW5i
         ZrCnVgK5F0b9Ph/G43yRhjaItFJ1JQwBhILRPq8qeyV0i148yjbLxxAZN1N6cnsE0a
         SQ51AYYU3a9KVodtpfDtjoifyEZeKghQHWP2k/Tg=
Date:   Thu, 7 May 2020 18:35:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        Martin Habets <mhabets@solarflare.com>
Subject: Re: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
Message-ID: <20200507163531.GA2100062@kroah.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
 <20200506210505.507254-3-jeffrey.t.kirsher@intel.com>
 <20200507081737.GC1024567@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7DCD6B850@fmsmsx124.amr.corp.intel.com>
 <20200507150658.GA1886648@kroah.com>
 <ef4bb479-1669-7611-81c8-cd21497d9103@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef4bb479-1669-7611-81c8-cd21497d9103@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 04:24:32PM +0100, Edward Cree wrote:
> On 07/05/2020 16:06, Greg KH wrote:
> > I can't accept that this series is using a virtual bus properly without
> > actually using the virtual bus driver code, can you?
> I might be misunderstanding, but I *think* a hardware driver likeice is
>  the 'provider' of a virtbus, and it's only 'consumers' of it (like an
>  RDMA device talking to that ice instance) that are virtbus_drivers.
> Though tbh I'm not entirely happy either with a series that adds the
>  provider side but not any users... and either way, the documentation
>  *really* doesn't make it clear whether it works the way I think it does
>  or not.

Exactly, I can't tell anything from the documentation at all, so I
looked at how the code was used.  That just made things worse...

This needs more work.

greg k-h

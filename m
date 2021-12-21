Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA647C229
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbhLUPCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:02:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40964 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbhLUPCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:02:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D60DDB8168A;
        Tue, 21 Dec 2021 15:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231C4C36AEA;
        Tue, 21 Dec 2021 15:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640098968;
        bh=1t9qj7e3Z95P0zEiXesN2Vc0H7GLvLh5b4UtFAPW0n4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fDAo3jyDmER1ygquBEqbhCacRdr2IvNgM10of2izQhWVJ92P91C1K60Ww9VdK14Kv
         Ri8retngaNKxJ5iaZDSBLUZiHb/Bf9YKg/VcqeTz2V6/pP2YKzoB+O/lSOWAA0WUka
         LwLFSG5e1j5KC0Sp4WNHkaELl+y8d1TTmBPiIPzw=
Date:   Tue, 21 Dec 2021 15:31:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Message-ID: <YcHlQH0gXTHh4cjV@kroah.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <YcF9rRTVzrbCyOtq@kroah.com>
 <CO1PR11MB51700037C8A23B19C0DCF5CAD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB51700037C8A23B19C0DCF5CAD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 02:03:38PM +0000, Chen, Mike Ximing wrote:
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Tuesday, December 21, 2021 2:10 AM
> > To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; Williams, Dan J <dan.j.williams@intel.com>; pierre-
> > louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> > Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
> > 
> > On Tue, Dec 21, 2021 at 12:50:30AM -0600, Mike Ximing Chen wrote:
> > > v12:
> > 
> > <snip>
> > 
> > How is a "RFC" series on version 12?  "RFC" means "I do not think this should be merged, please give me
> > some comments on how this is all structured" which I think is not the case here.
> 
> Hi Greg,
> 
> "RFC" here means exactly what you referred to. As you know we have made many changes since your
> last review of the patch set (which was v10).  At this point we are not sure if we are on the right track in
> terms of some configfs implementation, and would like some comments from the community. I stated
> this in the cover letter before the change log: " This submission is still a work in progress.... , a couple of
> issues that we would like to get help and suggestions from reviewers and community". I presented two
> issues/questions we are facing, and would like to get comments. 
> 
> The code on the other hand are tested and validated on our hardware platforms. I kept the version number
> in series (using v12, instead v1) so that reviewers can track the old submissions and have a better
> understanding of the patch set's history.

"RFC" means "I have no idea if this is correct, I am throwing it out
there and anyone who also cares about this type of thing, please
comment".

A patch that is on "RFC 12" means, "We all have no clue how to do this,
we give up and hope you all will do it for us."

I almost never comment on RFC patch series, except for portions of the
kernel that I really care about.  For a brand-new subsystem like this,
that I still do not understand who needs it, that is not the case.

I'm going to stop reviewing this patch series until you at least follow
the Intel required rules for sending kernel patches like this out.  To
not do so would be unfair to your coworkers who _DO_ follow the rules.

> > > - The following coding style changes suggested by Dan will be implemented
> > >   in the next revision
> > > -- Replace DLB_CSR_RD() and DLB_CSR_WR() with direct ioread32() and
> > >    iowrite32() call.
> > > -- Remove bitmap wrappers and use linux bitmap functions directly.
> > > -- Use trace_event in configfs attribute file update.
> > 
> > Why submit a patch series that you know will be changed?  Just do the work, don't ask anyone to review
> > stuff you know is incorrect, that just wastes our time and ensures that we never want to review it again.
> >
> Since this is a RFC, and is not for merging or a full review, we though it was OK to log the pending coding
> style changes. The patch set was submitted and reviewed by the community before, and there was no
> complains on using macros like DLB_CSR_RD(), etc, but we think we can replace them for better
> readability of the code.

Coding style changes should NEVER be ignored and put off for later.
To do so means you do not care about the brains of anyone who you are
wanting to read this code.  We have a coding style because of brains and
pattern matching, not because we are being mean.

good luck,

greg k-h

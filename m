Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7936B17245F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgB0RBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:01:53 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38073 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbgB0RBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:01:53 -0500
Received: by mail-pj1-f66.google.com with SMTP id j17so40444pjz.3
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 09:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dBI6+TsbTlRVUAaplE4C4o69J3JoBZpdX04crWTpwgU=;
        b=rs3IzH+DHybDu+FpNiw3h8Z22J6sac4aLhLp0nNpodeNYiQ+7Za35irSTQ8BPrq2Vf
         7lJAR2kIAmSXPQMDkSuhRuuugy4FUG3wpuNv8S8eLYLkh/wg04YHBrQHjFNlUvE/IHA+
         8OVhtpMYrmjO0Eq6ZZ33zWxnDwSfK3XUuYAuUxbOA/BAtWLn5SBu5TCj2LyJj5nSjGLl
         18QCvmm9HO1CfPbQmNFskUKcqYxjZNfXVaAfrhNeIqQ9erU1ogQkfds+oS3ODkKAQH2A
         /5hYVzqC5Xs4EiUGUjpyVRmR0SWFHQvqfc+q26kn9xRNBxyBxXSon8wcI6OWiyiGg5Vu
         cYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dBI6+TsbTlRVUAaplE4C4o69J3JoBZpdX04crWTpwgU=;
        b=rpIfDf+0vZ1TIEfpwo8kDkhjWEt4EPuYWBi38zaVd/V46CNqgU8uNaOhFc+dzpWLe9
         g9cvUSeCoyexr9BimYn97569eZXblJI1won0OxkJN1mbQUGIrL5pOZ+WEsE9xO9nim6h
         hYpJG0JkXNDH9QGfp5CVWmgF0t+T9C35lckRI1RkCWFSz+0c4wdYkU/xY8RBg7l2sPu7
         gbjxe+uBsb7LEkOCPU+hxI/nJwvz2JFFbS4HWdHM21olHoN/FJRVEu5OsQ2mMt72YGjr
         tNBhWfcGEC+Rto0ftyXjFmQQs5REMOd3j62wGeV3wq2RJc8gb4uvYbM0rNvxVIamDIol
         Cppg==
X-Gm-Message-State: APjAAAXJDDjSi+Lr5WG4ciPKIGGzd0b28r6RG2Vx/M4QCsKnqxGZ2v/e
        75lDfUddAJHVkBu3CZqYMmu/xsfT
X-Google-Smtp-Source: APXvYqwHvXTBvDczEtoUrWgac1XMCN48hjyc8ymwzvbzNl2AtaAscqvvWBIl9RTR/23YddkREeeiLg==
X-Received: by 2002:a17:90a:8d81:: with SMTP id d1mr670464pjo.63.1582822911995;
        Thu, 27 Feb 2020 09:01:51 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z4sm7195851pfn.42.2020.02.27.09.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 09:01:51 -0800 (PST)
Date:   Thu, 27 Feb 2020 09:01:48 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vivek Thampi <vithampi@vmware.com>
Cc:     Pv-drivers <Pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] ptp: add VMware virtual PTP clock driver
Message-ID: <20200227170148.GA1742@localhost>
References: <20200227135824.GA389099@sc2-cpbu2-b0737.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227135824.GA389099@sc2-cpbu2-b0737.eng.vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 01:58:39PM +0000, Vivek Thampi wrote:
> Add a PTP clock driver called ptp_vmw, for guests running on VMware ESXi
> hypervisor. The driver attaches to a VMware virtual device called
> "precision clock" that provides a mechanism for querying host system time.
> Similar to existing virtual PTP clock drivers (e.g. ptp_kvm), ptp_vmw
> utilizes the kernel's PTP hardware clock API to implement a clock device
> that can be used as a reference in Chrony for synchronizing guest time with
> host.
> 
> The driver is only applicable to x86 guests running in VMware virtual
> machines with precision clock virtual device present. It uses a VMware
> specific hypercall mechanism to read time from the device.

Please post this driver to the lkml for wider reivew.  Also, be sure
to include the relevant VM/x86 maintainers on CC.

Thanks,
Richard

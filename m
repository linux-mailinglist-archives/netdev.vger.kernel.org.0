Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFF41059CB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKUSnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:43:37 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37285 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUSnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:43:37 -0500
Received: by mail-lf1-f65.google.com with SMTP id b20so3467217lfp.4
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 10:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JLwvQUtBMXA0cs1/nlsAZGUYppiHlifF/b1qEVrABAI=;
        b=a9Ca5oCmwpSHBLc9KvEe17M7Ks+y4NSeYegERYzeyDWhhmD/j34c5zUDFBZsJhjAgi
         d/SFoIbaOXwF4vxUxtQon7o1zRJWsBXVQpACb+er5zjOnhz8p7zdkcJ5CUxM7KZuWufu
         cVumb6C43G9ubg+hVR1UyFPPdiA9uHrH6d+us2q4h0Czv7YIvZ3R418Mn6LbW+RA3ELg
         8EgObKtT8ha1CBYsfJWtQ6Vj021oDCZowdndxM3WPLvEJSXak8jr4PcCsOxLeTZsjIY2
         YzoAK+BbeM6QBQxYuXfeoL8MqW5/hd2C6Y77nTy8p8cNgv4RbMFZW+JhnAehG+3/1NxY
         Tkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JLwvQUtBMXA0cs1/nlsAZGUYppiHlifF/b1qEVrABAI=;
        b=sIPquHcxNqvS/1BL7O9x6RGuxo1ipljcL/Gv1VAhGx3ECm20Xntmom1dZmAcJkxVmT
         4CIft/btyqsEl9fTQmDVuuQ/3U/s7vDqx+lzCpTm45PJiM0DF2YEqQzjqrAbIBQ6OBO9
         aAQ5KAPDRJxT/BGmGrWEQHBXdZyaw48acZ4n5rPf2UV2tsmG78InYzI9v4pd7uA4qLd1
         FG0z+z+lynjPSEDp0iBCcAFvTdrYqou7HZEcrivcNJMdiTx5JB5W2tdtqc4GtS4VDTMM
         GauJUw/T4ieQpSuRo7qPhGdbN1iWUMKT9UyuZsSTSYxkd8d4zQ2BHJbQMEtHm/h63jsO
         TkhQ==
X-Gm-Message-State: APjAAAVsBgVFUVX4Oxu1ELGajzEOS7/Z6NdXdRq2vHVJz2dS/D+IjUGP
        3EF1rzmg4+1nGOuXRrgZEN1UCQ==
X-Google-Smtp-Source: APXvYqwGbCMbpl+KeDJEWR38X134B5OsHvakBl6uS1IB23XqGXeEuXhr+E0skd6RTID97SyuesIdNQ==
X-Received: by 2002:ac2:4ace:: with SMTP id m14mr9196232lfp.130.1574361815565;
        Thu, 21 Nov 2019 10:43:35 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m10sm1904127lfa.46.2019.11.21.10.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 10:43:35 -0800 (PST)
Date:   Thu, 21 Nov 2019 10:43:16 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v3 16/16] Documentation: net: octeontx2: Add RVU HW and
 drivers overview.
Message-ID: <20191121104316.1bd09fcb@cakuba.netronome.com>
In-Reply-To: <CA+sq2CdbXgdsGjG-+34mNztxJ-eQkySB6k2SumkXMUkp7bKtwQ@mail.gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574272086-21055-17-git-send-email-sunil.kovvuri@gmail.com>
        <20191120164137.6f66a560@cakuba.netronome.com>
        <CA+sq2CdbXgdsGjG-+34mNztxJ-eQkySB6k2SumkXMUkp7bKtwQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 08:19:29 +0530, Sunil Kovvuri wrote:
> > Thanks for the description, I was hoping you'd also provide more info
> > on how the software componets of the system fit together. Today we only
> > have an AF driver upstream. Without the PF or VF drivers the card is
> > pretty much unusable with only the upstream drivers, right?
> 
> I will start submitting netdev drivers (PF and VF) right after this patchset.
> And just FYI this is not a NIC card, this HW is found only on the ARM64
> based OcteonTX2 SOC.

Right, that's kind of my point, it's not a simple NIC, so we want
to know what are all the software components. How does a real life
application make use of this HW.

Seems like your DPDK documentation lays that out pretty nicely:

https://doc.dpdk.org/guides/platform/octeontx2.html

It appears the data path components are supposed to be controlled by
DPDK.

After reading that DPDK documentation I feel like you'd need to do some
convincing to prove it makes sense to go forward with this AF driver at
all. For all practical purposes nobody will make use of this HW other
than through the DPDK-based SDK, so perhaps just keep your drivers in
the SDK and everyone will be happy?

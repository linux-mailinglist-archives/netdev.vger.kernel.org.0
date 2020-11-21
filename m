Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4612BC104
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 18:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgKURTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 12:19:03 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:55702 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgKURTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 12:19:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2C7E2128048D;
        Sat, 21 Nov 2020 09:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1605979140;
        bh=oKjwoQQYqAGHYIcGa87tH3kfRh6eNDZ11DRWs/5n6Nc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Lvt0xf0A2UjzBqGR2epCNoE7DN6YV9pUrVXD+f22BVAeiOW2KxZsGCImkMcXBrgh/
         zD0zBdigF+USoIPaRfSUxU4T/o3yBTwQz1ZuRUKYioWvma2ORezv7XJ+/UVZk14HDg
         znn3A0Y1A4QkkRvYDhfOKnhgBoH92sfIP7bAjSz4=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dA_Y3gfv-HlR; Sat, 21 Nov 2020 09:19:00 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 584A71280481;
        Sat, 21 Nov 2020 09:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1605979139;
        bh=oKjwoQQYqAGHYIcGa87tH3kfRh6eNDZ11DRWs/5n6Nc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=qZT/78tSZnguNV1yoYzSSmvqmDGgzNIuIpg2PbOws0zqwE5yu2CoK/DoUP3fxAE7/
         cwr3zThASX8R91ADl4Ew6X2dNx0rQAVJjUjWHCFXFVZg8s5iaP8BFiZuwsxl12vuws
         rCw1QQ3k1zT/j95+Y6p1vgihiOvqC5dVUCKPWDl0=
Message-ID: <5843ef910b0e86c00d9c0143dec20f93823b016b.camel@HansenPartnership.com>
Subject: Re: [RFC] MAINTAINERS tag for cleanup robot
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     trix@redhat.com, joe@perches.com,
        clang-built-linux@googlegroups.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, tboot-devel@lists.sourceforge.net,
        kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-wireless@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        keyrings@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, alsa-devel@alsa-project.org,
        bpf@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-nfs@vger.kernel.org, patches@opensource.cirrus.com
Date:   Sat, 21 Nov 2020 09:18:57 -0800
In-Reply-To: <20201121165058.1644182-1-trix@redhat.com>
References: <20201121165058.1644182-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-21 at 08:50 -0800, trix@redhat.com wrote:
> A difficult part of automating commits is composing the subsystem
> preamble in the commit log.  For the ongoing effort of a fixer
> producing
> one or two fixes a release the use of 'treewide:' does not seem
> appropriate.
> 
> It would be better if the normal prefix was used.  Unfortunately
> normal is
> not consistent across the tree.
> 
> 
> 	D: Commit subsystem prefix
> 
> ex/ for FPGA DFL DRIVERS
> 
> 	D: fpga: dfl:
> 

I've got to bet this is going to cause more issues than it solves. 
SCSI uses scsi: <driver>: for drivers but not every driver has a
MAINTAINERS entry.  We use either scsi: or scsi: core: for mid layer
things, but we're not consistent.  Block uses blk-<something>: for all
of it's stuff but almost no <somtehing>s have a MAINTAINERS entry.  So
the next thing you're going to cause is an explosion of suggested
MAINTAINERs entries.

Has anyone actually complained about treewide:?

James



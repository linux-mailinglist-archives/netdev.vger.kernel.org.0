Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907243797A6
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 21:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhEJTXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 15:23:55 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47815 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233208AbhEJTXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 15:23:49 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 14AJM3dI013584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 15:22:05 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id F267215C3CD9; Mon, 10 May 2021 15:22:02 -0400 (EDT)
Date:   Mon, 10 May 2021 15:22:02 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
Message-ID: <YJmH2irxoRsyNudb@mit.edu>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
 <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
 <20210510135518.305cc03d@coco.lan>
 <de6d1fa5b7934f4afd61370d9c58502bef588466.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de6d1fa5b7934f4afd61370d9c58502bef588466.camel@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 02:49:44PM +0100, David Woodhouse wrote:
> On Mon, 2021-05-10 at 13:55 +0200, Mauro Carvalho Chehab wrote:
> > This patch series is doing conversion only when using ASCII makes
> > more sense than using UTF-8. 
> > 
> > See, a number of converted documents ended with weird characters
> > like ZERO WIDTH NO-BREAK SPACE (U+FEFF) character. This specific
> > character doesn't do any good.
> > 
> > Others use NO-BREAK SPACE (U+A0) instead of 0x20. Harmless, until
> > someone tries to use grep[1].
> 
> Replacing those makes sense. But replacing emdashes — which are a
> distinct character that has no direct replacement in ASCII and which
> people do *deliberately* use instead of hyphen-minus — does not.

I regularly use --- for em-dashes and -- for en-dashes.  Markdown will
automatically translate 3 ASCII hypens to em-dashes, and 2 ASCII
hyphens to en-dashes.  It's much, much easier for me to type 2 or 3
hypens into my text editor of choice than trying to enter the UTF-8
characters.  If we can make sphinx do this translation, maybe that's
the best way of dealing with these two characters?

Cheers,

					- Ted

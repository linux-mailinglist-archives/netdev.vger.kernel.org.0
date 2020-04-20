Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1671B18A8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgDTVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:43:21 -0400
Received: from ms.lwn.net ([45.79.88.28]:53958 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDTVnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:43:19 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 632E4823;
        Mon, 20 Apr 2020 21:43:17 +0000 (UTC)
Date:   Mon, 20 Apr 2020 15:43:16 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Yuti Amonkar <yamonkar@cadence.com>,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-afs@lists.infradead.org,
        ecryptfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, linux-pci@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-spi@vger.kernel.org,
        Sandeep Maheswaram <sanm@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        linux-usb@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 00/33] Documentation fixes for Kernel 5.8
Message-ID: <20200420154316.28e42905@lwn.net>
In-Reply-To: <cover.1586881715.git.mchehab+huawei@kernel.org>
References: <cover.1586881715.git.mchehab+huawei@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Apr 2020 18:48:26 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Patches 1 to 5 contain changes to the documentation toolset:
> 
> - The first 3 patches help to reduce a lot the number of reported
>   kernel-doc issues, by making the tool more smart.
> 
> - Patches 4 and 5 are meant to partially address the PDF
>   build, with now requires Sphinx version 2.4 or upper.
> 
> The remaining patches fix broken references detected by
> this tool:
> 
>         ./scripts/documentation-file-ref-check
> 
> and address other random errors due to tags being mis-interpreted
> or mis-used.
> 
> They are independent each other, but some may depend on
> the kernel-doc improvements.
> 
> PS.: Due to the large number of C/C, I opted to keep a smaller
> set of C/C at this first e-mail (only e-mails with "L:" tag from
> MAINTAINERS file).

OK, I've applied this set, minus #17 which was applied elsewhere.

Thanks,

jon

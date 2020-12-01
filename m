Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE522C993E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbgLAIWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbgLAIWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 03:22:07 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94ECB20659;
        Tue,  1 Dec 2020 08:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606810884;
        bh=xHTFstOj6O/KMLPWIJ9livXkeh5E3cNJZoMEX1ICbl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ugfFVtmDEFz3qweRxNJGIbdlhHbJEbe+SPrGbc9I44gM+O6I2rVgrcZagGiPQlJe
         qDa/e9cJY/n7rREFFqWQI6CYR7sTmaWJfiub5J4ReXH3L76qQfPF0XWoTZ+/KCqBa1
         43uSa/AsDxhQJOFTJrlenu8ULt+S2HlexiyIiZjk=
Date:   Tue, 1 Dec 2020 02:20:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        amd-gfx@lists.freedesktop.org, bridge@lists.linux-foundation.org,
        ceph-devel@vger.kernel.org, cluster-devel@redhat.com,
        coreteam@netfilter.org, devel@driverdev.osuosl.org,
        dm-devel@redhat.com, drbd-dev@tron.linbit.com,
        dri-devel@lists.freedesktop.org, GR-everest-linux-l2@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        linux-block@vger.kernel.org, linux-can@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-geode@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i3c@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
        op-tee@lists.trustedfirmware.org, oss-drivers@netronome.com,
        patches@opensource.cirrus.com, rds-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, samba-technical@lists.samba.org,
        selinux@vger.kernel.org, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        usb-storage@lists.one-eyed-alien.net,
        virtualization@lists.linux-foundation.org,
        wcn36xx@lists.infradead.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-hardening@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
Message-ID: <20201201082047.GA11832@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <yq1h7p6gjkk.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1h7p6gjkk.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 12:52:27AM -0500, Martin K. Petersen wrote:
> 
> Gustavo,
> 
> > This series aims to fix almost all remaining fall-through warnings in
> > order to enable -Wimplicit-fallthrough for Clang.
> 
> Applied 20-22,54,120-124 to 5.11/scsi-staging, thanks.

Awesome! :)

Thanks, Martin.
--
Gustavo

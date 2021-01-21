Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C982FF3F0
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbhAUTLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbhAUTLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 14:11:23 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686F7C061756;
        Thu, 21 Jan 2021 11:11:08 -0800 (PST)
Received: from lwn.net (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 67463615C;
        Thu, 21 Jan 2021 19:09:55 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 67463615C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1611256197; bh=0PfEGC/cPJ5o5ce4iP7kPM3qg+xRX/ZAzMq8mA7LR+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LfmTwdSQP3IBIFsgIimE+P0zc4qOuRRENhFAbFZ81/G0xiY0DScELhTCtldW3XIfz
         Ugs8obCBqzDnsrsJoi5krEbWrGHjyZPpGee+9oAGUJ1ZDXrSP/jMHtPw39Va3bBst2
         L4SlcWZ4eBnLVGq3hawDKWCzzYzGfx0DG20ajnIZZRO05FEVzu6Z6QH1o0t7hxv9Z5
         FAGLGDnT/R3zaflLKjCnNdzZoWBPmMbSxH+vE+gp8swBNJrsI901YZhh5xO0J5KAQE
         q+gS4MkjsOprcfN5wLvJLeHWfw2eGdzUGLUYeV2MifPW5V3sfXPnjMGNWyuhz0xfWx
         Q0+/sodoN2x/A==
Date:   Thu, 21 Jan 2021 12:09:54 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Maxime Ripard <mripard@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Richard Gong <richard.gong@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Will Drewry <wad@chromium.org>,
        Ying Xue <ying.xue@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v6 00/16] Fix several bad kernel-doc markups
Message-ID: <20210121120954.5ed4c3b2@lwn.net>
In-Reply-To: <cover.1610610937.git.mchehab+huawei@kernel.org>
References: <cover.1610610937.git.mchehab+huawei@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 09:04:36 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> 1)  10 remaining fixup patches from the series I sent back on Dec, 1st:
> 
>    parport: fix a kernel-doc markup
>    rapidio: fix kernel-doc a markup
>    fs: fix kernel-doc markups
>    pstore/zone: fix a kernel-doc markup
>    firmware: stratix10-svc: fix kernel-doc markups
>    connector: fix a kernel-doc markup
>    lib/crc7: fix a kernel-doc markup
>    memblock: fix kernel-doc markups
>    w1: fix a kernel-doc markup
>    selftests: kselftest_harness.h: partially fix kernel-doc markups

A week later none of these have shown up in linux-next, so I went ahead
and applied the set.

Thanks,

jon

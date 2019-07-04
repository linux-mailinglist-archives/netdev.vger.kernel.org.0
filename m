Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A40C5F456
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 10:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfGDIJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 04:09:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41017 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfGDIJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 04:09:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so5543815wrm.8
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 01:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ikIOKBV36H/Xx1iuFIPI2qkuopRb0oqwGFKJA2jzmY4=;
        b=I/LimrpioiWUl+TQIxDzRUuF3Atd37fYhfeZDCXfS3Ifza1QV3qL8hlvjJ/vGuk8Yz
         2UY8Fd26nxylwrUL52R1hDOuoT0hPmJYMLXXLavrZAeWDIyuIFJvxMRrerEhw+ecH9HY
         6MX+olxNieSfywey7Cw8GkZ3JOaYzvSXAaT6SLHt6pbdfOIIU7vG86ffZJCUM+L2Jtkr
         QbJ42HuXTdTckIw4vuToyYxZ0rY6jmRgzM6dVveKzM3OZA42KZ3Zx+aLz9ZAg2L/O816
         HODt2JTXwQzDhEQpB7Rkl/r7tN3LUYg/l3R/D/jLTQ98VrZIHEYzqT3bt20m8h/aC+SQ
         hOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ikIOKBV36H/Xx1iuFIPI2qkuopRb0oqwGFKJA2jzmY4=;
        b=WZCJi8Yek19QrMmFrKNwzfZBU06R/FcnnHMgfniFuGitf9uizy/KYjpv2ldsIqAYdl
         Qoasn8UfTt8AeLaZBg4GF+AhcJ4Dx5ZkyOAxiASslCb8geSn9UKSIvOewn879m/Asjl8
         BnvYz4WUXsxMYWk06BhAfeqWDl7GgEsoBRo9KPUY6lMsgzYos41qq7o5yO4RdCdIO5MI
         Vnc/SdZyiodpIGWgSc9NpjuIcE5/7k8lcy5SMjuefb+PVNAZgaiJzwOXTUwwc9z9h7Lh
         u6foa7IPU/i5iYVgok+Yc2DEr+hUOddV+Ul3JEVHxgOOdXsV2Bwfu672Wh25ivpoBS4Z
         i/UQ==
X-Gm-Message-State: APjAAAXI05mvrUIsOahxPNPMhJUoz7YKVRLTrTO/5Y0+LDAbQvdlMadY
        P4LStkWTB6A1t85reoS2aLsqUQ==
X-Google-Smtp-Source: APXvYqxtJJPyG4RX207axr0ToNgMTD3BFhUKT7pEJfs8Zwuc3CesCIlqz0qlHQjj96AAD8AbNBdIGw==
X-Received: by 2002:a5d:6182:: with SMTP id j2mr21751875wru.275.1562227795632;
        Thu, 04 Jul 2019 01:09:55 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id a2sm5896823wmj.9.2019.07.04.01.09.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 01:09:55 -0700 (PDT)
Date:   Thu, 4 Jul 2019 10:09:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 08/15] ethtool: move string arrays into
 common file
Message-ID: <20190704080954.GH2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <0647ac484dac2c655d0e4260d81e86405688ff5b.1562067622.git.mkubecek@suse.cz>
 <20190703134452.GZ2250@nanopsycho>
 <20190703143722.GN20101@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703143722.GN20101@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 03, 2019 at 04:37:22PM CEST, mkubecek@suse.cz wrote:
>On Wed, Jul 03, 2019 at 03:44:52PM +0200, Jiri Pirko wrote:
>> Tue, Jul 02, 2019 at 01:50:19PM CEST, mkubecek@suse.cz wrote:
>> >Introduce file net/ethtool/common.c for code shared by ioctl and netlink
>> >ethtool interface. Move name tables of features, RSS hash functions,
>> >tunables and PHY tunables into this file.
>> >
>> >Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>> >---
>> > net/ethtool/Makefile |  2 +-
>> > net/ethtool/common.c | 84 ++++++++++++++++++++++++++++++++++++++++++++
>> > net/ethtool/common.h | 17 +++++++++
>> > net/ethtool/ioctl.c  | 83 ++-----------------------------------------
>> > 4 files changed, 104 insertions(+), 82 deletions(-)
>> > create mode 100644 net/ethtool/common.c
>> > create mode 100644 net/ethtool/common.h
>> >
>> >diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
>> >index 482fdb9380fa..11782306593b 100644
>> >--- a/net/ethtool/Makefile
>> >+++ b/net/ethtool/Makefile
>> >@@ -1,6 +1,6 @@
>> > # SPDX-License-Identifier: GPL-2.0
>> > 
>> >-obj-y				+= ioctl.o
>> >+obj-y				+= ioctl.o common.o
>> > 
>> > obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
>> > 
>> >diff --git a/net/ethtool/common.c b/net/ethtool/common.c
>> >new file mode 100644
>> >index 000000000000..b0ce420e994e
>> >--- /dev/null
>> >+++ b/net/ethtool/common.c
>> >@@ -0,0 +1,84 @@
>> >+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>> >+
>> >+#include "common.h"
>> >+
>> >+const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
>> 
>> const char *netdev_features_strings[NETDEV_FEATURE_COUNT] = {
>> ?
>> 
>> Same with the other arrays.
>
>These are not new tables, this patch only moves existing tables from
>ioctl.c (originally net/core/ethtool.c) into common.c so that they can
>be used by both ioctl and netlink code.
>
>This fixed size string array format is used by ETHTOOL_GSTRINGS ioctl
>command. So if we switch these into simple const char *table[], we can
>get rid of some complexity in strset.c and bitset.c (the "simple" vs.
>"legacy" string set mess) but we would have to convert them into the
>fixed size string array in ioctl ETHTOOL_GSTRINGS handler. And then we
>would also have to convert (or rather "index") string sets retrieved
>from NIC driver (e.g. private flags, stats, tests) - which also means an
>extra kmalloc() (or rather kmalloc_array()).
>
>It an option I'm certainly open to if we agree on it but it's not for
>free.

Got it. I don't think we need to do this now. But it would be certainly
nice to fix this later on.

>
>Michal

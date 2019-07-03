Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2D35E5AE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfGCNo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:44:56 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36254 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfGCNoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:44:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so2904996wrs.3
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 06:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lqjwb4PSRRpgur45S0Sj39llo2koNK5cJny1303AO4k=;
        b=2Gl3DVSUwdQHd8Q3VmCtrI4Qk3ly3TpMfWH+JoiElbBZyH3bTKl/I/hZnH4h2rAMgn
         Dro/izjGNqzGybKf0Na86V0xPu684GM4bQvNLuLiQ9nb/h8KQwmrSUk7AWYbLo8wn2sI
         RpsXaF8qXgwQdMQ0DxAREpJkFCdeNCiEevvniv1mb/jwTWsn1vz0H/3Xge75bEFot4Op
         hrp6FAAaT6xt1JFvGUMwUBoI/HPBuJKifIScUI3zJwMjmJ1nZQaMHDRNQ3FRw6o2ZRub
         scq9E0LAWVWxxB3vRNYpwU3o3lT6Zk7HKdJnU99vj5gPNh/NvrI4KdyCRA8HziSVzywD
         Wq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Lqjwb4PSRRpgur45S0Sj39llo2koNK5cJny1303AO4k=;
        b=fTxipTrubP6pdxmjtncAE+vIKQRQK+zcYMeSqpiE7wvHXHu0YUp80Lgscd+Dfraw/2
         Jijamw7sCsaB9yWlRL/F1DAkD7WoTo24buJ5cM8N0JoaghUe4Oft6PFxKRqz8KzPm7E4
         sPnhXzZ2g8dYLOd/LF0fUu5BvFnGcIlAMSlXvloSdGlwvqveCehn1Gtxwvn8QH5VRIC+
         7kwSgw+foD4Fep0fxRM72bWm104WS6A21T/O7uHjBMBhxJPCJvFza1ckC3xo5MQGjBRi
         4PpNJjS/WqRvDxpjmIvRDV94LtZ/hSFXMtdwAmNl9Doe697l0knsLKy3x6ohbqZV6vWd
         G+zQ==
X-Gm-Message-State: APjAAAW8QHHqtAfmfKZvE868ADAulvUS+ytT9wKYIV4a4ut+F7aVAnfi
        TOUFoZPNjWKag9tVpv1nJ8RMGQ==
X-Google-Smtp-Source: APXvYqwDx1CQACHzdJvabOorGtzHxc6vae/DyNdKL+DNE+ANBUk4KWYrClqDqFMzup8XvG+kANkUMg==
X-Received: by 2002:adf:fa4c:: with SMTP id y12mr28966912wrr.282.1562161493662;
        Wed, 03 Jul 2019 06:44:53 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id p11sm2910322wrm.53.2019.07.03.06.44.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 06:44:53 -0700 (PDT)
Date:   Wed, 3 Jul 2019 15:44:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 08/15] ethtool: move string arrays into
 common file
Message-ID: <20190703134452.GZ2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <0647ac484dac2c655d0e4260d81e86405688ff5b.1562067622.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0647ac484dac2c655d0e4260d81e86405688ff5b.1562067622.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 02, 2019 at 01:50:19PM CEST, mkubecek@suse.cz wrote:
>Introduce file net/ethtool/common.c for code shared by ioctl and netlink
>ethtool interface. Move name tables of features, RSS hash functions,
>tunables and PHY tunables into this file.
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>---
> net/ethtool/Makefile |  2 +-
> net/ethtool/common.c | 84 ++++++++++++++++++++++++++++++++++++++++++++
> net/ethtool/common.h | 17 +++++++++
> net/ethtool/ioctl.c  | 83 ++-----------------------------------------
> 4 files changed, 104 insertions(+), 82 deletions(-)
> create mode 100644 net/ethtool/common.c
> create mode 100644 net/ethtool/common.h
>
>diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
>index 482fdb9380fa..11782306593b 100644
>--- a/net/ethtool/Makefile
>+++ b/net/ethtool/Makefile
>@@ -1,6 +1,6 @@
> # SPDX-License-Identifier: GPL-2.0
> 
>-obj-y				+= ioctl.o
>+obj-y				+= ioctl.o common.o
> 
> obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
> 
>diff --git a/net/ethtool/common.c b/net/ethtool/common.c
>new file mode 100644
>index 000000000000..b0ce420e994e
>--- /dev/null
>+++ b/net/ethtool/common.c
>@@ -0,0 +1,84 @@
>+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>+
>+#include "common.h"
>+
>+const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {

const char *netdev_features_strings[NETDEV_FEATURE_COUNT] = {
?

Same with the other arrays.

[...]

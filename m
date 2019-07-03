Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4865DB4F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfGCCE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:04:26 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:38062 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCCE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:04:26 -0400
Received: by mail-qt1-f171.google.com with SMTP id n11so852618qtl.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=D+csHyoXmCSfo36FjRvnFg+jSmMkHBvbr36bQgH7vNk=;
        b=mSPg9yAuCQf0++B9j2eL4h8AxelwNz6s8rBhCtOzR9ETFAzSzwNRwYxfefPE70gqzz
         klH0aVmx7Jo6j39VTbd7/EzqoGJLfp8wdsYfnl3XufZtCPF2MHesQ1i13AK0GbD5eVYH
         2Z7c8hFaBl47V0UVztztD42Y/1BMFlQ9VPhnhZJvggSf6xP9b1N1TnOHITpNOg4ffc8b
         lxumVSZgbKRhzeU68dP8Lz3vDB9TPvgN48fcHHUx4RZKIKMp5610/N3hMavuxlCAb2CV
         G0gQkwMjYFYqfel79Qw2ld0wS43k0OOfpAfMSd6UBif906QBiHGjgEDQA8uFEouzjN9e
         fczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=D+csHyoXmCSfo36FjRvnFg+jSmMkHBvbr36bQgH7vNk=;
        b=EzziyCShGu29olch18IeSy2f+mCZQoVIoBcCnq03hjJn+F5Zi6Fp5OPNFovhPXL+Hk
         m5GnN22z/loj2Zyrge5zdYGv3m1+Ug8cw3AbCdCKJusEM4j7wo/7Wiz/WOqnjxnpm95E
         5UHV5ZQpD8lyAQfZuvGAI8S4sACNWkGJVoJc7Zw3tcG3BrjyYTDP6L2faO9D7zEFaydi
         b0zCAOXEzdc4ZaVvvuZ/8RjL8qSTotTIQZfqCSH8dQ/t62dAJe68VjVolLfTVncY6+6Q
         4lojWwhqrgAp07nPYfd5TZxjTGiYovpvt3WRdSgf8NN0NaEDAoaN+X6RiY+XLtIYnyck
         rZgg==
X-Gm-Message-State: APjAAAUFKJM95YdonjPUZdSHCUHHXwdHHNVHnbMzHbl8B/nN3sB+77k9
        nAyPD1hXudQfzcehgnLs1qRcjA==
X-Google-Smtp-Source: APXvYqyNNXeWcpsv07GuG3AuJ6PH8AJPyEjMJU4wwj+LUGZw2xzKqfxmBouRwJ788Gpa2tYTsHOj3g==
X-Received: by 2002:a0c:baa8:: with SMTP id x40mr30028502qvf.168.1562119465176;
        Tue, 02 Jul 2019 19:04:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t2sm433654qth.33.2019.07.02.19.04.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 19:04:25 -0700 (PDT)
Date:   Tue, 2 Jul 2019 19:04:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 11/15] ethtool: provide link mode names as a
 string set
Message-ID: <20190702190419.1cb8a189@cakuba.netronome.com>
In-Reply-To: <1e1bf53de26780ecc0e448aa07dc429ef590798a.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
        <1e1bf53de26780ecc0e448aa07dc429ef590798a.1562067622.git.mkubecek@suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jul 2019 13:50:34 +0200 (CEST), Michal Kubecek wrote:
> +const char *const link_mode_names[] = {
> +	__DEFINE_LINK_MODE_NAME(10, T, Half),
> +	__DEFINE_LINK_MODE_NAME(10, T, Full),
> +	__DEFINE_LINK_MODE_NAME(100, T, Half),
> +	__DEFINE_LINK_MODE_NAME(100, T, Full),
> +	__DEFINE_LINK_MODE_NAME(1000, T, Half),
> +	__DEFINE_LINK_MODE_NAME(1000, T, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(Autoneg, "Autoneg"),
> +	__DEFINE_SPECIAL_MODE_NAME(TP, "TP"),
> +	__DEFINE_SPECIAL_MODE_NAME(AUI, "AUI"),
> +	__DEFINE_SPECIAL_MODE_NAME(MII, "MII"),
> +	__DEFINE_SPECIAL_MODE_NAME(FIBRE, "FIBRE"),
> +	__DEFINE_SPECIAL_MODE_NAME(BNC, "BNC"),

> +	__DEFINE_LINK_MODE_NAME(10000, T, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(Pause, "Pause"),
> +	__DEFINE_SPECIAL_MODE_NAME(Asym_Pause, "Asym_Pause"),
> +	__DEFINE_LINK_MODE_NAME(2500, X, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(Backplane, "Backplane"),
> +	__DEFINE_LINK_MODE_NAME(1000, KX, Full),
...
> +	__DEFINE_LINK_MODE_NAME(5000, T, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(FEC_NONE, "None"),
> +	__DEFINE_SPECIAL_MODE_NAME(FEC_RS, "RS"),
> +	__DEFINE_SPECIAL_MODE_NAME(FEC_BASER, "BASER"),

Why are port types and FEC params among link mode strings?

> +	__DEFINE_LINK_MODE_NAME(50000, KR, Full),
...
> +	__DEFINE_LINK_MODE_NAME(1000, T1, Full),
> +};

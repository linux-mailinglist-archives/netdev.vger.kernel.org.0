Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65D51284E5
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 23:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfLTWaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 17:30:05 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40721 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfLTWaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 17:30:05 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so4251580pjb.5
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 14:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5z39mOS8bxPtjntTPhpVVDgmV2j/x/5fKucSUExC1EA=;
        b=eDFfEnOLprT8muE+30chQApltFQpfQlVx/r9tQhwkypQkEM4GIwofJbnLMy2w8VS2k
         y0tc1Bgm8nBTitS5ScAJFwexOOVffpfdl5HLdz4yEZ1UK7ArcDVq/AIPWwzY52vt5lxz
         KP+CMb21ndNllufwmZk65yn9EQ31wv06ubobzmyzzo3AMjvzlQf6dk6dMto8Rj32u+Da
         AeTg5fwa/TIvhWPjop5947dCPMG1sg1Cp6JWbziLc5y5mrFqVOgBuYxVXtMvCASUDul2
         OIajV68Ffya8RaRppVjka0qP985P+qrZU+YsC9iVHHt9JIdACOL7BzzHbL7pGpWmdvej
         BK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5z39mOS8bxPtjntTPhpVVDgmV2j/x/5fKucSUExC1EA=;
        b=KnwgXuuCqNXrWk2ecRAkvvYk/d5iGhTxWOi+r92rq4LYQYHy47Ehc3ViXayZtdQe2l
         Zpro5skdrNyqB/QGlzOlYA48hy/MA8wDfNuHetzUIzd6RRkK0nHW9TcTIZ8Tipe2Wil0
         dWQirGkQwhJ3wFUBrRnmrScfq/3sYn06pBpzes4StzjZ4ojXVQSKRYXbjLmN2s2id35B
         v8wGhRNnjKPRhAsDQ4jkd59XYYf5kIQ/zObs9taq0Zxr0I4BAdN2AMcWR/zZNc/y1GHO
         BkYHBeQC6MqSaT+cPrxLRPajDtSB3nSfzPltpML8uq+wbAQf6KJLVUhAJBbvNxf5DVBB
         ZHFQ==
X-Gm-Message-State: APjAAAUI5mqXMoTMkOyq3Q0Z78kj78RLUMFKPBPHHqiTxR5DTxvGIW0l
        6tDY0TldDt55ze3TeQGdoo63og==
X-Google-Smtp-Source: APXvYqx0pY/Yx/d3swGhyRBKdRVLtKCJ5hteAaLx8f7tjl6xlj5jqZNG7XfjR3Ulv1flYuDEeku5qQ==
X-Received: by 2002:a17:902:a614:: with SMTP id u20mr17892057plq.107.1576881004390;
        Fri, 20 Dec 2019 14:30:04 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d24sm15022315pfq.75.2019.12.20.14.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 14:30:04 -0800 (PST)
Date:   Fri, 20 Dec 2019 14:30:01 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     cforno12@linux.vnet.ibm.com, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 0/2] net/ethtool: Introduce
 link_ksettings API for virtual network devices
Message-ID: <20191220143001.1e78dc82@hermes.lan>
In-Reply-To: <20191219.141619.1840874136750249908.davem@davemloft.net>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
        <20191219131156.21332555@hermes.lan>
        <20191219.141619.1840874136750249908.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 14:16:19 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Thu, 19 Dec 2019 13:11:56 -0800
> 
> > I don't think this makes sense for netvsc. The speed and duplex have no
> > meaning, why do you want to allow overriding it? If this is to try and make
> > some dashboard look good; then you aren't seeing the real speed which is
> > what only the host knows. Plus it does take into account the accelerated
> > networking path.  
> 
> Maybe that's the point, userspace has extraneous knowledge it might
> use to set it accurately.
> 
> This helps for bonding/team etc. as well.
> 
> I don't think there is any real harm in allowing to set this, and
> we've done this in the past I think.

Looked a little more. The netvsc driver does query the host already
and get a correct link speed.  See drivers/net/hyperv/rndis_filter.c

If running on Windows Server 2019 you will see speed report of 40G
if using 40G Mellanox SRIOV, and 10G if using a private virtual network.

On Azure, the guest sees the speed of the underlying network connection
which varies based on machine type.

Bottom line: it behaves like real hardware now, why should we allow user
to set it for netvsc and not other real hardware.

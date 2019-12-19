Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336E5126F73
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLSVMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:12:05 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50628 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfLSVMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:12:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so3105392pjb.0
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 13:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D0+/ajlkEthM7DJw0ZEHKu5bYSEkznyr/aacsmedtL0=;
        b=V1V0EQ8UIyk/aWfhDkUgayqFWpprwO2dO5RLlCmoQ8bx96g22wj0F+aRc+REGuHZL+
         O/OJHp/S6gvUVhr6v7zZb5FFmKg/2fM+CpRzXm08J/wYPsPP9DNaSm7IicKbM5eWSYVF
         c1/4dnstKdkKwzCuTjI9lg2l/dSfZSzHQ22sBDDCpiRJf9Y4f2WtJ1ikRtrd7fhVmwGl
         Ki+7W2W1pqkRt/JUCF3WqnwvM9SRtroeyCnAtrTscUYmK+m9tWE+l5cKhPISKQm8HTJB
         y+0p+BUdPGCfDXy6R98oSSCPo1y7RXCJNBFVLvk39b7cz/LA4lJeqkCygc20EhPul9o3
         zLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D0+/ajlkEthM7DJw0ZEHKu5bYSEkznyr/aacsmedtL0=;
        b=eyoZO6yOLrLAV1THKf5T3fRHs3zg/TIGEa2LTBDNB/TxZRbjMlVLgTpwj3NLJzvipu
         SO6wVPLFA1CQdBkYqNXW9L9EKFrr4WcO5nMABVFsFLWaqfRsqZLW+JWUcHY0sdHtRlMR
         b79IIL098wbk0/dOwS8e+p3/6ha808QDCsepxUvd/bv9kQWmZxURPPW+ZQRuiQPh9S5S
         o6Ki0E29so/684+xRGjMbntkxi1r+0MTMaG8gNhVCMYa9m+vAEk51YSC6W3Xx7WEqAoZ
         oW61C8Uo2suorYmJSxR7kxlHbOoC2wWXr1JYXoQETnNQNBVl6pxyyA3QG69nv+xaHEzf
         ndmA==
X-Gm-Message-State: APjAAAXKHIa/Vk2edwnH/J8KUVxJe/Numf0NwngdNoRCoqz5MCflg8rF
        z4wJYV+PnXvrbMpZT+S72kuFug==
X-Google-Smtp-Source: APXvYqzkiTe/X2RCTQs08hneGJ/eSW+SDjp2/w3uDQPw9TMhDSWiH3hjil3vX5PkNd+vxImzfbXx/A==
X-Received: by 2002:a17:902:aa48:: with SMTP id c8mr11020645plr.243.1576789924509;
        Thu, 19 Dec 2019 13:12:04 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u123sm9290950pfb.109.2019.12.19.13.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 13:12:04 -0800 (PST)
Date:   Thu, 19 Dec 2019 13:11:56 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Cris Forno <cforno12@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 0/2] net/ethtool: Introduce
 link_ksettings API for virtual network devices
Message-ID: <20191219131156.21332555@hermes.lan>
In-Reply-To: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 13:40:55 -0600
Cris Forno <cforno12@linux.vnet.ibm.com> wrote:

> This series provides an API for drivers of virtual network devices that allows
> users to alter initial device speed and duplex settings to reflect the actual
> capabilities of underlying hardware. The changes made include two helper
> functions ethtool_virtdev_get/set_link_ksettings, which are used to retrieve or
> update alterable link settings, respectively. In addition, there is a new
> ethtool operation defined to validate those settings provided by the user. This
> operation can use either a generic validation function,
> ethtool_virtdev_validate_cmd, or one defined by the driver. These changes
> resolve code duplication for existing virtual network drivers that have already
> implemented this behavior.  In the case of the ibmveth driver, this API is used
> to provide this capability for the first time.
> 
> ---
> v3: Factored out duplicated code to core/ethtool to provide API to virtual
>     drivers
>     
> v2: Updated default driver speed/duplex settings to avoid breaking existing
>     setups
> ---
> 
> Cris Forno (2):
>   Three virtual devices (ibmveth, virtio_net, and netvsc) all have
>     similar code to set/get link settings and validate ethtool command.
>     To     eliminate duplication of code, it is factored out into
>     core/ethtool.c.
>   With get/set link settings functions in core/ethtool.c, ibmveth,
>     netvsc, and virtio now use the core's helper function.
> 
>  drivers/net/ethernet/ibm/ibmveth.c | 60 +++++++++++++++++++++-----------------
>  drivers/net/ethernet/ibm/ibmveth.h |  3 ++
>  drivers/net/hyperv/netvsc_drv.c    | 21 ++++---------
>  drivers/net/virtio_net.c           | 45 ++++------------------------
>  include/linux/ethtool.h            |  2 ++
>  net/core/ethtool.c                 | 56 +++++++++++++++++++++++++++++++++++
>  6 files changed, 104 insertions(+), 83 deletions(-)
> 
> --
> 1.8.3.1

I don't think this makes sense for netvsc. The speed and duplex have no
meaning, why do you want to allow overriding it? If this is to try and make
some dashboard look good; then you aren't seeing the real speed which is
what only the host knows. Plus it does take into account the accelerated
networking path.

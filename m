Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5D3F398A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfKGUco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:32:44 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32816 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfKGUco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 15:32:44 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay6so2399802plb.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 12:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=H1xRS46fM5LD5K/ydfNvqg7rYgxWxCSqEht+PRGUa4U=;
        b=tfsumkoAdjTKHfYeisbsRDvaxQtbOoI/KGYjE81Yl0PG95lm/ujd3Y4G5wuC8c1nc1
         HK0X8h6vOomissKrVlvXzUCVcVgVjU+Rc6vogymUT4FOKIACOC7Rhh/7fGMbcL/Dc8Q5
         sBRRY3L8eX8HajS2sBlP0NEuDCge8l6wMteDEQsT5allc+AVpzFzPknkI7kMkp89BWPU
         Nexa7AwhxcBqhGulxhqBr2lGoNqjlalgk2QZMJHYS0kKDD4l1QS6643BNob8xEpA/C/W
         3p/1adKgt8CBcD+Bt9sNv8+RP12YkmJwSE3XBVKqr0Z9ttUHYm4HnjcJebfdAPzxaiMt
         ulKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=H1xRS46fM5LD5K/ydfNvqg7rYgxWxCSqEht+PRGUa4U=;
        b=kXgrUh+SJlDKtYuqmn/aSTKPISKan/pSmir/0WF1JjLnVyQjD1rjvN4JadcGsxl/po
         w/oh6Mrb8lHHBNnP4VUoAxhqXoTW53K/IQtirptoDBkSN9yf97QY8re3Prk2FNRblc5m
         HqAjKORW2iIVYRy/r9zStgZBInv2D7eXJAAvsX9wr+vGrNK+Njjk6nqllSQUsOti56ut
         gPY3tb3CO2HkWOO5J0kUeax8PBr/dNyXsWGCBTU+VZEnG6sAJh/IgaBB5/MxlukNnY9m
         U40YUPdOGn5HXSRgQ3/sIYfWyCec8urCaR7umEe5MnWNLSFPuK/dBwBWuF5LjCuYmgci
         TMRw==
X-Gm-Message-State: APjAAAVTaSEDkLIeNGTY7btwXTeLgFike1ZBjxZ9Zrig2/EMCOjRyoH+
        7oTQQTEDJw6Ey8zJsgbumIJU4Q==
X-Google-Smtp-Source: APXvYqwhMCPR1WhyCfSCTY6X/ImHgiDS2TCZ50mSul13Rm3wAlTshDzZs6tMtEB+yT/FsJxEeI/Fyw==
X-Received: by 2002:a17:902:a410:: with SMTP id p16mr5875809plq.184.1573158763275;
        Thu, 07 Nov 2019 12:32:43 -0800 (PST)
Received: from cakuba.netronome.com ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id a66sm3627107pfb.166.2019.11.07.12.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 12:32:42 -0800 (PST)
Date:   Thu, 7 Nov 2019 15:32:34 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191107153234.0d735c1f@cakuba.netronome.com>
In-Reply-To: <20191107160448.20962-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:
> Mellanox sub function capability allows users to create several hundreds
> of networking and/or rdma devices without depending on PCI SR-IOV support.

You call the new port type "sub function" but the devlink port flavour
is mdev.

As I'm sure you remember you nacked my patches exposing NFP's PCI 
sub functions which are just regions of the BAR without any mdev
capability. Am I in the clear to repost those now? Jiri?

> Overview:
> ---------
> Mellanox ConnectX sub functions are exposed to user as a mediated
> device (mdev) [2] as discussed in RFC [3] and further during
> netdevconf0x13 at [4].
> 
> mlx5 mediated device (mdev) enables users to create multiple netdevices
> and/or RDMA devices from single PCI function.
> 
> Each mdev maps to a mlx5 sub function.
> mlx5 sub function is similar to PCI VF. However it doesn't have its own
> PCI function and MSI-X vectors.
> 
> mlx5 mdevs share common PCI resources such as PCI BAR region,
> MSI-X interrupts.
> 
> Each mdev has its own window in the PCI BAR region, which is
> accessible only to that mdev and applications using it.
> 
> Each mlx5 sub function has its own resource namespace for RDMA resources.
> 
> mdevs are supported when eswitch mode of the devlink instance
> is in switchdev mode described in devlink documentation [5].

So presumably the mdevs don't spawn their own devlink instance today,
but once mapped via VIRTIO to a VM they will create one?

It could be useful to specify.

> Network side:
> - By default the netdevice and the rdma device of mlx5 mdev cannot send or
> receive any packets over the network or to any other mlx5 mdev.

Does this mean the frames don't fall back to the repr by default?

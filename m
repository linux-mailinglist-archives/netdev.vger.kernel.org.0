Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC41B6300F
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 07:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfGIFkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 01:40:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38620 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfGIFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 01:40:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so8717566pfn.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 22:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IQmdRFrEhhSLWwTIYZ9Pn7y/fJjbbazKtcw+0/kPqq8=;
        b=xWQlK469LrFiOaGb/tLN6seCfU69pqfnFdCuAQdUle39QhBzesz5qln/kL8xSSpi2+
         BI6m4QPQ+Y+K0AqFvzwzg6Mpg7qXXQYQ3U6BZ6js0nKhndvQRVub5trBd2lXxaTRZ3dX
         J4cxPUisy0Bvt2qjKDh0/14hIQkMQu/s3ueA9pwj6ipBW+/cAyn0KYLKaSprLyEShmLP
         RFf1xKxAekwkzWvPiQyNjUV5nY66h2GxbOU0Z8pZZDtLCf6gIlBPeaF7kih4VCA0tpXv
         vhTvKEYgVGfJxW2EJRXkr/UKGUVn4ZGXhb1CatmfywSVlXjU80c1W51aPRuz6RyWgrXA
         ebeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IQmdRFrEhhSLWwTIYZ9Pn7y/fJjbbazKtcw+0/kPqq8=;
        b=t0fGTe0b9h+gmALt23rbVK9+xHap7EgnDul/LaFg3hSuspcJpQj9uTkYLEPbwzbmTm
         XS15RJCnRB3Um6u/dkaGgVN9Hm2bMCUyNN4kBDWyeMxYounlhGm+BB+0mExLBJgm+qUT
         eG3HaHWxzW3ablEmoPglWAwWBzke93nGBswWpKK13WqR4ptTT9t1qtGKJ9ZUuez0sy12
         qhtEVxmhPCmGqI4pTkOKRPcqJ5WnS84OY6RlXWuNQ5T924b6e3qh06oAkJKrS8c0CIK9
         tBI2STLkRDsbTRFjW7LFgbIcwL5I053u62mYnAGLDswKDtrdYQ8buYAiFXmwnJZSkxIu
         LX0g==
X-Gm-Message-State: APjAAAX6HuVSwtyK/ZHAC3nagWTITHQcpxxxmMy20Iujr2LuQ2Imm6Mt
        +TnPkT2FmCzUk6vvE42J9JdVUw==
X-Google-Smtp-Source: APXvYqxg3GjtlvLwKbI9WgwQO4WbYrQVL3xpSv9rbvBO2Vm4aDE9n+x+biqbJAL/g6fXr4ECm+e/Bw==
X-Received: by 2002:a17:90a:f488:: with SMTP id bx8mr30254996pjb.91.1562650816992;
        Mon, 08 Jul 2019 22:40:16 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id o14sm1144368pjp.19.2019.07.08.22.40.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 22:40:16 -0700 (PDT)
Date:   Mon, 8 Jul 2019 22:40:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Message-ID: <20190708224012.0280846c@cakuba.netronome.com>
In-Reply-To: <20190709041739.44292-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190709041739.44292-1-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Jul 2019 23:17:34 -0500, Parav Pandit wrote:
> This patchset carry forwards the work initiated in [1] and discussion
> futher concluded at [2].
> 
> To improve visibility of representor netdevice, its association with
> PF or VF, physical port, two new devlink port flavours are added as
> PCI PF and PCI VF ports.
> 
> A sample eswitch view can be seen below, which will be futher extended to
> mdev subdevices of a PCI function in future.
> 
> Patch-1 moves physical port's attribute to new structure
> Patch-2 enhances netlink response to consider port flavour
> Patch-3,4 extends devlink port attributes and port flavour
> Patch-5 extends mlx5 driver to register devlink ports for PF, VF and
> physical link.

The coding leaves something to be desired:

1) flavour handling in devlink_nl_port_attrs_put() really calls for a
   switch statement,
2) devlink_port_attrs_.*set() can take a pointer to flavour specific
   structure instead of attr structure for setting the parameters,
3) the "ret" variable there is unnecessary,
4) there is inconsistency in whether there is an empty line between
   if (ret) return; after __devlink_port_attrs_set() and attr setting,
5) /* Associated PCI VF for of the PCI PF for this port. */ doesn't
   read great;
6) mlx5 functions should preferably have an appropriate prefix - f.e.
   register_devlink_port() or is_devlink_port_supported().

But I'll leave it to Jiri and Dave to decide if its worth a respin :)
Functionally I think this is okay.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

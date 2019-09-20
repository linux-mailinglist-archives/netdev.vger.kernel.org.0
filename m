Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A907B8E3C
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 12:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405970AbfITKFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 06:05:40 -0400
Received: from mx.cjr.nz ([51.158.111.142]:56130 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393354AbfITKFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 06:05:39 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 46FA580C01;
        Fri, 20 Sep 2019 10:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1568973936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ins2TSKeYgQuuE+zqzLA/MBqsHxtlvLHMg+kDG21zGY=;
        b=HQiIlFXvSGJ9bvFAHnEJa5A93NGyhuDVMhBAG1FLanJ9+yKTI0LazbNZFW6ApR3HAAfX9t
        e3RP4Y8t75bopox2k/lc4kpQyWFS0GvlQbC2vd6c2gq3zzZhLYqgkDQOFGNZCUCXFX70OK
        gQLQJBI9QH2/gKG8kZOIbKogYT5cie15o3hxgq8RrhTfY1fHH0zIUqCPR9XE01BDZSEq3l
        hmu5MLN5JiIz2zAD0IcDWU4fbdIkLBV9yF7QOctU+q9L8ihJnYaSxH8IcpR5a8ZCDDg7vD
        gAbl636P8ZgOIP1i4EPVW7vlR3VTi6iI0eG6qHlTKRgRA642YbvvWMs2s/Obiw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        "David S. Miller" <davem@davemloft.net>,
        Steve French <smfrench@gmail.com>
Cc:     Aurelien Aptel <aaptel@suse.com>
Subject: Re: [PATCH v2 1/3] cifs: Add support for root file systems
In-Reply-To: <20190919152116.27076-1-pc@cjr.nz>
References: <20190716220452.3382-1-paulo@paulo.ac>
 <20190919152116.27076-1-pc@cjr.nz>
Date:   Fri, 20 Sep 2019 07:04:06 -0300
Message-ID: <8736gr2six.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz;
        s=dkim; t=1568973936; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ins2TSKeYgQuuE+zqzLA/MBqsHxtlvLHMg+kDG21zGY=;
        b=d5hvI/vrK5+fjiRA3B6UvBReH0gSktp65GgjBG11y05GGTgctQp+sey17Utou6dJmkFG/d
        LPA52E458xYgbVpnALCwU/kBuj5ZVFHt0KtWqgfjUc0ajgDMqZtczVztP+bB1p+bsKxuOZ
        fSl9MIqzs8Z4ADD6FCY9KaRevFT6lCEm99fsok46dHzjfhr35R5ZRx42C19Lzw+Z5v/vRz
        H8lk+e0F64VcgnDFGwBqse1xnwK1d88DIuLzLQgLeWKD0fvdfEm4Fq9DDPIlsD5Ala3UoE
        6EPfEuznXiCSV2hJNR/Eu831wqsMM5Xl5zLjmy79w7ld5bwwdyvbT2G+6NIdtw==
ARC-Seal: i=1; s=dkim; d=cjr.nz; t=1568973936; a=rsa-sha256; cv=none;
        b=eM0lxNtzOEjwskAm5TldDSBc1eqyNpVHMoqait7Y3FeAXIJ3wjcgaDCIFQCgPQEOnXkeAK
        ZjynmpkDE6c8bGTX6UxxBDacrr7t0zLVPx7atc6e7mGojetcAl+FdKN7QPzc6tpasdFHBC
        FU8S2DJOiQrnxmYFic/GOqMc8Itgnx5JpBM2snkGsiFCss3bVzJap8ZhT5EtFojIr1dv6j
        Jv5V6LWBAznuELZuAfQMbsn28WYXmEloXX9KAADuMfBMi0fdhqmaKQz8yMo5DBwy9Fhm/I
        zEMPPN3wioqU2PtB9Hpr/AmRXGSOb21Z6WLxpU6cflr4gn9Cyhfo8X/hh3y9Jg==
ARC-Authentication-Results: i=1;
        mx.cjr.nz;
        auth=pass smtp.auth=pc smtp.mailfrom=pc@cjr.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:

> Introduce a new CONFIG_CIFS_ROOT option to handle root file systems
> over a SMB share.
>
> In order to mount the root file system during the init process, make
> cifs.ko perform non-blocking socket operations while mounting and
> accessing it.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  Documentation/filesystems/cifs/cifsroot.txt | 97 +++++++++++++++++++++
>  fs/cifs/Kconfig                             |  8 ++
>  fs/cifs/Makefile                            |  2 +
>  fs/cifs/cifsglob.h                          |  2 +
>  fs/cifs/cifsroot.c                          | 94 ++++++++++++++++++++
>  fs/cifs/connect.c                           | 17 +++-
>  include/linux/root_dev.h                    |  1 +
>  7 files changed, 218 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/filesystems/cifs/cifsroot.txt
>  create mode 100644 fs/cifs/cifsroot.c

Hi David,

This patch has already been merged into Linus tree. The other two (2/3
and 3/3) still need to be reviewed.

I'm not sure how this works when series touch multiple subsystems --
that is, these changes should go through your tree or Steve's?

Please let me you know if you need anything else.

Thanks!
Paulo

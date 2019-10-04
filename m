Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54D5CC624
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbfJDW4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfJDW4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 18:56:44 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 704A021D81
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 22:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570229803;
        bh=iYyHcIx0kYHXnvPcEbvF8D+TbfHIfcOMsp5S5dWCz7E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T+05Fe7hqv/Y4jgra5VYgz6bnHro8FIo1ToqnHyGR5wNjghx/yzGoysWYFN8WomK5
         6Lt1L6A6BtfYHC+rbtekxpySnN0qg0liRkaywnuEwnn027imNFLA85sKNhmGbSXkS/
         y3yTjyok8Tzho1c6HOePAwJxVNyJa4h5uF5GDloM=
Received: by mail-qt1-f182.google.com with SMTP id c3so10753539qtv.10
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 15:56:43 -0700 (PDT)
X-Gm-Message-State: APjAAAXeAgyod1w/h4gQz3G0/tlYrZHb42+C8VTu0dvYnsEqp1WAnDcx
        9qgmYebmdWPUxZJxFu7lYZZqfug1Z356o+cLvSk=
X-Google-Smtp-Source: APXvYqxoSii7SkgV3GqQdzrogMHINVTWXbVwqgt786jbHpYvN7oGZBCZqVT6DIm5J2X7eDS7uzxAGnmOGmGt4Db3Nc4=
X-Received: by 2002:a0c:a5a5:: with SMTP id z34mr16648398qvz.110.1570229802571;
 Fri, 04 Oct 2019 15:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190923215610.7905-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190923215610.7905-1-jeffrey.t.kirsher@intel.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Fri, 4 Oct 2019 18:56:31 -0400
X-Gmail-Original-Message-ID: <CA+5PVA7Zb-+1gMAyovo3Xd=VKKE58zkneYnNwt6A+tV3HWBkcg@mail.gmail.com>
Message-ID: <CA+5PVA7Zb-+1gMAyovo3Xd=VKKE58zkneYnNwt6A+tV3HWBkcg@mail.gmail.com>
Subject: Re: [linux-firmware][pull request] ice: Add package file for Intel
 E800 series driver
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>, sassmann@redhat.com,
        poswald@suse.com, Andrew Bowers <andrewx.bowers@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 5:56 PM Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
>
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
>
> The ice driver must load a package file to the firmware to utilize full
> functionality; add the package file to /lib/firmware/intel/ice/ddp. Also
> add a symlink, ice.pkg, so the driver can refer to the package by a
> consistent name.
>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> The following are changes since commit 417a9c6e197a8d3eec792494efc87a2b42f76324:
>   amdgpu: add initial navi10 firmware
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/firmware dev-queue
>
>  LICENSE.ice                   |  39 ++++++++++++++++++++++++++++++++++
>  WHENCE                        |   9 ++++++++
>  intel/ice/ddp/ice-1.3.4.0.pkg | Bin 0 -> 577796 bytes
>  intel/ice/ddp/ice.pkg         |   1 +
>  4 files changed, 49 insertions(+)
>  create mode 100644 LICENSE.ice
>  create mode 100644 intel/ice/ddp/ice-1.3.4.0.pkg
>  create mode 120000 intel/ice/ddp/ice.pkg

Thanks.  I added another commit on top to remove the symlink and fix
the WHENCE file because we merged a commit that changes how symlinks
are handled.  All applied and pushed out.

josh

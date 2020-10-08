Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB75287D25
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgJHUa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730429AbgJHUa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602189057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=lgT/Pao2dhRy7r2cOmOSyyn/G9gLMf1e4iWJG7ETJJY=;
        b=M2zZYYdJ5+q+9TleHTorYoPeLeaQ/nhamfBEfqyigEje8LU5drjh6BmyAOpV+aVx+XGfx5
        4X5eo7mbSVR9yA90vRjWjRWEHmxQ2cbzdo/DTxpi6Zpzcz8AAm2aKKC+kqTyQq6Ut6F14D
        hzjlO1nKEtxYHCUWWHgT5KogDayU0CQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-OUUmGZirOvqVOOmU4MOAJw-1; Thu, 08 Oct 2020 16:30:55 -0400
X-MC-Unique: OUUmGZirOvqVOOmU4MOAJw-1
Received: by mail-wm1-f69.google.com with SMTP id b20so4442668wmj.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=lgT/Pao2dhRy7r2cOmOSyyn/G9gLMf1e4iWJG7ETJJY=;
        b=XFyktQ76+I8W9lJ4dh+W+MfpkCgCiwvrULsJiaUb3j77PwAKXnj9YMwQwwNC1W2fWh
         qaqXrboGFEfTQXssQLvf59azRYx9kfaQ9CLYaEtTKqJAtxGB7aqYenvZE7m8U0kkfANP
         Ny7JB+Y/9NgSxXwqPpw/79z1F9ntBn/QWFDfRMF2FDqtPhQsQCe6sBeHkKVNaAVayqX0
         /IzOnD7ZIaCLwP+p+fKRC6obne6E+bLbTn4Qz/NQjJ6upMl6h/HIAOW/ViLBWqiCVrQ6
         68Ne5OZ++jwDxl5+gfAV+UkSX8y123DXhuiLGyYFjtpvm7uMB7faQ1yUrWRpv1toEREE
         nE1A==
X-Gm-Message-State: AOAM531TdJp1StBtJJYmT7H8D88z6hUxEKvOP6RTpwgKKCLJO/yapm8a
        2Cfp90eZbb92e8iYWG5FN1F4U3WBlOgNl63SigQSBfs/1iNGndX4GdVQqTs/06QhXhwxlDKnn+a
        QgrEuelWtTHMOQ0xa
X-Received: by 2002:a7b:c305:: with SMTP id k5mr10972363wmj.102.1602189054221;
        Thu, 08 Oct 2020 13:30:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz39hXz1Of1vVfE+ExLOVbu6aOgDjiquQ4GfgQ/XcsmEw8zvuDHbrPJdW4dVAvGz1TOUqEloQ==
X-Received: by 2002:a7b:c305:: with SMTP id k5mr10972350wmj.102.1602189054015;
        Thu, 08 Oct 2020 13:30:54 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id a81sm9549014wmf.32.2020.10.08.13.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:30:53 -0700 (PDT)
Date:   Thu, 8 Oct 2020 16:30:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, groug@kaod.org, jasowang@redhat.com,
        lkp@intel.com, michael.christie@oracle.com, mst@redhat.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org
Subject: [GIT PULL] vhost,vdpa: last minute fixes
Message-ID: <20201008163051-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit a127c5bbb6a8eee851cbdec254424c480b8edd75:

  vhost-vdpa: fix backend feature ioctls (2020-09-24 05:54:36 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to aff90770e54cdb40228f2ab339339e95d0aa0c9a:

  vdpa/mlx5: Fix dependency on MLX5_CORE (2020-10-08 16:02:00 -0400)

----------------------------------------------------------------
vhost,vdpa: last minute fixes

Some last minute fixes. The last two of them haven't been in next but
they do seem kind of obvious, very small and safe, fix bugs reported in
the field, and they are both in a new mlx5 vdpa driver, so it's not like
we can introduce regressions.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Fix dependency on MLX5_CORE

Greg Kurz (3):
      vhost: Don't call access_ok() when using IOTLB
      vhost: Use vhost_get_used_size() in vhost_vring_set_addr()
      vhost: Don't call log_access_ok() when using IOTLB

Mike Christie (1):
      vhost vdpa: fix vhost_vdpa_open error handling

Si-Wei Liu (3):
      vhost-vdpa: fix vhost_vdpa_map() on error condition
      vhost-vdpa: fix page pinning leakage in error path
      vdpa/mlx5: should keep avail_index despite device status

 drivers/vdpa/Kconfig              |   7 +--
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  20 ++++--
 drivers/vhost/vdpa.c              | 127 +++++++++++++++++++++++---------------
 drivers/vhost/vhost.c             |  33 +++++++---
 4 files changed, 117 insertions(+), 70 deletions(-)


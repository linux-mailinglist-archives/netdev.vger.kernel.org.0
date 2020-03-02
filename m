Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E2B175F92
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCBQ2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:28:03 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36920 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgCBQ2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:28:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id q8so495899wrm.4
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 08:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uNu7eEit1yf3M2N9Tj6w1CyhzehwyypTd8FthDbQqQE=;
        b=WSaCz+FZ6OmLg3Ps65oQvX3SfW9CyzmjpB4PwUlAtbkYeplS1tRMtNPOdwVWZUiiAj
         te0d7OWUbiR+Th9bufRM/xDYpTYLrmf0HePTB7IEnv/Twe/bMuC0aiMRK/+qPoeHdd1/
         OdPN+IqAfCRvkN0/B6Qk+gzYAKq03f9/J759oxz3nfzhFShKBlYRddV9kuyShu9/ZgXL
         ZktUxnx1zoJa6s83Bx9cVHNmF3hIhp0ROYJ210HUmRnqdIYAAHc3UUGmXI5b6WJTdSSA
         Vsf6xUJYDIpfewjBrzr0nsUvg/VD4Mh9V6voe/GYm1Gol1y5unBriamF5EeEmqnRSbm5
         qyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uNu7eEit1yf3M2N9Tj6w1CyhzehwyypTd8FthDbQqQE=;
        b=HXJNbAYVt5f5pZfFSoZq6gIKXCaWo6l4Fczi6PmqHKyWvwq5IrJlFnFiswCR/Mzyyk
         yV8Nh6vunMoOyElXupmbYBLLYPw0QRzdQ0vJuUyRunnNpeZXqO1WqfaIY+8Dejxw0hqt
         FDaR/VUO9HVYamdKKeeK3JbrsSyrMXQJdjXorEOfg9gT6LEI03r6EM0myZ3IJTN2mUjl
         4Y5FtMdgBdp5JB8aNrp+QYQj4Hv8GpQ71pd73MeTQ71Me5dC1L6Omn8iSZ2OXmAAMsZs
         7csmdC80nfiKqEw3R/oCPiwtXcy8VYl/PpWP2GAZ1KUhc0btyN74ghRXgq4CiX09GNoL
         hK0A==
X-Gm-Message-State: ANhLgQ3QxeiEgZ9W1PHEejX9L/zVaMyIJRQJJG4+jd2oNOHb0MXhjHma
        PJiswfQrGNvA3tt5NK4yGME1fg==
X-Google-Smtp-Source: ADFU+vvYMdCCpiyUyYHOS1PTatH1OwBVv9tx17RsHgbatuyhgXSeUVtOGYQaPeFKZty6SwMiDHMrPg==
X-Received: by 2002:a5d:69cb:: with SMTP id s11mr362684wrw.47.1583166480378;
        Mon, 02 Mar 2020 08:28:00 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id f16sm19666134wrx.25.2020.03.02.08.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 08:27:59 -0800 (PST)
Date:   Mon, 2 Mar 2020 17:27:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 00/22] devlink region updates
Message-ID: <20200302162758.GA2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:21:59AM CET, jacob.e.keller@intel.com wrote:
>This is a second revision of the previous RFC series I sent to enable two
>new devlink region features.
>
>The original series can be viewed on the list archives at
>
>https://lore.kernel.org/netdev/20200130225913.1671982-1-jacob.e.keller@intel.com/
>
>Overall, this series can be broken into 5 phases:
>
> 1) implement basic devlink support in the ice driver, including .info_get
> 2) convert regions to use the new devlink_region_ops structure
> 3) implement support for DEVLINK_CMD_REGION_NEW
> 4) implement support for directly reading from a region
> 5) use these new features in the ice driver for the Shadow RAM region

Hmm. I think it is better to push this in multiple patchsets. For example,
for 1) you don't really need RFC as it is only related to the ice driver
implementing the existing API.


>
>(1) comprises 6 patches for the ice driver that add the devlink framework
>and cleanup a few places in the code in preparation for the new region.
>
>(2) comprises 2 patches which convert regions to use the new
>devlink_region_ops structure, and additionally move the snapshot destructor
>to a region operation.
>
>(3) comprises 6 patches to enable supporting the DEVLINK_CMD_REGION_NEW
>operation. This replaces what was previously the
>DEVLINK_CMD_REGION_TAKE_SNAPSHOT, as per Jiri's suggestion. The new
>operation supports specifying the requested id for the snapshot. To make
>that possible, first snapshot id management is refactored to use an IDR.
>Note that the extra complexity of the IDR is necessary in order to maintain
>the ability for the snapshot IDs to be generated so that multiple regions
>can use the same ID if triggered at the same time.
>
>(4) comprises 6 patches for modifying DEVLINK_CMD_REGION_READ so that it
>accepts a request without a snapshot id. A new region operation is defined
>for regions to optionally support the requests. The first few patches
>refactor and simplify the functions used so that adding the new read method
>reuses logic where possible.
>
>(5) finally comprises a single patch to implement a region for the ice
>device hardware's Shadow RAM contents.
>
>Note that I plan to submit the ice patches through the Intel Wired LAN list,
>but am sending the complete set here as an RFC in case there is further
>feedback, and so that reviewers can have the correct context.
>
>I expect to get further feedback this RFC revision, and will hopefully send
>the patches as non-RFC following this, if feedback looks good. Thank you for
>the diligent review.
>
>Changes since v1:

Per-patch please. This is no good for review :/


>
>* reword some comments and variable names in the ice driver that used the
>  term "page" to use the term "sector" to avoid confusion with the PAGE_SIZE
>  of the system.
>* Fixed a bug in the ice_read_flat_nvm function due to misusing the last_cmd
>  variable
>* Remove the devlinkm* functions and just use devm_add_action in the ice
>  driver for managing the devlink memory similar to how the PF memory was
>  managed by the devm_kzalloc.
>* Fix typos in a couple of function comments in ice_devlink.c
>* use dev_err instead of dev_warn for an error case where the main VSI can't
>  be found.
>* Only call devlink_port_type_eth_set if the VSI has a netdev
>* Move where the devlink_port is created in the ice_probe flow
>* Update the new ice.rst documentation for info versions, providing more
>  clear descriptions of the parameters. Give examples for each field as
>  well. Squash the documentation additions into the relevant patches.
>* Add a new patch to the ice driver which renames some variables referring
>  to the Option ROM version.
>* keep the string constants in the mlx4 crdump.c file, converting them to
>  "const char * const" so that the compiler understands they can be used in
>  constant initializers.
>* Add a patch to convert snapshot destructors into a region operation
>* Add a patch to fix a trivial typo in a devlink function comment
>* Use __ as a prefix for static internal functions instead of a _locked
>  suffix.
>* Refactor snapshot id management to use an IDR.
>* Implement DEVLINK_CMD_REGION_NEW of DEVLINK_CMD_REGION_TAKE_SNAPSHOT
>* Add several patches which refactor devlink_nl_cmd_region_snapshot_fill
>* Use the new cb_ and cb_priv parameters to implement what was previously
>  a separate function called devlink_nl_cmd_region_direct_fill
>
>Jacob Keller (21):
>  ice: use __le16 types for explicitly Little Endian values
>  ice: create function to read a section of the NVM and Shadow RAM
>  ice: enable initial devlink support
>  ice: rename variables used for Option ROM version
>  ice: add basic handler for devlink .info_get
>  ice: add board identifier info to devlink .info_get
>  devlink: prepare to support region operations
>  devlink: convert snapshot destructor callback to region op
>  devlink: trivial: fix tab in function documentation
>  devlink: add functions to take snapshot while locked
>  devlink: convert snapshot id getter to return an error
>  devlink: track snapshot ids using an IDR and refcounts
>  devlink: implement DEVLINK_CMD_REGION_NEW
>  netdevsim: support taking immediate snapshot via devlink
>  devlink: simplify arguments for read_snapshot_fill
>  devlink: use min_t to calculate data_size
>  devlink: report extended error message in region_read_dumpit
>  devlink: remove unnecessary parameter from chunk_fill function
>  devlink: refactor region_read_snapshot_fill to use a callback function
>  devlink: support directly reading from region memory
>  ice: add a devlink region to dump shadow RAM contents
>
>Jesse Brandeburg (1):
>  ice: implement full NVM read from ETHTOOL_GEEPROM
>
> .../networking/devlink/devlink-region.rst     |  20 +-
> Documentation/networking/devlink/ice.rst      |  87 ++++
> Documentation/networking/devlink/index.rst    |   1 +
> drivers/net/ethernet/intel/Kconfig            |   1 +
> drivers/net/ethernet/intel/ice/Makefile       |   1 +
> drivers/net/ethernet/intel/ice/ice.h          |   6 +
> .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   3 +
> drivers/net/ethernet/intel/ice/ice_common.c   |  85 +---
> drivers/net/ethernet/intel/ice/ice_common.h   |  10 +-
> drivers/net/ethernet/intel/ice/ice_devlink.c  | 360 ++++++++++++++
> drivers/net/ethernet/intel/ice/ice_devlink.h  |  17 +
> drivers/net/ethernet/intel/ice/ice_ethtool.c  |  44 +-
> drivers/net/ethernet/intel/ice/ice_main.c     |  23 +-
> drivers/net/ethernet/intel/ice/ice_nvm.c      | 354 +++++++------
> drivers/net/ethernet/intel/ice/ice_nvm.h      |  12 +
> drivers/net/ethernet/intel/ice/ice_type.h     |  17 +-
> drivers/net/ethernet/mellanox/mlx4/crdump.c   |  32 +-
> drivers/net/netdevsim/dev.c                   |  41 +-
> include/net/devlink.h                         |  38 +-
> net/core/devlink.c                            | 465 ++++++++++++++----
> .../drivers/net/netdevsim/devlink.sh          |  15 +
> 21 files changed, 1257 insertions(+), 375 deletions(-)
> create mode 100644 Documentation/networking/devlink/ice.rst
> create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.c
> create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.h
>
>-- 
>2.25.0.368.g28a2d05eebfb
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8E21B213F
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgDUIQH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 04:16:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:45624 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgDUIQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:16:06 -0400
IronPort-SDR: 6JrmxbE9NwThM+Q45CjODXzd3vGJv0K9Smov1/0SIP4IM2rTPMNtr6nYI9cjIWEfBHKTNE9gVi
 WL8Wnm3T/jbA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 01:16:02 -0700
IronPort-SDR: 8nUKFyHXy1Pskhs/mHLqd1HlKc/128kEtxuW+Y92U7ZCRuzBwzqZwzMiW3022po2E74MD4JzaV
 GYLulULvPnyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="279556242"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga004.fm.intel.com with ESMTP; 21 Apr 2020 01:16:01 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 01:16:00 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.85]) with mapi id 14.03.0439.000;
 Tue, 21 Apr 2020 01:16:00 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>
Subject: RE: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-04-20
Thread-Topic: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-04-20
Thread-Index: AQHWF7M+ytg6HKzOoEituinftxWI0KiDOHUA
Date:   Tue, 21 Apr 2020 08:15:59 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449866D71D@ORSMSX112.amr.corp.intel.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Sent: Tuesday, April 21, 2020 01:02
> To: davem@davemloft.net; gregkh@linuxfoundation.org
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org;
> linux-rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> jgg@ziepe.ca; parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> louis.bossart@linux.intel.com
> Subject: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver Updates
> 2020-04-20
> 
> This series contains the initial implementation of the Virtual Bus, virtbus_device,
> virtbus_driver, updates to 'ice' and 'i40e' to use the new Virtual Bus.
> 
> The primary purpose of the Virtual bus is to put devices on it and hook the
> devices up to drivers.  This will allow drivers, like the RDMA drivers, to hook up
> to devices via this Virtual bus.
> 
> This series currently builds against net-next tree.
> 
> Revision history:
> v2: Made changes based on community feedback, like Pierre-Louis's and
>     Jason's comments to update virtual bus interface.
[Kirsher, Jeffrey T] 

David Miller, I know we have heard from Greg KH and Jason Gunthorpe on the patch
series and have responded accordingly, I would like your personal opinion on the
patch series.  I respect your opinion and would like to make sure we appease all the
maintainers and users involved to get this accepted into the 5.8 kernel.

> 
> The following are changes since commit
> 82ebc889091a488b4dd95e682b3c3b889a50713c:
>   qed: use true,false for bool variables and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE
> 
> Dave Ertman (7):
>   Implementation of Virtual Bus
>   ice: Create and register virtual bus for RDMA
>   ice: Complete RDMA peer registration
>   ice: Support resource allocation requests
>   ice: Enable event notifications
>   ice: Allow reset operations
>   ice: Pass through communications to VF
> 
> Shiraz Saleem (2):
>   i40e: Move client header location
>   i40e: Register a virtbus device to provide RDMA
> 
>  Documentation/driver-api/virtual_bus.rst      |   62 +
>  MAINTAINERS                                   |    1 +
>  drivers/bus/Kconfig                           |   10 +
>  drivers/bus/Makefile                          |    2 +
>  drivers/bus/virtual_bus.c                     |  279 ++++
>  drivers/infiniband/hw/i40iw/Makefile          |    1 -
>  drivers/infiniband/hw/i40iw/i40iw.h           |    2 +-
>  drivers/net/ethernet/intel/Kconfig            |    2 +
>  drivers/net/ethernet/intel/i40e/i40e.h        |    2 +-
>  drivers/net/ethernet/intel/i40e/i40e_client.c |  133 +-
>  drivers/net/ethernet/intel/ice/Makefile       |    1 +
>  drivers/net/ethernet/intel/ice/ice.h          |   15 +
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   33 +
>  drivers/net/ethernet/intel/ice/ice_common.c   |  206 ++-
>  drivers/net/ethernet/intel/ice/ice_common.h   |    9 +
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   68 +
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    3 +
>  .../net/ethernet/intel/ice/ice_hw_autogen.h   |    1 +
>  drivers/net/ethernet/intel/ice/ice_idc.c      | 1327 +++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_idc_int.h  |  105 ++
>  drivers/net/ethernet/intel/ice/ice_lib.c      |   50 +
>  drivers/net/ethernet/intel/ice/ice_lib.h      |    4 +
>  drivers/net/ethernet/intel/ice/ice_main.c     |  104 +-
>  drivers/net/ethernet/intel/ice/ice_sched.c    |   69 +-
>  drivers/net/ethernet/intel/ice/ice_switch.c   |   27 +
>  drivers/net/ethernet/intel/ice/ice_switch.h   |    4 +
>  drivers/net/ethernet/intel/ice/ice_type.h     |    4 +
>  .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   59 +-
>  include/linux/mod_devicetable.h               |    8 +
>  .../linux/net/intel}/i40e_client.h            |   15 +
>  include/linux/net/intel/iidc.h                |  337 +++++
>  include/linux/virtual_bus.h                   |   53 +
>  scripts/mod/devicetable-offsets.c             |    3 +
>  scripts/mod/file2alias.c                      |    7 +
>  34 files changed, 2942 insertions(+), 64 deletions(-)  create mode 100644
> Documentation/driver-api/virtual_bus.rst
>  create mode 100644 drivers/bus/virtual_bus.c  create mode 100644
> drivers/net/ethernet/intel/ice/ice_idc.c
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
>  rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h
> (94%)  create mode 100644 include/linux/net/intel/iidc.h  create mode 100644
> include/linux/virtual_bus.h
> 
> --
> 2.25.3


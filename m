Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2879731581A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhBIUxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbhBIUmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:42:07 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D0BC0611C1
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 12:41:23 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id m17so9702723ioy.4
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 12:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XnQUO4pOsP4g9Wad8O8navplAd/zC0BPiCjdS0yinCY=;
        b=LvtMsMIzZLKax1/X6Z1jm22j3WC5BBIq7q/3rL3pLb8wBBZqb1A1MHt58B1IR0nYkB
         9qn8wrQ9QT6uI2H52wt7VLmOYdK9QxONWscg3I4Bxz+ajHr1X3Y2fTGaXm4Cc+L80E/W
         TbAFMOQaUjhtjVZWwjIZn0q5bwtJq/FsOK9tZE5XKvLijZOAs40vXxxM3JyOKwDzOXgv
         n+dWD9g0pz8z6cGWv43LoILnLqlxs3sLyMITKDo9123dlptX8rREKVrt+ZtUeCalVbVG
         XIUzVSLBbfAahjLKaPCybZKkv8FQWdQwUic1a8GyF1dwnvzvfc5LS+rEk62MR49FXq2k
         PzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XnQUO4pOsP4g9Wad8O8navplAd/zC0BPiCjdS0yinCY=;
        b=TSbcbmfOnrM4eTC80kli6c4Q7DuxUDykgiMmDstqsqvGB/zYJSuroscl5/BhScOSih
         MaUtXyO1/EPtrblVTQsksjZMW516dYddlE0MtPMhK+Ti3iOVK2F21t3RQ2mbc9KiqLVm
         SSFu8Z9FF4TWt+uGgWqxSWHlYiwA7nCHDFsQYbiTYO/BnRT8nB3sYOWkKhc6pMJV3UK7
         LhpfkCciXMBfgZ6sm17HwE8b9IeM8+bmRsNV6rHiAfUDOzDryfos6m7D5bf+yMhjp0Hc
         BpI75BH6u7WDZWWKXLVF9MVnNObgNK5Lp6JhBlGfeW55SmCDC6UYONT4MF6/DMpzMdVq
         yWSw==
X-Gm-Message-State: AOAM532q4G1ZnKbDO7DosZ8dR/wGrpuMNamvaoUpoxW1aj8IvTWCypsQ
        260rKMxh2N32+DlLbTqHwX9aqF95wh5aC7q3fNo=
X-Google-Smtp-Source: ABdhPJyIlzyeVqoIeL6/97/nLCfMClhfJfruiQEFt/E9iPaViy/IsB2Rwj294j9MCBSMfEEGDPlrT323sk9NGNIimmk=
X-Received: by 2002:a5d:9343:: with SMTP id i3mr2897838ioo.138.1612903283370;
 Tue, 09 Feb 2021 12:41:23 -0800 (PST)
MIME-Version: 1.0
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 9 Feb 2021 12:41:12 -0800
Message-ID: <CAKgT0UfcCnuTHp_anBATVNqU+vYbLJFcEE9vi3+=29Z=CaZbUw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN
 Driver Updates 2021-02-08
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 5:19 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> This series contains updates to the ice driver and documentation.
>
> Brett adds a log message when a trusted VF goes in and out of promiscuous
> for consistency with i40e driver.
>
> Dave implements a new LLDP command that allows adding VSI destinations to
> existing filters and adds support for netdev bonding events, current
> support is software based.
>
> Michal refactors code to move from VSI stored xsk_buff_pools to
> netdev-provided ones.
>
> Kiran implements the creation scheduler aggregator nodes and distributing
> VSIs within the nodes.
>
> Ben modifies rate limit calculations to use clock frequency from the
> hardware instead of using a hardcoded one.
>
> Jesse adds support for user to control writeback frequency.
>
> Chinh refactors DCB variables out of the ice_port_info struct.
>
> Bruce removes some unnecessary casting.
>
> Mitch fixes an error message that was reported as if_up instead of if_down.
>
> Tony adjusts fallback allocation for MSI-X to use all given vectors instead
> of using only the minimum configuration and updates documentation for
> the ice driver.
>
> The following are changes since commit 08cbabb77e9098ec6c4a35911effac53e943c331:
>   Merge tag 'mlx5-updates-2021-02-04' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
>
> Ben Shelton (1):
>   ice: Use PSM clock frequency to calculate RL profiles
>
> Brett Creeley (1):
>   ice: log message when trusted VF goes in/out of promisc mode
>
> Bruce Allan (1):
>   ice: remove unnecessary casts
>
> Chinh T Cao (1):
>   ice: Refactor DCB related variables out of the ice_port_info struct
>
> Dave Ertman (2):
>   ice: implement new LLDP filter command
>   ice: Add initial support framework for LAG
>
> Jesse Brandeburg (1):
>   ice: fix writeback enable logic
>
> Kiran Patil (1):
>   ice: create scheduler aggregator node config and move VSIs
>
> Michal Swiatkowski (1):
>   ice: Remove xsk_buff_pool from VSI structure
>
> Mitch Williams (1):
>   ice: Fix trivial error message
>
> Tony Nguyen (2):
>   ice: Improve MSI-X fallback logic
>   Documentation: ice: update documentation
>
>  .../device_drivers/ethernet/intel/ice.rst     | 1027 ++++++++++++-
>  drivers/net/ethernet/intel/ice/Makefile       |    1 +
>  drivers/net/ethernet/intel/ice/ice.h          |   52 +-
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   25 +
>  drivers/net/ethernet/intel/ice/ice_common.c   |   58 +-
>  drivers/net/ethernet/intel/ice/ice_common.h   |    3 +
>  drivers/net/ethernet/intel/ice/ice_controlq.c |    4 +-
>  drivers/net/ethernet/intel/ice/ice_dcb.c      |   40 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   47 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |   50 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |   14 +-
>  .../net/ethernet/intel/ice/ice_flex_pipe.c    |   10 +-
>  .../net/ethernet/intel/ice/ice_hw_autogen.h   |    3 +
>  drivers/net/ethernet/intel/ice/ice_lag.c      |  445 ++++++
>  drivers/net/ethernet/intel/ice/ice_lag.h      |   87 ++
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  142 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |   87 +-
>  drivers/net/ethernet/intel/ice/ice_sched.c    | 1283 +++++++++++++++--
>  drivers/net/ethernet/intel/ice/ice_sched.h    |   24 +-
>  drivers/net/ethernet/intel/ice/ice_switch.c   |    2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |   61 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |    1 -
>  drivers/net/ethernet/intel/ice/ice_type.h     |   27 +-
>  .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   72 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c      |   71 +-
>  25 files changed, 3234 insertions(+), 402 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_lag.c
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_lag.h
>

I looked over the patch set and it seems good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01F334CB1E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhC2InX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhC2Iml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:42:41 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E1C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:42:40 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e7so13257469edu.10
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mB59Sn+mDYRXkhWpiVMqAk9pbJgYvIBEJ4blPOXzWrg=;
        b=NAYyBsoLaptD7W+O0F1DPgMK27P5HZYxl3zV04tvj2hSA9hXGidkoI8Gt58qq5a6U3
         pZn0vVnSHjj54PYOLmLuSQ8rDCKpDXgyzv3Ifk9V4zb9UhYCZN2EAeebfKVkI4ZP0f15
         gxgvtz/cBqJyhfh1Oe0VM7PVdpNFWnMtq8+dpqyl2/JlznvxYeETOeTs++tJqPXAH84U
         oU6VhJJ2j+oek4sReP4T5Tmv0YAkqyOaig3RNTs+jw/pz3P7FiZ+BQp1sepx+JsnZ8Ke
         xa48t8wOuz0Jgh4vj4PvY8eZt6pnYkvUCgxSkm3ZAF8MP8/ferlRgEZV2m+nqjBjOnLT
         NDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mB59Sn+mDYRXkhWpiVMqAk9pbJgYvIBEJ4blPOXzWrg=;
        b=RVyxaTgLxbtiBWf44KUNQMhNwYLNn8QsWylnA4D18DTMvQ/leA1xjtzKsV5i0lNc8d
         H0IZ5j7xyThFF13OXs+4toUVvsE+bkw9qjn1rS7R46wOaHkIdBE1WTmzZsdbVZshPVvS
         c0L6ctpLS/8fvrdwLsNik46l+dhOotjbzmlNr2ZeONOVj1C0ZwCYULMjv4/20zLIJuZf
         sYJ3mAf6xQqo4Eej7Nd6grlotV0/cIxXWzzDf3DVCRa2dJQHS4qU7G17KNAI72rJG89f
         73vChhEkVcl7CPQcxGJGHRH/cnzkcru+PNOnKgigIi7jEkcFwHPDwC3pvnwJ4A5JWMRc
         EBGw==
X-Gm-Message-State: AOAM530QHS0DWto7wDDMSXIoVwyzAw6tF2/EqliKpdD/xL5nIC5mBH2F
        OzvCjD39rxMt5AptERs4xKfTg7Ntdje1L8E8YCjKT8G9TruJ6Q==
X-Google-Smtp-Source: ABdhPJyIvkYr+ryqimL3OEJOO2dLLTOwsbXYdWdpwIPYPsw99ppnQnxOZYBmclQg4ywbnnLE9dEBwpPjifN6UEQuBLE=
X-Received: by 2002:a50:eb97:: with SMTP id y23mr27706337edr.170.1617007359448;
 Mon, 29 Mar 2021 01:42:39 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6auY6ZKn5rWp?= <gaojunhao0504@gmail.com>
Date:   Mon, 29 Mar 2021 16:42:27 +0800
Message-ID: <CAOJPZgkLvkhN4+_OCLPyWBiXPRc=qLYa3b5jyz63dkn7GQA2Uw@mail.gmail.com>
Subject: esp-hw-offload support for VF of NVIDIA Mellanox ConnectX-6 Ethernet
 Adapter Cards
To:     borisp@nvidia.com, saeedm@nvidia.com
Cc:     netdev@vger.kernel.org, seven.wen@ucloud.cn, junhao.gao@ucloud.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris,Saeed

     I'm enabling esp-hw-offload for VF of NVIDIA Mellanox ConnectX-6
Ethernet Adapter Cards, but it doesn't work.
     Before I created VF, the esp-hw-offload function of CX-6 is on,
after I created VF, the esp-hw-offload function of VF doesn't inherit
the esp-hw-offload function of CX-6.
     Enable esp-hw-offload could refer to
https://docs.mellanox.com/display/OFEDv522200/IPsec+Crypto+Offload.

     Create VF steps as follows:
     modprobe mlx5_core
     echo 2 > /sys/class/net/net2/device/sriov_numvfs
     # lspci to get pci bdf number(example:0000:07:00.0)
     lspci -nn | grep Mellanox
     echo 0000:07:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
     echo 0000:07:00.3 > /sys/bus/pci/drivers/mlx5_core/unbind
     /etc/init.d/mst start
     mcra /dev/mst/mt4119_pciconf0  0x31500.17  0
     devlink dev eswitch set pci/0000:07:00.0  mode switchdev encap enable
     echo 0000:07:00.2 > /sys/bus/pci/drivers/mlx5_core/bind
     echo 0000:07:00.3 > /sys/bus/pci/drivers/mlx5_core/bind

     Then query the esp-hw-offload of VF:
     #firstly need to find the created VF(has the properties:
     bus-info: 0000:07:00.2, driver: mlx5_core)
     ethtool -i eth0 | grep esp-hw-offload
     esp-hw-offload: off [fixed]

Best Regards,
Junhao

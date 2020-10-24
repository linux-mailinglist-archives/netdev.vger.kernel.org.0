Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FA1297CCB
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761985AbgJXOZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 10:25:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760049AbgJXOZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 10:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603549515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKPZFZI6PsM50gCd4zIkNHztcKC9O1bw2iGPoIRNKZU=;
        b=NoZIWYLP03zP19wyUVQlGOUubYAxnpz6c8yviO83ecP5H0dpIYTtNip1X2hEwOx9YzNqTj
        NsfhYWFJeNydMj76UrCWlBirX7+3tmJOHYJKFP2ZxXmWBOE1ulf4ZNYUiBYahuXyjwso7Z
        /H7M1zInbokY4tbt3CCE2JquL3tGUaE=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-_8GI6Rz4PIiZ44qDTatjpA-1; Sat, 24 Oct 2020 10:25:13 -0400
X-MC-Unique: _8GI6Rz4PIiZ44qDTatjpA-1
Received: by mail-oi1-f198.google.com with SMTP id n62so3221522oig.9
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 07:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iKPZFZI6PsM50gCd4zIkNHztcKC9O1bw2iGPoIRNKZU=;
        b=gmDuZpOnxygnzAnN5g1ZOkSqntlshECp503u6xY8laZCY7fVwFfHoYNtfg8r6CZm58
         K+0FazdUxW+uZMB/Vqyx3IwbcW90074RHVDdl1Ra7hDi1XkZOAYNLonqXf0jHgoQBQtk
         qfm5PFBEHOmsOpd3orNI9CFWGVPy4jRboGgABnpLewdPW4hZ01S++2K7DS1Uw31fE5Nj
         dyc7Gm/Mr6UxB5yrxCyuPXrDsVJAxiI5SMSHOUvNPudAIjyXkxrpvUv6riNk1/47K2VG
         3rJ7lH2PFopZOloHAJSSJYw6imxtnaB52DMdlTvRVBfjpmV4p7d/0WuVdW0qSz9cv0Wo
         TyIg==
X-Gm-Message-State: AOAM530+VlQm+GefCydfYm8ADJfOdz4GbF2820eS2EwxQhZYcXThrgsb
        iYmIFbjZGDzhiryMeWZ/oFHNb/D+F4LxTUCivlrcYcAbskh/dvqG8xQFJMQrLMOgaU5cM4tx0W1
        AHZPqZN1E2FNCys1u
X-Received: by 2002:a05:6830:12d9:: with SMTP id a25mr281081otq.168.1603549512874;
        Sat, 24 Oct 2020 07:25:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnY6+X0dcjISR/TyARnEutbJFGSZZh039Hq9UbwtBpMmAJPhuG4H5cMdOkS//S1FWjTzGdiw==
X-Received: by 2002:a05:6830:12d9:: with SMTP id a25mr281064otq.168.1603549512571;
        Sat, 24 Oct 2020 07:25:12 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id g16sm1306936ooe.20.2020.10.24.07.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 07:25:11 -0700 (PDT)
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether
 Group driver
To:     Xu Yilun <yilun.xu@intel.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        mdf@kernel.org, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, lgoncalv@redhat.com, hao.wu@intel.com
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <a37c40ce-0160-10d6-e809-2aa501369f5d@redhat.com>
Date:   Sat, 24 Oct 2020 07:25:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/23/20 1:45 AM, Xu Yilun wrote:
> This patch adds the document for DFL Ether Group driver.
>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> ---
>  .../networking/device_drivers/ethernet/index.rst   |   1 +
>  .../ethernet/intel/dfl-eth-group.rst               | 102 +++++++++++++++++++++
>  2 files changed, 103 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst
>
> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
> index cbb75a18..eb7c443 100644
> --- a/Documentation/networking/device_drivers/ethernet/index.rst
> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
> @@ -26,6 +26,7 @@ Contents:
>     freescale/gianfar
>     google/gve
>     huawei/hinic
> +   intel/dfl-eth-group
>     intel/e100
>     intel/e1000
>     intel/e1000e
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst b/Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst
> new file mode 100644
> index 0000000..525807e
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst
> @@ -0,0 +1,102 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +
> +=======================================================================
> +DFL device driver for Ether Group private feature on Intel(R) PAC N3000
> +=======================================================================
> +
> +This is the driver for Ether Group private feature on Intel(R)
> +PAC (Programmable Acceleration Card) N3000.
> +
> +The Intel(R) PAC N3000 is a FPGA based SmartNIC platform for multi-workload
> +networking application acceleration. A simple diagram below to for the board:
> +
> +                     +----------------------------------------+
> +                     |                  FPGA                  |
> ++----+   +-------+   +-----------+  +----------+  +-----------+   +----------+
> +|QSFP|---|retimer|---|Line Side  |--|User logic|--|Host Side  |---|XL710     |
> ++----+   +-------+   |Ether Group|  |          |  |Ether Group|   |Ethernet  |
> +                     |(PHY + MAC)|  |wiring &  |  |(MAC + PHY)|   |Controller|
> +                     +-----------+  |offloading|  +-----------+   +----------+
> +                     |              +----------+              |
> +                     |                                        |
> +                     +----------------------------------------+
> +
> +The FPGA is composed of FPGA Interface Module (FIM) and Accelerated Function
> +Unit (AFU). The FIM implements the basic functionalities for FPGA access,
> +management and reprograming, while the AFU is the FPGA reprogramable region for
> +users.
> +
> +The Line Side & Host Side Ether Groups are soft IP blocks embedded in FIM. They
The Line Side and Host Side Ether Groups are soft IP blocks embedded in the FIM.
> +are internally wire connected to AFU and communicate with AFU with MAC packets.
are internally connected to the AFU and communicate with the AFU using MAC packets
> +The user logic is developed by the FPGA users and re-programmed to AFU,
The user logic is application dependent, supplied by the FPGA developer and used to reprogram the AFU.
> +providing the user defined wire connections between line side & host side data
between Line Side and Host Side
> +interfaces, as well as the MAC layer offloading.
> +
> +There are 2 types of interfaces for the Ether Groups:
> +
> +1. The data interfaces connects the Ether Groups and the AFU, host has no
The data interface which connects
> +ability to control the data stream . So the FPGA is like a pipe between the
> +host ethernet controller and the retimer chip.
> +
> +2. The management interfaces connects the Ether Groups to the host, so host
The management interface which connects
> +could access the Ether Group registers for configuration and statistics
> +reading.
> +
> +The Intel(R) PAC N3000 could be programmed to various configurations (with
N3000 can be
> +different link numbers and speeds, e.g. 8x10G, 4x25G ...). It is done by
This is done
> +programing different variants of the Ether Group IP blocks, and doing
> +corresponding configuration to the retimer chips.
programming different variants of the Ether Group IP blocks and retimer configuration.
> +
> +The DFL Ether Group driver registers netdev for each line side link. Users
registers a netdev
> +could use standard commands (ethtool, ip, ifconfig) for configuration and
> +link state/statistics reading. For host side links, they are always connected
> +to the host ethernet controller, so they should always have same features as
> +the host ethernet controller. There is no need to register netdevs for them.
> +The driver just enables these links on probe.
> +
> +The retimer chips are managed by onboard BMC (Board Management Controller)
> +firmware, host driver is not capable to access them directly. So it is mostly

firmware. The host driver

So it behaves like

> +like an external fixed PHY. However the link states detected by the retimer
> +chips can not be propagated to the Ether Groups for hardware limitation, in
Limitations should get there own section, this is going off on tangent.
> +order to manage the link state, a PHY driver (intel-m10-bmc-retimer) is
> +introduced to query the BMC for the retimer's link state. The Ether Group
> +driver would connect to the PHY devices and get the link states. The
> +intel-m10-bmc-retimer driver creates a peseudo MDIO bus for each board, so
> +that the Ether Group driver could find the PHY devices by their peseudo PHY
> +addresses.
> +
> +
> +2. Features supported
> +=====================
> +
> +Data Path
> +---------
> +Since the driver can't control the data stream, the Ether Group driver
> +doesn't implement the valid tx/rx functions. Any transmit attempt on these
> +links from host will be dropped, and no data could be received to host from
links from the host will be dropped.  (you can assume a dropped link will not have data and shorten the sentence)
> +these links. Users should operate on the netdev of host ethernet controller
> +for networking data traffic.
> +
> +
> +Speed/Duplex
> +------------
> +The Ether Group doesn't support auto-negotiation. The link speed is fixed to
does not
> +10G, 25G or 40G full duplex according to which Ether Group IP is programmed.
> +
> +Statistics
> +----------
> +The Ether Group IP has the statistics counters for ethernet traffic and errors.
> +The user can obtain these MAC-level statistics using "ethtool -S" option.
> +
> +MTU
> +---
> +The Ether Group IP is capable of detecting oversized packets. It will not drop
> +the packet but pass it up and increment the tx/rx oversize counters. The MTU
but will pass it and
> +could be changed via ip or ifconfig commands.
> +
> +Flow Control
> +------------
> +Ethernet Flow Control (IEEE 802.3x) can be configured with ethtool to enable
> +transmitting pause frames. Receiving pause request from outside to Ether Group

pausing tx frames. Receiving a pause

Tom

> +MAC is not supported. The flow control auto-negotiation is not supported. The
> +user can enable or disable Tx Flow Control using "ethtool -A eth? tx <on|off>"


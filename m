Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9825FE59
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 00:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfGDWHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 18:07:52 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42780 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDWHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 18:07:52 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so3360343pgb.9
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 15:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rx71tEPMtZ/3OLDOg1j9gVLszMiBkI3r/N+rnnsealk=;
        b=FPWjPG/ZqnRyxkE50jLxEqhxCyMSqTmixLHnpZ+alpbcP8g3U3w+fJiCSgPLl6apAF
         6V+DRYR1VT9Cug0GhushWRxIEz13riYQUMlFlzy2avFIpMT0C56wedqX0XbncgYjGDwu
         sHEG3SJPVVVgTqYwoT83BiuhKUz3CNvVQ9R3opVEF/DDy3is2prEl8cH1WapYP0gCDWX
         9ZYmyxzExxw+S/o4CR8LkHO2srRQqf3v3iaGT/Y/NGoC9teKc20KjULxkFRNr8g8ZLFE
         NQBqLwq7Jw2EUqcGtvHAgBIKjSD0VurFW9g3qubPKlLmyH4wkPxcTyLXINtnKJwAQ7H9
         nHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rx71tEPMtZ/3OLDOg1j9gVLszMiBkI3r/N+rnnsealk=;
        b=cA7Mupf9hq5mxE6hgJgaMCR9o1ZZ5hdqPw1a6DANkDVnChZ+3xqgWVOFFJZXW0lSEA
         UApAYQT3XJdNYUQvhtLsuee4GjmeSF/FeHLiwqYnXGnHigK5FkkGpkvCcjhuV4LE494m
         B0xIOW66ztR9ySUKKli58aXeAz0vq6UOXJME3XSu4DZfP2wxIpZti8LlOHQpqoEsL2Aj
         ygxwhcw3RK/zXjpdBY0pTx/hkVKg3EwlCWMMyqiX+LJz2Kj+K6gHZ3F8DIBvzG/9uke0
         zoMTBvwqemDdWf8ccMaFHvYkhLZcWA3pT6hhs6qOtRxsmxN0oeUrEWnRijrcsfOMJr+A
         3NsA==
X-Gm-Message-State: APjAAAX6cOQSQoZugIWEk+CnRCJXfIAGYHUKn8MFnUMipORxpawAIaLB
        EjTSJcQn2n/WXQcW0LoYVLMUaTd3OJw=
X-Google-Smtp-Source: APXvYqzb3outZ8MCVu6ZTXCYQd158kS6XWpGJ8/FwM8d2IMiMaXlU75Szhb1JmEgwcEdkuek9YTV0g==
X-Received: by 2002:a65:5248:: with SMTP id q8mr670683pgp.259.1562278071721;
        Thu, 04 Jul 2019 15:07:51 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id w132sm8238609pfd.78.2019.07.04.15.07.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 15:07:51 -0700 (PDT)
Date:   Thu, 4 Jul 2019 15:07:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <mkalderon@marvell.com>, <aelior@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v2 4/4] qed*: Add devlink support for
 configuration attributes.
Message-ID: <20190704150747.05fd63f4@cakuba.netronome.com>
In-Reply-To: <20190704132011.13600-5-skalluru@marvell.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
        <20190704132011.13600-5-skalluru@marvell.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 06:20:11 -0700, Sudarsana Reddy Kalluru wrote:
> This patch adds implementation for devlink callbacks for reading and
> configuring the device attributes.
> 
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
>  Documentation/networking/devlink-params-qede.txt |  72 ++++++++
>  drivers/net/ethernet/qlogic/qed/qed_main.c       |  38 +++++
>  drivers/net/ethernet/qlogic/qede/qede.h          |   3 +
>  drivers/net/ethernet/qlogic/qede/qede_devlink.c  | 202 ++++++++++++++++++++++-
>  drivers/net/ethernet/qlogic/qede/qede_devlink.h  |  23 +++
>  include/linux/qed/qed_if.h                       |  16 ++
>  6 files changed, 353 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/networking/devlink-params-qede.txt
> 
> diff --git a/Documentation/networking/devlink-params-qede.txt b/Documentation/networking/devlink-params-qede.txt
> new file mode 100644
> index 0000000..f78a993
> --- /dev/null
> +++ b/Documentation/networking/devlink-params-qede.txt
> @@ -0,0 +1,72 @@
> +enable_sriov		[DEVICE, GENERIC]
> +			Configuration mode: Permanent
> +
> +iwarp_cmt		[DEVICE, DRIVER-SPECIFIC]
> +			Enable iWARP support over 100G device (CMT mode).
> +			Type: Boolean
> +			Configuration mode: runtime
> +
> +entity_id		[DEVICE, DRIVER-SPECIFIC]
> +			Set the entity ID value to be used for this device
> +			while reading/configuring the devlink attributes.
> +			Type: u8
> +			Configuration mode: runtime

Can you explain what this is?

> +device_capabilities	[DEVICE, DRIVER-SPECIFIC]
> +			Set the entity ID value to be used for this device
> +			while reading/configuring the devlink attributes.
> +			Type: u8
> +			Configuration mode: runtime

Looks like you copied the previous text here.

> +mf_mode			[DEVICE, DRIVER-SPECIFIC]
> +			Configure Multi Function mode for the device.
> +			Supported MF modes and the assoicated values are,
> +			    MF allowed(0), Default(1), SPIO4(2), NPAR1.0(3),
> +			    NPAR1.5(4), NPAR2.0(5), BD(6) and UFP(7)

NPAR should have a proper API in devlink port, what are the other modes?

> +			Type: u8
> +			Configuration mode: Permanent
> +
> +dcbx_mode		[PORT, DRIVER-SPECIFIC]
> +			Configure DCBX mode for the device.
> +			Supported dcbx modes are,
> +			    Disabled(0), IEEE(1), CEE(2) and Dynamic(3)
> +			Type: u8
> +			Configuration mode: Permanent

Why is this a permanent parameter?

> +preboot_oprom		[PORT, DRIVER-SPECIFIC]
> +			Enable Preboot Option ROM.
> +			Type: Boolean
> +			Configuration mode: Permanent

This should definitely not be a driver specific toggle.

> +preboot_boot_protocol	[PORT, DRIVER-SPECIFIC]
> +			Configure preboot Boot protocol.
> +			Possible values are,
> +			    PXE(0), iSCSI Boot(3), FCoE Boot(4) and NONE(7)
> +			Type: u8
> +			Configuration mode: Permanent

Ditto.

> +preboot_vlan		[PORT, DRIVER-SPECIFIC]
> +			Preboot VLAN.
> +			Type: u16
> +			Configuration mode: Permanent
> +
> +preboot_vlan_value	[PORT, DRIVER-SPECIFIC]
> +			Configure Preboot VLAN value.
> +			Type: u16
> +			Configuration mode: Permanent

And these.

> +mba_delay_time		[PORT, DRIVER-SPECIFIC]
> +			Configure MBA Delay Time. Supported range is [0-15].
> +			Type: u8
> +			Configuration mode: Permanent
> +
> +mba_setup_hot_key	[PORT, DRIVER-SPECIFIC]
> +			Configure MBA setup Hot Key. Possible values are,
> +			Ctrl S(0) and Ctrl B(1).
> +			Type: u8
> +			Configuration mode: Permanent
> +
> +mba_hide_setup_prompt	[PORT, DRIVER-SPECIFIC]
> +			Configure MBA hide setup prompt.
> +			Type: Boolean
> +			Configuration mode: Permanent

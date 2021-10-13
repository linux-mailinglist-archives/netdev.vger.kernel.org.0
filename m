Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05A342CDEE
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhJMWaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhJMWaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:30:18 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A941C061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:28:14 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id m20so1506133iol.4
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gnPT1e5VwLELPDXI4dmuSv1PvGNh6xffkBKkxsoEnaM=;
        b=OPcEZosUd5Osd/tyii9CZBYzRaF4diQLBlnbe4bGEtKJg09TuxWDnz9IFCh9LeGoxw
         yaPhgvMjKUhyRAc2OBl4sVSEFIlIwxHi7RE9CN7Ryh07dK/bq5zl/vMhYVxubd6vH2+F
         ls4Cdwxs6DJz8cx+buzwvPKwXmR6BDnpCn6xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gnPT1e5VwLELPDXI4dmuSv1PvGNh6xffkBKkxsoEnaM=;
        b=b7r92yAsU96ezOeqv7lJT4qPX45+4f2nRlZqJN917g81MlPzBAO5lflGcdrubFXEJt
         nMZF5aHZ4mBVC1zxGL585PslSd8uh1APDBSTddfk3NhcgaMI7arx7tskExjV1/ajib+6
         cNkS3L0GL70q/a20afBwngRDuW7WxYCekDzZCpHdIKeF0c0OVJv4KW7lEyAA6SIbormw
         V+QcxxDFUy/QKQHiLiPXuYsOQQSwdVDplv70qLeSjNY9M3l/Sr54febkGPACKJwZb2fz
         XC47lf9Uw8cCLl97gSg5GpqXGCA2i/0YsVpkBG4nUWDIFDi7yjKiWIZ3/eR3aoBk+TVI
         /cBg==
X-Gm-Message-State: AOAM531nmXQhRtZCufL5HSf+yHwjbXprw05Q38i8jehpkwFajfW+bkTO
        8JTbyhZsr/8wnq/ipAu0rrO8OIIzbBSsIQ==
X-Google-Smtp-Source: ABdhPJzLV9ys/LdquBJceUAfrXKbfNMAROvLDngM4GbY6zNnD8D2ULXda6CAtcblebX3zmjAGpLbbg==
X-Received: by 2002:a6b:6b08:: with SMTP id g8mr1530025ioc.199.1634164093560;
        Wed, 13 Oct 2021 15:28:13 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id m25sm374434iol.1.2021.10.13.15.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:27:44 -0700 (PDT)
Subject: Re: [RFC PATCH 00/17] net: ipa: Add support for IPA v2.x
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <09719f6e-a886-68b8-3fb9-cc0a92db41af@ieee.org>
Date:   Wed, 13 Oct 2021 17:27:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:07 PM, Sireesh Kodali wrote:
> Hi,
> 
> This RFC patch series adds support for IPA v2, v2.5 and v2.6L
> (collectively referred to as IPA v2.x).

I'm sorry for the delay on this.  I want to give this a
reasonable review, but it's been hard to prioritize doing
so.  So for now I aim to give you some "easy" feedback,
knowing that this doesn't cover all issues.  This is an
RFC, after all...

So this isn't a "real review" but I'll try to be helpful.

Overall, I appreciate how well you adhered to the patterns and
conventions used elsewhere in the driver.  There are many levels
to that, but I think consistency is a huge factor in keeping
code maintainable.  I didn't see all that many places where
I felt like whining about naming you used, or oddities in
indentation, and so on.

Abstracting the GSI layer seemed to be done more easily than
I expected.  I didn't dive deep into the BAM code, and would
want to pay much closer attention to that in the future.

The BAM/GSI difference is the biggest one dividing IPA v3.0+
from its predecessors.  But as you see, the 32- versus 64-bit
address and field size differences lead to some ugliness
that's hard to avoid.

Anyway, nice work; I hope my feedback is helpful.

					-Alex

> Basic description:
> IPA v2.x is the older version of the IPA hardware found on Qualcomm
> SoCs. The biggest differences between v2.x and later versions are:
> - 32 bit hardware (the IPA microcontroler is 32 bit)
> - BAM (as opposed to GSI as a DMA transport)
> - Changes to the QMI init sequence (described in the commit message)
> 
> The fact that IPA v2.x are 32 bit only affects us directly in the table
> init code. However, its impact is felt in other parts of the code, as it
> changes the size of fields of various structs (e.g. in the commands that
> can be sent).
> 
> BAM support is already present in the mainline kernel, however it lacks
> two things:
> - Support for DMA metadata, to pass the size of the transaction from the
>    hardware to the dma client
> - Support for immediate commands, which are needed to pass commands from
>    the driver to the microcontroller
> 
> Separate patch series have been created to deal with these (linked in
> the end)
> 
> This patch series adds support for BAM as a transport by refactoring the
> current GSI code to create an abstract uniform API on top. This API
> allows the rest of the driver to handle DMA without worrying about the
> IPA version.
> 
> The final thing that hasn't been touched by this patch series is the IPA
> resource manager. On the downstream CAF kernel, the driver seems to
> share the resource code between IPA v2.x and IPA v3.x, which should mean
> all it would take to add support for resources on IPA v2.x would be to
> add the definitions in the ipa_data.
> 
> Testing:
> This patch series was tested on kernel version 5.13 on a phone with
> SDM625 (IPA v2.6L), and a phone with MSM8996 (IPA v2.5). The phone with
> IPA v2.5 was able to get an IP address using modem-manager, although
> sending/receiving packets was not tested. The phone with IPA v2.6L was
> able to get an IP, but was unable to send/receive packets. Its modem
> also relies on IPA v2.6l's compression/decompression support, and
> without this patch series, the modem simply crashes and restarts,
> waiting for the IPA block to come up.
> 
> This patch series is based on code from the downstream CAF kernel v4.9
> 
> There are some things in this patch series that would obviously not get
> accepted in their current form:
> - All IPA 2.x data is in a single file
> - Some stray printks might still be around
> - Some values have been hardcoded (e.g. the filter_map)
> Please excuse these
> 
> Lastly, this patch series depends upon the following patches for BAM:
> [0]: https://lkml.org/lkml/2021/9/19/126
> [1]: https://lkml.org/lkml/2021/9/19/135
> 
> Regards,
> Sireesh Kodali
> 
> Sireesh Kodali (10):
>    net: ipa: Add IPA v2.x register definitions
>    net: ipa: Add support for using BAM as a DMA transport
>    net: ipa: Add support for IPA v2.x commands and table init
>    net: ipa: Add support for IPA v2.x endpoints
>    net: ipa: Add support for IPA v2.x memory map
>    net: ipa: Add support for IPA v2.x in the driver's QMI interface
>    net: ipa: Add support for IPA v2 microcontroller
>    net: ipa: Add IPA v2.6L initialization sequence support
>    net: ipa: Add hw config describing IPA v2.x hardware
>    dt-bindings: net: qcom,ipa: Add support for MSM8953 and MSM8996 IPA
> 
> Vladimir Lypak (7):
>    net: ipa: Correct ipa_status_opcode enumeration
>    net: ipa: revert to IPA_TABLE_ENTRY_SIZE for 32-bit IPA support
>    net: ipa: Refactor GSI code
>    net: ipa: Establish ipa_dma interface
>    net: ipa: Check interrupts for availability
>    net: ipa: Add timeout for ipa_cmd_pipeline_clear_wait
>    net: ipa: Add support for IPA v2.x interrupts
> 
>   .../devicetree/bindings/net/qcom,ipa.yaml     |   2 +
>   drivers/net/ipa/Makefile                      |  11 +-
>   drivers/net/ipa/bam.c                         | 525 ++++++++++++++++++
>   drivers/net/ipa/gsi.c                         | 322 ++++++-----
>   drivers/net/ipa/ipa.h                         |   8 +-
>   drivers/net/ipa/ipa_cmd.c                     | 244 +++++---
>   drivers/net/ipa/ipa_cmd.h                     |  20 +-
>   drivers/net/ipa/ipa_data-v2.c                 | 369 ++++++++++++
>   drivers/net/ipa/ipa_data-v3.1.c               |   2 +-
>   drivers/net/ipa/ipa_data-v3.5.1.c             |   2 +-
>   drivers/net/ipa/ipa_data-v4.11.c              |   2 +-
>   drivers/net/ipa/ipa_data-v4.2.c               |   2 +-
>   drivers/net/ipa/ipa_data-v4.5.c               |   2 +-
>   drivers/net/ipa/ipa_data-v4.9.c               |   2 +-
>   drivers/net/ipa/ipa_data.h                    |   4 +
>   drivers/net/ipa/{gsi.h => ipa_dma.h}          | 179 +++---
>   .../ipa/{gsi_private.h => ipa_dma_private.h}  |  46 +-
>   drivers/net/ipa/ipa_endpoint.c                | 188 ++++---
>   drivers/net/ipa/ipa_endpoint.h                |   6 +-
>   drivers/net/ipa/ipa_gsi.c                     |  18 +-
>   drivers/net/ipa/ipa_gsi.h                     |  12 +-
>   drivers/net/ipa/ipa_interrupt.c               |  36 +-
>   drivers/net/ipa/ipa_main.c                    |  82 ++-
>   drivers/net/ipa/ipa_mem.c                     |  55 +-
>   drivers/net/ipa/ipa_mem.h                     |   5 +-
>   drivers/net/ipa/ipa_power.c                   |   4 +-
>   drivers/net/ipa/ipa_qmi.c                     |  37 +-
>   drivers/net/ipa/ipa_qmi.h                     |  10 +
>   drivers/net/ipa/ipa_reg.h                     | 184 +++++-
>   drivers/net/ipa/ipa_resource.c                |   3 +
>   drivers/net/ipa/ipa_smp2p.c                   |  11 +-
>   drivers/net/ipa/ipa_sysfs.c                   |   6 +
>   drivers/net/ipa/ipa_table.c                   |  86 +--
>   drivers/net/ipa/ipa_table.h                   |   6 +-
>   drivers/net/ipa/{gsi_trans.c => ipa_trans.c}  | 182 +++---
>   drivers/net/ipa/{gsi_trans.h => ipa_trans.h}  |  78 +--
>   drivers/net/ipa/ipa_uc.c                      |  96 ++--
>   drivers/net/ipa/ipa_version.h                 |  12 +
>   38 files changed, 2133 insertions(+), 726 deletions(-)
>   create mode 100644 drivers/net/ipa/bam.c
>   create mode 100644 drivers/net/ipa/ipa_data-v2.c
>   rename drivers/net/ipa/{gsi.h => ipa_dma.h} (57%)
>   rename drivers/net/ipa/{gsi_private.h => ipa_dma_private.h} (66%)
>   rename drivers/net/ipa/{gsi_trans.c => ipa_trans.c} (80%)
>   rename drivers/net/ipa/{gsi_trans.h => ipa_trans.h} (71%)
> 


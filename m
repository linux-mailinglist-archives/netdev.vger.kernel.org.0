Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410192AC11E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgKIQmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:42:01 -0500
Received: from mail-ej1-f68.google.com ([209.85.218.68]:38365 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIQmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:42:00 -0500
Received: by mail-ej1-f68.google.com with SMTP id za3so13201371ejb.5;
        Mon, 09 Nov 2020 08:41:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ujpjlJ97w4LBR+Pnd8eyIdETkwyQryD31slWX4jQqCE=;
        b=sBv3Cf8W03PcDtd9VrNynwA83ryxhW3ksTUSsUxTfjVswf5pdZQILWGkR2oBmkZzFA
         OG/l09/YOpQM5KPyB/V8YRTiL7Yz+GNPBzXH+aN45CCFxlBjeGAI5beOWChK+2ypCzHU
         Ybw5tj1fqR5DbMO138OCAgCN21t96kvtrTr/j0hYXD/K5Bf1Mez1U+l08pFgstdyMi2H
         J2szejvX894Q/aVoKwvHmpPXSNhGmakYL2cOp4/2b/wCfeDano6ifn1pI/ALVvYzZ4bV
         nb7e22e7zRGyGAMk2HyM5IoFn+H8/DB19LIByoNDlI85TWfL31wUC2xbykOrDVO+ujM2
         1G/Q==
X-Gm-Message-State: AOAM533A+GCMbbgTH5dDSH3CCoXFDmdRqqlV9YbO+ROf2C5f0y/RoUtQ
        JMIuRdVTRo2rofwEXRq7FqE=
X-Google-Smtp-Source: ABdhPJzcaGkJsjB9w9JlX/w2LEYFW0rptQq19FiwHB5QJnt9C2Oo2XDrCELiId89J6u4L1rC2xHweQ==
X-Received: by 2002:a17:907:2712:: with SMTP id w18mr14881574ejk.130.1604940116998;
        Mon, 09 Nov 2020 08:41:56 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id d10sm9009186ejw.44.2020.11.09.08.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 08:41:56 -0800 (PST)
Date:   Mon, 9 Nov 2020 17:41:54 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     thierry.reding@gmail.com, jonathanh@nvidia.com,
        madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mperttunen@nvidia.com, tomeu.vizoso@collabora.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH V2] memory: tegra: add missing put_devcie() call in error
 path of tegra_emc_probe()
Message-ID: <20201109164154.GA211123@kozik-lap>
References: <20201102185216.GB13405@kozik-lap>
 <20201109132847.1738010-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201109132847.1738010-1-yukuai3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 09:28:47PM +0800, Yu Kuai wrote:
> The reference to device obtained with of_find_device_by_node() should
> be dropped. Thus add jump target to fix the exception handling for this
> function implementation.

You still need to correct the typo devcie->device in subject, as in v1.

> 
> Fixes: 73a7f0a90641("memory: tegra: Add EMC (external memory controller) driver")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/memory/tegra/tegra124-emc.c           | 21 +++++++++++++------
>  .../net/ethernet/freescale/fman/fman_port.c   |  3 +--

Changes in net are not related, please split... although actually I
think the issue is already fixed by 1f1997eb44b1 ("memory: tegra: Add
and use devm_tegra_memory_controller_get()").

Best regards,
Krzysztof


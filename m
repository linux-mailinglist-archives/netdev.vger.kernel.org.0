Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779FE214E5A
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgGESDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgGESDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:03:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F27C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 11:03:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b92so16018119pjc.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 11:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PvP5Nq3IgpsI9NOXWVGeclwBHRDzJdRbYoTrWsbR/ag=;
        b=Rv9GmC3s8LxEieXjez0gKZI9xuxiFtU5mto93CZ+fYsEP079wwXNfaIV8i+go31DyL
         gJQUogYuYdQLN9ndTM/zjtQNkJnJzTXZtyRVwmDrkbVjdzPQz3D0JUquC5Wxo1g7bg5n
         2HNwTY8eTxShxQV4D5IoBSSGi3MjIUpGD8SHC1RV6XlTIS23DY9MJVgIGpLSxT+el+9z
         a7E7eG/zYc4QeBXb0HCn2dxBo7Jzc3Y+kyfn4FftntI8kIvZ8BHUAM7wCovpC0aS2QVR
         fQuhdB1T0617u5+flc4oKJ1gKLzkwqy5/TLcw/cz8P2LPb3Kzke+3ni1KSdi8x9npcrw
         4dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PvP5Nq3IgpsI9NOXWVGeclwBHRDzJdRbYoTrWsbR/ag=;
        b=G41vDSSWgUEkTjMsWzFLcCy4cUNMu278nG4kwpgwoSPjg/2ecxM2z7FdWB/gyP/YpS
         NwkTEDibf1Gn+YvJDlNyEwuECdB1rkDWn74VR05bpKZmlkuGvs/ddgKb4pN9dy4F/ucN
         vegyjsKVJSDyrr/binDvSynDvl8ufvZVlKy6/LLHUtvR37Vty1e/USMggrQM2CboMqti
         Y7ghkA6nyvCeCKSYhHqXt6pwTSqkvHJx3GEQDohNrd0N71FR5cj6cKICk3Ikn0vyVho6
         q0WOja18XuhV3bkuImVP3THjjb5fAvT3iceJ6EdUPhIgNwMtuKdaaESVH++eweKLXkh1
         qL+w==
X-Gm-Message-State: AOAM532lxTH4VYWkCdf7wtILf6FDaxVnxR+OjXSzqqSFCFUqXWgcBjx/
        IuzC1CaWuOoPMW+SElNy2+EQqA==
X-Google-Smtp-Source: ABdhPJycdPEgC6AbP63kmOQQMf+RoHW/ixQSUL0PFypH72ki5xo3RXiGaHWY6h5hcRsr8qKUgXWWzw==
X-Received: by 2002:a17:902:8a96:: with SMTP id p22mr40096905plo.281.1593972190325;
        Sun, 05 Jul 2020 11:03:10 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w11sm17073342pfc.79.2020.07.05.11.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 11:03:10 -0700 (PDT)
Date:   Sun, 5 Jul 2020 11:03:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, kuba@kernel.org, michael.chan@broadcom.com
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to
 info subcommand.
Message-ID: <20200705110301.20baf5c2@hermes.lan>
In-Reply-To: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 13:13:04 +0530
Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:

> Add support for reading board serial_number to devlink info
> subcommand. Example:
> 
> $ devlink dev info pci/0000:af:00.0 -jp
> {
>     "info": {
>         "pci/0000:af:00.0": {
>             "driver": "bnxt_en",
>             "serial_number": "00-10-18-FF-FE-AD-1A-00",
>             "board.serial_number": "433551F+172300000",
>             "versions": {
>                 "fixed": {
>                     "board.id": "7339763 Rev 0.",
>                     "asic.id": "16D7",
>                     "asic.rev": "1"
>                 },
>                 "running": {
>                     "fw": "216.1.216.0",
>                     "fw.psid": "0.0.0",
>                     "fw.mgmt": "216.1.192.0",
>                     "fw.mgmt.api": "1.10.1",
>                     "fw.ncsi": "0.0.0.0",
>                     "fw.roce": "216.1.16.0"
>                 }
>             }
>         }
>     }
> }

Although this is valid JSON, many JSON style guides do not allow
for periods in property names. This is done so libraries can use
dot notation to reference objects.

Also the encoding of PCI is problematic



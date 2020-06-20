Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C83202380
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 14:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgFTMJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 08:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgFTMJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 08:09:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC7DC06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 05:09:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y20so11353894wmi.2
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 05:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AheN3R6ePWllHdGYdgPJIKfyYu+kFtN4E+iQw+iFxvk=;
        b=wDH+/kHqySwAY7htmEfa1Lot+ubYCSMlZ62E9RYviH3Bl/JaWDKS3zt0w+2FU0+Cm8
         n4ZlQsI0Z+LQ74jWRp5ungonjurFlDdRL4UqLwDNSa/SwqRURepTrqQDomNkLc7roYOl
         T9XLxENKF+On2ROZm2yerdUCejG5TtjcW8Lj6HwQ6inKrMLC/dZucuox5t4J/e24dDJR
         kqg4PapBr2ERqALUeN6PM+gvLkZTRfg9Ip2+/vYjwpDK9U5ug0tzg6mln4utf2aafSjV
         Kor3Wf92Fh+h+sYnVohxTg2dN2GvYh/DYQbNjH1Nv9d32nIj/8yqi0AxV09e85WftbD3
         P3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AheN3R6ePWllHdGYdgPJIKfyYu+kFtN4E+iQw+iFxvk=;
        b=rzZ4FnIrjqjUKfEZP0ymE/dIBcDWsE2nc8PxZ0KJxrhhXz7afYhIr+JG/0nft7WauX
         9wry0rgHLQ1WFEQ2dgw85kixcdiAaXzJsPQws0zl7HPznOVT+i+sqKN2uNonO9utq6gD
         BF+gti7eNVTkVSgd5KryjJ92+SlWkQYczjWPl7UVu4L5pOznHEg5oB2cCCLy0cm2iToK
         a8HU0roF9PCSQon0P2eUIuxrBC07a8IXMEFatdAa9KLQL0KlvrWc3oVdfvQGXf0VPN8N
         Suf+slf1c5+rSYd+5pce0jw1K2KmUx6Sv6eaN0Bu7mz2odaYRzpVC5yz1+9c0Kgs77Bt
         BKSw==
X-Gm-Message-State: AOAM53095HKPHv54GI24kUa+tKgXaCVlwXOjriaDOnYlUVYhIGeMnEv7
        l48QE97X7syXhd8yjHSpIfJbx7h0CHQ=
X-Google-Smtp-Source: ABdhPJy76ew0Hdne1WDieYAm75xtGJFUD1tUDIWrriQI/Va3uO05n+tqJrOSePf8ns1+rsRVel0bfQ==
X-Received: by 2002:a1c:6744:: with SMTP id b65mr8495874wmc.170.1592654990461;
        Sat, 20 Jun 2020 05:09:50 -0700 (PDT)
Received: from localhost (ip-94-113-156-94.net.upcbroadband.cz. [94.113.156.94])
        by smtp.gmail.com with ESMTPSA id a81sm10363222wmd.25.2020.06.20.05.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 05:09:49 -0700 (PDT)
Date:   Sat, 20 Jun 2020 14:09:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, kuba@kernel.org, jiri@mellanox.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 0/2] devlink: Add board_serial_number field to
 info_get cb.
Message-ID: <20200620120949.GA2748@nanopsycho>
References: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jun 20, 2020 at 10:15:45AM CEST, vasundhara-v.volam@broadcom.com wrote:
>This patchset adds support for board_serial_number to devlink info_get
>cb and also use it in bnxt_en driver.
>
>Sample output:
>
>$ devlink dev info pci/0000:af:00.1
>pci/0000:af:00.1:
>  driver bnxt_en
>  serial_number 00-10-18-FF-FE-AD-1A-00
>  board_serial_number 433551F+172300000
>  versions:
>      fixed:
>        board.id 7339763 Rev 0.

We have board.id already here. I understand that the serial number does
not belong under the same nest, as it is not a "version".

However, could you at least maintain the format:
board.serial_number
?


>        asic.id 16D7
>        asic.rev 1
>      running:
>        fw 216.1.216.0
>        fw.psid 0.0.0
>        fw.mgmt 216.1.192.0
>        fw.mgmt.api 1.10.1
>        fw.ncsi 0.0.0.0
>        fw.roce 216.1.16.0
>
>Vasundhara Volam (2):
>  devlink: Add support for board_serial_number to info_get cb.
>  bnxt_en: Add board_serial_number field to info_get cb
>
> Documentation/networking/devlink/devlink-info.rst | 12 +++++-------
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 +++++++
> include/net/devlink.h                             |  2 ++
> include/uapi/linux/devlink.h                      |  2 ++
> net/core/devlink.c                                |  8 ++++++++
> 5 files changed, 24 insertions(+), 7 deletions(-)
>
>-- 
>1.8.3.1
>

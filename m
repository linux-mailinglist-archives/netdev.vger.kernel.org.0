Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CB423A33B
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHCLWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHCLWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 07:22:06 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B535C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 04:22:06 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k8so15098929wma.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 04:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+WJMtF2OlQMecDYqTTcIAzjzLoooma9wylUIYUl+Blw=;
        b=zjg37dmbPSAnjkEN1PMV8tLx2VfgG+0jWZg6V1fhOSxf5Vq1lxpXj17sQo9N7sg3U5
         Y2OE25mlC3QpvLsn2jEKNMe1MZIOgTX3ffgP1XqoZrwVst4NX285MEzgvIx0h156WduZ
         Dk3Bk0FMpDDepvSFeaX/v6SYJPEY3/k6Ku5KWU1spLua4303sZ55YqyD/8H+OXy143xm
         D8y4LlzMyDu6mMB6JfUDHfv5/euIZ0QDlZ/A02CsYW9Ag03FVU9Cqa7JNJykgEdDH2R3
         QHwmCwVEb2CnU6FIy2W2YxyoywcFBPwxSeqNCtH/82xY6DyF9/3bgt12P75NnYygTy+y
         I6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+WJMtF2OlQMecDYqTTcIAzjzLoooma9wylUIYUl+Blw=;
        b=LqV1DVagGGoAAzioJOnkN5vHqFInkqXt4M332OnYm1We8skfkAXP4ELHT1QQqB31tJ
         VU6TCqbBe+bcMwwPLll6ttawsvSHAVwVu2m2ILLMtci9cpMgX3b41JloHP/WXjJLuhkE
         74v8+3pDFefkNZ329Rc9HdLPRiSk51xqmd4quORUk+PGQ8gBA6M/m4FY7csgpYjAvXuw
         XJTc2qMUw9WOWMkU6jR+u6hIgFEffuMRqlAcAMdMrLMVRAmEncxEwWM4x8JNKzKypvWD
         SMQECe5G66tN0D9YgFcKUh9ZpxiAEBpqBI+FuGaiNo3xEFnXfhzAmpjF2hnUYSg5MY9i
         s3jw==
X-Gm-Message-State: AOAM531ODXWe0bZmblvLHPx/pVl6vf1VDsCdE2qgUr6uriqdGl2OYmiH
        4Q1J6C6j++Z58oufhLH2CRwrWg==
X-Google-Smtp-Source: ABdhPJx3+IjX//eSKqoZ6vsDRt9UMx2JrH2LbC05mWU3WKgYRP4D6OW+AzzxhGnjWZuf9Lbw29s2Xw==
X-Received: by 2002:a1c:4e17:: with SMTP id g23mr15101855wmh.42.1596453725280;
        Mon, 03 Aug 2020 04:22:05 -0700 (PDT)
Received: from localhost (ip-89-176-225-97.net.upcbroadband.cz. [89.176.225.97])
        by smtp.gmail.com with ESMTPSA id a10sm24650498wro.35.2020.08.03.04.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 04:22:04 -0700 (PDT)
Date:   Mon, 3 Aug 2020 13:22:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, davem@davemloft.net, jiri@mellanox.com,
        kuba@kernel.org, michael.chan@broadcom.com
Subject: Re: [PATCH v3 iproute2-next] devlink: Add board.serial_number to
 info subcommand.
Message-ID: <20200803112203.GA2290@nanopsycho>
References: <20200731104643.35726-1-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731104643.35726-1-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 31, 2020 at 12:46:43PM CEST, vasundhara-v.volam@broadcom.com wrote:
>Add support for reading board serial_number to devlink info
>subcommand. Example:
>
>$ devlink dev info pci/0000:af:00.0 -jp
>{
>    "info": {
>        "pci/0000:af:00.0": {
>            "driver": "bnxt_en",
>            "serial_number": "00-10-18-FF-FE-AD-1A-00",
>            "board.serial_number": "433551F+172300000",
>            "versions": {
>                "fixed": {
>                    "board.id": "7339763 Rev 0.",
>                    "asic.id": "16D7",
>                    "asic.rev": "1"
>                },
>                "running": {
>                    "fw": "216.1.216.0",
>                    "fw.psid": "0.0.0",
>                    "fw.mgmt": "216.1.192.0",
>                    "fw.mgmt.api": "1.10.1",
>                    "fw.ncsi": "0.0.0.0",
>                    "fw.roce": "216.1.16.0"
>                }
>            }
>        }
>    }
>}
>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Looks fine.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

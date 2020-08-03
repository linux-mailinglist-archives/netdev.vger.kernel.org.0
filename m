Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A682523A983
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHCPh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCPh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:37:28 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EDBC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:37:28 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j187so35452361qke.11
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e5j3xReH1Pgas+a6d+na4JiIm84HdjWteh/C9jzhG6g=;
        b=ZWfzGGwb+z1g7/QRs81F5u4Q9KXkpDX2WKsQY4eavvQbxGXPoZxOjG2zOGy4VzuAZo
         y7xwjl4MG7SG6Vp2vasiWQ1GOZ1j8IAF/QWcSsFb3VRu2AcGbItwOex7S9XQ2R+PISHj
         qW03qTv87CoXRR1dJ5bgGJKPyo/7+Xk5Hw/0YzEBsgfBBo+AsqSGt6Wus/QKFFHGGkio
         1zMukz50kYY22CnQFnmJ52rNvlU2cEN9RPY+AKNlerWTnVZY7P1EimGJYMPwvM3qXfRu
         q4OQZZFEoBd0Vmzoq1GTCGM9y2JZKXshocLNa77A0/PpOMeqPznj13JOxkHz3ztT7USk
         hLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e5j3xReH1Pgas+a6d+na4JiIm84HdjWteh/C9jzhG6g=;
        b=nttjWbvukROHZKyjbhYxSAdO42eAwuiQSLEmOD59x00HFTXLbomwH2Eya3k/sI2eqd
         VMlnr1Tu+UvlCQt+NZHmm23mdkuRN+T/tsT3IZHeGHlbiw9lhwfj/5aBcAKDzzVJonSb
         wL2Za9jhGWbetd0MFN1clzxzyFkK+lypUeCMgCBVdn891pFDrxABXv+jzUpDuFWgH65x
         R6qBhPZc8RRNeULU2iZq/Wat4WOVfPLplnvRtRW68RkRWdH5RP4SyamyjYo2Mzad5si3
         l12q4LnXXqyZLj60OVHQhEbCd1/xSTYFBbUs78EWCha3Rea09ScfmEFhss87MtM9+vGj
         DpFw==
X-Gm-Message-State: AOAM531csOJKL8dfEgpNVyWJF4uKsHGnn7vLVPuh9R6pnZeR+0OAmG04
        OUTwJaIoXazDdAEaRlUjE/A=
X-Google-Smtp-Source: ABdhPJwKuWmm2t/JNxu6iv5fvB0M/JpkUJAQWo1wpM+iKM94acMlE4Hjp2APcZvoRMfqUM5C1uq6bQ==
X-Received: by 2002:a37:5dc6:: with SMTP id r189mr16303035qkb.364.1596469047608;
        Mon, 03 Aug 2020 08:37:27 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:989f:23de:f9a0:6da? ([2601:284:8202:10b0:989f:23de:f9a0:6da])
        by smtp.googlemail.com with ESMTPSA id z68sm20232726qke.113.2020.08.03.08.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 08:37:26 -0700 (PDT)
Subject: Re: [PATCH v3 iproute2-next] devlink: Add board.serial_number to info
 subcommand.
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        jiri@mellanox.com, kuba@kernel.org, michael.chan@broadcom.com
References: <20200731104643.35726-1-vasundhara-v.volam@broadcom.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c68cc5b7-2db3-a13d-88de-2f39b26c786a@gmail.com>
Date:   Mon, 3 Aug 2020 09:37:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200731104643.35726-1-vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 4:46 AM, Vasundhara Volam wrote:
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
> 
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> ---
> v2: Rebase. Resending the patch as I see this patch didn't make it to
> mailing list.
> v3: Rebase the patch and remove the line from commit message
> "This patch has dependency on updated include/uapi/linux/devlink.h file."
> as the headers are updated.
> ---
>  devlink/devlink.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

applied to iproute2-next


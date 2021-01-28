Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C728306C13
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhA1EPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhA1EPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:15:11 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83D5C061788
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:50:12 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id h6so4653551oie.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M5IAMukckoOUkpoFV9U2XcnqwX67tpK3wH18jBg8XN0=;
        b=drgxbgZQLp30JAeW7EvfYoxC1fEGqiLpNwIACZDFLi8+F1ezt9bnzCYW+fhB0JPwTN
         8XgxRNMMGqyHf/sXUnbxGnTDsyDDAtIiwNzEWkkkS9BQlUHi3ey/QBcjL8ln+Ny68DOx
         jZAEsNBB3CmMcTvctxujdP+/sAVeK+5Upse3YMpCRgNjWz3mOWsHxV25Q09v+qt1iptB
         kmVz+O+4YYfaQ2PqijUwVVxmkf6MZeygSHS2i+XTnvTBhXdT8PBz8CMmoCQFuj2+FsmR
         esp8sn2SufMQUchKhPDQCAfcLrhCmBxVpCSvjYPj/0UV9rIHUyxTHQHhjc4PF8sXo00I
         0IYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M5IAMukckoOUkpoFV9U2XcnqwX67tpK3wH18jBg8XN0=;
        b=geoOleZ9qVEfP0XVIQrzvOdyOwz5xaSGIoeV+9/CEWzHpl0X8U3aoHVn3u4l7XjE89
         SHP1h42gbuZXoxN6QbQ73RboxvVN/QgEtWGyeBtiSDODWwHdUYBTziXFhwEO1WANf/qC
         cwrsaUD+lQxF2QWsfcT5iRK1lbmnsJ5FnWWkOOKaQtTi0OV9dAolVAN3IrmSNA08sy8S
         byeOxrqbi0lRD5tV2xIsJiug/yX8XsBrzXe4U+w0fyytj4xMBNEnrab1yFjE0DshNXRz
         tcvVBGsmKTzG/H/4y8pScOXzwvEPDPhq+j1kT6z4H6Ue94HB0EJWuPO/s6Q2uwkRfklB
         xkRA==
X-Gm-Message-State: AOAM530qRi2piDdXg8Ohq1FFdT3qD2nGurmpfJ6W3Ko6zO3Zx2cJhv2A
        Xn9mS37IwqrORuoplsojaSc=
X-Google-Smtp-Source: ABdhPJzAyeZ3DC+b23xKpvgAYhx2cNCgACb+DAe5K8/KzA3PdRRTzH+O85BE3vmJyFPi+H+OItbVVg==
X-Received: by 2002:aca:7513:: with SMTP id q19mr5548457oic.115.1611805812269;
        Wed, 27 Jan 2021 19:50:12 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id s10sm867380ool.35.2021.01.27.19.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 19:50:11 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/1] rtnetlink: extend RTEXT_FILTER_SKIP_STATS
 to IFLA_VF_INFO
To:     Edwin Peer <edwin.peer@broadcom.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20210126174024.185001-1-edwin.peer@broadcom.com>
 <20210126174024.185001-2-edwin.peer@broadcom.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7427e82d-e19d-bfe6-03d1-7fdab3dfe26a@gmail.com>
Date:   Wed, 27 Jan 2021 20:50:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126174024.185001-2-edwin.peer@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 10:40 AM, Edwin Peer wrote:
> This filter already exists for excluding IPv6 SNMP stats. Extend its
> definition to also exclude IFLA_VF_INFO stats in RTM_GETLINK.
> 
> This patch constitutes a partial fix for a netlink attribute nesting
> overflow bug in IFLA_VFINFO_LIST. By excluding the stats when the
> requester doesn't need them, the truncation of the VF list is avoided.
> 
> While it was technically only the stats added in commit c5a9f6f0ab40
> ("net/core: Add drop counters to VF statistics") breaking the camel's
> back, the appreciable size of the stats data should never have been
> included without due consideration for the maximum number of VFs
> supported by PCI.
> 
> Fixes: 3b766cd83232 ("net/core: Add reading VF statistics through the PF netdevice")
> Fixes: c5a9f6f0ab40 ("net/core: Add drop counters to VF statistics")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> ---
>  net/core/rtnetlink.c | 96 +++++++++++++++++++++++---------------------
>  1 file changed, 51 insertions(+), 45 deletions(-)
> 

looks reasonable to me - userspace is opting out of data it does not want.


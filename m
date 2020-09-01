Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35802584ED
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 02:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgIAAsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 20:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgIAAsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 20:48:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E282AC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 17:48:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u128so1677184pfb.6
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 17:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+zV4krydJX1tlO+YSVi9DXxXBNSVtvY8gxj8fdpVosI=;
        b=b7wF6chx8xFum8uskxrQLaoGiQsPfp9/2XoX01qef9jbnFvls7I3SchToZX1wH+AYL
         OJT1SCfH2NP395USBh4+zV0MuLpcoSqgdJZnSxLFbIjaP7tJt3/9J0xerFo2m/BqtYbp
         48qWbUZzxX7VF/lippVY1GoDi0ujxJL7MxqY+kcwnewOxs2woW2qsAzdFes+bQYZ1DPV
         IngHNBcezoZqOcT58Rn2NHGE5bnwGFvdIzJgfS09ZFVDn42KpHyGvPpWewiy87iXA68E
         HO4a9netNRkGHlo+Gd729HzWO+RpWCpvk01bZ77VTyyfzMhu8canONgwhAdm6ywxz74c
         pDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+zV4krydJX1tlO+YSVi9DXxXBNSVtvY8gxj8fdpVosI=;
        b=Zh2ftjeu3H+VGbYXch6nJvIY1gxP7T1SMy6i0NJLzoAlpE3D9zNTHwyMO3Xlz2wh/E
         0/wfzHe9znrEfmbDmxxtf/n2CeSh1F14qag4k/WNHr/tnr3Dc+aPQlDP5uOMHq/r3cWK
         ZyWpPjdg37v/aPprmYtvujA/DRAjNfmCcs8N7PvlQht2W+lANfNjOPdlKfcInYyExl09
         Xv8pvUfcF6PFJsYHBW5Lq95jO+HZ2VV9u3lLoyUtMZvue4LvlmlgdfJS5BOqI3+DYCfG
         cbzoGxuo+B8WReFSNR8QHoXzOu4yPICThr+ekKEnMuz1VVpYOE0zxKSBeVRIfX/LlLcQ
         d6+g==
X-Gm-Message-State: AOAM5314MD7SCpBkFODrTnDGmBSH2jDBMLVW2hv7iUvrqDXUcuXmetTO
        +PajEI+JFrf18scuMOSFkvs=
X-Google-Smtp-Source: ABdhPJyhkFoVuezI4+aG47jUkrWRaBQvmrk9J9lkT85Bk46dm7ff+pC8qBPdDO6A/MAgtFiRMzYfSQ==
X-Received: by 2002:a63:ed01:: with SMTP id d1mr2248991pgi.58.1598921281900;
        Mon, 31 Aug 2020 17:48:01 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g9sm9399577pfr.172.2020.08.31.17.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 17:48:01 -0700 (PDT)
Subject: Re: [PATCH net-next 0/5] ionic: struct cleanups
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200831233558.71417-1-snelson@pensando.io>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <49f1ff16-c3e2-8bbf-e05c-8dc9328b2be1@gmail.com>
Date:   Mon, 31 Aug 2020 17:47:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200831233558.71417-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/2020 4:35 PM, Shannon Nelson wrote:
> This patchset has a few changes for better cacheline use,
> to cleanup a page handling API, and to streamline the
> Adminq/Notifyq queue handling.

Some other non technical changes, the changes that Neel in the 
Signed-off-by should also have a From that matches his Signed-off-by, or 
you should use Co-developped-by, or some variant of it.

> 
> Shannon Nelson (5):
>    ionic: clean up page handling code
>    ionic: smaller coalesce default
>    ionic: struct reorder for faster access
>    ionic: clean up desc_info and cq_info structs
>    ionic: clean adminq service routine
> 
>   drivers/net/ethernet/pensando/ionic/ionic.h   |  3 -
>   .../net/ethernet/pensando/ionic/ionic_dev.c   | 33 +-------
>   .../net/ethernet/pensando/ionic/ionic_dev.h   | 26 +++---
>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 44 +++++-----
>   .../net/ethernet/pensando/ionic/ionic_lif.h   | 14 ++--
>   .../net/ethernet/pensando/ionic/ionic_main.c  | 26 ------
>   .../net/ethernet/pensando/ionic/ionic_txrx.c  | 81 +++++++++++--------
>   7 files changed, 92 insertions(+), 135 deletions(-)
> 

-- 
Florian

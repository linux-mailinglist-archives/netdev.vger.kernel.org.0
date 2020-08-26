Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4354E252C5E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 13:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgHZLWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 07:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbgHZLV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 07:21:28 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FAFC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 04:21:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x9so1394117wmi.2
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 04:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SEDuZLoEMjEHog4pApJjNCMgFg9dzBqJXIk1pFgNb80=;
        b=tj1ZX9QaB4QGO9d4/spzrqx89NYfYamXLXhILYwshGhtiGjacdxXcGR/ehyTyM9sU/
         cH2MkkHG8d4hUjmtFhEUgcIrg/US6K/ZezMARZ3YETc2gT8IolPxBNJpBHBk/7I9YcMx
         8ppmQhFRyLlquFbvQyz6iSJVqJ7Y9XgwPZca62eQJtkzoR3uG9SjxR/6or9jaocJLico
         gTv+O7jcD+kq3DpraaKuNZOcdxdQL+K/dRZV1l2aQT+mqirwCICbLGGkN+kKuYsCOsit
         Vd5YRrNP0DmW8AOFBDRzM1LLtt4IifdYL6i7093b3j/NPtKkiNEw8JbuVCErU2VwuSOL
         pU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SEDuZLoEMjEHog4pApJjNCMgFg9dzBqJXIk1pFgNb80=;
        b=WtySlSNbTiwCMr4EN9puegHtm8nN3tsTROHyi2BhftU20kLDXE4mL8EV/IfYsJ7yGd
         G/tPTdL78y6wpy41plmxzrqnL/uO0B7BpCiYXW++SdwSpNlGnokaSEl6MUGAGc7x0v7T
         uETbSMQpDyK9qcUbeWuib8cqjn41b6EzmhFmZ7H10C3el1ir+4pImaMMVA3/MgbzCHE1
         qyGZ2QrEGH89wst5uA7xPi1pv00bHgN+CNJPv6EB6jn2kBRCDZWyTiuwCv902EU1ErE8
         HAMDxOe6YxMw/i5RMh+wqb4eeRkhE0d2EhMiY7RnoLIjfouU+lqfkwZWTuSRXDdZRtJQ
         b+3A==
X-Gm-Message-State: AOAM532WWuGd+poJkfFI/yBE7pwEgLSCtAu58Jq4cQFXXrK64nI1BMei
        dy4fNHFnqRJ+aY/RStvy52Kh+A==
X-Google-Smtp-Source: ABdhPJzMnJP2DhJKlKa0q/INIKLrcWwlyHS0fmuV/bjwj4iefa5IJkdfbtDVq8kV6WpCJ0owLKxtUw==
X-Received: by 2002:a1c:bc45:: with SMTP id m66mr6121110wmf.36.1598440886485;
        Wed, 26 Aug 2020 04:21:26 -0700 (PDT)
Received: from dell ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 3sm4623945wms.36.2020.08.26.04.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 04:21:25 -0700 (PDT)
Date:   Wed, 26 Aug 2020 12:21:24 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     merez@codeaurora.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 25/32] wireless: ath: wil6210: wmi: Fix formatting and
 demote non-conforming function headers
Message-ID: <20200826112124.GN3248864@dell>
References: <20200821071644.109970-1-lee.jones@linaro.org>
 <20200821071644.109970-26-lee.jones@linaro.org>
 <330bc340a4d16f383c9adef2324db60e@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <330bc340a4d16f383c9adef2324db60e@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Aug 2020, merez@codeaurora.org wrote:

> On 2020-08-21 10:16, Lee Jones wrote:
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/wireless/ath/wil6210/wmi.c:52: warning: Incorrect use of
> > kernel-doc format:  * Addressing - theory of operations
> >  drivers/net/wireless/ath/wil6210/wmi.c:70: warning: Incorrect use of
> > kernel-doc format:  * @sparrow_fw_mapping provides memory remapping
> > table for sparrow
> >  drivers/net/wireless/ath/wil6210/wmi.c:80: warning: cannot understand
> > function prototype: 'const struct fw_map sparrow_fw_mapping[] = '
> >  drivers/net/wireless/ath/wil6210/wmi.c:107: warning: Cannot
> > understand  * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for
> > Sparrow D0
> >  drivers/net/wireless/ath/wil6210/wmi.c:115: warning: Cannot
> > understand  * @talyn_fw_mapping provides memory remapping table for
> > Talyn
> >  drivers/net/wireless/ath/wil6210/wmi.c:158: warning: Cannot
> > understand  * @talyn_mb_fw_mapping provides memory remapping table for
> > Talyn-MB
> >  drivers/net/wireless/ath/wil6210/wmi.c:236: warning: Function
> > parameter or member 'x' not described in 'wmi_addr_remap'
> >  drivers/net/wireless/ath/wil6210/wmi.c:255: warning: Function
> > parameter or member 'section' not described in 'wil_find_fw_mapping'
> >  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function
> > parameter or member 'wil' not described in 'wmi_buffer_block'
> >  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function
> > parameter or member 'ptr_' not described in 'wmi_buffer_block'
> >  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function
> > parameter or member 'size' not described in 'wmi_buffer_block'
> >  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function
> > parameter or member 'wil' not described in 'wmi_addr'
> >  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function
> > parameter or member 'ptr' not described in 'wmi_addr'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> > parameter or member 'wil' not described in 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> > parameter or member 'vif' not described in 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> > parameter or member 'cid' not described in 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> > parameter or member 'ringid' not described in
> > 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> > parameter or member 'vif' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> > parameter or member 'id' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> > parameter or member 'd' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> > parameter or member 'len' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:2588: warning: Function
> > parameter or member 'wil' not described in 'wmi_rxon'
> > 
> > Cc: Maya Erez <merez@codeaurora.org>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: wil6210@qti.qualcomm.com
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/net/wireless/ath/wil6210/wmi.c | 28 ++++++++++++++------------
> >  1 file changed, 15 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/wil6210/wmi.c
> > b/drivers/net/wireless/ath/wil6210/wmi.c
> > index c7136ce567eea..3a6ee85acf6c7 100644
> > --- a/drivers/net/wireless/ath/wil6210/wmi.c
> > +++ b/drivers/net/wireless/ath/wil6210/wmi.c
> > @@ -31,7 +31,7 @@ MODULE_PARM_DESC(led_id,
> >  #define WIL_WAIT_FOR_SUSPEND_RESUME_COMP 200
> >  #define WIL_WMI_PCP_STOP_TO_MS 5000
> > 
> > -/**
> > +/*
> >   * WMI event receiving - theory of operations
> >   *
> >   * When firmware about to report WMI event, it fills memory area
> 
> The correct format for such documentation blocks is:
> /**
>  * DOC: Theory of Operation
> 
> This comment is also applicable for the rest of such documentation blocks
> changed in this patch.

Ah yes, good point.  Will fix.

> > @@ -66,7 +66,7 @@ MODULE_PARM_DESC(led_id,
> >   * AHB address must be used.
> >   */
> > 
> > -/**
> > +/*
> >   * @sparrow_fw_mapping provides memory remapping table for sparrow
> >   *
> >   * array size should be in sync with the declaration in the wil6210.h
> For files in net/ and drivers/net/ the preferred style for long (multi-line)
> comments is a different and
> the text should be in the same line as /*, as follows:
> /* sparrow_fw_mapping provides memory remapping table for sparrow
> I would also remove the @ from @sparrow_fw_mapping.
> This comment is also applicable for the rest of such documentation blocks
> changed in this patch.

Sounds fair.  Will also fix.

Thank you.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

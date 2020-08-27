Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98A0253DCD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgH0Gdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0Gdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:33:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98888C061262
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 23:33:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h15so4167589wrt.12
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 23:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JTST4BWR1o6f31+3txuRC8iq9BPG0VV2EIdBaLzgefU=;
        b=RXk5shD/gE6LWb2PuZ+hYpDl4vVfYrjX8ykPsZZyOEn+Xmowin2zLD84PWYt1m/EjK
         no31UUC6MZgLLQElkysGxiymXszbBPC8NWM4/tqrkDnXR/Pq/ISynXWPMTKbY7Norhrv
         2du3wYDqAy+NXulT9StnxMGkTfLgwyWXOrFjOK8iOb+3+ELqZSAuEUcgeteu//tKK68W
         wH8FQUpLDb8vl4jjlCW8no26QjF3VmHBetRAs1+3jh3EMs7giesKNbi7fgTqO/8ZpKc2
         4dSpU/5JanuqNSsED08RZ4GE3HQyBe+sO8iGIbm7nR+S1ck+bLoFzD7V1MPx3HK2Dt8g
         mj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JTST4BWR1o6f31+3txuRC8iq9BPG0VV2EIdBaLzgefU=;
        b=YaL5Ito3KWBm9Xlk04x9wG8CdIcUjaT6lrKxnySFkNZ8GJMt94jX6CRZnAagjifMvi
         catyebRYGn1QQDEqc4coHrnOTABreOkJPMSSMJHl/tEiNab3dx/eFCilQHUsilOHJQtL
         zZ8tp1vix+czx3LuIoPKWATasD/1e4PKEg3rpVQxBYDGaokjL8XZRbtwlag69qZScD0l
         151BteuZxJNB6/nn3b53GdhaLJQckRXy5aJlg7UIp6uOci/4t6bGvxX8+6Avxduh6zxm
         Qz+H7S72votEVFSwGWi1tDwR/xg52Vew6Z1VB7kS2qmbpRv/y8AHlY8wb8MkTyIlg1mW
         tahA==
X-Gm-Message-State: AOAM533wKhb7UXQArTwRWsYRlvSDyquyfcMNQ5Oouqtec8t2MoUoKVV5
        FVAWOnR3Ev2+yCez86jQkaEnoA==
X-Google-Smtp-Source: ABdhPJyfeAUa/Uy7YxxruSqTDkMS7AYe8d4261w2HGfyJAstCNYwquAKmVn6PZeEkXArpYQDHpz+qQ==
X-Received: by 2002:a5d:484d:: with SMTP id n13mr18638402wrs.297.1598510021995;
        Wed, 26 Aug 2020 23:33:41 -0700 (PDT)
Received: from dell ([91.110.221.141])
        by smtp.gmail.com with ESMTPSA id f16sm3264112wrw.67.2020.08.26.23.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:33:41 -0700 (PDT)
Date:   Thu, 27 Aug 2020 07:33:39 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 25/32] wireless: ath: wil6210: wmi: Fix formatting and
 demote non-conforming function headers
Message-ID: <20200827063339.GO3248864@dell>
References: <20200821071644.109970-26-lee.jones@linaro.org>
 <20200826155523.EB372C43387@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200826155523.EB372C43387@smtp.codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Aug 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/wireless/ath/wil6210/wmi.c:52: warning: Incorrect use of kernel-doc format:  * Addressing - theory of operations
> >  drivers/net/wireless/ath/wil6210/wmi.c:70: warning: Incorrect use of kernel-doc format:  * @sparrow_fw_mapping provides memory remapping table for sparrow
> >  drivers/net/wireless/ath/wil6210/wmi.c:80: warning: cannot understand function prototype: 'const struct fw_map sparrow_fw_mapping[] = '
> >  drivers/net/wireless/ath/wil6210/wmi.c:107: warning: Cannot understand  * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for Sparrow D0
> >  drivers/net/wireless/ath/wil6210/wmi.c:115: warning: Cannot understand  * @talyn_fw_mapping provides memory remapping table for Talyn
> >  drivers/net/wireless/ath/wil6210/wmi.c:158: warning: Cannot understand  * @talyn_mb_fw_mapping provides memory remapping table for Talyn-MB
> >  drivers/net/wireless/ath/wil6210/wmi.c:236: warning: Function parameter or member 'x' not described in 'wmi_addr_remap'
> >  drivers/net/wireless/ath/wil6210/wmi.c:255: warning: Function parameter or member 'section' not described in 'wil_find_fw_mapping'
> >  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'wil' not described in 'wmi_buffer_block'
> >  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'ptr_' not described in 'wmi_buffer_block'
> >  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'size' not described in 'wmi_buffer_block'
> >  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function parameter or member 'wil' not described in 'wmi_addr'
> >  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function parameter or member 'ptr' not described in 'wmi_addr'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'wil' not described in 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'vif' not described in 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'cid' not described in 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'ringid' not described in 'wil_find_cid_ringid_sta'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'vif' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'id' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'd' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'len' not described in 'wmi_evt_ignore'
> >  drivers/net/wireless/ath/wil6210/wmi.c:2588: warning: Function parameter or member 'wil' not described in 'wmi_rxon'
> > 
> > Cc: Maya Erez <merez@codeaurora.org>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: wil6210@qti.qualcomm.com
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> So what's the plan, should I drop the six patches for wil6210 in this patchset?

I'll fix them and submit the v2s in reply-to the v1s.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BCE2DAD80
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 13:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgLOMu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 07:50:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729036AbgLOMul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 07:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608036551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OxXx20BFwiHVDFgGooksFXIaxb5NmyKwvjjoeQDcyQw=;
        b=W8irMLzdgqB+UV/b9sGaO9W82yV8ampft7d7fC3Xsz/0CAZuW+VOILQxIKndrJWtmT5rlP
        Erj3V0yruHasvb6ZvFZeffiJ622unMyoqsxfFlGttRwNLgwK42o1OJEPl60O8j+vg8uLCs
        o/NuIyU9QWqb10njYHGAj2Jk9BhKK0g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-T6xaip-LOlyd_G6r5kN8iQ-1; Tue, 15 Dec 2020 07:49:10 -0500
X-MC-Unique: T6xaip-LOlyd_G6r5kN8iQ-1
Received: by mail-ed1-f70.google.com with SMTP id z20so9872710edl.21
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 04:49:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OxXx20BFwiHVDFgGooksFXIaxb5NmyKwvjjoeQDcyQw=;
        b=nDMYgz0N7+86x4tzWS7f6GD2fBPClbOXuE/YbwgD/CmA5s6fPycnaUQdgOKrqjap0I
         L0kN7mpH1akt5yuMUKkid8rl2lye9nNB7jOM5cKbsbBxj+pqLIHjOncw6rSckJlIpWsd
         z/Of8YePJMN+pBiSAIFCk7fPMgudgq6R27zLoosuJq+BhrFqmy4ZbtUk5kKt82lJIxRx
         8jJ6vjF3E2GuGhghAKiaK1gbugjRwwOAVfK+cLey87iI15nzr047wZ1URHz30lhqFOlp
         wJlPOUpQmaGIB8lnv305DdLktzhO685Hu5neLHpSjcyGPFvGcHpjnD3CM9T74JImYW0p
         gagw==
X-Gm-Message-State: AOAM530pBxrs4DGCUDC9/zcDeHxZcArUGMgtuQL82zyalJF1HmMXy5UT
        7X1HQtdLcxP477vQxuIn2QDpY43g8C34on0REacbecx5tRbwqpwjfKnt/frbjWdckFks/qN46Xv
        rcYOtFzFmLvPY1VYS
X-Received: by 2002:a17:906:2798:: with SMTP id j24mr7083354ejc.328.1608036548845;
        Tue, 15 Dec 2020 04:49:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJ3g9KAuikE+FtAYcMKJ9EtGXTqBRBor464OJm8jgA390yH927E715k2aSH3ftCUL95fvMsQ==
X-Received: by 2002:a17:906:2798:: with SMTP id j24mr7083333ejc.328.1608036548600;
        Tue, 15 Dec 2020 04:49:08 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id x6sm19398619edl.67.2020.12.15.04.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 04:49:08 -0800 (PST)
Subject: Re: [PATCH v5 3/4] Revert "e1000e: disable s0ix entry and exit flows
 for ME systems"
To:     Mario Limonciello <mario.limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com
References: <20201214192935.895174-1-mario.limonciello@dell.com>
 <20201214192935.895174-4-mario.limonciello@dell.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <12098c6f-a44a-df90-b69c-d0cb2a68543c@redhat.com>
Date:   Tue, 15 Dec 2020 13:49:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201214192935.895174-4-mario.limonciello@dell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/14/20 8:29 PM, Mario Limonciello wrote:
> commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> disabled s0ix flows for systems that have various incarnations of the
> i219-LM ethernet controller.  This changed caused power consumption regressions
> on the following shipping Dell Comet Lake based laptops:
> * Latitude 5310
> * Latitude 5410
> * Latitude 5410
> * Latitude 5510
> * Precision 3550
> * Latitude 5411
> * Latitude 5511
> * Precision 3551
> * Precision 7550
> * Precision 7750
> 
> This commit was introduced because of some regressions on certain Thinkpad
> laptops.  This comment was potentially caused by an earlier
> commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case").
> or it was possibly caused by a system not meeting platform architectural
> requirements for low power consumption.  Other changes made in the driver
> with extended timeouts are expected to make the driver more impervious to
> platform firmware behavior.
> 
> Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 45 +---------------------
>  1 file changed, 2 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 6588f5d4a2be..b9800ba2006c 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -103,45 +103,6 @@ static const struct e1000_reg_info e1000_reg_info_tbl[] = {
>  	{0, NULL}
>  };
>  
> -struct e1000e_me_supported {
> -	u16 device_id;		/* supported device ID */
> -};
> -
> -static const struct e1000e_me_supported me_supported[] = {
> -	{E1000_DEV_ID_PCH_LPT_I217_LM},
> -	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
> -	{E1000_DEV_ID_PCH_I218_LM2},
> -	{E1000_DEV_ID_PCH_I218_LM3},
> -	{E1000_DEV_ID_PCH_SPT_I219_LM},
> -	{E1000_DEV_ID_PCH_SPT_I219_LM2},
> -	{E1000_DEV_ID_PCH_LBG_I219_LM3},
> -	{E1000_DEV_ID_PCH_SPT_I219_LM4},
> -	{E1000_DEV_ID_PCH_SPT_I219_LM5},
> -	{E1000_DEV_ID_PCH_CNP_I219_LM6},
> -	{E1000_DEV_ID_PCH_CNP_I219_LM7},
> -	{E1000_DEV_ID_PCH_ICP_I219_LM8},
> -	{E1000_DEV_ID_PCH_ICP_I219_LM9},
> -	{E1000_DEV_ID_PCH_CMP_I219_LM10},
> -	{E1000_DEV_ID_PCH_CMP_I219_LM11},
> -	{E1000_DEV_ID_PCH_CMP_I219_LM12},
> -	{E1000_DEV_ID_PCH_TGP_I219_LM13},
> -	{E1000_DEV_ID_PCH_TGP_I219_LM14},
> -	{E1000_DEV_ID_PCH_TGP_I219_LM15},
> -	{0}
> -};
> -
> -static bool e1000e_check_me(u16 device_id)
> -{
> -	struct e1000e_me_supported *id;
> -
> -	for (id = (struct e1000e_me_supported *)me_supported;
> -	     id->device_id; id++)
> -		if (device_id == id->device_id)
> -			return true;
> -
> -	return false;
> -}
> -
>  /**
>   * __ew32_prepare - prepare to write to MAC CSR register on certain parts
>   * @hw: pointer to the HW structure
> @@ -6974,8 +6935,7 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
>  		e1000e_pm_thaw(dev);
>  	} else {
>  		/* Introduce S0ix implementation */
> -		if (hw->mac.type >= e1000_pch_cnp &&
> -		    !e1000e_check_me(hw->adapter->pdev->device))
> +		if (hw->mac.type >= e1000_pch_cnp)
>  			e1000e_s0ix_entry_flow(adapter);
>  	}
>  
> @@ -6991,8 +6951,7 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
>  	int rc;
>  
>  	/* Introduce S0ix implementation */
> -	if (hw->mac.type >= e1000_pch_cnp &&
> -	    !e1000e_check_me(hw->adapter->pdev->device))
> +	if (hw->mac.type >= e1000_pch_cnp)
>  		e1000e_s0ix_exit_flow(adapter);
>  
>  	rc = __e1000_resume(pdev);
> 


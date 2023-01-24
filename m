Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4159D6790AE
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjAXGNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjAXGNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:13:34 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851DA166EB
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:13:32 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id e19-20020a05600c439300b003db1cac0c1fso10579673wmn.5
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siiLc8cPXpq/vjWKe5UyG3dqWDXMa5+kj9UwG65Nl6U=;
        b=aAU5NH3mndxKYxEEa85ACvxsvsqAN9T8NM2Yq11gRywITF3i3inr/S175cv9Iuc70Z
         gIDfvKYV+HdK0YFTucjab6RleePXfptCbRg6NYWpXKu7/0bcwn/57pw8de1lLHvR3On/
         lMFQzAhycSwVyOHYu9bRKciksIScmakp4dM41wkxwxFRSSdkkcmgGNUSyOGjX8A7/Tc6
         UADJsipqqx5wgJQW4l8oEAITqIkSkAte7n01Z6lSysZIBDn4h9NK7MggiQXvBsX9kMoN
         s4uI8x+ANYIgsiTp04hRvOiIC5In6jioPU/9VVDsEiXOUVeO7THmtY7uwpUYia/3Rftm
         QftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=siiLc8cPXpq/vjWKe5UyG3dqWDXMa5+kj9UwG65Nl6U=;
        b=1EZYYuWrk2K6o9MC1c6Fta5mvCpZSEX4rGM8Z30e/2cP4oNR2vjHICbBKOgr7csQuy
         TOzzPXMTB9mkXVzX7uX+wUcDa2HroXRIy7FVgcC4uYV4lAAJ7czCeVW40aXtbGm01m/9
         XPQkn3EEsRSmFwHT+e4ct7qFnkQxaNmq5GsHPCA1D3soWiSJj9kkfX/WSkNywdvBkHqH
         do6Ic3eBGELyMasz6Dtr6rEBF1VAjwllHg464u9pjOcHlWr/fqeWF03SanGjYqskjvNr
         JtFh9AW/r51swpCGBtQMC1fLVikeq1PD4ij9U/7dPh6dZNUbf5uVLxzYocGxk+iDOrIg
         kcBg==
X-Gm-Message-State: AFqh2kr4KgO+H/Cb+5k1fVs9w2sr9VLG7S9m8LOFLaLjBhpeX+x1mSnk
        LprJPWIcFIAIHCeicZS6w88=
X-Google-Smtp-Source: AMrXdXs8flfZtzikaHSDxUpLiJIo/JcwFMwiTmRb5iOOg5m1y6xfNxlLoEH8odUU4rIJyAlNtzMieg==
X-Received: by 2002:a05:600c:5390:b0:3d9:a145:4d1a with SMTP id hg16-20020a05600c539000b003d9a1454d1amr23449888wmb.34.1674540811034;
        Mon, 23 Jan 2023 22:13:31 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id j25-20020a05600c1c1900b003c71358a42dsm17249100wms.18.2023.01.23.22.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 22:13:30 -0800 (PST)
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
 <24448301-f6cd-2b8e-f9fa-570bc10953c9@intel.com>
 <a9a56e4c-1a57-a282-1ae5-182656437e01@amd.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a11cdd6f-fb67-3517-31aa-88e64d607778@gmail.com>
Date:   Tue, 24 Jan 2023 06:13:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a9a56e4c-1a57-a282-1ae5-182656437e01@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2023 14:11, Lucero Palau, Alejandro wrote:
> 
> On 1/19/23 23:40, Jacob Keller wrote:
>>
>> On 1/19/2023 3:31 AM, alejandro.lucero-palau@amd.com wrote:
>>> @@ -1124,6 +1125,10 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>>>   		netif_warn(efx, probe, net_dev,
>>>   			   "Failed to probe base mport rc %d; representors will not function\n",
>>>   			   rc);
>>> +	} else {
>>> +		if (efx_probe_devlink(efx))
>>> +			netif_warn(efx, probe, net_dev,
>>> +				   "Failed to register devlink\n");
>>>   	}
>>>   
>> A bit of a weird construction here with the next step in an else block?
>> I guess this is being treated as an optional feature, and depends on
>> efx_ef100_get_base_mport succeeding?
> 
> Right. The mae ports initialization can fail but the driver can still 
> initialize the device with limited functionality.

But in that case, we probably should support e.g. devlink info, even
 though without the MAE ports we can't support devlink port.

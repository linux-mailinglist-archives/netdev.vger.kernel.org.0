Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A12482A55
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiABGpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiABGpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:45:34 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD73EC061574;
        Sat,  1 Jan 2022 22:45:33 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id g26so68586310lfv.11;
        Sat, 01 Jan 2022 22:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yty7Sta3hpzZNIcplufgh0H88CRlJ0n+FdzdP67vzFo=;
        b=js168AEYQcBxTfdJ1TUJXZWw12HLw9hLgPSCrzWoq1LYMv5sasn2BhZbjp5Ml1SwJz
         18dlsdnm4fM+OdQLWXfc3RtVnsieAwEjBwJo3Pg8YbYeQZCrkyGs+UI1FzP2eERU4VKs
         1CXx+gkwkAlbP9TLrDzrNcAglXGul9bVVMfNTcrF6bWPJm7ePEcVA7xpWNZ2bKl0/hrV
         LGWuJD0U2PGSgTLvCo9VrxM8VY+/L7xUErM7NuK8DHc9Cn3bV+6LvXCFu1c9Rd6XZGNr
         Cd7LIJAtbZMRg/A+q5mXztY/OMXCBGRSo/idypKLciGUyz4+1QjaWHhKWqgCoVtiiAzs
         Qa/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yty7Sta3hpzZNIcplufgh0H88CRlJ0n+FdzdP67vzFo=;
        b=VPzhyOjvH9ywJ2APnRu62BuGk89khylH9b/CAsT84dh1GFyjFiipsXM+3m0Jj2e2YS
         mhQKdI8dQWxK320Gkw3cV9RQAvDhxB+qSTXjCmi+HEU68X4hmD0rcZUXyI1vV+ni7e6t
         UaTvl4nNYCjffjiva8vU9ma4opRiH1OVi2jYGnBTxosTSkjpFDkhgPMsfHxgsPJhw8qS
         HkX/XG6dwesk/z5AL38TN7yYF3VB2EATY0wLFKyuNbh78quDqU/qz9FPsJhgp12TYSnY
         nrTSqPbCrXcG2+LGx2xnCr19tenKbh783JeRwa202uHywjqs3ceCCmiklKeUBSZ+dkiU
         /jHg==
X-Gm-Message-State: AOAM532pGS4pMcyukrv5neXZTXRNAEEiaWlaRJR9n2L62frEB2c04ZHn
        ZrpmeUSsGJvVZ8Ud8c5RT0s=
X-Google-Smtp-Source: ABdhPJxJXE//HZ/SIC38dBVlNFzg+P1VU3bR0WokzjlaLYLg1VfZOWdcMABcYjoSzcMv96bd3RuixA==
X-Received: by 2002:ac2:5507:: with SMTP id j7mr35496562lfk.635.1641105932136;
        Sat, 01 Jan 2022 22:45:32 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id v23sm967432lfg.289.2022.01.01.22.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 22:45:31 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
To:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <8e99eb47-2bc1-7899-5829-96f2a515b2cb@gmail.com>
Date:   Sun, 2 Jan 2022 09:45:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211226153624.162281-4-marcan@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

26.12.2021 18:35, Hector Martin пишет:
> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
> +static const char **brcm_alt_fw_paths(const char *path, const char *board_type)
>  {
>  	char alt_path[BRCMF_FW_NAME_LEN];
> +	char **alt_paths;
>  	char suffix[5];
>  
>  	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
> @@ -609,27 +612,46 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>  	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
>  	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>  
> -	return kstrdup(alt_path, GFP_KERNEL);
> +	alt_paths = kzalloc(sizeof(char *) * 2, GFP_KERNEL);

array_size()?

> +	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
> +
> +	return (const char **)alt_paths;

Why this casting is needed?

> +}


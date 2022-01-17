Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE754900AA
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 05:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiAQECg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 23:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiAQECf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 23:02:35 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F53C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:02:35 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e8so6410400plh.8
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PVumsdrSq60qcqZv35c7Zu6adROLHcLMBHoesC6CPGM=;
        b=DQHONQ8gaDnSTxG2naiKREG5nC/GfpETTTmWkdt4ZMGz8caqI1e2ueMRJVjycSVniQ
         hgrte5GzYPxjGD9Uga04YuJw1eMTiBewKkd6Ox2XX2A8A2G/ufaE0WfPsZpyLb41F6HF
         qpyK89SztzzL+J6BEcYwheYyI/CWp750rCKixTk27ybRUq2b4skci4RqdCksBZau87oP
         zUEKncFu6STidDARE2xwwm+tRz8cLctEv61yaLkZyrdZ+ntuzI7TDlbALMME0p31sguo
         fv9GY28rmI/k5+wiWduupx6TRTFglurBkD294rIk2P3o9/eljq2itu+F1dXhmU1I15c4
         ufNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PVumsdrSq60qcqZv35c7Zu6adROLHcLMBHoesC6CPGM=;
        b=h0/M3GYz7DvU0YL4p+f8Yfjc565UVf+UIl7W8ibKNbQnwY/KyxntT3UCsrcauXbIv5
         GwuiZ1H0QN1E467zt9fIOe6SH1/t2oUKdgyph3019ktoXllAttdQYsM+lS4Z8lbVP/qZ
         vkpmsHv0ID/kGp6rzoYBYFLURnSTXg1P1q+aVWrEO8HibdCzIUesoTlably6YQiRuPc/
         GZcz8B9sOXheXpsGTAJk2NhA4PiHOsgZp5q+uwuEFkUhBxPtXx6mdMu9wlGiPhvrCnZk
         lCyRkuZwqxoP43QPyukpAHQphgvO09hYpvO8RmfarRX3SCizBTL6Ur1/GHaRJWkc/pmo
         bG3w==
X-Gm-Message-State: AOAM533WNg8Lh60Psy0kZhWEBTPpXPtJO481so+I1B8q5rczYeOq/nHw
        AjbpFw9TNlIkJ8nrNzlLg1o=
X-Google-Smtp-Source: ABdhPJzBw+sLsNHnVOjHdf/ODfk2uSXwTZf7N6JvgNMMMxRwcR9bpIqgtFxlwKBYo0hRuAQRRHrh5Q==
X-Received: by 2002:a17:903:28f:b0:149:d7e0:fbbe with SMTP id j15-20020a170903028f00b00149d7e0fbbemr20636166plr.147.1642392154953;
        Sun, 16 Jan 2022 20:02:34 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id k8sm11040923pjj.3.2022.01.16.20.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:02:34 -0800 (PST)
Message-ID: <b5c79eb7-9c1e-292b-721d-043653a7062e@gmail.com>
Date:   Sun, 16 Jan 2022 20:02:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 04/11] net: dsa: realtek: convert subdrivers
 into modules
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-5-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-5-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> Preparing for multiple interfaces support, the drivers
> must be independent of realtek-smi.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD4C38F812
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhEYC0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhEYC0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:26:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71273C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:24:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so983490pjr.0
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lEeBlWyDHIBGk/ZxhkpWCvVghvX21E0ZALaGZBppJ/0=;
        b=rqLXd5Q+n9J09dkqlflD3ME0kdzoNX1jrpcDpMAHoBWWc7Pf65hmShPlSkhJNkZXsM
         J49jwkxykFLlAMqtM7zjQrTKq0ZvR1Z5Jk8VisSHWUjI/I4n8js5LFDjf5n4/Uju0X/9
         K+2Tn7/VHuUIbnGnBJVFykc7Jv9ViNvIMNW8dMTfsbBwVTSELQTWM0g6JfNIAR9bKZ3V
         DBOn5ljwFpQ1miYHltklV8QigFZ/Dov4IUSOYU0cJv/T+H9NvDijdNZAkH2kZIU1+ZN4
         ywLHk0SyDx4VvNddH7v0ztk4Bvu1qygQEa842Bhhlu5yV4mh31fSKOPIcHm8/yY+vOoJ
         /sOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lEeBlWyDHIBGk/ZxhkpWCvVghvX21E0ZALaGZBppJ/0=;
        b=dOs+Dq3mb9ftoQDxDQ7OqpeasmhbJ7QtP3KCTyx5RvrLNpsEQeE9HrSSL+uzTh5bbQ
         CnsIYo/pksPJ9SMw/Ibu/xLuIgTESb7SCry0tFaEOfJRaPPMnyM4c5clFZlbWUFqCg3+
         P9Nug9uq7DhNIH6rjTAKkDenaY/o9y7AYWDoBc7pqGyiChI3s0KaCWSMDx/feuhDeUlF
         0FJSjFNV91TcgIsSYNr2o4q+a89UP132S/Uhk+5pcT540PQD/aPD2KcmV5R61mGL1d22
         ErkG1QQJZwFkPx7i85JV/RL8AAB6ND1MdgCvJPWeGa0f6swPKCnQIGrpNaMnn0e8A0d2
         haOw==
X-Gm-Message-State: AOAM530y2vjM2oY3lzuOb6eYtFoA69gGLDCopCxKZPAQ418e1jmVswCx
        oW9BdegIwz+b4jWiaqgcdrU=
X-Google-Smtp-Source: ABdhPJzgZ5d5fXDkuPP2DBwuLiXGC62Unlqtym/5yHCkiFoGTqAnrYAvBS/kVPgKFnbgHjxMUAllFA==
X-Received: by 2002:a17:902:b412:b029:ef:1737:ed with SMTP id x18-20020a170902b412b02900ef173700edmr28835609plr.43.1621909480035;
        Mon, 24 May 2021 19:24:40 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t14sm11378251pfg.168.2021.05.24.19.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:24:39 -0700 (PDT)
Subject: Re: [PATCH net-next 09/13] dt-bindings: net: dsa: sja1105: add
 compatible strings for SJA1110
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4e6cd92d-b2f3-9eb5-9a6f-e169dbd41537@gmail.com>
Date:   Mon, 24 May 2021 19:24:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are 4 variations of the SJA1110 switch which have a different set
> of MII protocols supported per port. Document the compatible strings.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Time to YAMLify that binding?
-- 
Florian

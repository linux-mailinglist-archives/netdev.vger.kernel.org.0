Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F493054A2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhA0H24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317471AbhA0Ae4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:34:56 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFD6C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 16:33:59 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d4so72392plh.5
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 16:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MKvmc0JB1r31cicj4aHjWkx7cdLDHGl5q8dvEHkTQDQ=;
        b=AYoKXLgeMC/X1s4m71QoTYtGHkI7MFQdKHdsVIre3E7kABL/X6lZF9VUTquwjfg1Mg
         0Fr0IwpzGQvsXNJFtZJIdtQ4s/wHnwTxm9t2F+C5HcODfUesau0kqANs4NzEz0dq6MLj
         NPaEzsLp3s2038kZ7yatqyS5d3i9V96sWQD84YVlfcPABj3Einflhvo/yeaotWE/XdEf
         deBmV5U2TSc9YwysFp6+C1oJHfOC59mTG8ZH28ZR4o4/K6qgTyeRzR4iyDZ2EYqtKJ5e
         qi5dL2ujMO+qUEoQsJWyJ5ekK1Q9kIv1Gas1V5HtVc/rk4DkIOrtMeTFIdO3bqZYTGv/
         8fdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MKvmc0JB1r31cicj4aHjWkx7cdLDHGl5q8dvEHkTQDQ=;
        b=FPSejTLvIoIg6sBQ4zH7A/IAs3gDqyEKKnOZyYXSaUf+zUtReYl4apsM8C4HrlEnwb
         nArgPmy+cTjgoVY8aeISNFIOdtoiF0JLRJzEJWrEYEVYT6cClLtuM36xBHnyyrbPK/iX
         GJrM1qjGuQglsymtjJt9bLEVfV41X2Le7c2Kl4EcKrVZniNXzPcU1j0an4/d/9fpVRPy
         67iAB3Wn6wwH14UvmSF2veG9ksmZJtNMNlddFwEcPgKhUJ3fMgDGYuOAISJTmD1Pih82
         a+mi7RYHMO2puynSssR2W34P+YLiedU7N910KFPe9SKnqNulLBBYSfp0RQ1NVPPyYnZN
         UHjQ==
X-Gm-Message-State: AOAM530gyvSh8Kuv3odh+hLeQaAzt6+YkyXvjeBKHf6suGe4oG5PxcTU
        PN51Q+dbJpXqmMSYEZ7/DEc=
X-Google-Smtp-Source: ABdhPJxItRXs4ziJyuBChRxjtcmJDISW0DeR6Zt39bvWb3dEYUGpwzmusQlOC7stQ8O8+hXd5Km2eA==
X-Received: by 2002:a17:902:bd44:b029:de:74ae:771e with SMTP id b4-20020a170902bd44b02900de74ae771emr8880796plx.73.1611707639019;
        Tue, 26 Jan 2021 16:33:59 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l190sm225671pfl.205.2021.01.26.16.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 16:33:58 -0800 (PST)
Subject: Re: [patch net-next v2] net: dsa: mv88e6xxx: Make global2 support
 mandatory
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        tobias@waldekranz.com, Vivien Didelot <vivien.didelot@gmail.com>
References: <20210127003210.663173-1-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1520e1df-de0d-04ec-6f71-03f82b0ac587@gmail.com>
Date:   Tue, 26 Jan 2021 16:33:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127003210.663173-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2021 4:32 PM, Andrew Lunn wrote:
> Early generations of the mv88e6xxx did not have the global 2
> registers. In order to keep the driver slim, it was decided to make
> the code for these registers optional. Over time, more generations of
> switches have been added, always supporting global 2 and adding more
> and more registers. No effort has been made to keep these additional
> registers also optional to slim the driver down when used for older
> generations. Optional global 2 now just gives additional development
> and maintenance burden for no real gain.
> 
> Make global 2 support always compiled in.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

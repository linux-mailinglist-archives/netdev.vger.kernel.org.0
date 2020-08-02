Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98D3235A76
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHBUVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgHBUVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:21:47 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25450C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:21:47 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m8so10232062pfh.3
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=XJfeU+l/dUFJsGnzTov8NlubsutC6Kmgu1wCy+pxzD3LeKcFckgZ+MiQfSn7XsqYk9
         jrsoBsPdOugEn0GdP8ZhmfG6ee0uaARM91+sPhI4f9faluwO9yxx8qzSwZ4FukAXJLNq
         CekNo0Cmi17b7DTxRCnKGwGggE9EtOI9GhjJymugdLyZAfm+GzeC4E4SlsuVWf/GqmJV
         /0/iX2nIo3pLd37/00Bz6oGUcgvmoCBciTRe2iWSqiU7/HNfFSiETKpMKv0FRjNkiznn
         /u162yTsTE5+GduXto5pMXh4pp2WNZFDDkuc65xwY6g45ahN+38LrAj3AWejogg8msvO
         sKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=qW21iCszpDu+wIRzkrqB1uK9KBGriIJ0CcozUIU52TQUg2+P+XZOlPkJFDMbLMFh5b
         4+tCN2eFmRUlSmjS4NhDAsEXykyH9nk8iDOyQBRkKz4qKELt1ODMCL4we4MfRUne5HxX
         z7EVbDYux3iBeUzjNzarEkVYyHN5BQTB8VksZd5MnVthibO2i0kLFumNMsmLoMkDgJxr
         P/QYYbYs0UI+YaEbIngOls1PO3fvaynfVk1ipTJ0+YkhXqChx3U3oDSWTL0igGgxLoSy
         TnLclQ6y6VW2vzxmMRaKzj08jUBeENflpZlNaQUhm33LeP43P4M4LR/f3RlHKGuuEH01
         Q+UQ==
X-Gm-Message-State: AOAM5312ZaFiwl+BOEMWR33JZm3nlKk2g1RRrP84H5SFZYaAg8XQ8Tbo
        zSDES+JhB8Az2/EdYM46vRg=
X-Google-Smtp-Source: ABdhPJyOwuTHY9WiDOexAD2GN2Z7odSLIE0x/I4gUoN0Eo4U+eUbCpiKjPGz9YMX3Fao+saSQS9gig==
X-Received: by 2002:a65:6710:: with SMTP id u16mr11989163pgf.45.1596399706666;
        Sun, 02 Aug 2020 13:21:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w16sm16205612pjd.50.2020.08.02.13.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:21:45 -0700 (PDT)
Subject: Re: [PATCH v3 4/9] mlxsw: spectrum_ptp: Use generic helper function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-5-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <394e3ff2-2ead-b1ba-4d2e-8dec3b11b59c@gmail.com>
Date:   Sun, 2 Aug 2020 13:21:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-5-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

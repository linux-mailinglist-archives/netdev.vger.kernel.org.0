Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A6F321030
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhBVFOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBVFOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:14:44 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E60C061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:14:04 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id j1so845264oiw.3
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=02zjX9FpuV4hI2zLEwrcmmEfkuluACihNzCYVtFR5DM=;
        b=VD3+i82cKpqfFUcVgs1XlXucOt8pcITqi+8cscD+pVnKCf2deClGbH7OoaRBgeKYSG
         sMf8tUfivnRdfvvRN20Xm98EVaWYyrA+axa0mIVAwMKsvhN7uGy6ADk74v8bihBNfkl4
         qxQAbfsDNsQYrZ25fzT9EfcZUL8vs3ztPYvoBpSprgHx3N4iDbr7alna6ejXNXBfCegJ
         rrUCDyolxjdSHXzRtbiRiR5dXekay0fnoXLl9d5no3tzou2SBE+cRE17Z5o9MsOp+XQM
         LDDsPbliRD+4yNlfXVoBNhatr2lxjaNKOwmdyI3sVWwYzjPr/OM04uFlDRIUaf/c3KDa
         PbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=02zjX9FpuV4hI2zLEwrcmmEfkuluACihNzCYVtFR5DM=;
        b=Dm/SJyJ9md/HrfMHXy2fwSbZ6KxvPponvOaedpWZy9jkG5gYEn0gEZVD2Wg1bWzT7e
         LerScitXB5z7eQSFEtmGmaKubKoTwE4HQ1cvfnpEv94TSuJ/j8AEY2g4b4w5qFd0T5aA
         JrVnc4BAHVuEADPm/Di1ddN3LsxbR/ak7fZ8MZ3uAXA2qU9jUC8/m4mspGcMTFmaUFv9
         JklxfjF/lhDn3Q0rc+Q+FnYOhRyCQXm5UCZ5mlmm7u5860LtUekMVByDQYBdEgdgIykx
         mTLBZ93AnG1ZKKKLXoeJZ1tTJZhMf4VMnZ7FkPhru9N28tdVbuKJW95XpVEsY2WERb5/
         HsvQ==
X-Gm-Message-State: AOAM532kySnIGpTCIvWSV7HXzapKRWo5smkmOUeuN8ZtXT4bYUF5f5L+
        eOklSOQI5L7hXulCKIqeNv0=
X-Google-Smtp-Source: ABdhPJzL34DOkEbPc4yc7DcJhpXLQSVIPwcJv7vNfMQ55RqKuOK8ovReSea6+lbGVdccaA6u/GbwDw==
X-Received: by 2002:a05:6808:bc3:: with SMTP id o3mr14645491oik.134.1613970843650;
        Sun, 21 Feb 2021 21:14:03 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id v16sm3530301oia.26.2021.02.21.21.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:14:03 -0800 (PST)
Subject: Re: [RFC PATCH net-next 04/12] Documentation: networking: dsa: remove
 references to switchdev prepare/commit
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ba479081-cd23-07aa-d2dd-61cca341a025@gmail.com>
Date:   Sun, 21 Feb 2021 21:13:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After the recent series containing commit bae33f2b5afe ("net: switchdev:
> remove the transaction structure from port attributes"), there aren't
> prepare/commit transactional phases anymore in most of the switchdev
> objects/attributes, and as a result, there aren't any in the DSA driver
> API either. So remove this piece.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

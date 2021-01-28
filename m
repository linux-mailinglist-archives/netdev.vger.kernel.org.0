Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2A306A9D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhA1Bog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhA1Bnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:43:46 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3779C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:43:05 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id j2so1570921pgl.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O9N93R8+zs26eOCHrsRLuYZnNp22ouaGoRUXdBnEkGQ=;
        b=GKhdDQCibJIwx5mHiKrBF91tWk6akGU8+YR2XvEVC7vaZ7/yKRDj91H5DYCsx3A7PC
         wfbLXpg31E20IEbWBKw8IwvyQmhs3hCWNNzUI8GF9Fum6AB5PWCNXAsrJGlgHPlzzCSJ
         darqGVKygEA7ao1S5B3xFA07WQrp741LJuvIAvXPCzr4mefosfPZqKRQ0CwXf4hMLb3m
         oGhirAcC9iRjICci/l2THJGYy7LC7YvasYtsg3NqQuGTYf9xDYq2Ia+ToMsCVV1IhVsl
         vhtp/lsnaZ28TPelaq8/P03ktM9QUXUkV4+FUSdLXzEuVXNej8p+91H7LFvPRJsT2EwM
         m7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O9N93R8+zs26eOCHrsRLuYZnNp22ouaGoRUXdBnEkGQ=;
        b=anB+AW5EcH/OhmoVObwMhDxK+OwKQRyItUzTdgws+Azeb08idpbuwo8YPeRCeuSv1/
         eWoE/nBGIN9kH4rM/RWyikbC3RYNsRgJb8Ffp/tDaKcqXjMoke0Rvg7BD2q0KgWNxrKr
         WvypL+tszruubyOG/o+qbMWcJj7qjQqgZ9q+5qEPrZn4W2BNkDKVFk26rwO0lm6iY7vl
         FBmaND0Nt8ZRfaSbzif613M4aW43MuFkr3blDsNZe/jq7McHeCRf9MqNGEr1Pc+P1K/b
         sWG3aNQK6vXKY4x8F7J1MHTyMuyxYP7Qt9+jjbNEIBo6QeBIMJ6vfOPh0eky6Z4SH3iF
         aUXA==
X-Gm-Message-State: AOAM530+RZHigycfAm+atqFZ3TK9stQuL31ha0zvDKugiN8Rhsz1T3qp
        epEtyGezfbuTrFu0mUWPFhfVHOYdfx8=
X-Google-Smtp-Source: ABdhPJwrFql8fhh0pQOUaZ+eBTmAwx7s3ejl+nT3iqdzxo7sHtXtgxcRosnGDF/eJc5VCV61Kmam1w==
X-Received: by 2002:a63:d506:: with SMTP id c6mr14043679pgg.77.1611798185462;
        Wed, 27 Jan 2021 17:43:05 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v8sm3552602pfn.114.2021.01.27.17.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:43:04 -0800 (PST)
Subject: Re: [PATCH net-next 3/4] Revert "net: Have netpoll bring-up DSA
 management interface"
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6d5163d8-dc49-d126-ed84-b7b093e1a680@gmail.com>
Date:   Wed, 27 Jan 2021 17:43:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127010028.1619443-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2021 5:00 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This reverts commit 1532b9778478577152201adbafa7738b1e844868.
> 
> The above commit is good and it works, however it was meant as a bugfix
> for stable kernels and now we have more self-contained ways in DSA to
> handle the situation where the DSA master must be brought up.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

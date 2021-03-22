Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98870344FB3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhCVTPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCVTPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:15:02 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167B3C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 12:15:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j3so20691354edp.11
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 12:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KT43aWrbKxndmMt5+FUTpf7k7r6EmtFMwcKyWjeWiYc=;
        b=AshP2tghhfOot/SQeIONle6P+UkL8g1/TgWQpRkgZQpZ2LebWLdsSny5qCuFj3U9L6
         geOabqzaX6d6EpprB/pAnQNQ8+jNfg6HZLn/Mrj9RD2oZb/c4SS5YNpftlxDFNwDIrRE
         GBJTC2FsM1OE0ITkyoA3Dhf6e+T/9HVQTCL/G87hXYghFPx93ES9cqU/uF29zbJBQCUl
         m721l55ym7VWcXVjP+4covyyDdLv2QJmQPGyILK10l7G4476vGdNLNuyR4yqXwYD8ZfF
         5hJtMk29Yjyydjwm7dMI5/nsfrfgnUzpMuohoFtVIgH59EOSpV8hkf0ijN1sFKbqSXa4
         nUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KT43aWrbKxndmMt5+FUTpf7k7r6EmtFMwcKyWjeWiYc=;
        b=sO265kQiHwJ+ef2FuPooTb+g6VsVXeFEWYJfBxWgG3uoOHm6FPkoHsr09o1U0enzXi
         PsW6t/Cr8Vu6q5QDSMlL0Gz+eDDVVzY6ytnk2Vru+j2gu8YrBC/BXH2skR4m0iGOaTJ7
         O4KKSHXuMD28hcWZxwJT55Vs4q1u7o2xlzqCPFDpIq7LTpytL+Qycr+v8ZfeQWYYib7L
         gCcO7eSlOFGEEKyCEH8BSoqaCqNtwL2nIlY/IaDTXHRMsWJiXDqCpLOV74H6gs0CP9N2
         ISq51GlYtmdaIDEHkFYqphCiQiQkeVt6ysnOvtR6E1UJTf7Tqb37cF7LFIin57I5Vhbf
         Jd0g==
X-Gm-Message-State: AOAM531Q4T63xa7IV+VV0keTKO1Ll4zIISmXuIzbJTht7wq3XTFEA3gy
        MGJQG8+nq3ouCCEJL/YnV3TC8Vy85is=
X-Google-Smtp-Source: ABdhPJz73TSLIqDcF3RvMqAMqIcq4uvdXTUI/38+h9auGosS/9sZ5G9CXo5VxE9MSd4gEt4DtuDyBQ==
X-Received: by 2002:a05:6402:524e:: with SMTP id t14mr1100573edd.371.1616440500452;
        Mon, 22 Mar 2021 12:15:00 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g20sm11591842edb.7.2021.03.22.12.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 12:15:00 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: hellcreek: Report switch name and
 ID
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210322185113.18095-1-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c2823aa0-5f4f-c87c-4c77-4b4bfc490090@gmail.com>
Date:   Mon, 22 Mar 2021 12:14:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322185113.18095-1-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/2021 11:51 AM, Kurt Kanzenbach wrote:
> Report the driver name, ASIC ID and the switch name via devlink. This is a
> useful information for user space tooling.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

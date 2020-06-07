Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CFA1F0F0C
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFGTOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 15:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgFGTOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 15:14:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59620C061A0E;
        Sun,  7 Jun 2020 12:14:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bh7so5775296plb.11;
        Sun, 07 Jun 2020 12:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4JHYoeZ0JntHyeIl9Uizp+UAT3c4yx4ISWQLG4fjhIo=;
        b=gMvyWNyLJWENt8iHIRJX+5zrIixKEZssTChJpyzGotKNrq4T2MJgg5ko1+ZLrctNa8
         gLJ2bmLgGpd+cLuxeQnk1wWHdx3S4pGaZqrGzsTbdj4VINXc4w6PIyh7aET6ksYmhobL
         VZ5LBdGFWOTz5o0l5X2NtjItooHrmQ/Gp7cjrSUH0evyAxXIpN8AIrkQMJIfC/rnNj1g
         Ysb+amNK/31r/E6g4tqbu2wcB7M+QwKSa/UuxnWSUZC2rc8NmwluCt+eAewp22YqM0T9
         SW9Fi60CwAWji/dKw4npTURuGX7Cj9asXrif8PueCAdr4VnnlBsuR8vltb0GmTaSczgZ
         S7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4JHYoeZ0JntHyeIl9Uizp+UAT3c4yx4ISWQLG4fjhIo=;
        b=jArN0qxUZOGwys3axFt0wkZZuyA5yUHUCBO0Q31/uVMK4uoBeaXg2+vnOjgVz/5p0P
         QaK/78/RBxGEpEoFnS8hsjGMJrVxOrjFk10dNotr2ut3y9ztTAWjG94RVYhwgrxESsFL
         TpsOo8/aCA0I5U93uRkxA+sM0YaHNgtb9UQzEC9bUF1Dw/8bU5H9MoaTZDZ5AjKVXpEX
         WuqC4dpws4jxbS88sGyi6ajjvnqUElIVDOhfZte/wWExqD3laDnnK2TLFsBZI3tOcb96
         oihPdyEm5mRBg8Dd0dwDG23Q1dL18HIelitSGHDP5EKO8pZK9FiyUTC7tZ0q1eZgqbXH
         kpjw==
X-Gm-Message-State: AOAM532eig7uN7rGIlaVWWtUyMHYU4fGU6pMqcecA9j2TOCeD6FESQSR
        U9cQ/LsxDx7ckRuxull0ESfIBxvA
X-Google-Smtp-Source: ABdhPJy0W29uRaeqKP1ce+z2LmXNRunGLITUjD6fGcROi7UeIPdpLoMREHIocA9Cgt22zsuQH34fsw==
X-Received: by 2002:a17:902:7204:: with SMTP id ba4mr17880305plb.137.1591557240395;
        Sun, 07 Jun 2020 12:14:00 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a17sm4981971pfi.203.2020.06.07.12.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 12:13:59 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 01/10] mlxsw: spectrum_dcb: Rename
 mlxsw_sp_port_headroom_set()
To:     Amit Cohen <amitc@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-2-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <89936628-6871-8c21-142b-48fa9d7070c0@gmail.com>
Date:   Sun, 7 Jun 2020 12:13:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-2-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> mlxsw_sp_port_headroom_set() is defined twice - in spectrum.c and in
> spectrum_dcb.c, with different arguments and different implementation
> but the name is same.
> 
> Rename mlxsw_sp_port_headroom_set() to mlxsw_sp_port_headroom_ets_set()
> in order to allow using the second function in several files, and not
> only as static function in spectrum.c.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

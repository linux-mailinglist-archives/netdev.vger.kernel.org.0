Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89541F0F2F
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgFGTPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 15:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbgFGTPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 15:15:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47562C061A0E;
        Sun,  7 Jun 2020 12:15:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id m2so5064820pjv.2;
        Sun, 07 Jun 2020 12:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U/uYcs3RzDzbfKbBDqV6cGLecIjVAkg4EoqiC2LpUQY=;
        b=dlosL3GYKfzXdiEAHLXVSiXmzmtCNINoCgxhO2YF7Sdzmr8K43R39YfHx8n2EXmVVI
         8M4+UO74rvAA9OnUcfJL87HKs4MxZHhJKEHJr61f4YjCC2XGrqo5B30URJMniRaDdDrk
         ZcpCk5rH9BVJnTzWCVPMUJE3loN3NHFYAF801unR+zM6RKKs52/8UEFs3lhUWvSpHFSv
         cml5iVkeWf9vNJBBOvkWL3mdJgqxPbDXTb9gInTwvoXcK33a8KgDXDn/hmQApDzo263U
         wgGOeEP6/LQlL7wukTYvrkyYiDy1KTykGEHzVzpNgD1umbKAy9w3T3h9nmeW5VErcHO5
         fneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/uYcs3RzDzbfKbBDqV6cGLecIjVAkg4EoqiC2LpUQY=;
        b=bGIkUqp0ZgZQkEPSg0MBai2h0P09DWg9C1P0eEnB1kB1gp0xbMZw8NVMXXBDerf+L2
         cPEX5Nhhz1QZxufJ3tuXh/tJzQn2YDtBlEUTO7MzmI2f0PA80CwhXUl4W9qrq7+sO7Fh
         SXz8K2RgcehxwHhC4/6lIidTaJ26N1O/Vr/xZuUXOUjp9g6bdGbPGVPUow9es9rsPMAq
         GXqVDK6K8iSVaXPZ3uQcZthsOs1wgV+vW1WJYZTTOa2CKBoWsdf/38f8Ya76Etq11dIR
         dY+bBUkQiAqZkHk+rSY8tMWTmLJPTdDz5ha8BeeQef794Q7YOtoN8xh+pTiLMVmVGf6k
         KDRQ==
X-Gm-Message-State: AOAM53177+DfXHrauzwSfMJrOIupY6MJfd2OgsAUIQBGvH2yERbY7xh6
        VWj31/LraZx9MlE0VfT2+BsgsMeu
X-Google-Smtp-Source: ABdhPJzlTQJiWTfjhtcmYBLYPskCX8Pyhe9THE/ZuZym0N1jzGHGx47xzMTvypHqGbOs/I30sp4PXw==
X-Received: by 2002:a17:90a:1485:: with SMTP id k5mr13469532pja.108.1591557302441;
        Sun, 07 Jun 2020 12:15:02 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f6sm5032253pfe.174.2020.06.07.12.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 12:15:01 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 03/10] mlxsw: spectrum_ethtool: Move
 mlxsw_sp_port_type_speed_ops structs
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
 <20200607145945.30559-4-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6f581284-16cd-803b-ead0-d012d973fc4d@gmail.com>
Date:   Sun, 7 Jun 2020 12:14:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-4-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> Move mlxsw_sp1_port_type_speed_ops and mlxsw_sp2_port_type_speed_ops
> with the relevant code from spectrum.c to spectrum_ethtool.c.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC4449E833
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244227AbiA0Q5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244109AbiA0Q5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:57:18 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ED7C061747;
        Thu, 27 Jan 2022 08:57:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so3553328pja.2;
        Thu, 27 Jan 2022 08:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LGM/27C3YzW7rU8ZLsFkmjbWaYiCNmRr/AGmoFHoJlk=;
        b=Jvir0pCZgBm+zUYLvvV/Sx4g3B6Kn+ssDkHhJ4XZlOUuqXdHsV+WaL7UqUPDE+1dzv
         OJzdvXHLwtgrCpmOSdUmCjlltJyjXVKJOJLnnccDbQfP+sY1OTgwdZtY7DklkbLpkLjE
         dSmBKJumQ3i58LA+3Ex+l2FuKAAIJNpBAIjX0LlP4kXxLXt9daFUpbRBvzH7elAaw7c4
         3hRHbxBAhdU1M1I5TAy+vKcUgmIhTpkddozLwF9oavKSd94H1jwyAgglUSLyOWpz/7y7
         GQC/3aR9T8sG0dIwQ/suTxw4cyZQfIoFWzsoC7vfN4uKXm/Ypmbm45b2oWDAIU8ku70b
         eYvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LGM/27C3YzW7rU8ZLsFkmjbWaYiCNmRr/AGmoFHoJlk=;
        b=ntnARvtQ1tw1GVSyfi2KXUCXhyxaPcVUB6z0n5nef6K88wgr2tQ4MfgWRW6kH3PGe/
         /vMxiVAJo6JIrES6Ge8/5zxdUGTX36KeSxi90D020OVMsMonHYzfeGKeWXPRseU8MHRv
         2UddzWEq9ETP2k/p2hPqLyr4hxuDvVyAShGil8zOBFD082FoYbb/v08vHEbIBPMinR4l
         5H7T7i6OgIMsK05OvySgTX9gqFj4Jg3emi0IV2QWHOnAeZAy7DS2iJdEUFyXGT0bjIQt
         Xd2NQICSiGQmHvV3EaXcM7xon3jqWIJreNdAs2yA6TyPmJV2x6JEdGQeQ+T/uF2pnSBs
         sVJw==
X-Gm-Message-State: AOAM532SyoBGjcW3PZqYqlHm5BWLSDOg9HTIvs6p/lUa0vL0L56AEkV8
        Fuc9kJoifd8SgiXMh9kGJyk=
X-Google-Smtp-Source: ABdhPJxhIj89g5iIfA+l4HgkFNxn7Q3lu1aLzh7RCGjhlTNwD7R6eANDShfu+O5be5/dIW7wpFg9vA==
X-Received: by 2002:a17:90b:391:: with SMTP id ga17mr5028484pjb.230.1643302637422;
        Thu, 27 Jan 2022 08:57:17 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ml14sm3273024pjb.10.2022.01.27.08.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 08:57:16 -0800 (PST)
Message-ID: <4867f2fe-0aca-8c9d-cd44-01d78e3ddd86@gmail.com>
Date:   Thu, 27 Jan 2022 08:57:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 2/2] net: dsa: microchip: Add property to
 disable reference clock
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        marex@denx.de, devicetree@vger.kernel.org
References: <20220127164156.3677856-1-robert.hancock@calian.com>
 <20220127164156.3677856-3-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127164156.3677856-3-robert.hancock@calian.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2022 8:41 AM, Robert Hancock wrote:
> Add a new microchip,synclko-disable property which can be specified
> to disable the reference clock output from the device if not required
> by the board design.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

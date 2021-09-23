Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27F74162CD
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhIWQQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhIWQQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:16:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACE7C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 09:14:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so2084672pjw.0
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 09:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VH8LLD+OqtW4aaSavuXc8s2jGxOuI3P3Z1v+yoIiDmI=;
        b=hxTuSwazOmPt+vNZJrceILwqukBEeYT29Cf/bY96/6yqv5YHRTEveu8183GoNyyy9L
         BkiCuyxq8xEJdGUW2GTlZ8Xb+SMSSyh9pQrv0ira7TjcGG7oP8+y12wcKrW8XQ24H+Bv
         2U6OavPxhgRAJPD6CG3ZfMmcwVrpxjxKknHdD4XeYHGAMAlDQ2lvv5i20iXsZFCHJzBP
         40TaVGsdXbT7wS7BM3F2R/MzXFagkC6HsLh2/8oVzw9C1rROLFxOZcU5B7FJnp4j6QeY
         OsRsNSY4wTIJHlSWt7c3iR2o0A0egdWj6O6Ar6+Ih3DnK4/a0O/NC1hXvrbIMlmIaxhN
         e/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VH8LLD+OqtW4aaSavuXc8s2jGxOuI3P3Z1v+yoIiDmI=;
        b=cpQ4ShnEv3XZyzzH3BHZHQTxNiJmeEHAqxOkm5yfUIc9Oouc+sedMx/UA/EhhXYb61
         q3OiWmXyR7CKI81dA7Xs/+aBZztEBq6LjvBIjxI3kJWWXzeq+6M9ZgR/OzFXuT/uqAn0
         8gKLJchxnNWAWKp5sfG/T2iaphDy716Mo5IrsUkd6vPshDPP95fOefAH1+tRpSniikEK
         OozcWQragyzdqJfgwuNvgw2hIikOxzOdrjGaVMmCffNfYf8DNB0u+A42jXBjFb2BrbHR
         nmh1L6wkbpTZK54jtxXhllDye3C9eJ1l/wXJcpbvYraFk7HVfsDEEJE9Fy1ec9K2+HXz
         TULg==
X-Gm-Message-State: AOAM532NFc3mCChmm1svAclMDJXe6P+Wy+dBuCNUsD/5h0XHZBpq3D5t
        DIoty4SDPFWVae49pSEFZyoxQeb56uM=
X-Google-Smtp-Source: ABdhPJy4cCLyvzS4/BtiB+tdnK1XgomrbcaYwxnZ/8UpC9vk0XsLOXReOtrzvfEgyamtnTF6pa2mcQ==
X-Received: by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP id s2-20020a17090302c2b02901019c88d928mr4572906plk.62.1632413694577;
        Thu, 23 Sep 2021 09:14:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d3sm10245954pjc.49.2021.09.23.09.14.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:14:54 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: felix: accept "ethernet-ports" OF node
 name
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210923153541.2953384-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3d3c5cb1-00e1-68bf-5358-70453d359065@gmail.com>
Date:   Thu, 23 Sep 2021 09:14:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923153541.2953384-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 8:35 AM, Vladimir Oltean wrote:
> Since both forms are accepted, let's search for both when we
> pre-validate the PHY modes.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

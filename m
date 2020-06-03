Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AE81ED5EC
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgFCSNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 14:13:00 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C93C08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 11:12:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x13so3391638wrv.4
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 11:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JqtDpDFI1LWe2aNE+QdlEKbAzw7vqAaPQ3M+TSzYxOE=;
        b=ZFBnnFkzGR9EKMc2L9ZP/IaWyj5NFMkPDWC/tAud8dbYNhScYv4dF7UvYUJMQuKxfN
         2iG2qQD5xaWMdejhqtPA5/GkS/om9eltTJcT8yfqdnA5lLQm2kVt5lmgWjWORKDtZeRE
         p/n9Bci+5zxrPrJ9fsH107A8H+rJTFHBthpMXN9AII7v+C1FirB7n5kEgWI8jkuq4li8
         zdxJtLcHDkwvRaqEiR5Lr9ld/HsMwBN/3h0uKIqoVH27QWQkqX1EOMGpYfA4xlPNdze2
         RDxi5XdX6ibXULyz6HJPxV0HLN572Xpq5GCELyzqmwhbZLKfTRuZQkrTGmpmRrllheRh
         FhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JqtDpDFI1LWe2aNE+QdlEKbAzw7vqAaPQ3M+TSzYxOE=;
        b=i9S1P0W8Wtn7RcC96V0U9RHbUqFipPcjE1gH7URGt9vpJAmkgN7bnXQQaH7DdOV114
         a083ucVWOSOzXeheOv1275t0oUcVUDjQNxpNi1MDfvGa14AO0efvTyncQafXU3qumZOs
         uyrni0MEHpSELUjZ3Us2rb6x4/pGMVfujRuX7arnHvzGYtxIsSmayA2YKfZqSdz09hp6
         syzfLIOOXHwmPvAQkMk6hgnbDZuMsMnkuRBx8DZ7gGSu28md4mYLC8KCpy6k0+jIMNJu
         7okNcNc8Af9FgzMZtAqwzzWa35xOpAIEvUYNGd16yT+QTU1JwPo6Bd4r/Fd1VcDzt4Tt
         nEcQ==
X-Gm-Message-State: AOAM530ppqDHcGRE0+FB6iyVvG84He0wvixWrW+ELCTxDY9DXFfIGzHx
        Sct28/m/kXp95tLSJaFw1fs=
X-Google-Smtp-Source: ABdhPJx+2yc3csM6ovSLyU3EEZ16NdjEE/PKX2nUmZdfn9imS1JF/9maB0IGGcQxAcIukh+XUkGYyw==
X-Received: by 2002:adf:e2c9:: with SMTP id d9mr630493wrj.227.1591207978446;
        Wed, 03 Jun 2020 11:12:58 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h74sm4695409wrh.76.2020.06.03.11.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 11:12:57 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 8/8] selftests: net: Add port split test
To:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Petr Machata <petrm@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
 <20200602113119.36665-9-danieller@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <619b71e5-57c2-0368-f1b6-8b052819cd22@gmail.com>
Date:   Wed, 3 Jun 2020 11:12:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200602113119.36665-9-danieller@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2020 4:31 AM, Danielle Ratson wrote:
> Test port split configuration using previously added number of port lanes
> attribute.
> 
> Check that all the splittable ports are successfully split to their maximum
> number of lanes and below, and that those which are not splittable fail to
> be split.
> 
> Test output example:
> 
> TEST: swp4 is unsplittable                                         [ OK ]
> TEST: split port swp53 into 4                                      [ OK ]
> TEST: Unsplit port pci/0000:03:00.0/25                             [ OK ]
> TEST: split port swp53 into 2                                      [ OK ]
> TEST: Unsplit port pci/0000:03:00.0/25                             [ OK ]
> 
> Signed-off-by: Danielle Ratson <danieller@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> ---
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/devlink_port_split.py       | 259 ++++++++++++++++++

Any reason why this is written in python versus shell?
-- 
Florian

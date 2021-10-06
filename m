Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04209423599
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhJFBvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJFBvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 21:51:23 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A24C061749;
        Tue,  5 Oct 2021 18:49:32 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id c7so954612qka.2;
        Tue, 05 Oct 2021 18:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NFTLGHBMGTj/bqyB06pAbMTp3kmN65zbjk+H+k3VcA8=;
        b=Ex2YmvXGeJGYy66cjbZGQBgJ7suFCi89zfBgsx3sOq6SFa2OF0bwdQ76RX6RtJGtW7
         exO1n+q9d04sNO+NZAIm01IwwLzhtRvp6kXbsMiFyxqn5O2dIyc2s2m7PyL/nwUNPTRb
         6nnE0C06rj50cDQRFLAH3/NjQgya5AI5Ti4ms7X8VJnGbhMGf41zWw9HA0VBTKfDvg7E
         9N35D1PgB0sck17ylZiOLszp0hdutV9r6YeCVpXYiY2ppBTquy2Ha9cy2uJNQFp0e5p9
         sgCVq/Feo+t2pDacbI+FIjhGUyqVyG/9XHqz8qMOVe8lXmtRNyALJwR/6xCG7Rxwwbx7
         JfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NFTLGHBMGTj/bqyB06pAbMTp3kmN65zbjk+H+k3VcA8=;
        b=wm4BRfaqUoXyPAsEZRFhhjh/KdxIONv89IRpJdjgCNNsNYVSEELXPilhJQICTWRpyy
         hUdFVmEHTMtfmKp79hTrOv1v6lyaugelL7Xb9PpUAGBUAwS7FuTW7to0vwtFdk35flWK
         1qdO4TjeZlgoEVthaH9v6G1/VS+6ypXVWSYyRFe3OCOaS4rfxzEtHinpYThiJDZSwKw9
         coiOWiZ310szQG9/kZMpr5fZKYRhoTreL4mi8ya9iXzP6xRFJAKpwp1nOVNQvCIGLPUz
         YdW4sDGAwvYwhEen0uXTzCjmQyyfpbJTMhYnK+dhvcVNc0U7tJ2B67twbbLpnW+TYW/L
         G5IA==
X-Gm-Message-State: AOAM530I4NQe80Z+vSEyWM+NLZiVRS/1elHqtQI4yc6P+8ZOASlBh1i8
        UdeWNN6huIPguCeD6kpjYCY=
X-Google-Smtp-Source: ABdhPJwDgGToZDL5/cCajwllHpQypKrp/R6X/JPrK1sGGUw3fGqNpHSPljiyCXX1rq4F7qpUj9Eh/g==
X-Received: by 2002:a37:a241:: with SMTP id l62mr17808851qke.386.1633484971058;
        Tue, 05 Oct 2021 18:49:31 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c86a:e663:3309:49d7? ([2600:1700:dfe0:49f0:c86a:e663:3309:49d7])
        by smtp.gmail.com with ESMTPSA id g15sm1687669qke.61.2021.10.05.18.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 18:49:30 -0700 (PDT)
Message-ID: <088acbaf-8f9e-6895-d1e9-2382803deb80@gmail.com>
Date:   Tue, 5 Oct 2021 18:49:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH V2 net-next 2/2] net: bgmac: support MDIO described in DT
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20211002175812.14384-1-zajec5@gmail.com>
 <20211002175812.14384-2-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211002175812.14384-2-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/2021 10:58 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Check ethernet controller DT node for "mdio" subnode and use it with
> of_mdiobus_register() when present. That allows specifying MDIO and its
> PHY devices in a standard DT based way.
> 
> This is required for BCM53573 SoC support. That family is sometimes
> called Northstar (by marketing?) but is quite different from it. It uses
> different CPU(s) and many different hw blocks.
> 
> One of shared blocks in BCM53573 is Ethernet controller. Switch however
> is not SRAB accessible (as it Northstar) but is MDIO attached.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-y: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

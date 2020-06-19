Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF2F2019FB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403957AbgFSSI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388336AbgFSSI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:08:56 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA18CC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:08:55 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h5so10583796wrc.7
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YD0k0ucldMZEEAW3H4tt7oRc0Nmlw99yW1X3umBjCPk=;
        b=mcIDZ2lbM1Om2f9nIQud/jMEK2NqY+2Iui90Yz71qQ6OZTg/2Sx1DSY68uda5TUoxC
         F5YOKhmAhCOa6hhZPtAfotdArbhjEh2h/BIiQeRsKWxdCfuXyUvItKdjL6/YMF4kZhex
         Fj5q5ORi2YCBG68AewkQet7gtKV9/JLzZy/GPWqCoCEtZeCnrJWO2fY2WVuCn9Kg/6Au
         biakNLQNwelVDkfBRgjsSOVGWCJoyHIroa354rjqDwUQZQ4wmdmFPA6zBu7qIFqITjjn
         Ows2fD1agASSvxZKqoFFjIbesyKdf+EmW01/GZccpzbN95LijC8n/06bJEitymgBFbei
         KJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YD0k0ucldMZEEAW3H4tt7oRc0Nmlw99yW1X3umBjCPk=;
        b=bVcF4M0sTAiCnXNU8vBLJnRPYsjJhzhIAWgIIi03cYERCJPrmIPrkzrb/NI6vlycxQ
         g44ZrqFC8z1+jpyvNtLgwMnwweX/u10+TOWdADccr3UlpETDFjG6kw4FaPdvwgexEUGB
         fpgg+OT5olpNHmgLVGZIY2aetJgAJGqS2Q9cPxQbXAA3l8KaDniqFMlCkgWx1RIHbtne
         oF9sA2ttHgUln5dZvnpskH3Mz6hYTbBb8Bn+o05D6fP5HN0dlhwHIlRZ+u3e10F3Btyn
         Luit25/DSN4XgGKrW3FyB+dcugzPwzz5u5zXTMFDnsCqoCUfuJNd8gQVQyaAjUby+hit
         qe4Q==
X-Gm-Message-State: AOAM5302RA/R+YtmOk31ruFw/FoK+0CLmwUNWP3vIV5sZNnA/FK+D2u9
        k8N+FZk4xZ/C8VOtaE6vTJQ=
X-Google-Smtp-Source: ABdhPJxM66HypyfkNjTVE2nus1tp/0uaWYUmYgdS60fKOXi+g6p+oKEWQo8UU/5sdgmO+IUSnNrPCA==
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr905175wrm.282.1592590134431;
        Fri, 19 Jun 2020 11:08:54 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g19sm7324370wmh.29.2020.06.19.11.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 11:08:53 -0700 (PDT)
Subject: Re: [PATCH 1/3] net: phy: marvell: use a single style for referencing
 functions
To:     Maxim Kochetkov <fido_max@inbox.ru>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200619084904.95432-1-fido_max@inbox.ru>
 <20200619084904.95432-2-fido_max@inbox.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <177fac6b-cfc0-d3bb-d6c0-a807bd3d7b89@gmail.com>
Date:   Fri, 19 Jun 2020 11:08:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619084904.95432-2-fido_max@inbox.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/2020 1:49 AM, Maxim Kochetkov wrote:
> The kernel in general does not use &func referencing format.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0231F2BD03
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfE1Bxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:53:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43952 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbfE1Bxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:53:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id c6so10425711pfa.10
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 18:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1SygZIj5RkSxHWlledmPYdZk9WFBSaC0Fte9eb8T3eY=;
        b=j47EcEWK1AOX1Zzz6K2mV+9LxqUXbkaRleGK8Qyetyw9O60UwmZZXkKAn91ZPoI3PT
         0Y02+rPOjkvvkrXQ522iPauZ0mXhG+IveA+04sJfCrxXhS7H+a+85/jrWhvlf5p84YoS
         MJ0DL+UCIjylpxSAe1n3+RnIfd/+oDjDOFwC9fzSr4RYXyflzIXDqRF60qnJdB7kw9Dt
         zWKH29aUjC6BRC9A72QBmFzKwsownoG6thczwXoG5BYBAG/2j53nj39fpmhO7OT2mWIx
         bsPqA2yGln5/JQ6WH+7Ir1/Ms0HxgO0Rtsi/YsViOiyLfu6Jik2sC8ixcZgB9FwgS/BT
         MNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1SygZIj5RkSxHWlledmPYdZk9WFBSaC0Fte9eb8T3eY=;
        b=m6q7aM0jJvOsFkLbyvYH+kHacWgkY2HymMBMsYZc8Tl6PDpA6QzgTUQ22KfYRbmXua
         qvNmBBN2B5F9XUsGjFQRyc3Nuq6MVzBNMz20s8m2qYKkX20KYuz3cKNhvK3vMAz2ATr3
         Ndznl5AAevRvzbhVxUDEQwqIyd2EefyMlyqhdGVLiCRfW3+H/WeHmrmh9yW+ysCVm/TY
         KSfbiWQ2ziFahogxk4wyH6OCArfDD+ycRS3+XANdP8CMt4koAnUc8w99an0DDUZwGheo
         RP25DQqQWo2uC5fm/P9r3nG7IIOCnUs2kH7xueMYwiRQHvqjMeI3fILBbBOZsImizv+X
         CONw==
X-Gm-Message-State: APjAAAXGToUzteE29qg4dlqb5Zlyv+0TrZzAKnkyyhIF2iKx4DmLj1qe
        5leAMrk1eoGD7V68QQz2Cr4vigxd
X-Google-Smtp-Source: APXvYqycbuFZC+UgrPVYuq/U1Ya/8HWQs+upOmV+Ehr/kuLJlQZioZPAylB9IeYcqTWGiiIT2dVdlA==
X-Received: by 2002:a65:5003:: with SMTP id f3mr127284619pgo.336.1559008409730;
        Mon, 27 May 2019 18:53:29 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id s66sm33926705pfb.37.2019.05.27.18.53.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 18:53:29 -0700 (PDT)
Subject: Re: [PATCH 08/11] net: phylink: Add
 phylink_{printk,err,warn,info,dbg} macros
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-9-git-send-email-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <9b8afa2c-5bc5-322d-3d83-bed374dc7797@gmail.com>
Date:   Mon, 27 May 2019 18:53:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1558992127-26008-9-git-send-email-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 2:22 PM, Ioana Ciornei wrote:
> With the latest addition to the PHYLINK infrastructure, we are faced
> with a decision on when to print necessary info using the struct
> net_device and when with the struct device.
> 
> Add a series of macros that encapsulate this decision and replace all
> uses of netdev_err&co with phylink_err.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

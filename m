Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECA32BA93
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 21:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfE0TPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 15:15:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38407 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfE0TPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 15:15:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id b76so10012660pfb.5
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 12:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e2sNGNdO4opLMMme/Wc7OWFZqrvz7uc2BKYQuMzaCMo=;
        b=hYv6KhEfm+EVljqjOlUClHe2kKuw1XK3T+Mpdc54IfBs1Sm6TxJn1+tBSkIjo9LxuC
         /23VPGgsU/gVqP8Gc45m8vZpf0lrEmQMSJKBuhcLGQ5aofrvjtPsuINq0wUXXI0zfCk3
         TY6x6U3jqcT4DId1IYUAS4B9+193b8umHbFkX78jnxMgtN1SU1NElTd+bg34lyKX0vfe
         UzWqhC6XT25UIqoqrwGzrumJ/cmLgZsG9j6afnYPf0VgSCR+JjBcpPFHYl0tZtxKZgsr
         zngjh2cmKngQUFtDvNqzTNEmUg16LGjxkVXomw6uCr2JcEpdka/CA5E9rHrcuU+aHZF2
         JO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e2sNGNdO4opLMMme/Wc7OWFZqrvz7uc2BKYQuMzaCMo=;
        b=GL87v1t60s2nCM/YA0UXlLwvqNAjBDF9D7VCXD06Fg2hU84MWKK0B53D7Yql/XJ0iQ
         a4KDwIbfwCIv4ruHlLko/QS9Ep4AMzzqng3JQ7HSmN8lnnSXQeH8ykBggDfpVQYSko1n
         6KiHfap3PL7FAjsGlybsz1MvJwefKSyDexlON80uDrhUwykWT/2HrkNvp9kQQEoIILO9
         6gKQ7dFFdBiwniLPQrgYBuQWTdAQ3oHi4jqIbuCSQRFAi8Ptqf/nTDkhonN4JfG/1YGF
         5yec462k7ybLZAtIWHSwI40dMnQDEO3nG8crhMHInzok9UPiJ6cFjb2SVvRPuppBl7Ue
         OeKA==
X-Gm-Message-State: APjAAAUaDKAdHq3KGh2XLEsSX1fN8dm6EZzb7Y76GlOjag/MtXnuX/F+
        u39mX6B1FyxrTnSUFcdkJp0=
X-Google-Smtp-Source: APXvYqyX9vzBZVdiOdYzZvnN6ENBIUm+JUY69f290EoIaCOGAwe7JUJkSGpWfbasz/G5ccauQ0GZiQ==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr547715pjq.46.1558984507875;
        Mon, 27 May 2019 12:15:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id q18sm10549766pgn.17.2019.05.27.12.15.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 12:15:07 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] net: phy: dp83867: Set up RGMII TX delay
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net
References: <20190527061607.30030-1-muvarov@gmail.com>
 <20190527061607.30030-5-muvarov@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <22875d6d-3131-2fc4-e6f2-10f62184c733@gmail.com>
Date:   Mon, 27 May 2019 12:15:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527061607.30030-5-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2019 11:16 PM, Max Uvarov wrote:
> PHY_INTERFACE_MODE_RGMII_RXID is less then TXID
> so code to set tx delay is never called.
> Fixes: 2a10154abcb75 ("net: phy: dp83867: Add TI dp83867 phy")
> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

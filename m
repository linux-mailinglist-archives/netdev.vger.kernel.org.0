Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18355FDC2
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfGDUYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:24:15 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41825 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDUYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:24:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so3327996pff.8;
        Thu, 04 Jul 2019 13:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TanYtRlfsVvBubfHthYKoLmt4bWU2kpmJREyybX9L5A=;
        b=ownub81hToiv+DRqgFX3ORIAH0GDgOHK4kU+ssbJGdPs9uRYnjisX+kNrK0T3mncPf
         arWdeErWbkzRAwjm0X6Cgm8AYNEDNsHI7YU3Z+VHySZ1sbESs/GmGinyN5UjnGlxqhDf
         gyf7uPYGZPx3DrnlNqVJF05sTxnepaZbf5aNvjiM0toUoFyEZP1vJkNBo9h05mljDA7T
         /tu8AjU2Pw37HNOtlA9edU/Rp+/OlCcXTVJJjYs6hFK5LX/GCvwNM3EqwF2X7f59jpRv
         G8Fyh0vohCFYXOzdfqHNion9mLf5IqkGV8PUfEtG4iPkth33zGOZw8eqtdibfwbtn/n1
         oAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TanYtRlfsVvBubfHthYKoLmt4bWU2kpmJREyybX9L5A=;
        b=IqdlUU/9qUyEYWGV8n0/NgSKU85cgoGFu0kzIzIhy7rLiyuzK6inqJjLQrYoBkE72K
         mcvvzNK+zVnP4TLKNy3wxxIYPWsQNQH0HiOoB/PKqdxe5v2nakLhWWBIvqsfxGwxFGJr
         Nj1iBG6VMP+HQ4euz0t8i+c4M4d9NIHawLn8m9jWLQrQdatYg0Bl3wodgjeg0bl56cS8
         4TU3YL+cvI5mJiIE3Q291Ox3r9/NR8MynIHbVQxeoRVYHi0YIWJmk/RNvW7RKMRLSPq+
         HOyKe5SfJ27XY8KlII0ytEyjAwiwEMyIGqWD6l9IdJvlOEPzYBkf4AsxVIzLd23qeJ5T
         kZug==
X-Gm-Message-State: APjAAAVc/83rrz3zCYvzieVAmZ24n2AW1hWANDs7UbE69h8zCJPsp3BS
        I4XLaFUTgKTh4rduBWAGqy10b1W4
X-Google-Smtp-Source: APXvYqwaMmlAya41Gk6m1cnP+9jSRmadz6/nRZigbPi+Xp7RMFtY0qp88xKuqc6R6ycLaWtSm7JIcQ==
X-Received: by 2002:a17:90a:8c90:: with SMTP id b16mr1393862pjo.133.1562271853978;
        Thu, 04 Jul 2019 13:24:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id v3sm6302054pfm.188.2019.07.04.13.24.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 13:24:13 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] net: dsa: vsc73xx: Split vsc73xx driver
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190703171924.31801-1-paweldembicki@gmail.com>
 <20190703171924.31801-3-paweldembicki@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <3f4eb7c2-512b-777e-39c4-5fb18f9e4226@gmail.com>
Date:   Thu, 4 Jul 2019 13:24:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703171924.31801-3-paweldembicki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/3/2019 10:19 AM, Pawel Dembicki wrote:
> This driver (currently) only takes control of the switch chip over
> SPI and configures it to route packages around when connected to a
> CPU port. But Vitesse chip support also parallel interface.
> 
> This patch split driver into two parts: core and spi. It is required
> for add support to another managing interface.
> 
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5068DC70
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfHNRzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:55:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43616 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfHNRzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:55:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id k3so2433780pgb.10;
        Wed, 14 Aug 2019 10:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j9DLeltmWqsK1VKgMNbmGPdPd+zVJj18lOtoOTyj2aE=;
        b=B5cExcFtUN2xSf6F3KnANjZcMO32Mf1SribfPey0JtmNXxP4BDTAMD0d+ux/DLkc/W
         ITTu55hrJsUbt9+IM9KQiLP83n0V2nRU9n67rIdC9OVzdiZ7pk6zz+wp/L3YHMbZuDlJ
         P9OhhNvDSJ9cyq7HAl4YkJCU2RkcqJuzgLUdsrIIxXGFnfs9xD+Jh+UR8blEBlnfKbyg
         Zfd0WwndgjM5jYj8UDTIkpEVDC0m3l0Sg7Alc5t/g4yuppOidJdmEA0osQ7QwNbukflH
         /eBA2LoyaJ2c2j5BN7tRdSlbmk/PgPznRIU0NHp6N7xBihLIECuNws2HqVGTNWG9rnRs
         3EMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j9DLeltmWqsK1VKgMNbmGPdPd+zVJj18lOtoOTyj2aE=;
        b=f64oKIyDGVHrlMsdvTpsVUiYb2OqfDhxg7JyK1qcMRP1xzQeQtaEnz4nz1Ho06dQgf
         bxn+GxMAIma7HQUKb1W3EY6ZTy+z9r+iGFx3GOjLvAI0dX1czKeteUXNmHaBItpgiG8q
         Lrbj9a4/M1zU76M5KBXhnnOuGd+xhncLqmXTeungonbImHCamna6VM72MoNaeSHWYEau
         XUKtmGihi4N2KlxfNcwW9YNk+Atc5lpj8QeZ0v943js8al99uwO/5KGmfXw1prR32CKi
         nVTx9QnWUb/6nb09V/XXgr8T99SbE1fncZJVVGGDAJ1HKRfSgfFvG6tyELNTAEQek7B6
         oU1Q==
X-Gm-Message-State: APjAAAUgfeVnhwuB0n+sgohKIgMuosGYY3ZZq9VUIvzjUnmYsoadsOm9
        2muzP0UP/a+YLe8niEOazbE=
X-Google-Smtp-Source: APXvYqxSIRb1/qhZIB33TiXGqt0Q79qM9ssv70o9wS6UrNdzIIuWrlDUBMQ8awZ8/bMnW+YCxo7v1Q==
X-Received: by 2002:a17:90a:2525:: with SMTP id j34mr906461pje.11.1565805323712;
        Wed, 14 Aug 2019 10:55:23 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b14sm297615pga.20.2019.08.14.10.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:55:19 -0700 (PDT)
Subject: Re: [PATCH v4 09/14] net: phy: adin: add EEE translation layer from
 Clause 45 to Clause 22
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-10-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <14ef4f7c-74d9-f8ce-a146-5c5f8777d5ed@gmail.com>
Date:   Wed, 14 Aug 2019 10:55:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-10-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> The ADIN1200 & ADIN1300 PHYs support EEE by using standard Clause 45 access
> to access MMD registers for EEE.
> 
> The EEE register addresses (when using Clause 22) are available at
> different addresses (than Clause 45), and since accessing these regs (via
> Clause 22) needs a special mechanism, a translation table is required to
> convert these addresses.
> 
> For Clause 45, this is not needed since the driver will likely never use
> this access mode.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

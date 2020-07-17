Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7C0224536
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgGQU35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgGQU34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:29:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5AEC0619D2;
        Fri, 17 Jul 2020 13:29:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id w3so18915104wmi.4;
        Fri, 17 Jul 2020 13:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PbAhWdHvHt7m/jshBgagWE4qFwSSRbIkuO8Zm6625xg=;
        b=j3DfUaLet+tHGz5hwEy+Q6N/qNE83K8LycMg9sAkknQavrG97fRmH48OmDkieMMD4j
         xX0/yFqjEopZOkjggRblpPB467oQ91UurwE2yOG8j9e6EawOy5/dbLx1ZfSZAZtX9V/L
         Ic58XGDzWmw9D/xMpWPoozjOTN7ff4FqrWfYtXluBDsVO17HXV9eh/pAVdQaeyAZfa9S
         CNNvw6DwVKrWcovRhY4wRmA4S8sQERVG9k5u00reQ+gJtHZdm+Tun/RGAWsma/vb0yMC
         XVPhnmOEN2uIy9JzswXwLUcm5kyUsfJdqDZUrbHhcxvaZ8nHa4yWYpk9/y/HZegAv0sn
         4jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PbAhWdHvHt7m/jshBgagWE4qFwSSRbIkuO8Zm6625xg=;
        b=LU2L6EUcF+dIVKa+KFasx5+0TpUVR2SMSsQceJ3tA1sCwc3+lcpEVdSnoHmMIdeD+7
         2suaTPNaucBAlhFGR3IshjsJWrB59pnL9mWKNY6mcsWzBdxpe9szc9Rg8mMGiomPDUNe
         LPWmLRCFTqxbQzTnb+TYx1NRe52QLFIxsEJSqQ2kOCGdOExIZmdIpFkAigQSZ1awb9vo
         DbtmQvqZOwpDDB4PISn8YqHCRiQO4ajr3ZJpQVE5JHmI17irSbP5PRQiubX0TVAsOzyw
         TCPL8JvMCCMJK94mpdQaYTz1BJFHE0vjP7azD//q5mwX819ysoQeq7XRz/+L4O6twQDc
         lSOA==
X-Gm-Message-State: AOAM531BBY9t+jrGoOBurEMwS3OAE99Gm3z0l5xQYO1SruVFkGEObrj8
        Y1CoxgwQ6jARTx6V/pQ0HZquMnXo
X-Google-Smtp-Source: ABdhPJzkYlnuEDFV3LA4qfCwsWwGo6wVIh3H5YCJznl7WxPJ/vK9QnXRAOkfWdj67bX9Yzp8nmUfzw==
X-Received: by 2002:a1c:7402:: with SMTP id p2mr11065874wmc.117.1595017794784;
        Fri, 17 Jul 2020 13:29:54 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id t14sm4490141wrv.14.2020.07.17.13.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 13:29:54 -0700 (PDT)
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
Date:   Fri, 17 Jul 2020 21:29:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/07/2020 23:09, Jakub Kicinski wrote:
> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
>> Add names and decriptions of additional PORT0_PAD_CTRL properties.
>>
>> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
>> ---
>>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>> index ccbc6d89325d..3d34c4f2e891 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>> @@ -13,6 +13,14 @@ Optional properties:
>>  
>>  - reset-gpios: GPIO to be used to reset the whole device
>>  
>> +Optional MAC configuration properties:
>> +
>> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
> 
> Perhaps we can say a little more here?
> 
From John's patch:
"The switch allows us to swap the internal wirering of the two cpu ports.
For the HW offloading to work the ethernet MAC conencting to the LAN
ports must be wired to cpu port 0. There is HW in the wild that does not
fulfill this requirement. On these boards we need to swap the cpu ports."

This option is somewhat linked to instances where both MAC0 and MAC6 are
used as CPU ports. I may omit this for now since support for this hasn't
been added and MAC0 is hard-coded as the CPU port. The initial intention
here was to cover options commonly set by OpenWrt devices, based upon
their ar8327-initvals, to allow migration to qca8k.


>> +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
>> +				falling edge.
>> +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
>> +				falling edge.
> 
> These are not something that other vendors may implement and therefore
> something we may want to make generic? Andrew?
> 
>>  Subnodes:
>>  
>>  The integrated switch subnode should be specified according to the binding
> 
Matthew

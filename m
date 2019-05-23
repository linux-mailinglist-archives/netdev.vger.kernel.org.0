Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6BA27430
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfEWCA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:00:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40329 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWCA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:00:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so2307842pfn.7
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zzQZxeov9p3mUQEyk+xSa3Iz6IrOPbDizA1r/N3J6zc=;
        b=LYKW0Y5ld8j3GSuakpGCQ5d/N4u/bVrXkOzgFB8hxfXryYRgd9qK2Si/wus4qCyGZO
         qVN8WYPFcSdrdjgkjLbkPl9MjbNdBsC7QUV77Bu9e1B4Qk4QzjbYrtRVaYG1SOYwVShI
         M1XoedhJO+iQCdjWcg4RxRNF4+PL70tGj5vgQah/4idSDHZFcx+NEhplwGei7uYxYQpA
         YplCCv2DAH3HbT7BWYeH8REW6PrvRNKQa4trJzzCE0R8iCqlz2wC++bNSPBTQYQkzOn/
         bV4kswb9khiHztUH1g12ssOua+numrWKp8t2w6y5x9V2daVCDsUnzhTPXSyl6F5GIVWg
         s9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zzQZxeov9p3mUQEyk+xSa3Iz6IrOPbDizA1r/N3J6zc=;
        b=FOXFTfTUwZ08RO2VV91xO6cXgbSxWSdzxuzeOhbL5RJV5KsTSF+9j0jenJxRq/yNjC
         tCmvZqtUEeT8sOBM0s/JnZJ6Jgl4EWqn5gAOTr2wW8M3Tz6ETusKS3Tj7EeEGUMOpw4n
         HDq1oqwcZ/nBF8WUMIqoNT2bD/TAGf1gKr/+sXjOc1hqRCn5piujitdi3n3J3lJf2IuT
         s20M1R9qOPGhqFMRvPEtLUCEnUX4OtVd8fmOeCmrzbONHbhLVypb32ncVDsRUWO4lICr
         jNRodV7CpbVadtrSOhMFuCkwbHnu4QMTPdEGKePIzUtgCeljRAgP4cLjMTsJzDZ3Gpep
         3avw==
X-Gm-Message-State: APjAAAXn3uKWmLl20MYYQEiBKIKj6IcJOW6RHGOCFo1CBWRGrT4nAvW2
        UWZOBOywzq+zRAJcqTHTUgk=
X-Google-Smtp-Source: APXvYqzYpjR6pU+fSafI8VDb5zNTpm/iiHswO+/LN0AWIyKQ9KnrlCNA6clmX3c+UAc1t706nanXBA==
X-Received: by 2002:a62:1a93:: with SMTP id a141mr67726375pfa.72.1558576827234;
        Wed, 22 May 2019 19:00:27 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v16sm12135532pfc.26.2019.05.22.19.00.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:00:26 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/9] net: phy: Add phy_sysfs_create_links
 helper function
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-2-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <dea376b1-d73b-b06b-6e9e-a6993135be7b@gmail.com>
Date:   Wed, 22 May 2019 19:00:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-2-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> This is a cosmetic patch that wraps the operation of creating sysfs
> links between the netdev->phydev and the phydev->attached_dev.
> 
> This is needed to keep the indentation level in check in a follow-up
> patch where this function will be guarded against the existence of a
> phydev->attached_dev.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

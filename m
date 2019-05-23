Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEBE2743E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfEWCGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:06:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41315 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWCGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:06:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id q17so2310604pfq.8
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t0jlbcDDPY4/zwYJLghVUyvA0rlRFPjXwD413pNOwKk=;
        b=HMukxjmk4+D3UMK1So2FfX39UVEXDLqwiobltfRCaAciwAwRYzn7dOgn7sdORtFcX1
         wDgcoHIff7aUYNakM82eykcDS8FDfnXiOkh2+4WwJd6xf2fKmhEzUuCghOjNISpp2kgE
         CSmhGkXMMY4MPCNpFRZ0g9r2PYqpab4oszCJOf9AbHyQnpkShH6M+NWgoUxgWqkFpaHW
         eXerqqhzK/IYAIKUF4rvi2qxAR+XaJS+pl10m1cMZKBTVFehUEeXiqm+z4KPugR8JocL
         iuEEMDHrhtGffvf7tMh9UDa1vc+3xSTGF61BpCEilvU/ihOom9OGGUheGZiidn2Xwh1h
         s8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t0jlbcDDPY4/zwYJLghVUyvA0rlRFPjXwD413pNOwKk=;
        b=tSTGxfujTAISRI0/6l/K4jcpt4ZdzE9cQFwaYfiZxBTI3FOXXkVmXzPXGhM8iGYCsp
         7scywlCvTALvAL4baas38tfcxjJ9TNxgCjZ7VeyJ+cEEfAItAJPlw181o4HojLPPKz52
         hl/xAuYVeNZaIX0VBKlMYfCtj7wkIh6ZAXoDpIonKQm91y/JX75SEvlIlQp2eQCsfCAP
         dD5z8EwjzvYwSuFD+zB5+PCkLtQZaZ2wKPN+bQNEc2BpNGdGpR7s32Veh04wRRBh2KxU
         bf/lJs5EjOUy8cPJpRe5F030A7eg1FQZhYEkmld8piTEm77MzEgnrwbR5GykR+JCPtkc
         ORcQ==
X-Gm-Message-State: APjAAAUMJs697sz7RntNJYdN+G7QzNSJLSmRIstRZBYJ3F8LE1zLKz8b
        a168jPz9qqV/6+geoOcK2Dc=
X-Google-Smtp-Source: APXvYqxybvpz1gMdPyrgG8b5uWTGgTqUm5GHebkChRX6bohbLdVxyeh9fohf2d8cuGHChBHvotR3Lw==
X-Received: by 2002:a65:5241:: with SMTP id q1mr91250316pgp.298.1558577166084;
        Wed, 22 May 2019 19:06:06 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r1sm31622799pgo.9.2019.05.22.19.06.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:06:05 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 4/9] net: phylink: Add
 phylink_mac_link_{up,down} wrapper functions
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-5-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <485c1278-1a06-46cb-4108-02be8e947466@gmail.com>
Date:   Wed, 22 May 2019 19:05:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-5-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> This is a cosmetic patch that reduces the clutter in phylink_resolve
> around calling the .mac_link_up/.mac_link_down driver callbacks.  In a
> further patch this logic will be extended to emit notifications in case
> a net device does not exist.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

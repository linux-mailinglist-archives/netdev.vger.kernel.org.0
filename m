Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCB82BCFB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfE1Bv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:51:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42136 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbfE1Bv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:51:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id 33so6974748pgv.9
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 18:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LNkjYrRJA0LchJCQlJOTOeprpPsFgp4/0Y9gTNf5+JI=;
        b=kU8mF7LQfjwmLb0tIMu2MTDRdf6lOvBj21TYobtSkWHFvVtkWi/W4acmvpwwXPDm9l
         J6nhxgKq6RyrGR3vT+xZ9iM5Aef72yisE9nyGtFtOE90zD11dAD6RgktRILm1WixKWU5
         nlavitERQi+iR7hXaaywbnCmFyoCsApZelIe6B3BMBOrGs6Gqlj2Z2TmOd55Ll0KAq/Z
         KZYZ+Ge9v8gy6ULhFRRS7zhQeAA9/PhjQz5OSg0hVoTOCJ6pz9tE/2v6fW5mxxDg3+zk
         BrKxDvGESNS5E7jR0iXWaopEBmsDxgvWCHwe0/ougnGiPSA/rHiHhuNli1/aCS/fwBao
         /FQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LNkjYrRJA0LchJCQlJOTOeprpPsFgp4/0Y9gTNf5+JI=;
        b=mRV9/evHZ+2nzwdq6q1e48gMLIFFTrQKgI4r6safTer8j2BqIIX4VjsVhPhEVQNRfE
         2YBvw6lYX8Bqy2lCejQA1QzAmQXJjB0z0yiD+05R3fAMpOd4y+vU+qrY4PomrKYFWdg4
         n2X/JLCeTUB2QtixNuP2mH/O1U0VbQgMh5e4ualxs+2kk0NFL9CrK4EJTHfiptJAt88N
         FV1VlwT2RcmMPtBHMJB+IeZ/3X97xgNkoKa08E21TNZfhm+1dG4O72SS4YNj4W4DpaYC
         oqhW05t2q4TVIY4TVWN4d6rNjuknS5EpllBFZ86i/2Z63eG46H6Vfw3jyQ/4mlcmcPg6
         ghlQ==
X-Gm-Message-State: APjAAAVBYNpwyMr/DCljTgU0rSDGtLE/HuPdOcfCZqsmPXRFgx1WPy9d
        lyZnZ2Wt6xKs2fvdSHGkjbuavWrb
X-Google-Smtp-Source: APXvYqzCML4FFjUFCsqeZX3YW+SIkkAMkoy52tR5FNkz8Qf5j8Akn4bEqMzBrY/BOVYJEPUsCHhB4A==
X-Received: by 2002:a62:ab10:: with SMTP id p16mr106510175pff.222.1559008287708;
        Mon, 27 May 2019 18:51:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id f67sm14245225pfa.149.2019.05.27.18.51.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 18:51:26 -0700 (PDT)
Subject: Re: [PATCH 06/11] net: phylink: Add struct phylink_config to PHYLINK
 API
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-7-git-send-email-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <d69527df-cbd8-3575-db70-e5f1166a5060@gmail.com>
Date:   Mon, 27 May 2019 18:51:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1558992127-26008-7-git-send-email-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 2:22 PM, Ioana Ciornei wrote:
> The phylink_config structure will encapsulate a pointer to a struct
> device and the operation type requested for this instance of PHYLINK.
> This patch does not make any functional changes, it just transitions the
> PHYLINK internals and all its users to the new API.
> 
> A pointer to a phylink_config structure will be passed to
> phylink_create() instead of the net_device directly. Also, the same
> phylink_config pointer will be passed back to all phylink_mac_ops
> callbacks instead of the net_device. Using this mechanism, a PHYLINK
> user can get the original net_device using a structure such as
> 'to_net_dev(config->dev)' or directly the structure containing the
> phylink_config using a container_of call.
> 
> At the moment, only the PHYLINK_NETDEV is defined as a valid operation
> type for PHYLINK. In this mode, a valid reference to a struct device
> linked to the original net_device should be passed to PHYLINK through
> the phylink_config structure.
> 
> This API changes is mainly driven by the necessity of adding a new
> operation type in PHYLINK that disconnects the phy_device from the
> net_device and also works when the net_device is lacking.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

The PHYLINK and DSA portions look good to me, and this is a lot nicer
than the notifier, thanks for coming up with that scheme:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

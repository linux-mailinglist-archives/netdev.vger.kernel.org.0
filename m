Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164892BD17
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 04:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfE1CB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 22:01:57 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39758 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfE1CB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 22:01:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id z26so10445540pfg.6
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 19:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cRnJd29jEvgDOO9nFMs0tE9mBl15uKH3s0mrH3U6eQE=;
        b=bg0r76uBMXwBnskD6v0/VZNRkpcCrKKGAZW2YguP1vc6uCbxFJjnCXRanguPnAL9d3
         GKZsD73kdFUhhaC0rx2z33UMn38F/6i3G+1VjGQq3ZlGCPlwsIH0tyB4DdQiLsD2hcB5
         B/IEYSDClMWsE9zTBNpOKV1yUq+FzzU9XDhUUDt6r6w8jwIkHzxUMxT4icFs98EmpRL6
         Dq5b+h0DHvlypXuqNq8uxwp+nolkQZYzriJ9CM39rMjHjmPMO8g9PSfJWOZ1nExuYETx
         WPyn6eHJluIAvLHmH+kkeFgEzUGI82iih177yOFLXXLW1t9UM9YXHxnxSpEz1yXSKYbb
         dCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cRnJd29jEvgDOO9nFMs0tE9mBl15uKH3s0mrH3U6eQE=;
        b=FD0dKQbjZtyCpID0VKJvt3GO0YW8ZtLZM05i7sGAX7D2iji0Bknij+mFmP6zdQ4S7W
         TwA65OYwo9MkEzR/4QAq94i2vRyjwugEoqmmfbNvjzD9nyeaeE4sNKOO6InppswRGyWU
         jfWCIXvhd4IQmcHeCWmZZy1cldKK3jqsVqn17ryUYt7ZURtArnSYhFDXdiu6FOTTBAVS
         VrUWxAIVffdK8MsuHg2okfCM+91LU/dA1OfgtDZqx5cLKpyw/PXQTS/NSeZtAzGmubDy
         ub76bVCHQV86ay8HZLfKixv4LYh5sItjOxRgIKvB//xFRtXulSsSnpAq3/uFYGGrqj3s
         EeKA==
X-Gm-Message-State: APjAAAWsF/NHzhkSeaoZ6m9OErbot35In3NPuMynfCMYn4qA6l9kZbYM
        zsPf2JE9+rkZawYV9dJFo6bl3f+T
X-Google-Smtp-Source: APXvYqymxrjB3s1p16hh9obcg4x7eFzPlaEenTsyiEnW3+FEceJg5Y0IGkWm9x6Gh3ZaOXmO2kL5oQ==
X-Received: by 2002:a63:561c:: with SMTP id k28mr18490835pgb.412.1559008915984;
        Mon, 27 May 2019 19:01:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id j22sm5644485pfh.71.2019.05.27.19.01.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 19:01:55 -0700 (PDT)
Subject: Re: [PATCH 07/11] net: phylink: Add PHYLINK_DEV operation type
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-8-git-send-email-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <1f35604c-6047-082e-814a-72d8739fff12@gmail.com>
Date:   Mon, 27 May 2019 19:01:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1558992127-26008-8-git-send-email-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 2:22 PM, Ioana Ciornei wrote:
> In the PHYLINK_DEV operation type, the PHYLINK infrastructure can work
> without an attached net_device. For printing usecases, instead, a struct
> device * should be passed to PHYLINK using the phylink_config structure.
> 
> Also, netif_carrier_* calls ar guarded by the presence of a valid
> net_device. When using the PHYLINK_DEV operation type, we cannot check
> link status using the netif_carrier_ok() API so instead, keep an
> internal state of the MAC and call mac_link_{down,up} only when the link
> changed.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Should not this patch be re-ordered to be after patch #8? Other than that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

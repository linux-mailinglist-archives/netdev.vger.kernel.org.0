Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF18D1AE8F8
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 02:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgDRAfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 20:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgDRAfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 20:35:02 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3ABC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 17:35:02 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o81so4607488wmo.2
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 17:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uCBEQ+Xgkgx/LHnU9wJFdny8e7iZnirJjjW9TTVJDa8=;
        b=OtxJLTUmzizPMJLPbeyQdzP+U3PvDBo3r0oTdFdrhnidfH3oJl5yHiqcTlIrSCe1rb
         GqgZ4P2OMn5hdlLC4q/gaZF589jNJSC3eGyAg3iehKJ/5F07wamjZ9zShCn/sF+7Vepz
         WPNe7utp2JHhCW5JYN1PV+u9NCxtog5kJszzGvmxoJrrmQQGaQX+e8fZ3eDHCaNjoQjG
         WMJJcC5fe2sbc69OLuV1adyhfn/PYYSDjlGXQwwKoGBZ8KGelu3DCPH2OEsuw/HOO+wT
         rr7IqBJmTb5R/YL6q0TWN3Zw5MTxLXMSbVwLU0lLTnjo+HKCX2JHnT8TIQZpnbqJL09G
         oteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uCBEQ+Xgkgx/LHnU9wJFdny8e7iZnirJjjW9TTVJDa8=;
        b=iidihmTbEbqZ6rd74dLd/M23xqfAiD8fVy3HXLMizE5k1IXAkMlEqNhU47iwc7n++G
         T6BAnsFRzSkqlmpy4X+jmfa0IakrVwlszg/yNGZSHzs+DiyIR8vwAiwQ/QeKnYEFKyeT
         O+4bqfUeRFh8k1yHhoub9OfBxhq6M7y182tuHg3natJ88WdtEOA2yEH4Xw/XXxLDscZW
         HIp8lL1Jlc0UTaOiJHu8M/BKxtrkdPYgeDvrxxVnAuA7sfwZ9nu2Ov4eMM2Yc+PYtdbM
         ThWWchD1lfy4F0z67tSaepLhNRrjhGVZBzxWhojXBuVLn3ZquDOsbTZtDoTH72Vl4jWh
         pEug==
X-Gm-Message-State: AGi0PubS6VeFMhF4RqEQKvX07on/7RwJXa1BhiBhZmfKUL2Sh0hIHJGB
        9U2eqx6MHknsxksMg2If5Tg=
X-Google-Smtp-Source: APiQypIdVMDE64EHA3+oixtvlYYc9btvrAmWl7MEX+l8vnyjL6XTKvU/E7p+uKdbbzcVmPTLYSx3/g==
X-Received: by 2002:a7b:c931:: with SMTP id h17mr6215284wml.105.1587170100896;
        Fri, 17 Apr 2020 17:35:00 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 145sm10115724wma.1.2020.04.17.17.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 17:35:00 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: fec: Allow configuration
 of MDIO bus speed
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3cb32a99-c684-03fd-c471-1d061ca97d4b@gmail.com>
Date:   Fri, 17 Apr 2020 17:34:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418000355.804617-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 4/17/2020 5:03 PM, Andrew Lunn wrote:
> MDIO busses typically operate at 2.5MHz. However many devices can
> operate at faster speeds. This then allows more MDIO transactions per
> second, useful for Ethernet switch statistics, or Ethernet PHY TDR
> data. Allow the bus speed to be configured, using the standard
> "clock-frequency" property, which i2c busses use to indicate the bus
> speed.
> 
> Suggested-by: Chris Healy <Chris.Healy@zii.aero>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

This does look good to me, however if we go down that road, it looks 
like we should also support a 'mdio-max-frequency' per MDIO child node 
in order to scale up and down the frequency accordingly, and do that on 
a per transfer basis. So this means that we would likely need to add a 
callback into the mii_bus structure to configure the MDIO bus controller 
clock rate based on the min between what the controller and the device 
supports.

It seems to me that everything works in your case because you have a 
single MDIO device which is a switch, right?
-- 
Florian

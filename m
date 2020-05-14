Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2651D3225
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgENOHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgENOHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:07:46 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09246C061A0F
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 07:07:46 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id s10so2260123iog.7
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 07:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=a5TpeT3R8kSC6vDxpfYUpcyfDnMdVpU9ivHQmQuNncM=;
        b=Div3duxAwWZBjre4FLiRGrdHK2+0XXX8e8owlNzARvHyHue0FDEAAvxg0cBpvXtm2N
         b3HkEr989uteCzEvXJUPPeaIFB1tpjNrrevADahkVG262tj+D1WuS5Vk+F6nGRY7Jvc1
         +QqRw+EowIc7+YX/eX353x/+J+53aMGv0Qdkz9P3L3XVGuKLsCJA4o4tDWiL6I8mnX7O
         df3B+7DhATMYFtaBC3MBBbKmo8ULAEzxf9aOkTEQ5SvWUSNYe6B6eHAg8YsvhzICATWM
         gEFIZv1+/0S+w+oSZ0OwK7H+KUayTST6Pqy8MT+Diacd/KQO9N11OHy0UizVpAxIGujX
         tZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=a5TpeT3R8kSC6vDxpfYUpcyfDnMdVpU9ivHQmQuNncM=;
        b=e8KnKf7AonbHNqcjVtXJmB6iIS9i0pb9/C4WyhOqzMivrHTYJVja8TtecYLPbMXZmo
         3y92ReWpEAxmExia9WentxwuoJdAJpIJEcPubKveDa2GwhettN5h109FeA3q+1zGJtFR
         /H4ahIp9RvrXYlxdesAoC/Qz15Cl0Mx51NqzaPButpAU//ykZySVh50at73Sy54mW2Zd
         6uOJVK1T22Ts6BFQTkT9ySKed53HQ0ACKG3sGmD2bVKZUBE8StApPWSb+VilzZVvC0xc
         mS1XMk7VphcVZRC2f17E8PVRmKyoCEmi7PEpMdy7r89dk3FmRcaxx4IpKS/P6+3D0L2n
         O3Yg==
X-Gm-Message-State: AOAM530RMc3yvH489Kb1pOLzA//vhLMfrRMPpOXkWO/iuPBEobi7N+fF
        JCl0L9U8Jai8IqbP8Kij7ARNNP3AhmyFqg==
X-Google-Smtp-Source: ABdhPJxAecCy/0UmE7Oo/ss6Wjvhd7B+NSqGrp4g/1uaVzI9FhiBNg4GlU5zjobx/OJ0NgAirK2xoQ==
X-Received: by 2002:a5d:8d1a:: with SMTP id p26mr4192627ioj.131.1589465265150;
        Thu, 14 May 2020 07:07:45 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id m89sm1174886ill.40.2020.05.14.07.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 07:07:44 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Netdev conf 0x14 update
To:     people <people@netdevconf.org>
Cc:     Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        prog-committee-0x14@netdevconf.info,
        attendees-0x14@netdevconf.info, lwn@lwn.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <69564296-2b54-ed57-deff-eb809dbfb8cc@mojatatu.com>
Date:   Thu, 14 May 2020 10:07:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Apologies for taking longer than promised to provide an
update on the conference.

We finally have a decision - the conference is going fully
virtual. For details please see:

https://netdevconf.info/0x14/news.html?virtual-netdev-0x14

cheers,
jamal

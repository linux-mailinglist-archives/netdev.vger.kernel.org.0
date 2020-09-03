Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E958E25C6CD
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgICQaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgICQ36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:29:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345D7C061244;
        Thu,  3 Sep 2020 09:29:58 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b124so2718388pfg.13;
        Thu, 03 Sep 2020 09:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nq4Y4LX++M/uKa3i+1xjIY2hdYC3sQ5Emz4iH0w5Bus=;
        b=HD97Fsc/y+B5kjeKHMOlfqvQFt2ZqCaTNLJdBLLowG4rLTC9o2fAaZR72bRPaUWUiR
         kVPlVX+7qIC88NDSnRh8AstE8oPgDHIqJp6l+cY+TN7qnxLi2iFrjH9CVUhpQrJ9D23c
         4LHISM9suprt5snYB5byAWoIqtSh/jr1z9+wTfJMc6XXR+Uu6bQplypKppzWTXxdMFX+
         vbOGqAZiuALSlgByVapbwi/1jlPkcsGa20K4q9HMiKDuq5sOPLPvtj1EZD+4iEsoQBaF
         pSL0CSg6oLr9SiQ+ll11FISz5JQMFOcBXeRVcSYj5rym6SfEX/gW/w1ZEY4yqmqOeM9V
         m7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nq4Y4LX++M/uKa3i+1xjIY2hdYC3sQ5Emz4iH0w5Bus=;
        b=gT057NgWTUA8TdXiSREHtnk1e5s8Yse4jpG14l5M3hmfrj+WZg2hzFGEoNQf6oUWQP
         /vC6MSei+3Fbzb3DHL3KSWqNjdn7EmTJTDCpORVBf57DzYTopHqcpTubzuTX240KXnQQ
         QJF4ZpAUfOrnk0cweEiQz4xhzJQD4+i8mH+IkNcaCibW6L79vSBUgi8JuujDm7m5Dhvn
         z43nIfwB/aub5Uc4VxVG4Wmr9GWJFMns+/f96mIFpufVJxX/7FyEZMJJ2+dbiXRCorBw
         VAG1Hqu806H+AIxuUDOr4mzO2eMbIDwQRsH9tuYN4vrSehsDx1KjAxJ38FL8I+9B8foF
         j3MQ==
X-Gm-Message-State: AOAM533GsCAsPmjufe/wuQWkTZSvMfHxBv0FwPPCng9qZffFPV0Rc7Uq
        W2QwJyDkNowhKSQFQbV3rXY=
X-Google-Smtp-Source: ABdhPJwom6O7abQjGJ0fwb74pAHB+lr2SSA77td5Qq18sKhO6li039UwtDx+7980GEHYmNSQTdNcOA==
X-Received: by 2002:a17:902:7083:: with SMTP id z3mr4673238plk.187.1599150597535;
        Thu, 03 Sep 2020 09:29:57 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y7sm3674852pfm.68.2020.09.03.09.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 09:29:56 -0700 (PDT)
Subject: Re: [PATCH v4 7/7] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
References: <20200901125014.17801-1-kurt@linutronix.de>
 <20200901125014.17801-8-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8470fd08-2a22-23b2-4735-a600ee2ea06b@gmail.com>
Date:   Thu, 3 Sep 2020 09:29:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200901125014.17801-8-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2020 5:50 AM, Kurt Kanzenbach wrote:
> Add basic documentation and example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

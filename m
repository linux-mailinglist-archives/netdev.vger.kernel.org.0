Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A0BB30A7
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 17:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfIOPPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 11:15:17 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33243 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfIOPPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 11:15:17 -0400
Received: by mail-oi1-f196.google.com with SMTP id e18so2112837oii.0
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 08:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qu+PNHiXDwy/d4EcGEIIWHtlh5arXnrneX+sTnLEBjQ=;
        b=D3ZVp0W6JDDYg227RScHddmNKaHqHTJY3x9mdU1Qqg/AqFnduQ7NoIksvYFp4hv/5J
         PJF5yqlNHRkI1qX32HISo6qe5sp324ZYE7xs95Xh+r2XQW2uw3SG+oM4LSUxre76IOCV
         OPH/yQn8gnv+P5G6c3RBO7VMN/WhmB7bg/EcDY6iAyZ0iQ/rDuvymuRSJq4ADbnQNC8S
         HLasOUYi57Ziq/EA2sQf4tKU8gumX6mW3A4VeNSZEWzx0zig4lG5AAVI4eM59jv4pBHg
         kuZaLOt72VMTEZL93IzF+SAHMSg9PnfkFUk28Klhc32CiHL2LRvlbSLQDhiasCEpo40M
         nGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qu+PNHiXDwy/d4EcGEIIWHtlh5arXnrneX+sTnLEBjQ=;
        b=nXazaXsA/DRqKqivOaYsw3g8bPcVkS3jOMoFRTtf53KqL4nJ73dIj1q/ghoeOmiknq
         gUyFi+g62VT8bZWLJLTuf4BGNldU3N9abtaQNJugso0e+KITtTyBc0bzwSGj5MlnJYQ4
         tyJe72wixCRgUrjGyk0FcvZDi5SPJ2+xWyl6i7UkrlukPq7IsYpy5HH3ZGhApvftqcnp
         mAhGArYHGJNCoa6/w/li+oOAHtYsogT0YBPClaCJ50GxJuaJeu0fRFkJOEsr/JG1Rnuc
         OFOJsUfdDmpkPFcXQFqoUpUe4Wi+G47+jQvOZyBSY+XfTHAbG5za5aWHoh/+tiaNVmqR
         njYQ==
X-Gm-Message-State: APjAAAWSQV8JF3JrWn+4YRQLXWWJXNV+ol94bVi7w/8ZHX1Tgn7Lxbaq
        jFrDf45l7ubF69rw5BdfXXBbFVae4Bo=
X-Google-Smtp-Source: APXvYqwfmJ27xMlWPOQRVV4q15VChL2Jri6wTKHlz8MI0r5y5XLk5p9QabJYsm6eouBMlKNHtf/3CQ==
X-Received: by 2002:a54:4e8c:: with SMTP id c12mr10949919oiy.162.1568560514568;
        Sun, 15 Sep 2019 08:15:14 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r187sm2969339oie.17.2019.09.15.08.15.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 08:15:13 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 4/6] net: dsa: sja1105: Advertise the 8 TX
 queues
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        jose.abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org
References: <20190915020003.27926-1-olteanv@gmail.com>
 <20190915020003.27926-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <05136e2f-b56d-03a1-e1de-e27bc4472048@gmail.com>
Date:   Sun, 15 Sep 2019 08:15:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190915020003.27926-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2019 7:00 PM, Vladimir Oltean wrote:
> This is a preparation patch for the tc-taprio offload (and potentially
> for other future offloads such as tc-mqprio).
> 
> Instead of looking directly at skb->priority during xmit, let's get the
> netdev queue and the queue-to-traffic-class mapping, and put the
> resulting traffic class into the dsa_8021q PCP field. The switch is
> configured with a 1-to-1 PCP-to-ingress-queue-to-egress-queue mapping
> (see vlan_pmap in sja1105_main.c), so the effect is that we can inject
> into a front-panel's egress traffic class through VLAN tagging from
> Linux, completely transparently.
> 
> Unfortunately the switch doesn't look at the VLAN PCP in the case of
> management traffic to/from the CPU (link-local frames at
> 01-80-C2-xx-xx-xx or 01-1B-19-xx-xx-xx) so we can't alter the
> transmission queue of this type of traffic on a frame-by-frame basis. It
> is only selected through the "hostprio" setting which ATM is harcoded in
> the driver to 7.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

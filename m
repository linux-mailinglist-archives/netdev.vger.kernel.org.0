Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D9D35169
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFDUzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:55:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42162 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDUzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:55:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id e6so9786537pgd.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JVt0lKk5C2TRWZigBnpJow7gG0tmHw+pHCZx/Yo+7eI=;
        b=DplrBF15mRkSe+ZiQ63pY8TOUJgM2DE7c1+6KeHAteNNx3dyWaC6cK4b0xLckRumlj
         FSkovTdRBjrp9u8JW6XQfyF6RarQMJJ1x6ChIbjtbBKx+oSiI4VuyyqFVd2r3luAyskw
         KiPGyIl5mnP1HA/vu2pZB0aU6lzOa6eqsVMnr46/Wo9eduI2YFo5bEM4lJni64QgxSdb
         FlwCCg921ysqkSTuLTlAjsYBmRfax37v74r8p7DioxI3txMJ4PY+FzqzKnSfjZ+oBQRa
         +7Ys6qfGP2B8Z0RZccL7yiQCZDpepNJj7Br5CRmdlp0DjM9OIT7qRRJdg5os3z5nuqrc
         9xUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JVt0lKk5C2TRWZigBnpJow7gG0tmHw+pHCZx/Yo+7eI=;
        b=IiTLu8KH4zftMjBvK/RZuES5q0lV3hC5T2ofxs4ozzwGhfUo1qL/pVywf7PXhFPf+0
         BSPWtIRZSyMYj5jkyK3nDav/UAfKj4U7PfbpGSKjEDYwI6e24PT4IH6UMHC+wh4f0l3/
         ZKX/Wt04SUuNRg9sw1QmvxUJKGhrRhnVfO7RzACoD3Ax0zyhrdOD1ZkHqUxyeKGx8RcJ
         lrT3Wvh509fTq1vXNHz248/L2tPYUsv9XjMhqtQeCMupjVoM1xURxcbmc1JkSmFgTnGR
         8ewSwhCJuPNBi02Ua3yVvuC0GsIPTO/3s/iymSO2TJrqRTl+CUrZ8jrhoK8WBRlOlSa6
         D2vg==
X-Gm-Message-State: APjAAAXoyvz/ZGU1Mme+9aE+cBonXcRRGPq20w9lXZ5S+Re+Fh1cjOoE
        +DYv+O7fGlfR8NetfrD2BMyjdTex
X-Google-Smtp-Source: APXvYqyVLIY9QRux/ZqtOVB66+5JJYU+y7MhUXnjFSDGWqQdhS1TbqL8sKPZtdq5iD8OI3MJLXPqJw==
X-Received: by 2002:a17:90a:b106:: with SMTP id z6mr39094718pjq.91.1559681749017;
        Tue, 04 Jun 2019 13:55:49 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id h12sm10349893pfr.38.2019.06.04.13.55.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:55:48 -0700 (PDT)
Subject: Re: [PATCH net-next 01/11] net: dsa: sja1105: Shim declaration of
 struct sja1105_dyn_cmd
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190602211203.17773-1-olteanv@gmail.com>
 <20190602211203.17773-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <461ffa34-953d-8533-4691-8cceb798ad4e@gmail.com>
Date:   Tue, 4 Jun 2019 13:55:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190602211203.17773-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2019 2:11 PM, Vladimir Oltean wrote:
> This structure is merely an implementation detail and should be hidden
> from the sja1105_dynamic_config.h header, which provides to the rest of
> the driver an abstract access to the dynamic configuration interface of
> the switch.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

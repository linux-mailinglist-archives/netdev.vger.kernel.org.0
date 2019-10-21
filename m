Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470DADE22C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfJUCgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:36:18 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45857 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfJUCgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:36:18 -0400
Received: by mail-pl1-f196.google.com with SMTP id y24so1912306plr.12;
        Sun, 20 Oct 2019 19:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lbYrxrchnRxSWQG3BzMPG5vArqETonI6npfu0w1obGU=;
        b=RP+iZBmTJHcpwfN4HRNzREPnGwVwCIDcHP+UoOvYL22wj75evIL5njoXATduCDUcmS
         USPqxf6gF4803bJ75dVI3PExRsKdqoMrVFBniXvkcAcqTo+RMWHli4YSbyL9Zh58EYqS
         2WTdxzLh4Yju09wPVuA0CvGZCasDBm2Gn5tQTuuQMUSA1VtaEmPgbE77O6F8g9VkqvQD
         Ons5VhDTy5aKMmU9VbUFi+lO2vYszo4UnIeNhOBKJfQ2hiEnxUpu7kr8fI1nNBwe1e/N
         NxrYxNzoFv3VYI9dh+rcs005hGEmODb9NUMsv8Pd1qSl+tYBJ5MAEjzGtz0DbB9DqJ7Y
         QIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lbYrxrchnRxSWQG3BzMPG5vArqETonI6npfu0w1obGU=;
        b=hzX4Ow5Dgqlyu6mEf2F2COqVEjrtMGLnbc0BMIVdADizT/FszIJWJI8tbSUPBEvHiC
         1CAQ2392cucmFeJ4v5PpGJs3RDKkE0C1ioNbq7P1SqqpHblnGlscF4oU13bsV9cnzRKu
         bMILhx4Om5wGL9FQtv/8nSAUmiuARdgW5pk4nqr8w2RCcFg6hRkDnPigCRlqLiNp36ml
         yG1hDh2+/l3+xvJ96cCWItrYe9izDRLMgdp0a8yoCJ0adfMz+zFjBfJLKyVRFK0ecOv5
         rQ8ICsze2+O+GVSzmEVbeX2/9bSOacS3hcDux6C7Zd+3n54cO+36wL9vd3RX28vYg7G1
         zN5Q==
X-Gm-Message-State: APjAAAUOCng1kPpbpjFOihaVzROZgSsHLuuoDfRXRvmQwGPW1WjpfZgt
        bd1X2ADy1mOnmihYo2BarWhlDv6W
X-Google-Smtp-Source: APXvYqzT0gNY4acpSD7eRxrkqKHKAjg8c3OlvnX+hkKSboVNiZaNpoVl2fqJjdKgoQsf0EAa2fB1cw==
X-Received: by 2002:a17:902:6946:: with SMTP id k6mr22426082plt.60.1571625377738;
        Sun, 20 Oct 2019 19:36:17 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s23sm7589647pgh.21.2019.10.20.19.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:36:17 -0700 (PDT)
Subject: Re: [PATCH net-next 02/16] net: dsa: add ports list in the switch
 fabric
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-3-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2a0fcfa9-ca00-97cf-114f-86d0a1908843@gmail.com>
Date:   Sun, 20 Oct 2019 19:36:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-3-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Add a list of switch ports within the switch fabric. This will help the
> lookup of a port inside the whole fabric, and it is the first step
> towards supporting multiple CPU ports, before deprecating the usage of
> the unique dst->cpu_dp pointer.
> 
> In preparation for a future allocation of the dsa_port structures,
> return -ENOMEM in case no structure is returned, even though this
> error cannot be reached yet.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

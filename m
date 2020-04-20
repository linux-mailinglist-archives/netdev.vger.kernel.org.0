Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039E11B1906
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 00:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTWJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 18:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgDTWJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 18:09:33 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C199C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 15:09:33 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f13so14103122wrm.13
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 15:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aGqVOajfIMbQAQ4dlpX8Q8R3lskgk1VotTR9MuNgMn4=;
        b=sGj3CPTNeJjr/V2ayNM7K10kHpOh4Dzel/OsmTHZy/RSgowzC0Srjy2ldfA7c/rKie
         Yvb0dASBCa/60IfTRS+maW17gu7gbr7l3NZnHpPaMpiI9lHTpHtDwgzw7m5Pp+8xmnPt
         L+IpDN0eAPJUSreDptl9J6XLFghdXMdxHCkHm1rP48xXuc1nLhPYRbfVM5/lkupMU6K3
         OBt2LZdDhuXR6xzxClK0uKIsZu29RozUHhrChDnbKKSlZP6am635zPsAvI+aGKNX3SP7
         lkL4S20YXOjzizpI6zFFYzUA6xX/XGK8brZC/nwd9410v9agxF8jWOSm6TkGgtBUCKFQ
         sBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aGqVOajfIMbQAQ4dlpX8Q8R3lskgk1VotTR9MuNgMn4=;
        b=qQs4EAslxM9djSkm6+9RNfdTmP3gBFzDJg+rf5Ov+4lohBYJ9axgzR4Zg4wZYnvEIX
         WjW4pmvppfxXVdf9y9RphDRzzCGQfwUym3z7QSKeY3skrKJFpEzNDhKX5T+YFJru+0ry
         pXKIXaQp+k0V7IOcA5uSuQR/9VUl1jkawOWXDVHxdRq6pvuCOZqO+ngVNs6S8VIPnP92
         qm2Jgg8pxt2uz0gFSHyCyEV5czoEuwbyYkkts9bY0KOxGGRI3IUSVVvSTau9lstl6cDr
         /V3RiupUrCglZRNbYt3e1plcNx883EjgL6fCzjHqLOYQ2QEFOYOpRHiyPuuhWuYEc/f4
         8K8A==
X-Gm-Message-State: AGi0Puakv5Vrc1tyypoiqaIuNzvr2rolo8yYW+G6NRdRDzd5DJn8CDEk
        nAKk8t1+IKrd3ib7p+V73K8tuL/6
X-Google-Smtp-Source: APiQypI7p99PjsBU9MiZBoc+xclsWj9/lyqaUV2ppvSvGUKm+KEQYQodUbwPO35gmhJySkmF+QH07Q==
X-Received: by 2002:adf:e58d:: with SMTP id l13mr21820680wrm.187.1587420572167;
        Mon, 20 Apr 2020 15:09:32 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e11sm1018419wrn.87.2020.04.20.15.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 15:09:31 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] net: bcmgenet: Drop useless OF code
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
 <20200420215121.17735-3-andriy.shevchenko@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <791c2bc1-9de4-d05d-b24b-7de005cddbde@gmail.com>
Date:   Mon, 20 Apr 2020 15:09:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420215121.17735-3-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/2020 2:51 PM, Andy Shevchenko wrote:
> There is nothing which needs a set of OF headers, followed by redundant
> OF node ID check. Drop them for good.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

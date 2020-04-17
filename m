Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3FD1AE8C0
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDQXxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgDQXxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 19:53:23 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6716FC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:53:23 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r4so1864910pgg.4
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=58/oLJudoLqvrBSL5NtQSIXKcbSsmq77pfuMAGQYuEw=;
        b=kkzr/3uxaRWB3B2yF8g8G+VPgvV+CCJzjmB2NIPBDKZDH+WtSSzU3DtVfjidIK1zaj
         eQF1an2MIAQXXn/i5o0qlXIYLerLaJVv4MlFgQ2eZXMNzroqtTXL/xjWfLqsZkU89BVC
         XRsHc3RoY3a73t5CGeD7rLewISg7IuueKu+VnZs4fGxHoTP7Ui3o5mjO5TgrL6VWxhtP
         N86WoVVpc9PbKrQXexp/qKcxlN758kTeMKK99OnGooTpcqQ41v9DhrVfjtaYwIVC4KwP
         ibg4uFANBIeR7+QalWCZn2N1B/mcsp1GkYaAGaVQ29xVYyBWc9CLTmW2PNzDrO0ggs/D
         afbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=58/oLJudoLqvrBSL5NtQSIXKcbSsmq77pfuMAGQYuEw=;
        b=Glwobkn8qVXMq+ZDoMqkbOJgmRZEDIf4N6lYGKNjqeIQFXDlGHqHrr8VhwUZNd4zkH
         LkGQ8VAfJFTaw/PBHNH1LbLL1bphlseksW4o9xgXDx6KuSotwl3tOyi60miCNB7OB9qp
         nsku4BYql/bn/CctoD1MwMdBto52qou6MX1rOtNvZwKGdbVkHfNh7rQKfYP/+h7pia6B
         jKgssVf/OVHXbUOMubJMajhPmtERfgiUhkyhdxKBExehnIHV0kpES3JpUpq46S2Fqmde
         heMxUi867C9RsRSRKPHTDqK1fHegXVtk6yesqIU/38deFP3CBL0vmcXtjfZ409IaFBZC
         TY4Q==
X-Gm-Message-State: AGi0PuaPsq8LW69MDhcoPpfMwpXplR4zQuY1wrzPLeahqBzyWLTBJALk
        XgrLWCJi7hkGaEecKrTeCnMRrhVr
X-Google-Smtp-Source: APiQypK4S9bDUlKcajl6vAAegJMggDPFJgZrUvd4NwfA4+pIS7YGz0NhL1+zAVSnv74+lM97YCsTyg==
X-Received: by 2002:a62:3147:: with SMTP id x68mr5739545pfx.62.1587167602477;
        Fri, 17 Apr 2020 16:53:22 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w185sm555399pgb.12.2020.04.17.16.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 16:53:21 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: ethtool: self_test: Mark interface in
 testing operative status
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200417230350.802675-1-andrew@lunn.ch>
 <20200417230350.802675-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8747f9f3-4c0e-ef42-02ea-fef635afb4b3@gmail.com>
Date:   Fri, 17 Apr 2020 16:53:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417230350.802675-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/2020 4:03 PM, Andrew Lunn wrote:
> When an interface is executing a self test, put the interface into
> operative status testing.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

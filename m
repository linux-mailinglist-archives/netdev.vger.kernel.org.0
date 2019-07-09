Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0446351A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 13:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfGILoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 07:44:09 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40102 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfGILoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 07:44:08 -0400
Received: by mail-qk1-f195.google.com with SMTP id s145so12178696qke.7
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 04:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fAO/bH4c9RcwOzXZthYlzNcxLECpx5mL+EBp6RN1GMI=;
        b=vWpinOyOEoxzwSLRgA8CBxbfS0HIZdOHHc/SEo1EAMDukvDMFGYeNaUlSvSnefCrXh
         N/VgQpmLUxjJ/OWwCFrdsiaGyyedH75JrD88Vr/KlNzJWHOza7jz3VmxbBB9hHbBSzYa
         3EB6PS07xMwEjizQKQ1Wgl78Xug4kzf2BYng0UTg3ofnYpIFtQFD4BFhFnJViTYUSoo5
         OwQVSOuNuFKpVplvnhKEc1H7evQ+JtToA1naLzmlU8+0Pya+IBD8M9uWxPqagh9LrNlJ
         BKun4fGYqs92N2wTOLOuKc91smx9Mq2p+aMExrXY15/n2me5ec9HytcjcxizOPBbOxr2
         mHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fAO/bH4c9RcwOzXZthYlzNcxLECpx5mL+EBp6RN1GMI=;
        b=ugrYRoEwPT9SBb3udvIy51raDHHBLaFetzWfNonmcsM9cy+vMq8lbYvBYY24j+WA+q
         MZ0xBxI4mZLudalUmBsqGKXNBP9uaCSlrhTkrZ4O95SC1y6Y9m/joWAb9wifNoPh/Eh4
         4YSqrPcTPeD1nMX9eR/ZGoeRDHcd+DthvjEb5Cw/09ygOXzus0tLeLP30hTHHEN6UF7X
         TDv9RWIbuCPoVSku9qdx7n+GAuNQpLoigArIxmInnqA5NhfH9+nRfaGseljHVLHfFhJ+
         +cIaMyDYFR92LmOF7AJUIK2QHzT/tQFADxbViduHIcS08iJ1b4W2RdcdLPSyTxE19nWM
         SyJA==
X-Gm-Message-State: APjAAAXXfT5+2l1djsD5qakoDCBG2wSkiB/53Z5+N2Na2N4k+32YLkpD
        QImjunCX1+fZJ4O9sZnUz4GbfQ==
X-Google-Smtp-Source: APXvYqzHQj0YIoDavnm1ag5ufg5Yb4MKQD5i9KE47HYH583Zhihj7Afc2ffEG1rdUUEmYIDjiLfOZg==
X-Received: by 2002:a37:4d06:: with SMTP id a6mr18529561qkb.298.1562672648081;
        Tue, 09 Jul 2019 04:44:08 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id e18sm8646306qkm.49.2019.07.09.04.44.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 04:44:07 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] tc-testing: Add plugin for simple traffic
 generation
To:     Lucas Bates <lucasb@mojatatu.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, dcaratti@redhat.com,
        kernel@mojatatu.com
References: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <0b1dad91-2240-c38b-bc5f-f6849496c62e@mojatatu.com>
Date:   Tue, 9 Jul 2019 07:44:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-08 9:34 p.m., Lucas Bates wrote:
> This series supersedes the previous submission that included a patch for test
> case verification using JSON output.  It adds a new tdc plugin, scapyPlugin, as
> a way to send traffic to test tc filters and actions.
> 
> The first patch makes a change to the TdcPlugin module that will allow tdc
> plugins to examine the test case currently being executed, so plugins can
> play a more active role in testing by accepting information or commands from
> the test case.  This is required for scapyPlugin to work.
> 
> The second patch adds scapyPlugin itself, and an example test case file to
> demonstrate how the scapy block works in the test cases.
> 

Shouldve said V3 in the subject line - but fwiw,

ACKed-by: Jamal Hadi Salim <jhs@mojatatu.com>


cheers,
jamal

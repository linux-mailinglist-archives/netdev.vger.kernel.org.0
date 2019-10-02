Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6E5C49E2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfJBIqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:46:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36523 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJBIqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:46:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so6027214wmc.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 01:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=typVKVAJaNMD366d7UKPmeo9zGfC/1CzS2YgV26La90=;
        b=XeV7IDt171/JUvbUWHvPEpRVC43BmwwIiWO1u4x6DruE2QoL8fhS4oPrA4wNEKemrz
         74GYL/eFykaA6HxCum2bwN5zcvR3fhffJu+WXilPQnEq5ABlV454UvWLlNpxbdJe+Zsp
         +eb20F2UBp5gs/h7zHYpIIXOEfkZYRjHovLmGMD0ezYJegjr6js/4OSY8cw48xVbwXoL
         ixhX41K9qc5aj1SF9RPZFDOBZu3WFvos6Hcl5LIBmKw+BUEG+2e+hwcpWpHZf3Z9Nz2f
         X1ntHfpkVC+0J2arTd3p9uugdl20ka9YkPR4x+9xgHgFwFKNSQOS/D/Ha/vj/KoKI44o
         qS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=typVKVAJaNMD366d7UKPmeo9zGfC/1CzS2YgV26La90=;
        b=HV2G4gefKGuOgOBMTGsx8BRjozCdtOXpBO7cyb+FeWKii9MWyoyC7hyqrd1fpE9FBh
         GiyHUqf7rzxNlWuozQmJIuSgkxaE7lTELMzHt9orlDW/70sNN/RACv2j4StJaoQbpMiM
         NFWaDuf1cZgUeKbn4mtM55nXTFz5sEiTBpw3ario4X5EyHT6IMJaAU+SOz6EDJ97IFLR
         XQYIA/G3eyzgSQl0TNmO7W3h1hXPOJm6PC84UxBXctHxA+/zhz753016LmYfYf3h42RA
         P5L7AE2FoGJlV94qVn8eFHEMcrR7t4G9rAszSe+o1lYdMhqRsj4NC3My+D6Le0DbIs6X
         DmNw==
X-Gm-Message-State: APjAAAWcJIlDREQbXleBqertQilb6EREqICqn2yeFxvZyjTkIoBEsdKC
        3DxcM4af9aWpn76xeO2CHcVjwZ5P97w=
X-Google-Smtp-Source: APXvYqzQYOAvRy1PfmC/j1GZL+lozeSlxIRoJNqjXbdYyLbkwIXdayKkk+MuE2uggDfWvtWzG55/HA==
X-Received: by 2002:a1c:ed02:: with SMTP id l2mr1831019wmh.155.1570005965110;
        Wed, 02 Oct 2019 01:46:05 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:f4ca:e608:891c:61ae? ([2a01:e35:8b63:dc30:f4ca:e608:891c:61ae])
        by smtp.gmail.com with ESMTPSA id w125sm11294123wmg.32.2019.10.02.01.46.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 01:46:04 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 0/2] Ease nsid allocation
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
 <20191001.212027.1363612671973318110.davem@davemloft.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <30d50c1d-d4c8-f339-816b-eb28ec4c0154@6wind.com>
Date:   Wed, 2 Oct 2019 10:46:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001.212027.1363612671973318110.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 02/10/2019 à 03:20, David Miller a écrit :
> From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Date: Mon, 30 Sep 2019 18:02:12 +0200
> 
>> The goal of the series is to ease nsid allocation from userland.
>> The first patch is a preparation work and the second enables to receive the
>> new nsid in the answer to RTM_NEWNSID.
> 
> The new reply message could break existing apps.
> 
> If an app only performs netnsid operations, and fills up the receive
> queue because it isn't reading these new replies (it had no reason to,
> they didn't exist previously), operations will start failing that
> would not fail previously because the receive queue is full.
Yes I see the problem. I was wondering if this was acceptable because the nl ack
is sent at the end. But nl ack are optional :/

> 
> Given this, I don't see how we can make the change.
> 
Is a new flag attribute ok to turn on this reply?


Thank you,
Nicolas

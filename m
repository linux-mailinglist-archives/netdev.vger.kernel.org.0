Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA2511D797
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbfLLT7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:59:52 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:41111 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730691AbfLLT7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:59:52 -0500
Received: by mail-pj1-f66.google.com with SMTP id ca19so1528676pjb.8
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 11:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VNwuwgo+Bw+y37eqt7TiSvWfvx5rw5yWHq1LlUg874g=;
        b=ZDwd0eXALl6Hvq/HHpz3+ExQgUZ0Xwp9eQMgpzWKw8B6T1h9Y+CEys+lTybN7NVgQ/
         WSc12EyescOP1k+5ggcUX3wiJIgEgXHkErW16tzLiALAqZn3ByNQB8eEiHAinFVpmbRD
         AG5jbq5pSsAKsQEMf/eEsqLRPRmM+gEi4/qFOy8HzwP67Mn8Q8cajZfPCmyzZBG0QZjn
         D1at8YmilanSqMacMfbGMLRWn3Oa07TNmOCllU3zZZeMpJTHbE3Ufd6Y/+GiXRYfr6Kg
         Z0UmHsEURKlMshxgzVKAL1EBkcJsR/BE1wCTBc7tzi/q9LQzPUZWq+zHMM+YSPm5MQoW
         ecug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VNwuwgo+Bw+y37eqt7TiSvWfvx5rw5yWHq1LlUg874g=;
        b=rZDfHUBDL1mfKj/qgRXCXrAh7qRBzKG+KJs6rf+mxCf9dvscS+363JurGR6N2/frHe
         QUNDp7K+XE6Ywndbv59pcOnxibUxlg0/cXVbShfwrgt2YT5u12cmfgOZQgJuqXvhUCZ2
         laSirTvi5loEccMohrNKt9mz9Xio/XmFm6Ak3ny75loXsuLCqPQrmTga4yQ2LziPj5Z9
         s8gXBqh8ei7SGCpjvyVQi4JMcIks2n1HpYLVm/W6AFM2ccDnW3VFxh4N2adzU7atVrWb
         KpZMVmpQ484uQ5o9pLZsxyw+3ogUAX0EntoZ5DHRqdeYsfRhRTahDVJH+lLxRGbU3HuG
         8ymQ==
X-Gm-Message-State: APjAAAVwicVt7QA1zNXuSHma/dPeyRb76avc6ix2dRy36AdcnRHgZTez
        fEJTDVYWZbbvFWx0596qvSMVgg==
X-Google-Smtp-Source: APXvYqwDqNszUsw5lg2HV64xQq+Ng7M6hNUregxKh54M/G7F2fQwJ6P3U+79wPqgTU4NJWLGOGb5gA==
X-Received: by 2002:a17:90a:bd91:: with SMTP id z17mr11795939pjr.34.1576180791706;
        Thu, 12 Dec 2019 11:59:51 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id z19sm7870952pfn.49.2019.12.12.11.59.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 11:59:51 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20191212003344.5571-1-snelson@pensando.io>
 <20191212003344.5571-3-snelson@pensando.io>
 <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
 <20191212115228.2caf0c63@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
Date:   Thu, 12 Dec 2019 11:59:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191212115228.2caf0c63@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/19 11:52 AM, Jakub Kicinski wrote:
> On Thu, 12 Dec 2019 06:53:42 +0000, Parav Pandit wrote:
>>>   static void ionic_remove(struct pci_dev *pdev)
>>>   {
>>>   	struct ionic *ionic = pci_get_drvdata(pdev);
>>> @@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
>>>   	if (!ionic)
>>>   		return;
>>>   
>>> +	if (pci_num_vf(pdev))
>>> +		ionic_sriov_configure(pdev, 0);
>>> +
>> Usually sriov is left enabled while removing PF.
>> It is not the role of the pci PF removal to disable it sriov.
> I don't think that's true. I consider igb and ixgbe to set the standard
> for legacy SR-IOV handling since they were one of the first (the first?)
> and Alex Duyck wrote them.
>
> mlx4, bnxt and nfp all disable SR-IOV on remove.

This was my understanding as well, but now I can see that ixgbe and i40e 
are both checking for existing VFs in probe and setting up to use them, 
as well as the newer ice driver.  I found this today by looking for 
where they use pci_num_vf().

sln


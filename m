Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E811F6FA4
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgFKV5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 17:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgFKV5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 17:57:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE37C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 14:57:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b7so3473314pju.0
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 14:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qZ+Mv2ge2dmR2H5rUYKCzaUQz5SRxjniN7C5PBxFAvw=;
        b=Dce2k2rY2/U/OWJn0nFqVPmEnMsMkrGhlE+0qJyEuKvU42aKKxsL+cXNty0rNZjj1j
         gBM/T3DT46+TEuTWGaVmZcSA5Q6uwc4xape2BpdYBgqjNe6W5ZMsN6HVZ3VeRXCwie94
         gNzoTexiGRmMNv6tO8Noqn/DPMoCr2Gn/DNcN66ZGpZZUwK7Sto16oL31i56LSuf1J5w
         rvl6NnuqYtLQT4qlg3M4Nt8CP7VGr37EI/NcJ9l+A+YsD9g5bquMueny940K58UJhL5j
         p1WKXlfX8lO+1UJrNGARtP2jZTQH9ACz9+xu7IJsdbNnm5E0fI/RRo2HUhDdQzsKfKK4
         HStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qZ+Mv2ge2dmR2H5rUYKCzaUQz5SRxjniN7C5PBxFAvw=;
        b=NNQ8Syxo9Z4wn5Rmosmi3l1Q5Ixh3tq1Uy1C+t0WzMNCbeX1hV//oovGc/EKEeV6tc
         iJE6if/KdEM9HTt0riBlRdMXo+XH1/Zxzkda9e5Feqckvj55P+aFFsqdqM5/2U5/+zH4
         NLeydr2/pMQQ4wRhr8RWhASGIsEIw+pWsTHv68zkpPxUbHz4+NHrZlZXvd6PTQ4lBAU2
         BhSL1seQy/FonOWbplriw/6xgljrvkh9Bz0Z0IqJRLZ6gaMf9I3LDkc0HD6qfVz82MOi
         wR6AKkUzR5/gx2mT1LD/pfhMpkmqrsfbDtuf74I5nPbrXy84ket+44wY5GagCzBIkx47
         qJuA==
X-Gm-Message-State: AOAM533M6kYDr5u4sr7WoWfnTDzg/g5M5SMW7cGRjQ/PIioOYLN5j81B
        ekrcDJg2C+E9PYQcDbkIWO+LA0vRywk=
X-Google-Smtp-Source: ABdhPJyKdcgJjygtZ0muqPAtPM9agfp0aS7IEcc6vnllhOlzAh6ObacL+LYw+7GcIeNIAmxvw9tXhw==
X-Received: by 2002:a17:90a:20c2:: with SMTP id f60mr10444748pjg.29.1591912668253;
        Thu, 11 Jun 2020 14:57:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id i62sm4254962pfg.90.2020.06.11.14.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 14:57:47 -0700 (PDT)
Subject: Re: [PATCH net] ionic: remove support for mgmt device
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200611040739.4109-1-snelson@pensando.io>
 <9bf6b140-f099-29ce-011e-e46c950b8150@redhat.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ff60c550-b7a3-5ecb-1b1d-5bddb96ddd35@pensando.io>
Date:   Thu, 11 Jun 2020 14:57:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <9bf6b140-f099-29ce-011e-e46c950b8150@redhat.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/20 1:33 PM, Michal Schmidt wrote:
> Dne 11. 06. 20 v 6:07 Shannon Nelson napsal(a):
>> We no longer support the mgmt device in the ionic driver,
>> so remove the device id and related code.
> ...> @@ -252,8 +248,6 @@ static int ionic_probe(struct pci_dev *pdev, 
> const struct pci_device_id *ent)
>>       }
>>         pci_set_master(pdev);
>> -    if (!ionic->is_mgmt_nic)
>> -        pcie_print_link_status(pdev);
>
> Was removing the call intentional? Notice the condition is negated.
>
> Michal
>
Yep, good catch.  Since Dave has already pulled this in, I'll follow up 
with something to put that pcie_print back.

Thanks,
sln


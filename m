Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56C12D2CF
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 18:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfL3Riw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 12:38:52 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36763 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfL3Riw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 12:38:52 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so28398560iln.3
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 09:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zAty9xcmNI6UDddasxpBYHqu+Bl0XErU588WLqMcXWo=;
        b=p/GRuPbtUqG1bt7Hf2uYfEeJcdHyDm85rRPDVys753hHTSeYtsSRCxe4klAvCjS1RJ
         +O4/8IdVzFTgFC2USSVxzTb9/rqptyKmrRncoO+5YfJunI+8R64IU/2cslgQ1zplkE/0
         uSwEqXS7fwXWWdDYwo5YbzLxBKf/8pTvxY+EJna4nDXSVFO0b4qOmPCWG8KuWZFRkuhf
         RlklTTbuktUdtBmUGdOebkmAQ+ErerLtpAHnQV6ErdCMEHgReXFdPNyHS2rWQB9ZkzAc
         KL5XrtWvo2W7nFZP4/q7G2WO/INhE9FVbvR42YQGsJVMt7Edv6gz/HYnBY3BJr+BxSUm
         4k1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zAty9xcmNI6UDddasxpBYHqu+Bl0XErU588WLqMcXWo=;
        b=HL1J4P6XDScwQwuWjc1qqE5upeFuFUCVoiMBTSrf14GTPzuVTPeiZDg1nHrD2phb9K
         gRXOQy1cqbWBxPMLXBsqucj7Dw5JtZfBeGVdU16O/1ZBxn9eKEhYr5lXXHpfUIGeGN/4
         LxtJpgkQCOdY674iivknk6WyP18y6D2OSLW7vmutdQ6dYZsLfky2sp8XfyQG/Yh3uKgu
         e81hAeJLS3XyDZeXD7hYNV8u5+B3FweYUPWXBLuuow3aojqh8ACXIvpvcuNqHHVZxWb8
         9VfWKGfFViqfnYArKo+yx+4GwxPGcMtohUHwHTSijreRqdNNy3Dc8EfYDa3sh5ajvgc+
         J79g==
X-Gm-Message-State: APjAAAVacbapmUlYpGdmjfZgsWttRxR+67oO6CfdcLkqxU4kkto1IL7W
        8WQV3Q6J+0OvEyQjpHtZPxc=
X-Google-Smtp-Source: APXvYqztIdL0Huc81a0DS2lmrkZWzvuyYuVSbH+8xjBRLIdjhrae4hkxKQxTx3wdtQ6HZfebEhZAxw==
X-Received: by 2002:a92:8d8e:: with SMTP id w14mr57090821ill.187.1577727531674;
        Mon, 30 Dec 2019 09:38:51 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:8026:b0da:25bd:32ee? ([2601:282:800:7a:8026:b0da:25bd:32ee])
        by smtp.googlemail.com with ESMTPSA id r18sm16926256ilo.3.2019.12.30.09.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2019 09:38:50 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip: ipneigh: json: print ndm_flags as
 boolean attributes
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Julien Fortin <julien@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        dsahern@gmail.com
References: <20191226144415.50682-1-julien@cumulusnetworks.com>
 <20191226090406.00aebbcf@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <53f116f6-f744-2f38-029e-c978f3a99f11@gmail.com>
Date:   Mon, 30 Dec 2019 10:38:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191226090406.00aebbcf@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/26/19 10:04 AM, Stephen Hemminger wrote:
> On Thu, 26 Dec 2019 15:44:15 +0100
> Julien Fortin <julien@cumulusnetworks.com> wrote:
> 
>> From: Julien Fortin <julien@cumulusnetworks.com>
>>
>> Today the following attributes are printed as json "null" attributes
>> NTF_ROUTER
>> NTF_PROXY
>> NTF_EXT_LEARNED
>> NTF_OFFLOADED
>>
>> $ ip -j neigh show
>> [
>>   {
>>     "dst": "10.0.2.2",
>>     "dev": "enp0s3",
>>     "lladdr": "52:54:00:12:35:02",
>>     "router": null,
>>     "proxy": null,
>>     "extern_learn": null,
>>     "offload": null,
>>     "state": [
>>       "REACHABLE"
>>     ]
>>   }
>> ]
> 
> 
> No, this was intentional. Null is a standard method in JSON
> to encode an option being present.
> 

seems weird for flags. ip mostly uses print_bool for flags; there are
only a few print_null.

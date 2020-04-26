Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789B21B92C3
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 20:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgDZSXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 14:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726151AbgDZSXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 14:23:07 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BA9C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:23:07 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s63so15884137qke.4
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WFgZ9EYJjv60qBu/eLGGIOoQbLSU6avspYKPRgK3f9M=;
        b=nT9coyD4L9OiUOoVUbZIqpmI/9QyE3dH+yOcVJ2Ml9BCln6670XSsOohHKzjPRUb5S
         QC9rzmj35A39Knmq/tgsxkYqki0KT+K8qcEFbHu+c6s44I+Mm0GG08wnHObZqJmJz7qe
         5qMgcXuPh2rTrD1K64QpiRZ5mu+YFcTNBfY4Kv694v72jKfxIHqH6ko1jnEH6k2tVWCN
         8ieih+mdQjPfShrP+yiDR+AHc/y+mhOIvLuWamP3GAFS+DUkpkm/gXrGEVtJY/q/IUf+
         VG0Irey0pKKhM8152c2GAas9DqN8RM5W7PH7pNE6eAhvgcruq9IUQMDIB8rOeQYkchjj
         4ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WFgZ9EYJjv60qBu/eLGGIOoQbLSU6avspYKPRgK3f9M=;
        b=DR4/TYheleRqQB/SUjsKSIae/WdumCxFaUx7OqRFgcdpJn+WBH3HcktNnBetxucu3l
         7V0HTPsvbr9EnqbrEMwT8yNr9e3NkG+uZEAat8yntpGAjwFduxYs2c8kkepoSK8aR0wE
         8d4/pFDuscFrtYrFV17UVlqyeURs7XqnBcE9yU5TyCp3RdyggclEcX7Jq4BQrd00n9TV
         xtpvBA4IVqPac4zLDKi7lJAl7rN7T7qoYUFoeKhhoGpvj43ihK8I+EkC9IMTSAul0Mo1
         RVJuPY8zKc4BT4QDXYTN8UV6W4ug/67ZkZtehnSAEbwZfLMcaQoHb8DUsMpQWiYyQmg0
         rPvA==
X-Gm-Message-State: AGi0Puaqovv8q5mQ1d6QlnFGftpU56t6g7EGrVnaxG8sIuC/DCYpidAI
        xTnSVvYtMqGvW0c/chWkIcE=
X-Google-Smtp-Source: APiQypJlQ7XsPKSQ+OwcO8/ojBW8KhKWhgoFkYqYtgtcXBJPskDUWLu7i1Kmjz8bYSGabpkXuxP8Dw==
X-Received: by 2002:a37:617:: with SMTP id 23mr19390387qkg.11.1587925386576;
        Sun, 26 Apr 2020 11:23:06 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id s50sm8565157qtj.1.2020.04.26.11.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 11:23:05 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: pedit: Support JSON dumping
To:     Petr Machata <petrm@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
References: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com>
 <20200422130245.53026ff7@hermes.lan> <87imhq4j6b.fsf@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cdb5f51b-a8aa-7deb-1085-4fab7e01d64f@gmail.com>
Date:   Sun, 26 Apr 2020 12:23:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87imhq4j6b.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 3:59 AM, Petr Machata wrote:
> 
> Stephen Hemminger <stephen@networkplumber.org> writes:
> 
>> On Wed, 22 Apr 2020 20:06:15 +0300
>> Petr Machata <petrm@mellanox.com> wrote:
>>
>>> +			print_string(PRINT_FP, NULL, ": %s",
>>> +				     cmd ? "add" : "val");
>>> +			print_string(PRINT_JSON, "cmd", NULL,
>>> +				     cmd ? "add" : "set");
>>
>> Having different outputs for JSON and file here. Is that necessary?
>> JSON output is new, and could just mirror existing usage.
> 
> This code outputs this bit:
> 
>             {
>               "htype": "udp",
>               "offset": 0,
>               "cmd": "set",   <----
>               "val": "3039",
>               "mask": "ffff0000"
>             },
> 
> There are currently two commands, set and add. The words used to
> configure these actions are set and add as well. The way these commands
> are dumped should be the same, too. The only reason why "set" is
> reported as "val" in file is that set used to be the implied action.
> 
> JSON doesn't have to be backward compatible, so it should present the
> expected words.
> 

Stephen: do you agree?

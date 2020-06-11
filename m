Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF7D1F6BA9
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 17:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgFKPzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 11:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFKPzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 11:55:19 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAD2C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 08:55:19 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c14so5986460qka.11
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 08:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Iq8kcYbQZnS7/KBk6Tk/hJ9Gf1hQYR5k9qcqQHWoswk=;
        b=J+5+3BaKrl1VnER2uDhUvYCOHzI1vh7vMaA9z+zxjO6aNN8WpILjBTO5qBGDTKeL61
         BS+euZWYg9THfjKCJKaiCFZltjjIP0rMOEcWRxORkn1xqAuTkcq+PiufuPg2Wy+fSzBx
         H3reeFqR7CZsqtYHFMahc8pW+ziAlrjrf6p6QDk+EPd3NlqyJxA5u/BB3j/0Sd/HzO9G
         FfOX2exd4cL3N2OYXEhBIjMT3VE3TJf9IGHlqbeAOSM5w/1vdidsRP9iJIDHs2nmg1x/
         90OkePt27ruNGDOvRwj4IDxv123v3xg9lAVMqNuG+qP6ldTnNapmAmeDtFpban+Ao/vI
         7sfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Iq8kcYbQZnS7/KBk6Tk/hJ9Gf1hQYR5k9qcqQHWoswk=;
        b=a329jqxxucYcz/FzmbC2gpf6H/+8GDotSCK9vJQ8BYxmIGfogKaty+xbnxoTeEZ/DC
         csg2wABNBJDJwLGDF5WLivvwZeJTBw/kFi7EcRhrOfo2XTNoTdmYMo2CSOvgR412yU7j
         PBlqzIEQQ2TAsdOsBCKkUwDCn1TdjPZorCUwlT/XImlVJ/jfhzb7AeDQ3JDLdmrcH7Ve
         kAADeq4lR1HbrNW/780/8RbQqDkF1RXIa9OjsSWV+b7CDqq6nLosIvhSWZZmoJ6TjxVY
         SPkzd2XL8woBZZrlNvp87PVeb04dAfOYyEkJyvyQt1mgewQ0KM2pCbrZ38gNzatlVNNa
         Kpzw==
X-Gm-Message-State: AOAM530N5dYQMGoF5Td0iArzf1JNSmAJImRc5QdNfHRYWdDYIklnpq97
        Qb3QieF4Xigf2Pf0EuHwpBmy5vil
X-Google-Smtp-Source: ABdhPJzLYqNft2gK3qPwPgDkqkY7msQ6z6GTGsNq9HtBDHhBsF3sGxhcHQXbQeAsROrg8h0zP+usBw==
X-Received: by 2002:a37:4656:: with SMTP id t83mr8999733qka.126.1591890918088;
        Thu, 11 Jun 2020 08:55:18 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d565:3ed4:96e0:d677? ([2601:282:803:7700:d565:3ed4:96e0:d677])
        by smtp.googlemail.com with ESMTPSA id i3sm2365293qkf.39.2020.06.11.08.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 08:55:17 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v2 0/2] support for fdb nexthop groups
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com
References: <1591835721-39497-1-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8407fce4-8dce-7082-24ed-7901ff301050@gmail.com>
Date:   Thu, 11 Jun 2020 09:55:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1591835721-39497-1-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/20 6:35 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> This series adds iproute2 support for recently added
> kernel fdb nexthop groups
> 
> example:
> /* create fdb nexthop group */
> $ip nexthop add id 12 via 172.16.1.2 fdb
> $ip nexthop add id 13 via 172.16.1.3 fdb
> $ip nexthop add id 102 group 12/13 fdb
>    
> /* assign nexthop group to fdb entry */ 
> $bridge fdb add 02:02:00:00:00:13 dev vx10 nhid 102 self
> 
> v2 - address errors pointed out  by David Ahern
> 
> Roopa Prabhu (2):
>   ipnexthop: support for fdb nexthops
>   bridge: support for nexthop id in fdb entries
> 
>  bridge/fdb.c                 | 11 +++++++++++
>  include/uapi/linux/nexthop.h |  2 ++
>  ip/ipnexthop.c               | 17 ++++++++++++++++-
>  man/man8/bridge.8            | 13 ++++++++++---
>  man/man8/ip-nexthop.8        | 30 +++++++++++++++++++++++++++---
>  5 files changed, 66 insertions(+), 7 deletions(-)
> 

applied to iproute2-next

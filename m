Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D83F9EA8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhH0SVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhH0SVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:21:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D9EC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:21:04 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w6so4441019plg.9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mZRXrDZomYa0wfGCOr+a90hGcgVfWjc0XjLcLy4laKI=;
        b=Mrs8YKiN9ja578460NQwTHrUUBYWCmkU+xCOFNSt/g/fVNXHiAzbyrZXuOdmBrqZHz
         YG59V8Yivw9YsPgFvtufZwBRrBLR4DGNz0Xq0rlaa5LVXxD+kIEE60vBCLM8ooPghX+5
         zdTiUwxXyaImWamhMFl+vSv0xxBwXErZhR6HLUOpFVlVNJMaRU5oXGUXHfUckMzLLn1h
         lSBRDPbMJ/zdsaAm6yrBrBDwBtguM8YjgJlMY0qp8Elhp9osc291bK7GttGhmsBs7YC3
         PgWC8ZEeYRys8cnmzzIDg1yKyloDgACHSyHB78DXIUS0IaCzy8thgSCCDXe/82hIZnLB
         IDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mZRXrDZomYa0wfGCOr+a90hGcgVfWjc0XjLcLy4laKI=;
        b=B6Eum5BTGNgUVQlTZZq9LpxL555SLy4TzLvZWQC6q6J2/T7TVB6V7mIU1Kgx+MgZzL
         7faBSJ7xR/yJne8+uuPqINWVW6RjJeOlasYpSW8rICgZuYF+FwSdc3JBQjEOY5vS7Qrv
         +oaJkaExput0sdmW0eROUoTulacZSDoffh7cH2PYtHh6EuvkpTjI5X95avcMHhPw3K2D
         3IiYVggr5AlvztBS9dR342GfyJo+bcD2yv6w7io2qaosLODJ3blNH67N2dER8+N4nJtB
         gc+UZCe1Ob1k2KwgRyAN6mqpolLeH3687ufjrAC4QJEWPtVA4PiQVGdOFQp6S47Hd9hV
         VIKw==
X-Gm-Message-State: AOAM533vg2iLWCAkWvrbZFeU6BphStWlkF5yNjK/ZNbWMl2+2wthX1BO
        TR5INyd6GDba5jqF58p2n4s=
X-Google-Smtp-Source: ABdhPJxEaaYvBsDcByHBp52gPlIZo7GXIteFg41jpXWDvuct9TiW28ze/YeW4MTvf7LJRHjzdZWSyQ==
X-Received: by 2002:a17:902:b288:b0:132:36f5:72c3 with SMTP id u8-20020a170902b28800b0013236f572c3mr9978458plr.52.1630088463995;
        Fri, 27 Aug 2021 11:21:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id 11sm7779511pgh.52.2021.08.27.11.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 11:21:03 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 10/17] bridge: vlan: add global
 mcast_last_member_interval option
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>
References: <20210826130533.149111-1-razor@blackwall.org>
 <20210826130533.149111-11-razor@blackwall.org>
 <bbcd47f3-f1a9-5167-0007-ed91802e8a46@gmail.com>
 <DM4PR12MB5278D58FD0768A3005F95804DFC89@DM4PR12MB5278.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <254468ad-0170-5ef3-2266-35f2beaf1f2f@gmail.com>
Date:   Fri, 27 Aug 2021 11:21:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM4PR12MB5278D58FD0768A3005F95804DFC89@DM4PR12MB5278.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/21 10:39 AM, Nikolay Aleksandrov wrote:
> 
> 
> ------------------------------------------------------------------------
> *From:* David Ahern <dsahern@gmail.com>
> *Sent:* Friday, 27 August 2021, 20:15
> *To:* Nikolay Aleksandrov; netdev@vger.kernel.org
> *Cc:* Roopa Prabhu; Joachim Wiberg; Nikolay Aleksandrov
> *Subject:* Re: [PATCH iproute2-next 10/17] bridge: vlan: add global
> mcast_last_member_interval option
> 
> On 8/26/21 6:05 AM, Nikolay Aleksandrov wrote:
>> @@ -42,6 +42,7 @@ static void usage(void)
>>                "                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
>>                "                                                      [ mcast_mld_version MLD_VERSION ]\n"
>>                "                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
>> +             "                                                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
>>                "                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
>>                "       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
>>        exit(-1);
> 
> line lengths are too long. The LAST_MEMBER_INTERVAL is at 107 characters
> wide just in what is displayed to the user. Let's keep those under 100.
> 
>>>
> 
> To be clear do you want me to break the help line or use a format string
> to print it?
> 
> 
> 

Something like this:

"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
"                      [ mcast_snooping MULTICAST_SNOOPING ]\n"
"                      [ mcast_igmp_version IGMP_VERSION ]\n"
"                      [ mcast_mld_version MLD_VERSION ]\n"
"                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"

(email line lengths are too short forcing wrapping too early, but that
is the intent with line lengths in the 80-90 range

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2442230143
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfE3Rwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:52:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37888 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Rwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:52:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id v11so2439873pgl.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qIel5cck0U7jl4FG8NdIBnAMqTvZZ92P2SVldf4NMro=;
        b=RLSEIgt3zl5KvzHY4PCoGmKCgpBJDN4phCsgY/4EJdstEFaFOkawCByE8lMLrEu6hK
         aOEcoipdupvzaco1GhJ8J90avjD8FOAYA43QuLyVT5O36FU6AEEk4Umn9/rxdvUx21UF
         3l4eAe7cA7eenw8pn3yx4W4Vr6rRpKqOfhJ6861VO30ElkaDUbAzrc9u8Duw5Qq4fwn9
         h131WoW81y84DhDtP9NaoH3A7mZOUOD4CgqSRuDlHJJCmgj3OiDJUsun48Tozsbqji52
         PjnAwFEtItqdguTVWbAB4fdufRu4KCEy44LgFq+QifYlKktOrJAc/4WDffS2cL9h/uqH
         uCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qIel5cck0U7jl4FG8NdIBnAMqTvZZ92P2SVldf4NMro=;
        b=CSQNnk83sTbsTuohSvOoMW6CvUGVkE9u2BkcxGDkRq/s/KfQooo+puHi84RIAUjCG9
         CdQ22z0wNoZKob+5jhSz12AcSmaHM+nnjzMR9JzKkAVvLtgOXajurxdg4V+kMgIOdZ2m
         jCavAuDE7zNHwug9Jc8G1WfbDgCi8BuLknjeXb/Yab9KWylGKVgPb8pak1Y57Bk7IJqH
         sQViEdT3DPK5fZ8feYlYh/HvxKvQ0YMaZcmR4Cudns9T03NX+prvGGPobd96uNYPhUiM
         GDvkZflL4+n/kiY7bBcmGiDg3nFQV2UrUsx6aEh681L6G4IN2mqWjw33/b8ElBdYBvG2
         HnPw==
X-Gm-Message-State: APjAAAXtfskWJN+rcwqcfUyJtEM7DRFoF+bCWwfkoOZQilzNE6d2jU2E
        UzN7KIOqwBA1G0uk60jB4VrNJK1dJaE=
X-Google-Smtp-Source: APXvYqwTD+/2I6AGPQls3eUWxLdfOn74H7z1oVnrr+CjtE3N9Nzn3SFrczDwzGMxt6q/JARh6/8eQw==
X-Received: by 2002:a63:ea44:: with SMTP id l4mr4600372pgk.29.1559238760919;
        Thu, 30 May 2019 10:52:40 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id d9sm2861367pgl.20.2019.05.30.10.52.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:52:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 7/9] Add support for nexthop objects
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20190530031746.2040-1-dsahern@kernel.org>
 <20190530031746.2040-8-dsahern@kernel.org>
 <20190530104550.62d78d8b@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3219b69d-397b-3319-4aa5-e0b33bae1671@gmail.com>
Date:   Thu, 30 May 2019 11:52:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530104550.62d78d8b@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 11:45 AM, Stephen Hemminger wrote:
> On Wed, 29 May 2019 20:17:44 -0700
> David Ahern <dsahern@kernel.org> wrote:
> 
>> +
>> +struct rtnl_handle rth_del = { .fd = -1 };
>> +
> 
> can this be static?
> 

oops, yes, it should be

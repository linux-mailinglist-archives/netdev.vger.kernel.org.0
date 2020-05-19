Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796471D9EDD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgESSJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESSJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:09:46 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01B2C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:09:44 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id i14so444166qka.10
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=snOhVhp5kSF1ouIxefjteMmTPd5uSscjjqWn5H8maAg=;
        b=sWHb+ifBqGNEJJ661iyHq+LEm6ikxemL3ClfbQTHLbDN5tEUV05FYsFiMaQvnA+72c
         tjwmnEvU93R6JEVisxORklRPI8562wVRmhAq2Md9jD5dQUUwOAoSXGyZ7Mbs+vs/m864
         5FhIdpy47ZGZB1M4sTkwOeDBvD0nZoQjgebJnGEYRK2nwH05asNI+86mpaGtMQmIoSFN
         +cYk1ElTn/BLGOCs6zo6X1PG6VXIqadMwAfEU1hJIyZxSrUEfaU/flqE/rCQcoOUTzBD
         VvO1pgs11hSZMoyOJLiOd/8KUMUbj6XrQf06DP5mR0fGwWfTHPkk9bqFhf6iX9lYGQta
         uOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=snOhVhp5kSF1ouIxefjteMmTPd5uSscjjqWn5H8maAg=;
        b=jE9stc8rSRhVCAGOwFON8aZMExOyEza5Wz4qNur67VBTPBTmyQMSHw/weloHbzBxoS
         AL6/dKmieg7e4h/RsXuw9LoX48wLihO8xJibvHxSjnxXKY6RQPc9Poj+ZLjZZcI/LHSj
         XwNDHAli6SuEVbP8P3qZ/PmZDdId7R8gbRMi2fkW+v9sR22NcT5JmCPaccNDGhHiECQS
         PowP66cfFfiGGed67zEu2Y6phjXV4Pl9dMP147yFpYbsj0YRMhvKdGygmlyNsXEXkqfW
         jVqqew/xVLYc6AFgqtpF6s8VTUrK0hjlsGldNAfNcTS/aqzVEqjdnzKJXMN8tQacK+Wo
         5gMw==
X-Gm-Message-State: AOAM530OnfaXBjgKQj7GI74cA2XGeXjI9cvqXh/ufQdsumwOLoX589qQ
        xEQiFw7yTv4UbLELel+BHuQ=
X-Google-Smtp-Source: ABdhPJzjLiEpF9BmJpMXaWhTPwJmxgnxcJ257ezTkPz8K1OAGoRLYRBSTbBFQSZHMc6HEL48f1a+EQ==
X-Received: by 2002:a05:620a:a53:: with SMTP id j19mr668474qka.183.1589911784024;
        Tue, 19 May 2020 11:09:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id h188sm215773qke.82.2020.05.19.11.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 11:09:43 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
 <8f9898bf-3396-a8c4-b8a1-a0d72d5ebc2c@gmail.com>
 <85pnb1mc0p.fsf@mojatatu.com> <20200519110835.2cac3bda@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <423a042a-bf77-c156-4f99-e52f6da68d75@gmail.com>
Date:   Tue, 19 May 2020 12:09:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519110835.2cac3bda@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 12:08 PM, Stephen Hemminger wrote:
>> Last time this function was touched in commit
>> 2704bd62558391c00bc1c3e7f8706de8332d8ba0 where json was added.
> 
> iproute commands are not supposed to expose the jiffies version of
> times in input or output. 
> 

Check your queue; I brought this up and Roman sent a bug fix.

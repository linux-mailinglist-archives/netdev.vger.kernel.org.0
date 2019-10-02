Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A79AC8F84
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfJBRPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:15:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40710 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfJBRPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:15:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so7741514wmj.5
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 10:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HQW+9aqjxMOR7vd6s7gSeaPG2jgjHjlQLEDCR/i0xYc=;
        b=v1qvBSqdk1Seo8pZyjVK7YfnquALxOlzFlUDmXBXvtkFLC8kOELOuembxY6iGHru/N
         tAp9kNFPmhT/b97I6NR22ESJzVZF5EXvTOb2YK7aHxUXnAFCoSttx35He3nfSm7YGwcA
         0Gg1SZlcwGw4XsVtgwNuaggEbHft6qPaQw/TqPV4xVMmOguTpDW9nyy6SsSJMQxZxcvD
         yyk4lSg82fMR224w9wKYupDhyyZNVNj0LnhcdmR5ahFU6pXjKac+ZjXK+icohEtwcEw4
         gIKuUoLfi9PWpfF+1eqXHesKBbCA8ESShPMU18c4ttUSDwl34wwT6YoOccivRxFWr8OS
         vfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HQW+9aqjxMOR7vd6s7gSeaPG2jgjHjlQLEDCR/i0xYc=;
        b=DJgYiWxLhaH37EHur06BT38uA4Y52rZ4A67dHOo/RJhHgPbqwshwupVYl0GJbqLE+j
         XcnDIjfVZDv3uzWHOYGgHspsDTaRwFYmvcHhwkdF5tAB7yYO024jgPWWsJgZkEo5qkJB
         LlDhplPxzI3KotxjUAFN5qz9eUQ8Ua+ho8t9Q8+qLSZZgAOjZye6vzwWQFs8XWWdY3y2
         RCZiyA2v6xk0aJ+dtZmiruzSE6sXthhI19JAbG9QKlYnyfXfb0BcqvT+6sOi7Ygxg9Ew
         1H+kaKsbvxpLHRRGbYCma/aXbiQC5RHTsKSa9yp2D+9KlnaZixF88grY6p5eS3yLhPRY
         wtIw==
X-Gm-Message-State: APjAAAU0QHrRSuVrQePqOya7VYHD03BbPEm4x8fASA2JV9Cms131O0Rj
        g/OL3q9d0Wu3lRd4tJ9dSOxvXeAUzIs=
X-Google-Smtp-Source: APXvYqztbqJLO4BvN/B5LzPQVHVjWuluRi4ssOP9f646FRlFrGo7AQvFTy0/KtpSndCjNGbKF4VDyQ==
X-Received: by 2002:a1c:c789:: with SMTP id x131mr3664040wmf.20.1570036497064;
        Wed, 02 Oct 2019 10:14:57 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f20sm6364520wmb.6.2019.10.02.10.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 10:14:56 -0700 (PDT)
Date:   Wed, 2 Oct 2019 19:14:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH V2 iproute2 1/3] devlink: Add helper for left
 justification print
Message-ID: <20191002171455.GA2279@nanopsycho>
References: <1570026916-27592-1-git-send-email-tariqt@mellanox.com>
 <1570026916-27592-2-git-send-email-tariqt@mellanox.com>
 <20191002074804.3ad4e5e2@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002074804.3ad4e5e2@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 02, 2019 at 04:48:04PM CEST, stephen@networkplumber.org wrote:
>On Wed,  2 Oct 2019 17:35:14 +0300
>Tariq Toukan <tariqt@mellanox.com> wrote:
>
>>  static void pr_out_str(struct dl *dl, const char *name, const char *val)
>>  {
>> -	if (dl->json_output) {
>> +	__pr_out_indent_newline(dl);
>> +	if (dl->json_output)
>>  		jsonw_string_field(dl->jw, name, val);
>> -	} else {
>> -		if (g_indent_newline)
>> -			pr_out("%s %s", name, val);
>> -		else
>> -			pr_out(" %s %s", name, val);
>> -	}
>> +	else
>> +		pr_out("%s %s", name, val)
>
>Overall this looks like an improvement.
>
>Why doesn't devlink already use existing json_print infrastructure?

It will happen soon hopefully. I have it on the todo list and hopefully
also a person to do it :)

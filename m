Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7DB45FF6
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbfFNOE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:04:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46210 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfFNOE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:04:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id v9so1594034pgr.13
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 07:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wWTPQIfRgF9Uuxi0qAw/dDjdSK+6G0d2xYwPCHUWXcQ=;
        b=bsWMMYSSwWAJ8BCr0MWq7mvBCQbxhwNHNmR+2heMj9aoJAskuWEAllBd5BhwhyRZG5
         kRdVYkznduAkDfLapbzbrBXO8Gco+oPw6kUlz6L8ib9s18BEcmC9SNOMGi+F4U6Q1zcq
         leUMO+U62ooSbsnfIjclorZ29sFsoRBSX7x5pHn6K2hw11c7NzDq2zYEVM3ymgy+SHh5
         CH0fTlvX1yGoWPVyfpjsmtlZH4oaOVvy+HRTtANekxktb19PrUGqXOMXMJwMP2O7Nx90
         Z652U8gIwgBdeuxxstQrhwBy3oJVQsn7TQiVI6lc4m8jmGCcGtpXA0Ar26qXpIOon2LN
         nDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wWTPQIfRgF9Uuxi0qAw/dDjdSK+6G0d2xYwPCHUWXcQ=;
        b=Aa6v+kGReO8SRuVc79eyuGyacGQPmyL3CeaOdTK9CFQ9996IU24Wpo80SwDgqG4GEC
         9xgv66AHZp9hxtJUWMwkB/YfuH/n9kZ+N/k4UnuPumKlpKUn6NS1dJwA12vnggRUsW9A
         rOS3iQYIBfyaQa66/DZOVLCE7gGp1yrNY0cDLJyIeGWmF0dPItZ+fC5HvuDpATiNDKk3
         QkIqsR5FadQhwqTdGKaGlN7Z3N+0lb86+ZYNgirDX+0mAkVefZyMeP7nBKOcPg8ea9bq
         kBC6sNXJRlzKIO3RB3Gv98ZsmU9esYimeSJtf/o9+7+Z6nBU8MUiHtIXymSXAkHCkG/X
         GJ7w==
X-Gm-Message-State: APjAAAVxD+AJ6G9E1fcXVx22d2OIMWLlOIdvsfHJoc4deeV1f3maS3nB
        DB/azLTRqAayzytCa0ESwltMSMfAmFo=
X-Google-Smtp-Source: APXvYqwRt7dyftPCeYtwmscGFPAKBcKxojnRX1AHxSFqTGSFsEalT1wp9duxSgmBIt+OYZlri+XAkg==
X-Received: by 2002:a63:140c:: with SMTP id u12mr35976268pgl.378.1560521065718;
        Fri, 14 Jun 2019 07:04:25 -0700 (PDT)
Received: from [172.27.227.167] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 2sm2932786pff.174.2019.06.14.07.04.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 07:04:24 -0700 (PDT)
Subject: Re: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
To:     Roman Mashak <mrv@mojatatu.com>, Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
References: <20190612092115.30043-1-liuhangbin@gmail.com>
 <85imtaiyi7.fsf@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c8bb54a4-604e-3082-c0bb-70c2ac1548b2@gmail.com>
Date:   Fri, 14 Jun 2019 08:04:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <85imtaiyi7.fsf@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/19 10:01 AM, Roman Mashak wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
>> Add a new parameter '-Numeric' to show the number of protocol, scope,
>> dsfield, etc directly instead of converting it to human readable name.
>> Do the same on tc and ss.
>>
>> This patch is based on David Ahern's previous patch.
>>
> 
> [...]
> 
> It would be good idea to specify the numerical format, e.g. hex or dec,
> very often hex is more conveninet representation (for example, when
> skbmark is encoded of IP address or such).
> 
> Could you think of extending it '-Numeric' to have an optional argument
> hex, and use decimal as default.
> 

I do not see how such an option could work. It would be best for
iproute2 commands to output fields as hex or decimal based on what makes
sense for each. That said, I do not see how this patch affects fields
such as skbmark. Can you give an example? The patch looks fine to me.

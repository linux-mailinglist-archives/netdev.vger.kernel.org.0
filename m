Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E44274D3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfEWDmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:42:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33159 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfEWDmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 23:42:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so2457466pfk.0
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 20:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mSz3HTfyv7+QQGumFbkOTWi87sl665Jw1P7icz4c5qc=;
        b=B0gSmD7DfhNwq+Bu4OhjHS7iGgdbEN9KUmDTqZ73nrP4mqV5ZP9xT+Wm6CWm7FYVN3
         sMtn1MqGkvOm54vqBAhSVOHmUwl7RKu/oZ74Pm/jCUqbnmOsh4mXVhDBMwHpgYDGtnBQ
         T4UGWbKxaIfwwb8MdHSpF0KuKhxFWFqqvHLdg3yGgUooLJ6wkRuoB/c0nC7zZNQ4pBb2
         +zPnSiNtJK2m5dEkxnb8POq7J2Hspj+gpyKRD1nlSB/2AQpJ3kNYvVAG/idpus2HsvHz
         tBnI8xQFNpbbbtozPt2uWLV+Ydf54WonVXz2lgA3l6sn09I1eG83OXFBHfnNLVg3gK1s
         71dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mSz3HTfyv7+QQGumFbkOTWi87sl665Jw1P7icz4c5qc=;
        b=UIacfPF3RXf5TY0TCd6VqjW/VfkQP+s38e/QxZkGaLUDMyjLZdOL4p1X09T6Aj38u/
         T1xwE2x1CC9Pbc2hJTLcIkFdO25aotzygI8Qum3hpYQOTHVpOFemLAt6evUIPNORBsel
         XPOfalvZCy29r/CR9tml0nYe5j90kYQZvj4y2OFAQ/aiScyDvDhUTcjHK1vTon6GAfyd
         4FJBSxsrDNNb1UkPmIQsld91EMrrBraM3PKrGwVoSvQiEEEeXJirEtANsZr2G5OHPMRf
         dGVUrPJpAsIIhaxmOXwLgXNkBJzuWtLji848urSsL553oS93ynIBeLk5rluq7cl4MYVW
         dbpw==
X-Gm-Message-State: APjAAAWF12VAcSyykzKWrfOEEdFCgQWId7MYjBNq2YoHx1A9rJkxfx0C
        W6aJM22d7ZyZG4ZNafPcDouh3HZJ
X-Google-Smtp-Source: APXvYqzus9Pn4wjUdJonxk/g6Cgt5We7Ey2D6vSeT6FZdK+K1U1rNqnYIst0g0crfdP84idTrpheCA==
X-Received: by 2002:a65:62cc:: with SMTP id m12mr39441938pgv.237.1558582956711;
        Wed, 22 May 2019 20:42:36 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f892:82c5:66c:c52c? ([2601:282:800:fd80:f892:82c5:66c:c52c])
        by smtp.googlemail.com with ESMTPSA id a8sm17031277pfk.14.2019.05.22.20.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 20:42:35 -0700 (PDT)
Subject: Re: [PATCH iproute2] ip route: Set rtm_dst_len to 32 for all ip route
 get requests
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Jason@zx2c4.com
References: <20190517175913.20629-1-dsahern@kernel.org>
 <20190522161652.42104430@xps13.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <35f170ea-d051-3e76-bfa7-1a5259a1d5c8@gmail.com>
Date:   Wed, 22 May 2019 21:42:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190522161652.42104430@xps13.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/19 5:16 PM, Stephen Hemminger wrote:
> On Fri, 17 May 2019 10:59:13 -0700
> David Ahern <dsahern@kernel.org> wrote:
> 
>> index 2b3dcc5dbd53..d980b86ffd42 100644
>> --- a/ip/iproute.c
>> +++ b/ip/iproute.c
>> @@ -2035,7 +2035,11 @@ static int iproute_get(int argc, char **argv)
>>  			if (addr.bytelen)
>>  				addattr_l(&req.n, sizeof(req),
>>  					  RTA_DST, &addr.data, addr.bytelen);
>> -			req.r.rtm_dst_len = addr.bitlen;
>> +			/* kernel ignores prefix length on 'route get'
>> +			 * requests; to allow ip to work with strict mode
>> +			 * but not break existing users, just set to 32
>> +			 */
>> +			req.r.rtm_dst_len = 32;
>>  			address_found = true;
>>  		}
>>  		argc--; argv++;
> 
> Why not warn user that any prefix length (ie not 32) is ignored,
> then do what you propose.
> 

My first version did that. I thought people would complain about a
stderr message. At least with failing the 'route get' scripts can be fixed.

After more thought even changing the prefix length for users presents a
limitation on future changes.

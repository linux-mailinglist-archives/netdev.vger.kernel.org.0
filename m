Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C82B3632A9
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 01:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhDQXhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 19:37:10 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:44328 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhDQXhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 19:37:09 -0400
Received: from webmail.uniroma2.it (webmail.uniroma2.it [160.80.1.162])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 13HNaPnR009227
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 18 Apr 2021 01:36:30 +0200
Received: from [160.80.103.126] ([160.80.103.126]) by webmail.uniroma2.it
 (Horde Framework) with HTTPS; Sun, 18 Apr 2021 01:36:22 +0200
Date:   Sun, 18 Apr 2021 01:36:22 +0200
Message-ID: <20210418013622.Horde.YlORJ7iYejhVF1yzgb2Eahq@webmail.uniroma2.it>
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: Re: [RFC iproute2-next v2] seg6: add counters support for SRv6
 Behaviors
References: <20210415180643.3511-1-paolo.lungaroni@uniroma2.it>
 <20210415142311.4e43a637@hermes.local>
In-Reply-To: <20210415142311.4e43a637@hermes.local>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Stephen Hemminger <stephen@networkplumber.org>:

> On Thu, 15 Apr 2021 20:06:43 +0200
> Paolo Lungaroni <paolo.lungaroni@uniroma2.it> wrote:
>
>> +	if (is_json_context())
>> +		open_json_object("stats64");
>> +
>> +	if (tb[SEG6_LOCAL_CNT_PACKETS]) {
>> +		packets = rta_getattr_u64(tb[SEG6_LOCAL_CNT_PACKETS]);
>> +		if (is_json_context()) {
>> +			print_u64(PRINT_JSON, "packets", NULL, packets);
>> +		} else {
>> +			print_string(PRINT_FP, NULL, "%s ", "packets");
>> +			print_num(fp, 1, packets);
>> +		}
>> +	}
>> +
>> +	if (tb[SEG6_LOCAL_CNT_BYTES]) {
>> +		bytes = rta_getattr_u64(tb[SEG6_LOCAL_CNT_BYTES]);
>> +		if (is_json_context()) {
>> +			print_u64(PRINT_JSON, "bytes", NULL, bytes);
>> +		} else {
>> +			print_string(PRINT_FP, NULL, "%s ", "bytes");
>> +			print_num(fp, 1, bytes);
>> +		}
>> +	}
>> +
>> +	if (tb[SEG6_LOCAL_CNT_ERRORS]) {
>> +		errors = rta_getattr_u64(tb[SEG6_LOCAL_CNT_ERRORS]);
>> +		if (is_json_context()) {
>> +			print_u64(PRINT_JSON, "errors", NULL, errors);
>> +		} else {
>> +			print_string(PRINT_FP, NULL, "%s ", "errors");
>> +			print_num(fp, 1, errors);
>> +		}
>> +	}
>> +
>> +	if (is_json_context())
>> +		close_json_object();
>
>
> The code would be cleaner with doing if (is_json_context()) once at  
> outer loop.
> See print_vf_stats64.

Hi Stephen,

thank you for your suggestion. We will change the code as you suggest.

Paolo.




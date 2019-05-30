Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F0930155
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfE3Rzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:55:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40436 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Rzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:55:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so2437820pgm.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i2PtCFrs8IGy+U86c2GXSQ+rBpYLzeHIpj4QsVw3f1w=;
        b=ICQvcvqxypsHCSW9AzNuMxBoxJw7rtJuu4s++romVUPBksK7mCbaU3KeS6HRbh7EOO
         iY9j8X3pu5zsQXAYs+2S0iz45ES80O0gbGJ0Adsv7p/iWl2Z17l7ufiiY9G9qpnxHhai
         MYKxPZCEGrUkltZSuevnYnxvLIU8Qm4oM8OLpptbf3LSXV/gX3w02bmmZqvTnWy4omrL
         b8CfbMap0B1Yr5Nqkc8TjnTpiqQ4F3aynjlGC6E2fc83dKPS3JIyrS5flGkUOHFh28On
         pIqAi1QViAZ9K5Uk2wsYsfuEZTYexg7BVmRSBWgfSiIugaenxKF+3KdmxJSrhGKUM1sV
         rAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i2PtCFrs8IGy+U86c2GXSQ+rBpYLzeHIpj4QsVw3f1w=;
        b=j2miKGrMgk3YrdjuoxkaHXFoYCyiS6xYtDAsPmpQphykLTfSugXpg4jbiFlkBbv/8r
         ceMK+e6QcH/NaXlbquExva1QueH6KE0g1VyyMywnUFkOPeQ8S/S9gB3T3klBaBVykUg8
         5Op+Zh1ncWENXtX7UkvofjklTC0iTlBwHKacSfz1NrwzMCOzQuRPs7BjzPV45Grmr/pI
         u9mjhE5/3Lsac3isEX4Zu1wP0/ImW2aLh+Qpg3X3b/+fY5d4W4732JqwF33HJdSeU0UJ
         cfNLtTV7NCRAxvJBiUx1ZPSHTrHS1VunYx4x4YmYzgOASWsG1RnDDp0KuENZQhqkYg6q
         s0ag==
X-Gm-Message-State: APjAAAW18+IsjdIS6eWgxWbPl3PHRIv+GOkbnlN4F2+cVZzwoUhOhKYx
        Ca9HCKkDV/xLh9mL58AwpzCG2GzqPMU=
X-Google-Smtp-Source: APXvYqy5OYBUDHqVGdUrKJqf9bnbTvUHE/AjNKMYL9Jhcl68i7WS1M6tXS48oFHsYlW2A17LnalBbQ==
X-Received: by 2002:a63:d416:: with SMTP id a22mr4810408pgh.218.1559238947992;
        Thu, 30 May 2019 10:55:47 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 25sm4309295pfp.76.2019.05.30.10.55.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:55:47 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 7/9] Add support for nexthop objects
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20190530031746.2040-1-dsahern@kernel.org>
 <20190530031746.2040-8-dsahern@kernel.org>
 <20190530105229.6951bffa@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dbce798b-a063-be24-a8ad-6fdb3aef8782@gmail.com>
Date:   Thu, 30 May 2019 11:55:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530105229.6951bffa@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 11:52 AM, Stephen Hemminger wrote:
> On Wed, 29 May 2019 20:17:44 -0700
> David Ahern <dsahern@kernel.org> wrote:
> 
>> +
>> +static void print_nh_gateway(FILE *fp, const struct nhmsg *nhm,
>> +			      const struct rtattr *rta)
>> +{
>> +	const char *gateway = format_host_rta(nhm->nh_family, rta);
>> +
>> +	if (is_json_context())
>> +		print_string(PRINT_JSON, "gateway", NULL, gateway);
>> +	else {
>> +		fprintf(fp, "via ");
> 
> I was trying to get rid of all use of /fprintf(fp, / since it was
> indication of non-json code and fp is always stdout.
> 
> Maybe
> 	print_string(PRINT_FP, NULL, "via ", NULL);
> 	print_color_string(PRINT_ANY, ifa_family_color(nhm->nh_family),
> 			"gateway", "%s ", format_host_rta(nhm->nh_family, rta));
> 
> 
> 			   
> 

The above is consistent with print_rta_gateway in ip/iproute.c. Since
the only difference between the 2 is the header struct, I will change
print_rta_gateway to take the address family over rtmsg and re-use it
for both paths.

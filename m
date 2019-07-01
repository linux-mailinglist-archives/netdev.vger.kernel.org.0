Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E141D5C29C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfGASGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:06:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38512 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfGASGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:06:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id z75so6408440pgz.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 11:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RB1+4t65SrtJNQk+3n9dt3c+u+GxU7U354kjExYTLZU=;
        b=jXIpawT2ZfDTUmcX53lKAJzVZLCLIpweW3a2NqZs3kDlSRhn1RAnxZM1QH0tm7oV2e
         j4kE22KZsV8lwAh6v20z6i/EksSh74e6VbkgKnaoFYO450jmsif6RCvFZOaCRyFXbunx
         dY5DwH/ZbQlGaT83tShyI7eftiXqxJ06aGad3NJ/cakmQlCAjY3vHTHa3h726wrJQftr
         A+EayQf9uTQl0bfOsa5Utdm9uK1jbt0oX2rN6jTBzDRjOCpyT0HVk7rx5Mv32sm4dOiA
         GOX5gFHEGV9ePwr7+kjmOO8HXHQhm53Z6mwkjxw4/InAMDjZ4JtTdW61gfgdQSqYgRCs
         Lv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RB1+4t65SrtJNQk+3n9dt3c+u+GxU7U354kjExYTLZU=;
        b=gYAgPWf7zk26vt04fH5xtBrbV0qjIRnKS7ot5qhxAtpp0+bLMvf//3CVISXBduPhp1
         m9BIfImB9ml5vlG8WDUihOVHdhM369u9GoFWrVEd9qjG4wCdEtgrhmO91GjRezx8FOAY
         EcfxGzXJbhEju13rCfmRcr0rdt97tpCKlIcCWAgu7EKWjofiy6iOnjB45soGZ0jbGcbL
         vO2Sb97pyRWI0/c67ClO0V9Eb3g7vSaYjBZk9OGfIEap3HLP+c6isnFdwvyW1+0Q9rFE
         9e/sdU6fiThqvWwYGfFwWjpRMtSyXYujJGHek57Y44G6kpj2XA2slUHXZSUuFy4KvHe/
         a6qQ==
X-Gm-Message-State: APjAAAUiWclP8wcY1RQnc5LcpwJQVjFrHM6IPABewhIh8Kf4NifzjTQK
        lYY8ifQciQcXDj6H+HHsHDRVgfVe8n8=
X-Google-Smtp-Source: APXvYqz+hB48fAnEBLdNUq07EKFs3fO46+dFjqH4IrkwpFCVIMCMR6aR+VRsklszhgZWetxAyw3uHA==
X-Received: by 2002:a63:1a5c:: with SMTP id a28mr26001588pgm.418.1562004400889;
        Mon, 01 Jul 2019 11:06:40 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id m100sm199216pje.12.2019.07.01.11.06.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 11:06:40 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 16/19] ionic: Add driver stats
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190628213934.8810-1-snelson@pensando.io>
 <20190628213934.8810-17-snelson@pensando.io>
 <20190629115324.7adfc3c9@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <797ede44-e303-16e2-11df-70a8eba76fbb@pensando.io>
Date:   Mon, 1 Jul 2019 11:06:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190629115324.7adfc3c9@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/19 11:53 AM, Jakub Kicinski wrote:
> On Fri, 28 Jun 2019 14:39:31 -0700, Shannon Nelson wrote:
>> Add in the detailed statistics for ethtool -S that the driver
>> keeps as it processes packets.  Display of the additional
>> debug statistics can be enabled through the ethtool priv-flags
>> feature.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>
>> +static void ionic_get_strings(struct net_device *netdev,
>> +			      u32 sset, u8 *buf)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +
>> +	switch (sset) {
>> +	case ETH_SS_STATS:
>> +		ionic_get_stats_strings(lif, buf);
>> +		break;
>> +	case ETH_SS_PRIV_FLAGS:
>> +		memcpy(buf, ionic_priv_flags_strings,
>> +		       PRIV_FLAGS_COUNT * ETH_GSTRING_LEN);
>> +		break;
>> +	case ETH_SS_TEST:
>> +		// IONIC_TODO
>> +	default:
>> +		netdev_err(netdev, "Invalid sset %d\n", sset);
> Not really an error, as long as sset_count() returns a 0 nothing will
> happen.  Also you can drop the SS_TEST if you don't report it.

Sure.

>> +
>> +#endif // _IONIC_STATS_H_
> Perhaps worth grepping the driver for C++ style comments?

Those nasty little things sneak in there when you're not looking, and 
you try to get rid of them all, and there always seems to be one more 
:-).  Yes, I'll look again.

sln


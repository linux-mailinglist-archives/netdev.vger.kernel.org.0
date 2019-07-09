Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A163DE3
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGIWdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:33:19 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35418 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIWdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 18:33:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so124167plp.2
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 15:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Ke10NiqnCzZE+I2grUp4qS49iUtPQIdi1x4v9XIc1gw=;
        b=fBTXGIXtlVx48i825m98FT0OxUO14hg9mMR76m7HImCAIcSQDVQTOmbRxOwZnPdMIn
         IcTvmNoRy7MYtqMeTVm6UxgXrfxZqydWgTVsNVZ6UOvCBrsBhDj3grLWOvxCVDERZUwy
         BUo0g4TxncNW1zoc6i88NLaBY2T2YgZh4wkGM8zDUrU48mqbsNkXeYsT9pLF8shkPpSy
         8OEQH3dee20I2Tg4u6DVl2IIYGDsVOi8JGcggh3dn6DfykhI4oOmvEpqrcnnwq9SvHU+
         gBrcaECwzWH9Rww0FSWO1UD19vMOXAtmAJQIXu9/Yd43i8uvNizJe6IQjBkFn8TAeQvi
         /AVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ke10NiqnCzZE+I2grUp4qS49iUtPQIdi1x4v9XIc1gw=;
        b=a6Ddg26vU+pe95+S3nmgMKdB9nCoGHcfRWzsow389lGgX9MNZtxvd0cLeLB1ZEsWcE
         nFlrqKZYF1EDarVNcsyjN4wxWgvrgmhbE1DJv3P/ybJWCak0xWOwZ6pcQSkIJeRQyaUh
         JnWY9s4hu/XSUE9ZPbSmmH3UEG4VTuazz9mOYOBuTBcmSptcnj+cvEk/TqeE0Xomw6PK
         uZ1jjxMJlz+GyD9XWyjdJhfuD4dpAFyTnUqUJn0d/LAWfvGZdYESOHACg+c+Lq4kpHMO
         ETnjpYyGSDShOnB1K2pUAiTHEMe2rYRrTcbpREESmW9rfsSYBQU7Nh6ZPCksd2yBnyUB
         cOnw==
X-Gm-Message-State: APjAAAWQKdZjEVKiF5zw23CtntWVG21jgDpdxnmZAn308irEKZTwzPez
        DnZ0LdFzKhIWRs4GvF7LQIWb06aywk0=
X-Google-Smtp-Source: APXvYqwavFJkl+MVV/ihh/6YDnFCbZu+xg2gIQvC728fAStGPKHjMVCw4+Ew5cUBPZe0huner3lJ+A==
X-Received: by 2002:a17:902:4201:: with SMTP id g1mr34977125pld.300.1562711597963;
        Tue, 09 Jul 2019 15:33:17 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 65sm110031pff.148.2019.07.09.15.33.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 15:33:17 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190709052541.GB16610@unicorn.suse.cz>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9de0a7a7-d609-ccfd-d27c-1b64b6366751@pensando.io>
Date:   Tue, 9 Jul 2019 15:34:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190709052541.GB16610@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 10:25 PM, Michal Kubecek wrote:
> On Mon, Jul 08, 2019 at 12:25:26PM -0700, Shannon Nelson wrote:
>> Add in the basic ethtool callbacks for device information
>> and control.
>>

>> +
>> +	if (fec_type != idev->port_info->config.fec_type) {
>> +		mutex_lock(&ionic->dev_cmd_lock);
>> +		ionic_dev_cmd_port_fec(idev, PORT_FEC_TYPE_NONE);
> The second argument should be fec_type, I believe.

Yep.

>
>> +		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +		mutex_unlock(&ionic->dev_cmd_lock);
>> +		if (err)
>> +			return err;
>> +
>> +		idev->port_info->config.fec_type = fec_type;
>> +	}
>> +
>> +	return 0;
>> +}
> ...
>> +static int ionic_set_ringparam(struct net_device *netdev,
>> +			       struct ethtool_ringparam *ring)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	bool running;
>> +	int i, j;
>> +
>> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
>> +		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	i = ring->tx_pending & (ring->tx_pending - 1);
>> +	j = ring->rx_pending & (ring->rx_pending - 1);
>> +	if (i || j) {
>> +		netdev_info(netdev, "Descriptor count must be a power of 2\n");
>> +		return -EINVAL;
>> +	}
> You can use is_power_of_2() here (it wouldn't allow 0 but you probably
> don't want to allow that either).

Sure.

Thanks,
sln


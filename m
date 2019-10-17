Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2229DB313
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440616AbfJQRO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:14:28 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:38081 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440595AbfJQRO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:14:27 -0400
Received: by mail-wr1-f47.google.com with SMTP id o15so2814154wru.5
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PiHktvU9Kg2x0MlRE+ETW3Ji2/1IsMOqPHvvhIb/ok0=;
        b=bjT/R1llh476wEfxWuxXyfte1cyPV0GZIHHlHbS/8AELaqk52hEPVXnx3K47cF95bz
         Dj6huwzAt/j8rOiiwE4dPYUxZgoXvFZoPr2o6iuYaSwq/3zIbO7jfOa4WLIkKn8KHBy5
         ZyIhImULQ+31i0ex6Sg+4I4UjIMmvASO/6hCJzWZC3/AUNgAvmllMubz1eiRqJj7iYBT
         QvGJnyK+TFdxM4I3ksFRyHHCvk2lyMpnfwU+UpNo2/I5H/VTQqHQJB8swNsXr5iIFKCL
         BM7ggZXPa1lbVyOQqwOnhRZN+m0TCjOx3QzNIpQIaFY2MUHkpstOTZGDP6UNHwWUrZ8P
         d3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PiHktvU9Kg2x0MlRE+ETW3Ji2/1IsMOqPHvvhIb/ok0=;
        b=tCcpkbOICtBni6hPsESFBFqiVVW6mYeMd3ag7/S3NLukb5wZVMCj6nRKqE4ISe9I5S
         +xHIw3o7MesAAblDVZ9L1GF6kJ+8gPEI0/lHUfL6KEbmbFNo6yBJRu0Gcy8V2g1lwOwj
         nIb6JaHWFsuzgb8T3jS8k6XiaJN03rKzCqzn7wM8pTpp2hrC0+4YJcv0TYCB5vcHXgPV
         XCGuvBc7TEPGanbET7+y2WTLFXpkyxqy46Jgkpss19yXkjlc055kE+QaptwxEKLSyYtY
         mwXUqpL4L3LeWYCBIZvv/32HXbTZgH5B9tw41tyM+4rpX1hMXkuRbID1nXZUtefVd8IZ
         O77A==
X-Gm-Message-State: APjAAAX0ImUNw+WrHcTwTREJ6xFFK/yjAhGGp0L/Lty409i4/zuyunV9
        kCNeaOGbMHTd9I2xV0IUoaTstQ==
X-Google-Smtp-Source: APXvYqwrK4fQgMz+wRFazQ2DBAFo6GcORIefYPywJi5IdubfcEm6AvUPRbbjbO/XF4PlPrYNfc9RlQ==
X-Received: by 2002:a5d:6b0e:: with SMTP id v14mr3954190wrw.280.1571332463683;
        Thu, 17 Oct 2019 10:14:23 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id z5sm400298wmi.12.2019.10.17.10.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 10:14:22 -0700 (PDT)
Date:   Thu, 17 Oct 2019 19:14:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v3 2/2] ip: allow to use alternative names
 as handle
Message-ID: <20191017171421.GB2185@nanopsycho>
References: <20191009124947.27175-1-jiri@resnulli.us>
 <20191009124947.27175-3-jiri@resnulli.us>
 <f0693559-1ba2-ea6c-a36a-ef9146e1ba9b@gmail.com>
 <20191016112858.GA2184@nanopsycho>
 <4ed31257-a1d1-23a3-827e-9dc1ec81ff26@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ed31257-a1d1-23a3-827e-9dc1ec81ff26@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 17, 2019 at 05:34:54PM CEST, dsahern@gmail.com wrote:
>On 10/16/19 7:28 AM, Jiri Pirko wrote:
>> Tue, Oct 15, 2019 at 08:34:56PM CEST, dsahern@gmail.com wrote:
>>> On 10/9/19 8:49 AM, Jiri Pirko wrote:
>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>
>>>> Extend ll_name_to_index() to get the index of a netdevice using
>>>> alternative interface name. Allow alternative long names to pass checks
>>>> in couple of ip link/addr commands.
>>>
>>> you don't add altnames to the name_hash, so the lookup can not find a
>>> match based on altname.
>> 
>> you are right, it is always going to fall back to ll_link_get(). I will
>> do another patch to add the altnames to name_hash. It can go in
>> separatelly or I can add that to this patchset. Up to you.
>
>this patch claims to do the lookup, so it should actually be able to do
>a lookup.

Allright.

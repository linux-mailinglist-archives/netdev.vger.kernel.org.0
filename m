Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70DC232175
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 17:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgG2PYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 11:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgG2PYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 11:24:35 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C625C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 08:24:35 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id a19so5008413qvy.3
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 08:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5/PZdv3bFLhuElUqG1qvFu2ykclQIxrd/zvQgb2PAsc=;
        b=tVzMkep2J1KXjhi6ZjtfuFipREXOBpLa3LhIxsHq0kbdmj4TkbZ92wEOXbZH3hp/n4
         SAW+40E3faOmQ5TRqTyxEqEOCbam/oWAbEG4wVZhKDoodTkGI/54YMIzgTKltmHoke/n
         evr6WUvrYcn0sQoBeFYI/a2zslDvfg+iHqtNwCUQ2d8vZYh7IRVh4gfJ9/p3/+LikDSv
         7+EQTRVSBHOGlFZJAb8PNWNMNMMnibJlEnDH9ru81terbguDhHUk9Xt/opucRaXUQ3DJ
         aQD4NrxDkarKB8wXzbsCzPx/BJV9TXi6TosrWvBpR6KugIbkW3FOZJKM9WxfZfYHHMhp
         UCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5/PZdv3bFLhuElUqG1qvFu2ykclQIxrd/zvQgb2PAsc=;
        b=OyN3UjQow7v2ecLshWNJEbileJ3/Iw1oObzrW8rL5speZzcHHRTa6BjBUl9Eqyxv4Y
         vgtG3FT9R4OrOnlZtgUShyCoqyG4LCOOM4VAHxnx7D+H4jE3kr3UGcnAm6KG4iAZTfwM
         qMvnHXV1DxlUjAhlszdlKmsZ7Ql5JODKmeI9uXHMacMSLMOdpdeRZYZn8omp6WTuL+Bo
         Oi10UhiPWoEUae9b/tjhgog/YenCh0Jhg9vkWDFUGE/T1eF8zB3OHHfgcJTgSssjZmZa
         4P/sqY0OisNH3PvObuBpfKv1MB5jOnHytcVpoCw6NDE4RbrGe9snwqEnsFISyv47g60D
         Bt7A==
X-Gm-Message-State: AOAM531l86HBlmQoVLKHJv5SyW6z4f6Rzk7cahVzz7W5kVyBvNsjTuYc
        ldeaMS03dYw0DRcKGcwPDwzQWcYG
X-Google-Smtp-Source: ABdhPJxESeXNX7SIv3A59zIe6KRrftNDmQYSsphjKmOEixUsAfKr7mTrIdIEXvrX0wV4OfYTLwtUnQ==
X-Received: by 2002:ad4:4d83:: with SMTP id cv3mr33400956qvb.236.1596036273756;
        Wed, 29 Jul 2020 08:24:33 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c873:abf:83ee:21b3? ([2601:284:8202:10b0:c873:abf:83ee:21b3])
        by smtp.googlemail.com with ESMTPSA id v58sm2073011qtj.56.2020.07.29.08.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 08:24:33 -0700 (PDT)
Subject: Re: [PATCH iproute2] tc: Add space after format specifier
To:     Briana Oursler <briana.oursler@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Petr Machata <petrm@mellanox.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
References: <20200727164714.6ee94a11@hermes.lan>
 <20200728052048.7485-1-briana.oursler@gmail.com>
 <2ba95cf58c6f72279dc42a2ccbd65a00abeeac95.camel@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e6882877-64ac-bdfd-5a40-79a7ab7172ab@gmail.com>
Date:   Wed, 29 Jul 2020 09:24:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2ba95cf58c6f72279dc42a2ccbd65a00abeeac95.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/20 11:53 PM, Briana Oursler wrote:
> I made the subject PATCH iproute2 after the question discussion with
> everyone, but I realized that the patch it fixes is in iproute2-next
> but not yet in iproute2. Sorry about the confusion. Should I resend to
> iproute2-next?

no, it is fine.


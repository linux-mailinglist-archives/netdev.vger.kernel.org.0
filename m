Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75ADB128922
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 14:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLUNLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 08:11:54 -0500
Received: from mail-io1-f53.google.com ([209.85.166.53]:46452 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfLUNLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 08:11:54 -0500
Received: by mail-io1-f53.google.com with SMTP id t26so12111679ioi.13
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 05:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rOpVuMy2RIQF9LbENi5T7IbwM6dhfF7zOJlxvEUj3Os=;
        b=fvQ/ZVBAoaXdvLO2ql0Xcej6Va+za9C0ZrsMqtJO2TXvPszZmXa9Q15IeJvxwk6J31
         D+9i/zAnsjmW+SI3G2qHKPAVsonCKGFTnsVD00Pf+0u9BVU2M56Vp4F4XHoLSUnm3Ya0
         xeqyZLa3ep5m7LZoxmW6YkRshOkp1gWp7hMMVzE1b78akFFfNz/L0GCSt6ITsOY8kNmN
         U0Um6QzmkwsoOdTAX6c++CmsCKXznBNKjG7I/Vp7XCA0okKdKTIMoeNd6/0lKG2AI4L+
         7cla9e9lgb3jMfeZO0HGpjP3rndB90lW5wS2TfkmY7lnpCsnLRTN5P6rjPEPW6yg+KXE
         PywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rOpVuMy2RIQF9LbENi5T7IbwM6dhfF7zOJlxvEUj3Os=;
        b=PSTDbDxWGfGHBeg9woramwSQsqaEQtKJFek6Jy3v4O9f4bG+8RkeDH1HC8ooU1VyJt
         1IXpsw/uLxtEvNkTZqWwk6bYTXoJlH28YVhXkIdGlQV8AYbXjGE9zNGH6lBMpqMEfSqU
         z13wLQWdU7qwjc2zK6X4U0E3aec3n6YoAeLFTxR2dtoEyksiEvz0BU+YHZgcjVN8txYS
         L9NFmiWSUEjn5F6mMEWAuc5l9Pf0q8TWSbn81PeVWlkVO7QVdIZtqkvjM2FdEqRWyYy6
         vV/MW2KV/L6wPr8/vpjUWIHKJjreUm2/CLx0knqf2J8+qY97misrFM5M3lC9hmlLDdIe
         e3tg==
X-Gm-Message-State: APjAAAWRU7o4aM5yO3+UvpxZZdAQBGU4UdU8XlSxP+jzvTHrgX6QIjxq
        nxFWQIPQd/LmSy3pb2Rb5gDtFWCIpsI=
X-Google-Smtp-Source: APXvYqy6DhEAWrnBYqhXc5qQOMZLI2wITuLcamSBmX/H3aBgV3ZxbAnNRq7gh5LH9hDk0O74yRxwCw==
X-Received: by 2002:a6b:6a02:: with SMTP id x2mr11864822iog.154.1576933913827;
        Sat, 21 Dec 2019 05:11:53 -0800 (PST)
Received: from [192.168.0.101] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id o70sm6763061ilb.8.2019.12.21.05.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:11:53 -0800 (PST)
Subject: Re: issues with the list?
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
References: <f31715cd-ae38-b358-a507-22eeb78717a6@mojatatu.com>
Message-ID: <3d1e7772-f91d-3323-fef9-e23278b4f7d3@mojatatu.com>
Date:   Sat, 21 Dec 2019 08:11:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f31715cd-ae38-b358-a507-22eeb78717a6@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it turns out I was unsubscribed (not by me).
I had to resubscribe...

cheers,
jamal

On 2019-12-20 7:19 a.m., Jamal Hadi Salim wrote:
> 
> I just noticed i am not receiving netdev mail for at least a day.
> Last email exchanges are related to Davide's patches. Is
> anyone else experiencing the same issue? The effect is
> like i have been unsubscribed.
> 
> cheers,
> jamal


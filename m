Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8F0ABB89
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbfIFO4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:56:03 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:39253 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfIFO4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:56:02 -0400
Received: by mail-wm1-f46.google.com with SMTP id q12so7453136wmj.4
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 07:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AlPfad4PCCBpyDs1jC4YhyIyakJmOQ1nP6oU5mESIzY=;
        b=ajMLi2J6ivM65Gnvb0ugyd7Nm/dg2CPRsFPHPxvYyyjkuVv1K1vMSwbKDj6amYrin9
         WBjpi4aNpZWAcDm7iq1VduGoSa1DGOXWtsc3G5H2RNOeBe3DKmavH4CzbtOd4w9K+5f4
         bEuz5vRAaHqwe+qLx0DCq21NhLY0/R+P7Tm2NQHAXOWMLCzFGuLAoK816Cqx8izpEcMT
         hp2qLJQztb83jcAsGfD1fVKdvTIifYi4BUWC8xO7gOJkWABLJa6ftDsdTM9rzflhb/28
         Y55iRB1u8GfrTS14PBnbO0BywPQNNdMko0MXbrlAlUikyStrpOeTD4lRtVtqSuWhNsb/
         1qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AlPfad4PCCBpyDs1jC4YhyIyakJmOQ1nP6oU5mESIzY=;
        b=bHcwAXZQSxpFIN1lplcuSOXwB9My3TYFiMWocBYNR/QGh3pPH/PoTyTIU3+/7LXy1Z
         uo2LMKz04nJqcwazxeupcUZVD/yLt9R6hBPzuDq04lhSaENXGwov52Ghwn4Q/+N7dQWp
         Ms9G8ydIYayrQU6L6BJ5Cu3T8+4gfWYLzOxiLHqBbbm7GDZ+70HKgGh9VqEpoYQl6MOz
         /9ac1acy2wdn8d2SVuPW4gJ5cF0njnj7mqpmCCzGR6ND07ZZ6h0htxXbWm6uQtbWSXqX
         ySsR+s7AzRq4R/KSGYuS37XzYBtWFPXt6Cc0zEbRh8zyYv4PtF98jc8GTAVOU+0WK5bB
         l2GQ==
X-Gm-Message-State: APjAAAV9KRyrOkxJjy8kLka0gc1E8ZWbXdarzFpP/2fbP82UHWjlCNiM
        sx7OzzjEDrw1yhgskJfT2DilN/BWDxI=
X-Google-Smtp-Source: APXvYqwH58cL+Es9AHgZ8xcvF4ISYpmo7pihMWhqMJ6bB7VmLvpUxqVXdsgafsQkESONLZYnsXjAIg==
X-Received: by 2002:a1c:7ecf:: with SMTP id z198mr7343809wmc.175.1567781760904;
        Fri, 06 Sep 2019 07:56:00 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:3c8b:1257:3510:1a1b? ([2a01:e35:8b63:dc30:3c8b:1257:3510:1a1b])
        by smtp.gmail.com with ESMTPSA id g185sm10772194wme.10.2019.09.06.07.55.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:56:00 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Need more information on "ifi_change" in "struct ifinfomsg"
To:     dhan lin <dhan.lin1989@gmail.com>, netdev@vger.kernel.org
References: <CAMvS6vYbphKKM4evbV6Vre7vaR8r+oJgZ8TuQU6VtBSjVqH7dA@mail.gmail.com>
 <CAMvS6vbeo5tBADNmLvkXUuSSHmxVpt3UW+jZtxY2Le9nXRbNDw@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <16579c2d-d0b7-179f-5381-3803118a8972@6wind.com>
Date:   Fri, 6 Sep 2019 16:55:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAMvS6vbeo5tBADNmLvkXUuSSHmxVpt3UW+jZtxY2Le9nXRbNDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 06/09/2019 à 07:08, dhan lin a écrit :
> Hi All,
> 
> There is a field called ifi_change in "struct ifinfomsg". man page for
> rtnetlink says its for future use and should be always set to
> 0xFFFFFFFF.
> 
> But ive run some sample tests, to confirm the value is not as per man
> pages explanation.
> Its 0 most of the times and non-zero sometimes.
> 
> I've the following question,
> 
> Is ifi_change set only when there is a state change in interface values?
ifi_change indicates which flags (ifi_flags) have changed.
It does not cover other changes.


Regards,
Nicolas

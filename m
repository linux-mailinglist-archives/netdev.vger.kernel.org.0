Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2047A118
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfG3GIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 02:08:20 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:33426 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfG3GIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 02:08:20 -0400
Received: by mail-wr1-f44.google.com with SMTP id n9so64426059wru.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 23:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=87OwG5gINfK7JLpMpbAZaO4RwN8uZ9a6pNpMSYcFUsU=;
        b=1HaPB3s508LFP1hh8nUiOqeyBCtU8EmAQVCz9ULWeAE5vHZvCiHKWYa77qiMNQ8dX7
         qXfqENtdbGY4m9eD9upxyMltWW+0RlI6dot/ZrMiG9EPBcTk+THCwkJB5Ky12KvWQHnf
         4EI6NZeFfx+156Jyl+GTcpqgT2PBAAzwMoKERgJymy0Ii2fbOffXB1ZvG942M/eKqwNG
         YFP4GuNBzD14h4OjmDRCgeAsGZEQRffI9ZdofYwLf7b3l9KPxc0CWKxcHP09BerCN4HL
         uk4DweNKTunBm7R7Ydhv4cxr0HIL49Txd7A90lsorQKhjqzdOwHIVBjymfzhugNxt7kO
         vIRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=87OwG5gINfK7JLpMpbAZaO4RwN8uZ9a6pNpMSYcFUsU=;
        b=t6jCJNPcTQTxXNr//kr11mTGbEPHuXJluC88EJD8RVWrn9w71VI3S0u9mWw9+1MQB3
         2JE7lhjgFZKVf1kQTc7Gw+sy27gYY/zg37pcDlpGZhtfEYmq9DDjDfNcx2TuBMcWMgk/
         D2YUudS0Z/9a+pCBfYNLwheP/dn7ttin3uD5jr5Nz9XaroFA51wk2mJy7GkKDu1Q4qCc
         4ez3QzUGHrFjit+ADr7en6oFfWPRKr6ekGT9vfiPs5k0Q4ungVvy83922A+wV627gF45
         B06IQ4W7Zgrs+tcs7dFJfVzp1tYYwrzEQ2iCHx7rEqENT2aRdC3hfLIqkp1ygRGHEnee
         AyxQ==
X-Gm-Message-State: APjAAAUOKkuS3vXng1Jb2UJLVj8M6JEKcrgbqxEWp5SFG7MXERW6uk9M
        K3lX4h34fTCxAbjcF2jiu8g=
X-Google-Smtp-Source: APXvYqxuvvqZoidWfVwSrvJgPWra1bAea2eM2zEGSJg97imNoBrIfKbNgz+Y7IBge1rFGYiycSqHvQ==
X-Received: by 2002:adf:e552:: with SMTP id z18mr128361317wrm.45.1564466898330;
        Mon, 29 Jul 2019 23:08:18 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g8sm66573103wme.20.2019.07.29.23.08.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 23:08:18 -0700 (PDT)
Date:   Tue, 30 Jul 2019 08:08:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190730060817.GD2312@nanopsycho.orion>
References: <20190727094459.26345-1-jiri@resnulli.us>
 <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 10:17:25PM CEST, dsahern@gmail.com wrote:
>On 7/27/19 3:44 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Devlink from the beginning counts with network namespaces, but the
>> instances has been fixed to init_net. The first patch allows user
>> to move existing devlink instances into namespaces:
>> 
>
>so you intend for an asic, for example, to have multiple devlink
>instances where each instance governs a set of related ports (e.g.,
>ports that share a set of hardware resources) and those instances can be
>managed from distinct network namespaces?

No, no multiple devlink instances for asic intended.

>

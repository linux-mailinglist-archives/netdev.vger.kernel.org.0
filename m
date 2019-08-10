Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF79B888C4
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 08:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfHJGGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 02:06:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51096 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfHJGGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 02:06:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so7608299wml.0
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 23:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jyINK+TDVic+IRvjORy4aBaqtG/tLl1lQ1zuvAarZwA=;
        b=QrtTzv/Xvfc/6DTbxWnBGu1GFeFyJXLvykjD9CazKpSEq5wWXYToYCdIHyfCqRFWW1
         jA2ShITwho9fB0kOx10vcQw3GMz+i26Fwa/8ldeXYUNfbfqwAJdWP+8jXBcO4/TgcRqm
         PbMiRQSWUdy+M0hdawocFzFhBmSeEM32EsdQj9XPzWhvEaJX7MuURc8bvqkxxwpfU7s6
         EWs6K74Z/UHi4HGQdGWvLaAfq0pVsTM5ZXXnJTYtXfgBV2hIPMzFHuiG972SIUecLJJH
         /POPgLYuR4b3dz/dNgX3vq9ZJphmw8y5Xr0qxtf0x2onZ5zz6EoLCd5wWySwoM3g1Kvs
         4aGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jyINK+TDVic+IRvjORy4aBaqtG/tLl1lQ1zuvAarZwA=;
        b=Isw5tNASRCpBf4tE2TVa8Y6OPDihWcXZIUg+maMSbVaRQdL+nPjP519BsZ+h2PQ3Qa
         4X2EB21nZ4bip1kBI+lkbPLq0/lJOdJhW9mtmaBb06nwbZg1KrsBVViRu8itjz6fm5bP
         aNbpLS7K63NGZTmMfUUxQ5C3yh2mReA3z6v6vWLQzxA+GWMb7LDrhnKFZOHe49ba9Nxx
         KjTw/OuQstUgUZv8WSIowoXuviOzYc5qTEmYgrqv81pH/l2CCFXPfKhPwxwL2U80j4On
         CHHAp0dwQ3qmDkWrW0k3sKA7qPkipyeXaXZTlEodI+WwgvjY9a3ZjSRshnJDRDSG19wQ
         P/sg==
X-Gm-Message-State: APjAAAXfZ6lXM4/Rveas+gDGj42Q1WozvQGrGgW9iG0DqXXOVLRUQZio
        JYO2Y4pvV2DbpfVzY/tjJdst+Q==
X-Google-Smtp-Source: APXvYqxnjr32FG9btnX00+22PJePJV6/JODsIemqH0uJ4sciTPY6jv6bwjfdzJjrr0d6EQNpYe4lxQ==
X-Received: by 2002:a1c:8094:: with SMTP id b142mr13735363wmd.110.1565417190169;
        Fri, 09 Aug 2019 23:06:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y18sm7767740wmi.23.2019.08.09.23.06.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 23:06:29 -0700 (PDT)
Date:   Sat, 10 Aug 2019 08:06:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] netdevsim: register couple of devlink params
Message-ID: <20190810060628.GB2344@nanopsycho.orion>
References: <20190809110512.31779-1-jiri@resnulli.us>
 <20190809142635.52a6275d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809142635.52a6275d@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 09, 2019 at 11:26:35PM CEST, jakub.kicinski@netronome.com wrote:
>On Fri,  9 Aug 2019 13:05:12 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Register couple of devlink params, one generic, one driver-specific.
>> Make the values available over debugfs.
>> 
>> Example:
>> $ echo "111" > /sys/bus/netdevsim/new_device
>> $ devlink dev param
>> netdevsim/netdevsim111:
>>   name max_macs type generic
>>     values:
>>       cmode driverinit value 32
>>   name test1 type driver-specific
>>     values:
>>       cmode driverinit value true
>> $ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
>> 32
>> $ cat /sys/kernel/debug/netdevsim/netdevsim111/test1
>> Y
>> $ devlink dev param set netdevsim/netdevsim111 name max_macs cmode driverinit value 16
>> $ devlink dev param set netdevsim/netdevsim111 name test1 cmode driverinit value false
>> $ devlink dev reload netdevsim/netdevsim111
>> $ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
>> 16
>> $ cat /sys/kernel/debug/netdevsim/netdevsim111/test1
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>The netdevsim patch looks good, what's the plan for tests?

I have this and a follow-up regions implementation for testing purposes
(netns notificatiosn). I will also need this for syzkaller. Selftest I
have scheduled right after.

>
>We don't need much perhaps what you have in the commit message 
>as a script which can be run by automated bots would be sufficient?

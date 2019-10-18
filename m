Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AD7DCFBF
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443228AbfJRUI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:08:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33075 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439837AbfJRUI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:08:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id r17so10058326wme.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 13:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f1An2DVQvnRVXiVDOOlQqsQ2gSVf2noTv+k9fm1aq78=;
        b=NN5itqDENpflIm0bdqfZFXfUNVvQVf7506e05vkRiGCHGP6Bt3JS4gY+N//SqxKYe9
         hkEIDLBjarUTn6Z/wE1pkpK+Ho2V3lG7iIyuCWsOn68Y58bEbri4fMyFb60bO0vxstXG
         my19ckFxvbf6PvFVACbVDVx93dqiUlA0doQrnnAhfXVvbDzarsP8f/LhlLuk8XEcqFrE
         YfCPbC+1sPwxa5h+y3rKwfdrrO6G9qeMxXx8AH7TOsxCBQBBR5m8dMwIVtjLk3uiHegK
         fx8n1jYOGNsyD4rY9B0xfDIiOKC6D7YKLwQwxpeg0OeiJXbyX30PaovpjfTzhGv57dqi
         QEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f1An2DVQvnRVXiVDOOlQqsQ2gSVf2noTv+k9fm1aq78=;
        b=nHqkEk3MPw/EXslB5frl6dm/QmB45L4G58FjZjx+8pmsf1F7dwxDKewfBsA3aLb8p9
         NGuY+9YTGOtyUBC0WyiHgUN2idMv87O9zVXh8RgR+pNre0xx6Uhh5RPma2QEHxn3aOC5
         dadQdNaQDB+zBOMQdVD42bqe8Bk65lh3tEBi46eT/17fbFl7KXacUIx8bEQ/c8BrIYPS
         yC4YKt5LgJJAr79DBtbAFj0/4SKgrIGg7nRcU6XhTyxIfABABKLfdcRZPSr+fwAt/lv8
         ESUoQ7iCgzGKz19P9Ygn7qBOxjg2xgySwWcJ9x7t7W6g/aF/a6m/Wzs+uEwzQaBOvSix
         MDcg==
X-Gm-Message-State: APjAAAVRtlIB1XNGklLXrwi1tzY9kVMXggubDexEzmCp5FrVv1RBn/1m
        AzJjHiD15fxnxJSlVa+AO8TJMQ==
X-Google-Smtp-Source: APXvYqwZtGByAiePp+dyxe9Kv5Dn1CEF5OP4+5pdq/ME/QylEYsH5sT2FLNvGDWEOi1uzTovvnMPgA==
X-Received: by 2002:a1c:3b42:: with SMTP id i63mr8465733wma.37.1571429303553;
        Fri, 18 Oct 2019 13:08:23 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id u68sm7895377wmu.12.2019.10.18.13.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 13:08:23 -0700 (PDT)
Date:   Fri, 18 Oct 2019 22:08:22 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018200822.GI2185@nanopsycho>
References: <20191018160726.18901-1-jiri@resnulli.us>
 <20191018174304.GE24810@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018174304.GE24810@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 18, 2019 at 07:43:04PM CEST, andrew@lunn.ch wrote:
>On Fri, Oct 18, 2019 at 06:07:26PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Currently, the name format is not required by the code, however it is
>> required during patch review. All params added until now are in-lined
>> with the following format:
>> 1) lowercase characters, digits and underscored are allowed
>> 2) underscore is neither at the beginning nor at the end and
>>    there is no more than one in a row.
>> 
>> Add checker to the code to require this format from drivers and warn if
>> they don't follow.
>
>Hi Jiri
>
>Could you add a reference to where these requirements are derived
>from. What can go wrong if they are ignored? I assume it is something

Well, no reference. All existing params, both generic and driver
specific are following this format. I just wanted to make that required
so all params are looking similar.


>to do with sysfs?

No, why would you think so?


>
>      Andrew

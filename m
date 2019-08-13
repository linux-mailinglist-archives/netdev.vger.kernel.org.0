Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226338AF37
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfHMGIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:08:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46617 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfHMGIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:08:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so106603272wru.13
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mQsq4H+//b9wU+lb5DASh+OnezUpGbeyiGEone08Xms=;
        b=AtVRwidAI8vkkcPj/fd5k/BtJSaToHD2uMnIOunh4RJIuhz9NFp9cM7OWGoYXszayv
         7ffzjNjO2BelYXEGDGPC7lBNe3Zc5a6lh+NtI3VP2CQDkkmK3TTvDmECwehYxsLmDRlK
         0HKmTyrDuFBj9OH3IrkQZf3KIy6W51zeR19S1P/TA+KgNvM0x/+bfbs7ieEkUDA5MORM
         6zp6GYqYde5phbEdmFNkR3nc8mKoFCdqOTmiHjEGFJRDq/w/wYZ4L/jTccfT2aanZeau
         fSEKli8CLWUgtErrwKzkuWT6DL+43FcTRUlHmSIqFrnfcPBX2N8ZRsvTtWUm6SBGeg7x
         20Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mQsq4H+//b9wU+lb5DASh+OnezUpGbeyiGEone08Xms=;
        b=OCU1OGMw5bXQVUvVDiN/JLkJjBbhxqrUJYoShTG1ahqjQMEEauobz0/8Lpi9mTjqnK
         rqByRmeSvmwiop3+/IfX3fRniyD8FjFcYEYelBZI5XIT/6JkD6c0icybwOqTJuNoOlJ/
         bckjBAopGO/Pv0BwUkHpiB4bV9oTs3h4dSuSZpoBSUSgBnE1qymrpgTLl3lHZUi2mFp/
         CycvQpaeRt7YnxjtsBgvpOW4/UJpAA7Rx5HhtyXB5f91+SJp1vksbMwDBXSyIUyCmUTf
         o5vF8UAgZoFCKNCwAKopI0cVfajKB3Tlkg8SQ0TZPABuq5QIAxH0mB55FzyXDZEGNhuu
         bblw==
X-Gm-Message-State: APjAAAVltMyTRNC8uPRn6zK+wEvsb7dHwUfke+B5riC4w07sM/eUToiY
        0S3rAfR0qX+5k8Cw7Jk0ZXu74A==
X-Google-Smtp-Source: APXvYqz6u4mrkkeQc6HdR0TKPPD6js8YGnR4RMeywLwwS9oVaL6tb4FsYQvqDVZq9006puwn9170mw==
X-Received: by 2002:a5d:5183:: with SMTP id k3mr41283481wrv.270.1565676479110;
        Mon, 12 Aug 2019 23:07:59 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id 39sm19180737wrc.45.2019.08.12.23.07.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:07:58 -0700 (PDT)
Date:   Tue, 13 Aug 2019 08:07:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190813060758.GD2428@nanopsycho>
References: <20190812134751.30838-1-jiri@resnulli.us>
 <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
 <20190812181100.1cfd8b9d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812181100.1cfd8b9d@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 03:11:00AM CEST, jakub.kicinski@netronome.com wrote:
>On Mon, 12 Aug 2019 18:24:41 -0600, David Ahern wrote:
>> On 8/12/19 7:47 AM, Jiri Pirko wrote:
>> > From: Jiri Pirko <jiri@mellanox.com>
>> > 
>> > Devlink from the beginning counts with network namespaces, but the
>> > instances has been fixed to init_net. The first patch allows user
>> > to move existing devlink instances into namespaces:
>> > 
>> > $ devlink dev
>> > netdevsim/netdevsim1
>> > $ ip netns add ns1
>> > $ devlink dev set netdevsim/netdevsim1 netns ns1
>> > $ devlink -N ns1 dev
>> > netdevsim/netdevsim1
>> > 
>> > The last patch allows user to create new netdevsim instance directly
>> > inside network namespace of a caller.  
>> 
>> The namespace behavior seems odd to me. If devlink instance is created
>> in a namespace and never moved, it should die with the namespace. With
>> this patch set, devlink instance and its ports are moved to init_net on
>> namespace delete.
>
>If the devlink instance just disappeared - that'd be a very very strange
>thing. Only software objects disappear with the namespace. 
>Netdevices without ->rtnl_link_ops go back to init_net.

Agreed. It makes sense to be moved to init_net.

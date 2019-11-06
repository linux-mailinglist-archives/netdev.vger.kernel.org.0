Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6372AF10F1
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfKFIUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:20:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38451 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfKFIUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:20:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id j15so3941698wrw.5
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 00:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M2e8RdzynAsdLA2G2Rg82W5oTcd29FupGWwhc/rt8JA=;
        b=em10wzBijTFxtj3TlbfCGBT62SEqjECK6HM0qOgmC/kqgBnflbBIFXsHtCLv7vr95i
         vxUOlRMQCcOnt/A2PlPpKxka4/muA5XXLcYsgZaIDoBrLbij4tyr9kaV5QPMLlz2+sPx
         ADCS4HVrc0Q0HG42j0FcCgzbu1ZnpKIxhoLCSV026gijBao4v5sV1z9v49GS8NpBGRSI
         hDgQ2AvEaY++YcVqr+ZCSMPh/GzqpDjmu5AKlkWRGYM0/QfOwsRcdZ+c8kscvDCFWa6j
         rTH8kex9IroHpdHpF5FqNp+US/NI+1c2oTRrgQcz79M6uR5uzuoP5SBBtMvcyybfTzz7
         UdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M2e8RdzynAsdLA2G2Rg82W5oTcd29FupGWwhc/rt8JA=;
        b=loI+iuWIliholLf315zHg2TCx3PTgBTT1lPQU60KNh29fe9vmnwJwceq28dE90CUpd
         ljq553B0kQ6yUPvTcYw4e411Kk0csI3+YjSs9endUeggqwmbpNvObINKh+KFWQU3Aksv
         XhdqDCzD/bWL6hLm052ZSsETCNfC1Ip4UBtE9+aqHs5QW8jlxnEOyb6fc/nlNFIhZkC5
         2RgfDtoIOTZ4AkMW+9hkpIvXTrZ3Du6FYMwnskLKcef5FLmlxCjGvE5PT6cHTTQ+rAcC
         2vKLTLjqJJBjot5CjCtrH0Sk6dSZ/6fz5mMWKZAI9Fu76N03I3F864sMLc2UE3vgmRXI
         g4OA==
X-Gm-Message-State: APjAAAVPaWXV3LjqpKw4AP6+JLCKs3RlnGBm41JaBmWkK9kxOhjkEHYL
        CpsDWhoEmE/+GsSeUmlUDiRnxQ==
X-Google-Smtp-Source: APXvYqyvAnLpPBzQ8kiHqEGfwheU/5sJyARjRjyYNf8BUVpKDe9zjMveJbGrbtd7jF924jNp1cDeag==
X-Received: by 2002:adf:dc06:: with SMTP id t6mr1446619wri.378.1573028440234;
        Wed, 06 Nov 2019 00:20:40 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id t24sm35365512wra.55.2019.11.06.00.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 00:20:39 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:20:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191106082039.GB2112@nanopsycho>
References: <20191103083554.6317-1-idosch@idosch.org>
 <20191104123954.538d4574@cakuba.netronome.com>
 <20191104210450.GA10713@splinter>
 <20191104144419.46e304a9@cakuba.netronome.com>
 <20191104232036.GA12725@splinter>
 <20191104153342.36891db7@cakuba.netronome.com>
 <20191105074650.GA14631@splinter>
 <20191105095448.1fbc25a5@cakuba.netronome.com>
 <20191105204826.GA15513@splinter>
 <20191105134858.5d0ffc14@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105134858.5d0ffc14@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 10:48:58PM CET, jakub.kicinski@netronome.com wrote:
>On Tue, 5 Nov 2019 22:48:26 +0200, Ido Schimmel wrote:
>> On Tue, Nov 05, 2019 at 09:54:48AM -0800, Jakub Kicinski wrote:
>> > Hm, the firmware has no log that it keeps? Surely FW runs a lot of
>> > periodic jobs etc which may encounter some error conditions, how do 
>> > you deal with those?  
>> 
>> There are intrusive out-of-tree modules that can get this information.
>> It's currently not possible to retrieve this information from the
>> driver. We try to move away from such methods, but it can't happen
>> overnight. This set and the work done in the firmware team to add this
>> new TLV is one step towards that goal.
>> 
>> > Bottom line is I don't like when data from FW is just blindly passed
>> > to user space.  
>> 
>> The same information will be passed to user space regardless if you use
>> ethtool / devlink / printk.
>
>Sure, but the additional hoop to jump through makes it clear that this
>is discouraged and it keeps clear separation between the Linux
>interfaces and proprietary custom FW.. "stuff".

Hmm, let me try to understand. So you basically have problem with
passing random FW generated data and putting it to user (via dmesg,
extack). However, ethtool dump is fine. Devlink health reporter is also
fine.

That is completely sufficient for async events/errors.
However in this case, we have MSG sent to fw which generates an ERROR
and this error is sent from FW back, as a reaction to this particular
message.

What do you suggest we should use in order to maintain the MSG-ERROR
pairing? Perhaps a separate devlink health reporter just for this?

What do you think?


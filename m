Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB57E6EE31
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 09:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfGTHWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 03:22:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34095 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfGTHWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 03:22:53 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so34324277wrm.1
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 00:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xQVCSlmvcz1k0Ol5F7B5psuIfaaSTcTcL+HgCCocGFU=;
        b=Y2a+88VoS+cdMsvB/R+xl6Vk0ihiA8m2Ec00OlP4uKgdF39uzGDOY0jwmcV+iO8+v9
         mVdR0cOplBf7+083sJHzH4TU89rBpgmkmr6oPENF4piDxp3NMBNHUSUVMdQ0W1+UVP6q
         p/63kny4MYM8nsdnFXCo7EZDnkkP3gPtJ42Il8Gj9wyCjRYsiWumi0oUUBZ253yeiV/S
         AjF2PMS9kkibGs2XJiqGumQR69p4I7vs45lwVjIMnDKC/pRBoxNTWNdNCmAQWh4vd4Bv
         gbGv7jV+SelRcNDF6NLROq6UXKkIJ5hMveHagAUGOqFfAhX7r4zGX3pENEw/FYZigyzB
         R31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xQVCSlmvcz1k0Ol5F7B5psuIfaaSTcTcL+HgCCocGFU=;
        b=uKFuF0xzJftuwtw02WdWHa0EVLC0aVJwRSOMqfyHDtB+s/EvVswLlCvpFKcYrQjlTt
         KyG7EPvWgOhjlwDCAwz1ZtI5moalvY/uTir96L25q652ufqo6JI2Uq5uF+x2Vb43DVlX
         bI0kZRIrduGmAI5n2j8Ez7IPqzEy5Mq+CvV21KQvc5y5E2oejP5PcIh1ROwgOCS6bx64
         3iG50fD/j7ZEivJTwSdedtsHNYbvclNdTwAS82qQ6NXLHKP8WGbkm5bGxPsxjv86RSqw
         bhVf9oSUzhozMWYgbzgW3mF9j6RcYRUTWFbFNApgSTTeco4rfkWL036N2s/hTCPCTwDd
         JIaA==
X-Gm-Message-State: APjAAAVI+1GdVgLnCoynpYVnFmhTSsSx9guRDBBIaXJhhbVp/G3H7Ep1
        zCo+LWZWbHBLsmkALvtxMx8=
X-Google-Smtp-Source: APXvYqzSToAOfNvAViP6KW7IM92y4Hs+PdguNiWRHjVTB/3x4Wy+a29imONoMC2naWV2zYNwPpqIJA==
X-Received: by 2002:adf:dd01:: with SMTP id a1mr59256664wrm.12.1563607371660;
        Sat, 20 Jul 2019 00:22:51 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id z25sm37301323wmf.38.2019.07.20.00.22.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 20 Jul 2019 00:22:51 -0700 (PDT)
Date:   Sat, 20 Jul 2019 09:22:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 7/7] net: rtnetlink: add possibility to use
 alternative names as message handle
Message-ID: <20190720072250.GJ2230@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-8-jiri@resnulli.us>
 <20190719205927.6638187f@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719205927.6638187f@cakuba>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 20, 2019 at 05:59:27AM CEST, jakub.kicinski@netronome.com wrote:
>On Fri, 19 Jul 2019 13:00:29 +0200, Jiri Pirko wrote:
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 1fa30d514e3f..68ad12a7fc4d 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -1793,6 +1793,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>>  	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
>>  	[IFLA_ALT_IFNAME_MOD]	= { .type = NLA_STRING,
>>  				    .len = ALTIFNAMSIZ - 1 },
>> +	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
>> +				    .len = ALTIFNAMSIZ - 1 },
>
>What's the disadvantage of just letting IFLA_IFNAME to get longer 
>on input? Is it just that the handling would be asymmetrical?

Hmm, that might work. But the problem is that sometimes the IFLA_IFNAME
is used as a handle, but sometimes it is used to carry the ifname
(newlink, changename). That might be a bit confusing and the code would
be harder to follow. I don't know...


>
>>  };
>>  
>>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
>

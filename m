Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D533F442F32
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhKBNrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBNrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:47:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B35C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 06:44:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 5so75136218edw.7
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 06:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UyxcWM+XsO0wDlrEivm2pjFkpldoq4vEJ8lBctwydME=;
        b=qP1ZKrhuPY8ZPnHOaV2NsLfE79sMOoVzjyzH5vq7vhiSB7i8RWJynNRq/jxT1d+5ye
         Q+cWmanwit4P/nFxoxKjubfqnJFbJ7Opdq1K1UKtwrmw50p15kiiMAXtuCYKBkmmFuPQ
         RnymQYGI3Zr4lCreweI8odI4z0Mf2O/PZ98CxeXjBLvTRHfvUg4LyVsZvtN1tBQi3eAn
         uz4yYHuRTGtNhLTaVQWCfrruEDkcfeHAEZ2R2rQx3/kjnxzaaPo66sRndS+b7IqhM7C/
         qVUkrA5IXEGBO2/KKCppz4Sc9k5DhL91f41wC8AuKct+1wZYSrVrm2yP12pm3Xb2zSSg
         m1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UyxcWM+XsO0wDlrEivm2pjFkpldoq4vEJ8lBctwydME=;
        b=su5ViPTlwkmqFrKsVr0FmYnbbEhnYF0mFVfe2fD7vBt79cFh73Vmo659T5kHqcjbiO
         Lohf8KZY5GUv88xI6riORfH64qvnWNiaGN9qOuBcEu+ZHw4TrzvQs8kGTq/LDQ3/rTCi
         uddTedTK4eZIfHAGidskj+/E3dCCOdqBgOg8fkkhKqgWXYYeMEfNupTT1SM8/GdFEKPa
         uGwwIDi1luJwaNM0m6eMa5+JrPHyBZoZYaEthXUADlmHJ39sf5cu10woLY/JCnVc/dkr
         EIua0NXYdwbDHrY7Hv743Cz9hve1l5woEvY6OUcfXVIpyxl+baRAWqDZSI5/z+iJM5S0
         RZMQ==
X-Gm-Message-State: AOAM531z60+NOBSVm8ZVom/uO6nq8MVz+5o47Jm4Xm8hrNsx8eMPihZT
        hJM4EjQ1T8XhemEdwJr8ULgm7A==
X-Google-Smtp-Source: ABdhPJxmPbBIKBn2Mmz/wfuItkOg7RIy/+WFEg1WJLmfda2FFjotIf3cBoCN5h0/UNYCLhEbiVYECA==
X-Received: by 2002:aa7:d494:: with SMTP id b20mr9351566edr.243.1635860683728;
        Tue, 02 Nov 2021 06:44:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h7sm10469530edt.37.2021.11.02.06.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 06:44:43 -0700 (PDT)
Date:   Tue, 2 Nov 2021 14:44:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] Code movement to br_switchdev.c
Message-ID: <YYFAynr/Q3iQlK8B@nanopsycho>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <YYACSc+qv2jMzg/B@nanopsycho>
 <20211102111159.f5rxiqxnramrnerh@skbuf>
 <YYEl4QS6iYSJtzJP@nanopsycho>
 <20211102120206.ak2j7dnhx6clvd46@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102120206.ak2j7dnhx6clvd46@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 02, 2021 at 01:02:06PM CET, vladimir.oltean@nxp.com wrote:
>On Tue, Nov 02, 2021 at 12:49:53PM +0100, Jiri Pirko wrote:
>> Tue, Nov 02, 2021 at 12:11:59PM CET, vladimir.oltean@nxp.com wrote:
>> >On Mon, Nov 01, 2021 at 04:05:45PM +0100, Jiri Pirko wrote:
>> >> Wed, Oct 27, 2021 at 06:21:14PM CEST, vladimir.oltean@nxp.com wrote:
>> >> >This is one more refactoring patch set for the Linux bridge, where more
>> >> >logic that is specific to switchdev is moved into br_switchdev.c, which
>> >> >is compiled out when CONFIG_NET_SWITCHDEV is disabled.
>> >> 
>> >> Looks good.
>> >> 
>> >> While you are at it, don't you plan to also move switchdev.c into
>> >> br_switchdev.c and eventually rename to br_offload.c ?
>> >> 
>> >> Switchdev is about bridge offloading only anyway.
>> >
>> >You mean I should effectively make switchdev part of the bridge?
>> 
>> Yes.
>
>Ok, have you actually seen the commit message linked below? Basically it
>says that there are drivers that depend on switchdev.c being this
>neutral third party, forwarding events on notifier chains back and forth
>between the bridge and the drivers. If we make switchdev.c part of the
>bridge, then drivers can no longer be compiled without bridge support.
>Currently br_switchdev.c is compiled as follows:
>
>bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
>
>whereas switchdev.c is compiled as follows:
>
>obj-y += switchdev.o
>
>So to rephrase the question: unless you're suggesting that I should
>build br_switchdev.o as part of obj-$(CONFIG_NET_SWITCHDEV) instead of
>bridge-$(CONFIG_NET_SWITCHDEV), then what do we do with the drivers that
>assume that the switchdev functions they call into are present when the
>bridge is not compiled, or is compiled as module?

It can work similarly as VLAN. It also has "vlan core" which is always
in for drivers, however VLAN driver itself does not have to be.


>
>> >See commit 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload}
>> >loosely coupled with the bridge").

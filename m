Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3472FCCDF
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 09:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731055AbhATIju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 03:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730950AbhATIi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 03:38:26 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D638FC061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 00:37:41 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id d22so13731305edy.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 00:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fGwWyoZ6uw1dLSKn5TwP9i2VrdlNGJCttlkO5TbGx0s=;
        b=lwkSL88MGLsBOcQR9G60cTzR4f6KDBqzi61G1i9qJ7dR5G54wa++6cjclce5jLilQ8
         xPWFiJ16W0CVWf26KL0HtJh4rAXMAxACKqo3Lxx8LPw0s9pOVEoMRvaH6qwIrrQIt4yJ
         DY/irS0dFfIN/hbc6SRZCiPEo2dD1i+jbFQBGxeyy07xDqTJLkA3ELJK3sL+GGjzyxdA
         f4ATFM/3aiMHNaFy2x3EqEuSRVKdYHXpaKJMT0pagvQKbSm9sbo6OezNzhkD7R3fl1RU
         LP9aVeBO3qBJRvm2gPbwxCyd+fIzEp7S7ccvH52jXy8ClPERFecfEueQ1ZjygD6fqQN7
         zdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fGwWyoZ6uw1dLSKn5TwP9i2VrdlNGJCttlkO5TbGx0s=;
        b=AwIAsarhYSaQF8ILSBVmIAqvPWQp3e9BBebl9AOsxl2zEwnzWPaRLSoBQDIS6Odlnd
         1YELD8ssazRuWmbzezfKt04W8jz7F16ky5w8HPPFofkBew3SaRCpfG/PQk+cU/CqZ086
         LbzXlLJ4Z9scu9SEn8arW6jQlxlLW6X3mqcYnFcZIeN67BTT2y+GOc8k5FwGksivcqRa
         MXWnaNSWauJmEHSQBitSNUZE098lzqDT6wjWxOnq+JmUpK54Ev273wX7+uf+Ci9ktpP9
         jI7n9Vh+LH5gKfvkgAMSPde8GkJh/2NO4sAVakT4sd08/tFrxOoZ+TQtagFWfFsnClz9
         ZMcQ==
X-Gm-Message-State: AOAM530XxCa6JD7rp++uJ0N+E7quJuMxjKwsOncyd2RRQp/oAw5bJJOr
        97yz4VX3RcfVmQn9tvS+9A4b5A==
X-Google-Smtp-Source: ABdhPJzU9EOzhoehuDFKemUitfo16+XWu4X9bne9cijl7Tt9AvN393BGShdeRSB+EVGu0r+d68Qwag==
X-Received: by 2002:a05:6402:212:: with SMTP id t18mr6499815edv.37.1611131860686;
        Wed, 20 Jan 2021 00:37:40 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id j23sm560568ejs.112.2021.01.20.00.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 00:37:39 -0800 (PST)
Date:   Wed, 20 Jan 2021 09:37:38 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210120083738.GC3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <42b4c13b-7605-948e-a68c-dcb568680988@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42b4c13b-7605-948e-a68c-dcb568680988@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 19, 2021 at 05:23:19PM CET, dsahern@gmail.com wrote:
>On 1/19/21 4:56 AM, Jiri Pirko wrote:
>> Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
>>>> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
>>>> $ devlink lc
>>>> netdevsim/netdevsim10:
>>>>   lc 0 state provisioned type card4ports
>>>>     supported_types:
>>>>        card1port card2ports card4ports
>>>>   lc 1 state unprovisioned
>>>>     supported_types:
>>>>        card1port card2ports card4ports
>>>
>>> Hi Jiri
>>>
>>>> # Now activate the line card using debugfs. That emulates plug-in event
>>>> # on real hardware:
>>>> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>>>> $ ip link show eni10nl0p1
>>>> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>>>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>>>> # The carrier is UP now.
>>>
>>> What is missing from the devlink lc view is what line card is actually
>>> in the slot. Say if i provision for a card4port, but actually insert a
>>> card2port. It would be nice to have something like:
>> 
>> I checked, our hw does not support that. Only provides info that
>> linecard activation was/wasn't successful.
>> 
>
>There is no way for the supervisor / management card to probe and see
>what card is actually inserted in a given slot? That seems like a
>serious design deficiency. What about some agent running on the line
>card talking to an agent on the supervisor to provide that information?

The ASIC does not have this info. The linecard type is exposed over i2c
interface, different driver sits on top of it.
I agree it is odd, but that is how it is for our hw, unfortunatelly.

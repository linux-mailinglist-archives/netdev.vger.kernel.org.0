Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED33D4053
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhGWRza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWRz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:55:29 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA405C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:36:02 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:90af:18a5:3772:6653] (unknown [IPv6:2600:8801:8800:12e8:90af:18a5:3772:6653])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 6DE562036B;
        Fri, 23 Jul 2021 11:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627065361;
        bh=6UUFi8FyLt+it19RVXGykEoJblJT1xUJEU4BGRoZ2kY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FnqpaRlvhfXDG9yoN5HP4zRie2sdW4NzrdGkNQebjJKHb1+X8fnbSUUi2xyDd8W9M
         YTgRiIwgy4EnW6bqddxBU4Pr36roZMFVGrKpFID5ziBpnERRoVNcCT8sPrrCo0+4xz
         o+bpDjLhuhejeaMJ3ehPsoCqLnDfy1ZVfz7VcqKk=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch> <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
Date:   Fri, 23 Jul 2021 11:36:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPsJnLCKVzEUV5cb@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/21 11:25 AM, Andrew Lunn wrote:
>>> You probably don't want both ends of the link in rgmii-id mode. That
>>> will give you twice the delay.
>>
>> Ok, I'll change phy-mode to "rgmii" for both ends. It's a little confusing
>> that there's a reference to phy-mode at all, though, given the actual
>> connection is SERDES. My understanding is SERDES is a digital, PHY-less
>> connection.
> 
> Is it even RGMII? You say SERDES, so 1000BaseX seems more likely.
> 
>     Andrew
> 

Ah, I see, good point. I'll use "1000base-x" instead.

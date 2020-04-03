Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6619DC62
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390849AbgDCRIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 13:08:18 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:41448 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbgDCRIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 13:08:18 -0400
Received: from [192.168.254.4] (unknown [50.34.219.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 9748C13C377;
        Fri,  3 Apr 2020 10:08:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 9748C13C377
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1585933697;
        bh=vXjSse61YM7LEVf9nGrOGe7M1dfPgEH0OAV3L6rr8WU=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=kBK0NeTkDXwNM3KXVnObUSl2tvBAyg5eT34IBZnbQUAxttB6SZgu+eX6YaeHmbCI/
         1AK2i5ah60l+xpUJhXuV8TgOmom4vsceT8986TASAJ0GzaqjT1LJv8SkXmUERH2/fN
         v3ZJgD8lj0GrPkveT818dqW0iVo9BkZr89qKUVXI=
Subject: Re: restarting efforts on AQL on intel wifi, at least?
To:     Dave Taht <dave.taht@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Johannes Berg <johannes@sipsolutions.net>
References: <CAA93jw6cX48oAE=KrYOMUx_jY0zBpPc+Vg-b+7aYa7+7KRsOPA@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <14f57458-a1d4-632d-7380-3c08e520f061@candelatech.com>
Date:   Fri, 3 Apr 2020 10:08:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAA93jw6cX48oAE=KrYOMUx_jY0zBpPc+Vg-b+7aYa7+7KRsOPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/03/2020 09:56 AM, Dave Taht wrote:
> the AQL patches for the ath10k finally landed in openwrt head, and were lovely:
>
> https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/
>
> When I last looked the attempt to get at least some intel wifi chips
> working with AQL had stalled out with
> a variety of other problems. I've been sitting on a bunch of ax200
> chips, and am feeling inspired to tackle those.

Hello Dave,

What features does a driver need to support AQL?  The 'patch' to enable
it in ath10k-ct was just to enable a feature flag, so the underlying
features must have gone in earlier?

Thanks,
Ben

>
> Any news on other chips like the ath11k?
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB072898CE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfHLIgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:36:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56172 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbfHLIgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:36:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so11331541wmf.5
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 01:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vmjw61td7/exIS64/GdDB+llM7txyd59zWSFdqtiJsk=;
        b=GA/wYuzoUrb9pHfYZoFmhqvn8JtTCUQBVMLeRJvL3QQjY+dXkiG//ezf+HDTrXeqn1
         hTd9CkiRJPbfbbqtzE9jUINbIVQLaSCHsY24c7a4fnDDm2JenkIiJaJ/XosFiFkxPWRq
         mhtGpyQzPbAEu2sQQ/DMH/UdNhbBVizTees+edLwnSdRpBoIh8J9UlwB4uhn0DzwXyZm
         3FoYYoElhpfnK4hZ+6Ke01GMou95H/6918V+Du5R8+tmo4nR634WZAe7IEzgGMmjbedj
         7GfuLB+e9NQB1TJ/v/4WuUzVqBx19nfQJzmOK06GPTXGjq2C1vrDZxu5BGbVqzd7idtv
         Kzkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vmjw61td7/exIS64/GdDB+llM7txyd59zWSFdqtiJsk=;
        b=N/OSt0yafefQJNcmnMf819WwHxCeDrUtWsIqnMX+FoBaOWrFd8Dadwd0PlQEi6qNgC
         YX7PLwb3dK7plISQ29QALKZaiQwEYiPglbISgtM4HV1yD+f3YIRSVGHlTWoTfkG/+Sik
         yuMMaW0tS2N22g1472SVaSlCn1JdjmQxaT1zVyG6U6dVCfYBxtzCMoshQjZwGY+cU3XH
         8BYeghOS5Lb9N5XiAjWb36OojAUFKkFTzlri+VPbtk64NvPLspxYNSD7NhRJzahHTfqZ
         VmHM/DfvBP2kWTTMuie8Ltl2YKxUrEs0/ZTF5EYyIbjAoQprmgYvsl9hIcx7FAg37Fsc
         Hcbg==
X-Gm-Message-State: APjAAAUReAf8VJlvsT8M5rZGIID7jkI6E09nX+1OHoKxwbRvbEh6mui0
        ojtH84sNEDQyopVZYHeHEcJZ2g==
X-Google-Smtp-Source: APXvYqwJuar08TwHoOEqlv6xgNozcN/MNrOKJEDHalyEi7JuNqzIZZGxhGQJVDRqI/GTWfDeJhwn8g==
X-Received: by 2002:a05:600c:2c9:: with SMTP id 9mr2593576wmn.79.1565598996245;
        Mon, 12 Aug 2019 01:36:36 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id c8sm1382453wrn.50.2019.08.12.01.36.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 01:36:35 -0700 (PDT)
Date:   Mon, 12 Aug 2019 10:36:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190812083635.GB2428@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190811.210218.1719186095860421886.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811.210218.1719186095860421886.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 12, 2019 at 06:02:18AM CEST, davem@davemloft.net wrote:
>From: David Ahern <dsahern@kernel.org>
>Date: Tue,  6 Aug 2019 12:15:17 -0700
>
>> From: David Ahern <dsahern@gmail.com>
>> 
>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>> tracked fib entries and rules per network namespace. Restore that behavior.
>> 
>> Fixes: 5fc494225c1e ("netdevsim: create devlink instance per netdevsim instance")
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>
>Applied, thanks for bringing this to our attention and fixing it David.
>
>Jiri, I disagree you on every single possible level.
>
>If you didn't like how netdevsim worked in this area the opportunity to do
>something about it was way back when it went in.

Yeah, I expressed my feelings back then. But that didn't help :(


>
>No matter how completely busted or disagreeable an interface is, once we have
>committed it to a release (and in particular people are knowingly using and
>depending upon it) you cannot break it.

I understand it with real devices, but dummy testing device, who's
purpose is just to test API. Why?


>
>It doesn't matter how much you disagree with something, you cannot break it
>when it's out there and actively in use.
>
>Do you have any idea how much stuff I'd like to break because I think the
>design turned out to be completely wrong?  But I can't.

Sure, me too :) But that is for real devices. That is a different story
as I see it. Apparently, I'm wrong...


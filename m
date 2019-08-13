Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672B98C22D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfHMUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:37:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51474 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHMUhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 16:37:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so2689655wma.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 13:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9xLkmOgXutiwDRcw+Jg/Sim8iV2nS/f0Txfoie0Alos=;
        b=J0FqwBL07EdQjfJp9SERgxCAvvovQJC5qutbOk0VCioSzy2xFVu2ToM0Mrc7/z/qMW
         0LpgFjPMkB4yu32Q2n9MdiO4+Ophl75GRc2ubHlWgChZdxjNkHZLOWmWp/W/KqgZuGkA
         0/ze4UoEKjY4qI673hCjlMHHOWsRXObLQO2xMeqGFAoiFRiy1UHFsAKSyByKmxYLcTgb
         I0gMRSyJmG1e9zQALtbszTviBVXnUKVmlyX8X6K80BN5I8zn+ey4g0HaiU2dOgT5BIHt
         88d2g263loo8mAu2NSWvI0PY9j/a9oaoPtYcdj5w/NInAD18GHETUwnHfEdihHNWfJHV
         d++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9xLkmOgXutiwDRcw+Jg/Sim8iV2nS/f0Txfoie0Alos=;
        b=TSWdiowZ9RuHfKSovNBRGoJ5SZCKlCUkEb70ZM6lXnlL7kLNkkQCpElphWxhmnLWsB
         hf7Vaikw6vUuLBWs17oh0cZcnN2xuBEYvGaHsO3ngcdXpBvajcuLGlL5TC0PSnDmeORs
         qzhWmGbo7O8vrP9rygc2VTxYN1ow/QoN4yGUVh5ymrNJz9l4BDhHwhzAVnnII4EwHxr7
         6C7QQ0YK0v9i9ii1S5DMfhvUbSNK5pKRzMyl0hkhyVFOfmv2Ixex2WJEwqZYbyP9WDhf
         K+5EBOwBSClSnBPBONpcu1XBAS48nqAQqzSIFMg76f4uXIgfVR+HxjiCoOlVx7OVEkUn
         nuOg==
X-Gm-Message-State: APjAAAWjjP6+K1KLnBBkfCqcr4aqpKUDegIdKThW7gsTsNWMRQQO9ESR
        UismWRsy7vDlETELeXOvJ2Nk4InL9lw=
X-Google-Smtp-Source: APXvYqyzebVfwhaZPIetKWjPxDAYaztmgSPu13+vDSWH2R5slT8qVCldfaT4QQ4crEX41LlaKOQn2w==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr4838463wmh.156.1565728668636;
        Tue, 13 Aug 2019 13:37:48 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id o16sm27675920wrp.23.2019.08.13.13.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 13:37:48 -0700 (PDT)
Date:   Tue, 13 Aug 2019 22:37:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190813203747.GS2428@nanopsycho>
References: <20190812083635.GB2428@nanopsycho>
 <20190812.082802.570039169834175740.davem@davemloft.net>
 <20190813071445.GL2428@nanopsycho>
 <20190813.104054.140346412563349218.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813.104054.140346412563349218.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 07:40:54PM CEST, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Tue, 13 Aug 2019 09:14:45 +0200
>
>> Mon, Aug 12, 2019 at 05:28:02PM CEST, davem@davemloft.net wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Date: Mon, 12 Aug 2019 10:36:35 +0200
>>>
>>>> I understand it with real devices, but dummy testing device, who's
>>>> purpose is just to test API. Why?
>>>
>>>Because you'll break all of the wonderful testing infrastructure
>>>people like David have created.
>>  
>> Are you referring to selftests? There is no such test there :(
>> But if it would be, could implement the limitations
>> properly (like using cgroups), change the tests and remove this
>> code from netdevsim?
>
>What about older kernels?  Can't you see how illogical this is?

Not really, since this is a dummy testing device. Not like we would
break anybody. Well, I changed instantiation of netdevsim from rtnetlink
to sysfs, that is even bigger breakage, nobody cared (of course).

Well sure we can comeup with netdevsim2, netdevsimN, to maintain backward
compatibility of netdevsim. I find it ridiculous. But anyway, I don't
really care that much. I resign as this seems futile :(

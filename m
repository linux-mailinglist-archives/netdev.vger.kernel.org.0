Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41667A115
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 08:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfG3GHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 02:07:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32886 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfG3GHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 02:07:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so44504346wme.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 23:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=227oliRtOAPsq/JHv/g9s9Ekam0ogxY2V9TU2/5y2Zg=;
        b=vA3kem+rzPk7leee9OPnSrI7HdcslwMHRKCOY9FpSZlzcAAwONUgVmkTivnZeSuD/n
         gfxFlOa4I15lGZLyAh3n/nZVJ7SK0ONoGuqwtSmz8jxydp7LUXoE9pvu01uzx61yteR0
         qwgRfODequyfx3RlLttZ3NXytgs0QjVPqBR1wFuLm0JITCGhmf60lA+UjsKq5O2egNGt
         iPtv+hlBwvQj8yPf2WMD7AiKHKZNn9ZlDY7XX68deeYOFhgpSwxMTBsKnN9kGdvlW1FZ
         JkIPNs8PK4tcOEdzR23UFF8fyCoFYVc6A0OauIY1wENIE1Kf4riFQn35tVN55nL182WJ
         qG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=227oliRtOAPsq/JHv/g9s9Ekam0ogxY2V9TU2/5y2Zg=;
        b=ngNt3s1RCxodCIAJH3DSMmD/4VBdjGRl/x5KA+bhizhTBuGgMVXIdX3NUiHlzDumDX
         WZoogI66v8AzQXfKQZhZ7A89ckqcRx8JjlXR72ioWIZdS6Z7Y5j8jEFu3Y+42IX+SAm8
         GJlKH7XqVjjg6e3WVZdDQw542zGs344G38Miuh3llsw2/yRk3Fs2hYzZ0/+Z+729R/jw
         O9cU9UU/FSOuG09DW+dmZe+TYXa2z6jwqaM6Qjv5BT73Dt5HcGoTfkk3hsQJposvD/0i
         JO/n0GmoEh3+eYFBT9CX5J1nQczOGTpVsWQ/lV33ExH8KXKRii1mJQMraCTmpNJcXtQ4
         kxcA==
X-Gm-Message-State: APjAAAXxNLD1jwMdMWjQQPI2ajnb3rIzowh6lKzDDbDn/9aBBRNLfcLr
        iYaYz0K2Ol5HG5DjKcTqCqw=
X-Google-Smtp-Source: APXvYqz54QHsqMLLamyD2noX5Y8ImfupxggyFz4adiBzPnBGB48dbU7mBcuegR7/Nh6dWZAae/D/kQ==
X-Received: by 2002:a1c:3:: with SMTP id 3mr104138431wma.6.1564466854687;
        Mon, 29 Jul 2019 23:07:34 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f70sm82329226wme.22.2019.07.29.23.07.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 23:07:34 -0700 (PDT)
Date:   Tue, 30 Jul 2019 08:07:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] devlink: introduce cmdline option to switch
 to a different namespace
Message-ID: <20190730060733.GC2312@nanopsycho.orion>
References: <20190727094459.26345-1-jiri@resnulli.us>
 <20190727100544.28649-1-jiri@resnulli.us>
 <87ef2bwztr.fsf@toke.dk>
 <20190727102116.GC2843@nanopsycho>
 <d590ac7b-9dc7-41e2-e411-79ac4654c709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d590ac7b-9dc7-41e2-e411-79ac4654c709@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 10:21:11PM CEST, dsahern@gmail.com wrote:
>On 7/27/19 4:21 AM, Jiri Pirko wrote:
>>>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>>>> index d8197ea3a478..9242cc05ad0c 100644
>>>> --- a/devlink/devlink.c
>>>> +++ b/devlink/devlink.c
>>>> @@ -32,6 +32,7 @@
>>>>  #include "mnlg.h"
>>>>  #include "json_writer.h"
>>>>  #include "utils.h"
>>>> +#include "namespace.h"
>>>>  
>>>>  #define ESWITCH_MODE_LEGACY "legacy"
>>>>  #define ESWITCH_MODE_SWITCHDEV "switchdev"
>>>> @@ -6332,7 +6333,7 @@ static int cmd_health(struct dl *dl)
>>>>  static void help(void)
>>>>  {
>>>>  	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
>>>> -	       "       devlink [ -f[orce] ] -b[atch] filename\n"
>>>> +	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns]
>>>>  netnsname\n"
>>>
>>> 'ip' uses lower-case n for this; why not be consistent?
>> 
>> Because "n" is taken :/
>
>that's really unfortunate. commands within a package should have similar
>syntax and -n/N are backwards between ip/tc and devlink. That's the
>stuff that drives users crazy.

I agree. But this particular ship has sailed :(

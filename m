Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A68BD37
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbfHMPeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 11:34:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37426 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbfHMPeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 11:34:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so6226657wrt.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 08:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1PVukblKVNEnDQumJvQmE/K48s1xxDSVgweBwewTpLM=;
        b=lGday1J/7hcwWpSOk4oDaSvHh3V8zB1nTeTUxvlxOfmHxlA4pPyOOdxvY9YaPk1a7q
         dUwrqgo37q7QtcmMaua8oslwKUR/jRitpLFX9GV5/7ufz2+jz/Mu/0Ihpi289Gu9B+UL
         YuO+APyAnoKiXzsSPUvYRuFG8YmpAuHwbZ3hWTnRKxrFq+5E1HOHrQnOJwnlD3lY1hlO
         v0y4N3s4zG3ILWRWah8e/C61ExsRE+v2gyvStDDNaZzzvqhFMWXAsf+qZ9xk8Z3sbxRG
         hH/CLw/gKzRQiPGqbjMLaqWQ27Fa4QJIsirSMudBtOaO5pKZ9VGcQpjxDpL+UoILsvdN
         xjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1PVukblKVNEnDQumJvQmE/K48s1xxDSVgweBwewTpLM=;
        b=El0oS2TVrfZLAE/Bat7JzOtbj+Rr2ECTuV1A1hu3bH/uIYymVaML2tbGDzsOBKwXWC
         ESNQ4n9IucPx7ym2omhZisqL0/iOwDkKGWwTCu3m698y68310jI7zTqUTwAQWeG/Jrlu
         IvbJkLlx3C9U5zalUIroMm0KmAYpf4lUGMe/ytzv5Xk0DfAlxbayeDEAp+x6iQNghdk4
         HqbWotWuQZiIKqAeGwX8paM1KSqXpZYDFniZIoblntyF2gS1e19hnBf+h/Fkf9jR5PSw
         udDRm9sc3F6YlhE68hhU3JIQ8mAWLvvdLCuv5UOsoRqm+Fw/Q/6WSZEMVohzwngNRnSn
         VQKA==
X-Gm-Message-State: APjAAAXJzibcmV0vjCzRiLye0GFrqmKm26ew18qiwkYwLtxbO6gI2Q/C
        rYn5H/wvNdBNrEgPqUcy1YtNGA==
X-Google-Smtp-Source: APXvYqxZAMJyp6Nr0/TlwCQGugrfW3sUzQzBKgulfQ9KEpORBjRJ18CiQ1Nn5oKOs3ojy8rI0pt91Q==
X-Received: by 2002:a5d:5543:: with SMTP id g3mr1704826wrw.166.1565710442271;
        Tue, 13 Aug 2019 08:34:02 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id g14sm18525749wrb.38.2019.08.13.08.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 08:34:01 -0700 (PDT)
Date:   Tue, 13 Aug 2019 17:34:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, dsahern@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190813153401.GR2428@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190811.210218.1719186095860421886.davem@davemloft.net>
 <20190812083635.GB2428@nanopsycho>
 <20190812.082802.570039169834175740.davem@davemloft.net>
 <20190813071445.GL2428@nanopsycho>
 <9306e893-cd43-75a0-9a81-fd2ee0dd44c5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9306e893-cd43-75a0-9a81-fd2ee0dd44c5@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 04:41:18PM CEST, dsahern@gmail.com wrote:
>On 8/13/19 1:14 AM, Jiri Pirko wrote:
>> Mon, Aug 12, 2019 at 05:28:02PM CEST, davem@davemloft.net wrote:
>>> From: Jiri Pirko <jiri@resnulli.us>
>>> Date: Mon, 12 Aug 2019 10:36:35 +0200
>>>
>>>> I understand it with real devices, but dummy testing device, who's
>>>> purpose is just to test API. Why?
>>>
>>> Because you'll break all of the wonderful testing infrastructure
>>> people like David have created.
>>  
>> Are you referring to selftests? There is no such test there :(
>
>I  have one now and will be submitting it after net merges with net-next.
>
>> But if it would be, could implement the limitations
>> properly (like using cgroups), change the tests and remove this
>> code from netdevsim?
>
>The intent of this code and test is to have a s/w model similar to how
>mlxsw works - responding to notifiers and deciding to reject a change.
>You are currently adding (or trying to) more devlink based s/w tests, so
>you must see the value of netdevsim as a source of testing.

Sure I do. Not sure makes sence to repeat myself again, but why not:
The way you use netdevsim with netnamespace limitation is nothing like
it is done in hardware. Devlink resources should limit the resources of
the device, not network namespace. You abused netdevsim and devlink for
that. Not cool :(

To be in sync with mlxsw, netdevsim should track fibs added to the ports
and apply the resource limitations to that. That is the correct
behaviour. Exacly like mlxsw does.

Frankly I don't really understand why you keep pushing your broken
design. Why the limitation applied only for fibs related to netdevsim
ports is not enough for testing??? Would that work for you? Please?

This is keeping me awake at night. Sigh :(

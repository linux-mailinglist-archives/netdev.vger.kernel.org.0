Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2267CD11
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbfGaTpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:45:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36183 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfGaTpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:45:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id g67so56779848wme.1
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ojNc1Q+rT8RztvuBmHxTHHrH7/4fTX7m36uFDLAscLA=;
        b=wDiKwJY2wu3ouy+/DNUZ+i76JWGOlQAhz/KKDUV85S1dMeA9nBICBzoYJNpbuuuF0d
         8tsXMThlPeTVPp+f0CXs1gHnI+8UyclbXbfy8W6NAV5fOTdFJlcuCzd/fIo//sl2b2Dq
         lJYb1dKBuvqBbyF9jdRcne1JVluC04lyM3ipc67xEJfi/PoLCJoyyg+jsNdk4vfI6a6j
         5KfG4rzPZQgMFGQj0fmnHfouJ7jUa/fjkmiwNWeHoGfJ0KIFPrm3t0uAtHuXJqKqOfHs
         26vgpLB89VKb/Zp5SsBWtyyFkn9yztQOZ4MiJsCkH2AZvB+m3OYIm7XY7GCoO2+CcoK/
         uTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ojNc1Q+rT8RztvuBmHxTHHrH7/4fTX7m36uFDLAscLA=;
        b=roLQOObml6BsTAyL5jMUFCXMhfUbYhmEJQclVRFBbaJfUhn/NsJE61fVgGwwfbR63y
         78vtHVL5t1gbO6ch/sNXoKOzWHVjl47Q7U0f6IsajFlOcy/jWro7SEQWUarYlhgQBO4+
         5cjTXh89nGWLSUpX8q2fjPf3R5vUbSZbpUjfkl6ZlRTqNc/ldnR7b7erhluvn7m80q31
         bgkywtaw5OZ2usOBw6wY2VBLFhaIY8gE+AiVVTskn23zDzWZZcDnTBDzd1YCDxnpzS23
         VF7oR+D1KNEX956CGJNUP8hcT2SjPvV2n2XQ8GGCTXvJ9lE7a7XnUX3dkMtq3h5mxwgx
         /NcA==
X-Gm-Message-State: APjAAAW+B0/uqNs61OLYcKZ3CiC0ffRE5IWJYP8DBCi4sFnVRVmO+DvS
        t/G3d1FyR5cb3SiNH5V45Kw=
X-Google-Smtp-Source: APXvYqwjTiFCOosyojI68E4fMKu3cNFvRBnVkpzjARIw3L1agPedqVZ7+w/k13NNBcbt7ruHgibnhA==
X-Received: by 2002:a1c:f914:: with SMTP id x20mr34812404wmh.142.1564602305179;
        Wed, 31 Jul 2019 12:45:05 -0700 (PDT)
Received: from localhost ([80.82.155.62])
        by smtp.gmail.com with ESMTPSA id b8sm90259501wmh.46.2019.07.31.12.45.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 12:45:04 -0700 (PDT)
Date:   Wed, 31 Jul 2019 21:45:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190731194502.GC2324@nanopsycho>
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 31, 2019 at 09:41:10PM CEST, dsahern@gmail.com wrote:
>On 7/31/19 1:26 PM, Jiri Pirko wrote:
>> Wed, Jul 31, 2019 at 12:39:52AM CEST, jakub.kicinski@netronome.com wrote:
>>> On Tue, 30 Jul 2019 10:57:32 +0200, Jiri Pirko wrote:
>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>
>>>> All devlink instances are created in init_net and stay there for a
>>>> lifetime. Allow user to be able to move devlink instances into
>>>> namespaces.
>>>>
>>>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>>>
>>> I'm no namespace expert, but seems reasonable, so FWIW:
>>>
>>> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>>
>>> If I read things right we will only send the devlink instance
>>> notification to other namespaces when it moves, but not
>>> notifications for sub-objects like ports. Is the expectation 
>>> that the user space dumps the objects it cares about or will
>>> the other notifications be added as needed (or option 3 - I 
>>> misread the code).
>> 
>> You are correct. I plan to take care of the notifications of all objects
>> in the follow-up patchset. But I can do it in this one if needed. Up to
>> you.
>> 
>
>seems like it should be a part of this one. If a devlink instance
>changes namespaces, all of its associated resources should as well.

Okay. Will do.


>
>Also, seems like you are missing a 'can this devlink instance be moved'

I don't see why not.


>check. e.g., what happens if a resource controller has been configured
>for the devlink instance and it is moved to a namespace whose existing
>config exceeds those limits?

It's moved with all the values. The whole instance is moved.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0596B1DE500
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgEVLDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEVLDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:03:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEE3C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 04:03:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so9730956wra.7
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 04:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OfisrLKwQ43NffhIjqAfiYXmPvM3pl/mUC1efR9ITaY=;
        b=rg7Ko2bAg9ui8EHTH2m/W0IVyj1rSTr8D2cc/+atK5VOBxnTuaBNkioxsHk/MXShAD
         SRMfVJsMRxBUcsandvolRCljqem55C6zbb9k144SrGhBeeXNZpNY1nwSxEzwhtA/gDDc
         X4CcE78SPRz3pvyDG5Aecw5dLztWG+5qbot5zSYANfPA0LasvboQzBmNV6BynJMfmigV
         8T7IbON/Gy9rcGubl1r7RJvgUTbqEqvGMMhA96N3y/e8r0/p6+SuhfcaxQQnmV5UVbUI
         +hmC8iRUWJMVooVA2c1WpM2RjV1Wc8NIMeapvjSJLb5YOngIRntd46SXrb6J20ZHKDs1
         gpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OfisrLKwQ43NffhIjqAfiYXmPvM3pl/mUC1efR9ITaY=;
        b=t8jp+fCv4uyIIwRuUnH52IjCCCuj0728lQvuwUxxhXGm9PX59FFKby+4Z+MzZC29gC
         s40fEo6MmeDS+oGFKcDeTsfpTFE6n6/7aPzSshbi4moWrt/2acs0DCZcyfYvWcpindh0
         cevf2sLuDdjTzbFRcpAVcUet6noIKnvSeV77yRFpYKb4JPx+5tZMhpJDo2OJneLlfzlQ
         T+d1auvMoi2rTq0aoo7IfxrbNcQRFrfxUPHD0K+u/r43UvW7LhohQqfIou8V8bv6HUDf
         7pXzz4k7SVrUQy+yc0BExClL0IATrMgeTUUh8pWHyR4i6iMh12wUtdEJn9uIgBK9Dc7g
         rZDA==
X-Gm-Message-State: AOAM530LeX19MUWIOKDsqWHLF5jd7PkgEbIXDsXJrZQRP00z5MkgPwN5
        8F6LVDXb5rHPQVjMOaDZYazovg==
X-Google-Smtp-Source: ABdhPJxjBKBY/7+dSstkm3KP25qJ1UctPN/oozCHmeDpo1gZPlzY9RWT+jRmgj0F2riH8E8iEIJ65g==
X-Received: by 2002:adf:ffc2:: with SMTP id x2mr2869953wrs.273.1590145386398;
        Fri, 22 May 2020 04:03:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v24sm9742804wmh.45.2020.05.22.04.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 04:03:05 -0700 (PDT)
Date:   Fri, 22 May 2020 13:03:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
Subject: Re: devlink interface for asynchronous event/messages from firmware?
Message-ID: <20200522110305.GD2478@nanopsycho>
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
 <20200521205213.GA1093714@splinter>
 <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 21, 2020 at 10:59:32PM CEST, jacob.e.keller@intel.com wrote:
>
>
>On 5/21/2020 1:52 PM, Ido Schimmel wrote:
>> On Thu, May 21, 2020 at 01:22:34PM -0700, Jacob Keller wrote:
>>> On 5/20/2020 5:16 PM, Jakub Kicinski wrote:
>>>> On Wed, 20 May 2020 17:03:02 -0700 Jacob Keller wrote:
>>>>> Hi Jiri, Jakub,
>>>>>
>>>>> I've been asked to investigate using devlink as a mechanism for
>>>>> reporting asynchronous events/messages from firmware including
>>>>> diagnostic messages, etc.
>>>>>
>>>>> Essentially, the ice firmware can report various status or diagnostic
>>>>> messages which are useful for debugging internal behavior. We want to be
>>>>> able to get these messages (and relevant data associated with them) in a
>>>>> format beyond just "dump it to the dmesg buffer and recover it later".
>>>>>
>>>>> It seems like this would be an appropriate use of devlink. I thought
>>>>> maybe this would work with devlink health:
>>>>>
>>>>> i.e. we create a devlink health reporter, and then when firmware sends a
>>>>> message, we use devlink_health_report.
>>>>>
>>>>> But when I dug into this, it doesn't seem like a natural fit. The health
>>>>> reporters expect to see an "error" state, and don't seem to really fit
>>>>> the notion of "log a message from firmware" notion.
>>>>>
>>>>> One of the issues is that the health reporter only keeps one dump, when
>>>>> what we really want is a way to have a monitoring application get the
>>>>> dump and then store its contents.
>>>>>
>>>>> Thoughts on what might make sense for this? It feels like a stretch of
>>>>> the health interface...
>>>>>
>>>>> I mean basically what I am thinking of having is using the devlink_fmsg
>>>>> interface to just send a netlink message that then gets sent over the
>>>>> devlink monitor socket and gets dumped immediately.
>>>>
>>>> Why does user space need a raw firmware interface in the first place?
>>>>
>>>> Examples?
>>>>
>>>
>>> So the ice firmware can optionally send diagnostic debug messages via
>>> its control queue. The current solutions we've used internally
>>> essentially hex-dump the binary contents to the kernel log, and then
>>> these get scraped and converted into a useful format for human consumption.
>>>
>>> I'm not 100% of the format, but I know it's based on a decoding file
>>> that is specific to a given firmware image, and thus attempting to tie
>>> this into the driver is problematic.
>> 
>> You explained how it works, but not why it's needed :)
>
>Well, the reason we want it is to be able to read the debug/diagnostics
>data in order to debug issues that might be related to firmware or
>software mis-use of firmware interfaces.

I think that the health reporter would be able to serve this purpose.
There is an event in firmware-> the event is propagated to the user.

The limitation we have in devlink health right now is that we only store
the last event. So perhaps we need to extend to optionally hold a
list/ring-buffer of events?


>
>By having it be a separate interface rather than trying to scrape from
>the kernel message buffer, it becomes something we can have as a
>possibility for debugging in the field.
>
>> 
>>> There is also a plan to provide a simpler interface for some of the
>>> diagnostic messages where a simple bijection between one code to one
>>> message for a handful of events, like if the link engine can detect a
>>> known reason why it wasn't able to get link. I suppose these could be
>>> translated and immediately printed by the driver without a special
>>> interface.
>> 
>> Petr worked on something similar last year:
>> https://lore.kernel.org/netdev/cover.1552672441.git.petrm@mellanox.com/
>> 
>> Amit is currently working on a new version based on ethtool (netlink).
>> 
>
>I'll take a look, thanks!
>
>-Jake

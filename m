Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12205293523
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404523AbgJTGpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 02:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404517AbgJTGpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 02:45:23 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08631C061755
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 23:45:22 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id b8so704668wrn.0
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 23:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7uYHbFkj0Ily3hsx7yQrc9r89pdawsJ/ONga/fXeJWg=;
        b=cXSstcL/E4jQi2eCU9IssEdlqous5Q2G+aDnyM0iE7q/RLIcU1MvAdR4kNxlucoFFc
         d/zLHUKTWH3aR2CY1D2Qvz/JyjsVKuuEiUJYkIr3yft6eI6CYaQKCACtOLhp82eQTrw6
         1FMNmwyyOJh4mFue3zv//u7sYeRbPAaR9X3trL/YJMw4LOlmdytahFRy0AsZEGpq+iv6
         IxbUqqWFoJJkpdcm5SOLDz4NpEAcqnozoiGSBWS5oltcQR2i1pCkH0FRb5Q/mqKthoSm
         ySpJRDCfWyVaJZjN/NNjW5yMGrEAPHlBOg4V8u6ukcTa/crsuwKClhvJ1hkL2C+CMn9r
         XVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7uYHbFkj0Ily3hsx7yQrc9r89pdawsJ/ONga/fXeJWg=;
        b=G8itBC7hDmPhUz/ua0OMTkpzaLDhttQJSnRjft1jGvKd3sf39yGZZ3QE7mJc75RiSk
         ampy2yzV5/iEO1QMnSDRUrlxNgO6zckEIls/tndWXTo4i7PSGngbCiE8b0RnqwzTuxcu
         /NxSzYt1MxRIfn+l+A5lBg4ELQqvIXr+N/2K/ZYdxglhW6Z9Bthu8sL2JTQYx8lOzNv4
         5ZPwetphqk9c4zC6+gHK8H478DMVdOOGmtgNiNNBJvaFq3p9U6C9rLWuStzfoNVAKllX
         NLtLw/XcUga5p1D/JXRlt8uhBBtFc/7hmRw5q4PQM3DPB5Y5wGisngAeyO/PPghG3JsS
         oBTw==
X-Gm-Message-State: AOAM532a7iwIo4mmuV9eEQionQ66tot0fu+Xq++/ReAHBIZ8eEgJ3W5r
        FSo6vqBaLH97c//kZphGZCkgfA==
X-Google-Smtp-Source: ABdhPJyWRoFpHkU6+9SZ9X4CLrw+isO+MBXKSbW8GQc0dAL8uItm82uD+lP/ZrEMP94HCyfSvbiTNg==
X-Received: by 2002:adf:e8cb:: with SMTP id k11mr1620566wrn.91.1603176320648;
        Mon, 19 Oct 2020 23:45:20 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 30sm1366094wrr.35.2020.10.19.23.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:45:20 -0700 (PDT)
Date:   Tue, 20 Oct 2020 08:45:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Subject: Re: [iproute2-next v3] devlink: display elapsed time during flash
 update
Message-ID: <20201020064519.GD11282@nanopsycho.orion>
References: <20201014223104.3494850-1-jacob.e.keller@intel.com>
 <f510e3b5-b856-e1a0-3c2b-149b85f9588f@gmail.com>
 <a6814a14af5c45fbad329b9a4f59b4a8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6814a14af5c45fbad329b9a4f59b4a8@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 19, 2020 at 09:05:34PM CEST, jacob.e.keller@intel.com wrote:
>> -----Original Message-----
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Saturday, October 17, 2020 8:35 AM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org; Jiri Pirko
>> <jiri@resnulli.us>
>> Cc: Shannon Nelson <snelson@pensando.io>
>> Subject: Re: [iproute2-next v3] devlink: display elapsed time during flash update
>> 
>> On 10/14/20 4:31 PM, Jacob Keller wrote:
>> > For some devices, updating the flash can take significant time during
>> > operations where no status can meaningfully be reported. This can be
>> > somewhat confusing to a user who sees devlink appear to hang on the
>> > terminal waiting for the device to update.
>> >
>> > Recent changes to the kernel interface allow such long running commands
>> > to provide a timeout value indicating some upper bound on how long the
>> > relevant action could take.
>> >
>> > Provide a ticking counter of the time elapsed since the previous status
>> > message in order to make it clear that the program is not simply stuck.
>> >
>> > Display this message whenever the status message from the kernel
>> > indicates a timeout value. Additionally also display the message if
>> > we've received no status for more than couple of seconds. If we elapse
>> > more than the timeout provided by the status message, replace the
>> > timeout display with "timeout reached".
>> >
>> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> > ---
>> > Changes since v2
>> > * use clock_gettime on CLOCK_MONOTONIC instead of gettimeofday
>> > * remove use of timersub since we're now using struct timespec
>> >
>> >  devlink/devlink.c | 105 +++++++++++++++++++++++++++++++++++++++++++++-
>> >  1 file changed, 104 insertions(+), 1 deletion(-)
>> >
>> 
>> applied to iproute2-next.
>> 
>> The DEVLINK attributes are ridiculously long --
>> DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT is 40 characters -- which
>> forces really long code lines or oddly wrapped lines. Going forward
>> please consider abbreviations on name components to reduce their lengths.
>
>This is probably a larger discussion, since basically every devlink attribute name is long.
>
>Jiri, Jakub, any thoughts on this? I'd like to see whatever abbreviation scheme we use be consistent.

I prefer long and easy to understand.


>
>Thanks,
>Jake

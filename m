Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE91776E0
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgCCNUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:20:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46873 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbgCCNUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:20:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id j7so4228458wrp.13
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zAkJ9g9MWgla5/oaAyZ008B4za5DBSIc4NoU0huAHTM=;
        b=rmsbUg4qXTMT+H6aZNtLYen3HXANnj5UanZaCaDtUIgBHFDbL8i2aKh89PYD1yX84I
         O7P0y8AmQzlSkIroJjp+XbVehvZ2tWhRzdbZ1G7CIOFGr3GtiT/emzPwN2kL4VGqvGgp
         Kt1dONVumdEGf5gEG0GNLmM6Gpqakh5isq+ht2v/ZUcH8Ct7NOSEc+0rJ7rC0+SyC2fT
         n2ONUylYWJffe7CFgMqoH6c5c1M9oy2VoVRAuoEkjfWA6LgMWY5SpAV/2OdcDfWCwPmA
         QLPfcXwMWaBzTSGzPmRSdpF9Jsw7S0zIbk8yNQnopaGzfKyouKoU/FtqwSKGFijSZb19
         0NPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zAkJ9g9MWgla5/oaAyZ008B4za5DBSIc4NoU0huAHTM=;
        b=hVuc5JKtSW554NHnkMyyEVluwDrRPBt8IZINhoNnRhyuBtY3QCeaH1Th45dU7awwy9
         e3zkfxMCpIQRhBRHgFgJuLfi7CGJrnaciYxajS1HcfbMAbovwsjLuwBIXjloFnyXNuFX
         GvW5jzrgrfbTNF8GOcQYEMiDX/Y1qzXGJOcXkhwY1YfUFoh6RF4y9ytNASQLxgBz7fC4
         V0CgSY7t3V6MhpD8rWW6luNU3Y/4BaHn7TojAj0AabUKWKgq6ZIfJyo0gyCT8y5PIHzy
         MeEUK6urdXDcuvACqhbBvF4eAuzcW+1GF7CCC+N/J9TUeEMzfH60Im78jBVq86LBmPBr
         PqNA==
X-Gm-Message-State: ANhLgQ1cQggPwqvnV7avqKAh+Y11k8wBl7R55T6nmeO1GLZP6EEsG8dW
        7imSuz0MvBuW8hpHeHCV20fomZCPePU=
X-Google-Smtp-Source: ADFU+vt8dOQw5iRTPN3OLWcfRJHvKTCIZnFF/wiKVzSMctmDcVmbz2Eb5bhjXCd2+q757ErgOCousw==
X-Received: by 2002:adf:eccd:: with SMTP id s13mr5257054wro.278.1583241637724;
        Tue, 03 Mar 2020 05:20:37 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id 4sm3660530wmg.22.2020.03.03.05.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:20:37 -0800 (PST)
Date:   Tue, 3 Mar 2020 14:20:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify type
 of HW stats for a filter
Message-ID: <20200303132035.GH2178@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-13-jiri@resnulli.us>
 <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200229075209.GM26061@nanopsycho>
 <20200229121452.5dd4963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200301085756.GS26061@nanopsycho>
 <20200302113933.34fa6348@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302113933.34fa6348@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 08:39:33PM CET, kuba@kernel.org wrote:
>On Sun, 1 Mar 2020 09:57:56 +0100 Jiri Pirko wrote:
>> >> >On request:
>> >> > - no attr -> any stats allowed but some stats must be provided *
>> >> > - 0       -> no stats requested / disabled
>> >> > - 0x1     -> must be stat type0
>> >> > - 0x6     -> stat type1 or stat type2 are both fine    
>> >> 
>> >> I was thinking about this of course. On the write side, this is ok
>> >> however, this is very tricky on read side. See below.
>> >>   
>> >> >* no attr kinda doesn't work 'cause u32 offload has no stats and this
>> >> >  is action-level now, not flower-level :S What about u32 and matchall?    
>> >> 
>> >> The fact that cls does not implement stats offloading is a lack of
>> >> feature of the particular cls.  
>> >
>> >Yeah, I wonder how that squares with strict netlink parsing.
>> >  
>> >> >We can add a separate attribute with "active" stat types:
>> >> > - no attr -> old kernel
>> >> > - 0       -> no stats are provided / stats disabled
>> >> > - 0x1     -> only stat type0 is used by drivers
>> >> > - 0x6     -> at least one driver is using type1 and one type2    
>> >> 
>> >> There are 2 problems:
>> >> 1) There is a mismatch between write and read. User might pass different
>> >> value than it eventually gets from kernel. I guess this might be fine.  
>> >
>> >Separate attribute would work.
>> >  
>> >> 2) Much bigger problem is, that since the same action may be offloaded
>> >> by multiple drivers, the read would have to provide an array of
>> >> bitfields, each array item would represent one offloaded driver. That is
>> >> why I decided for simple value instead of bitfield which is the same on
>> >> write and read.  
>> >
>> >Why an array? The counter itself is added up from all the drivers.
>> >If the value is a bitfield all drivers can just OR-in their type.  
>> 
>> Yeah, for uapi. Internally the array would be still needed. Also the
>> driver would need to somehow "write-back" the value to the offload
>> caller and someone (caller/tc) would have to use the array to track
>> these bitfields for individual callbacks (probably idr of some sort).
>> I don't know, is this excercise worth it?
>
>I was thinking of just doing this on HW stats dump. Drivers which don't
>report stats by definition don't need to set any bit :)
>
>> Seems to me like we are overengineering this one a bit.
>
>That's possible, the reporting could be added later... I mostly wanted
>to have the discussion.

Okay.

>
>> Also there would be no "any" it would be type0|type1|type2 the user
>> would have to pass. If new type appears, the userspace would have to be
>> updated to do "any" again :/ This is inconvenient.
>
>In my proposal above I was suggesting no attr to mean any. I think in
>your current code ANY already doesn't include disabled so old user
>space should not see any change.

Odd, no attribute meaning "any". I think it is polite to fillup the
attribute for dump if kernel supports the attribute. However, here, we
would not fill it up in case of "any". That is quite odd.

We can have a bit that would mean "any" though. What do you think?

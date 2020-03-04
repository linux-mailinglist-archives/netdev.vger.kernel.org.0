Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAA0178C6A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 09:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgCDIP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 03:15:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33966 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgCDIP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 03:15:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id z15so1200910wrl.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 00:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zsh6gtDbe5grknv3VRLhITB0vU82A8UlZTRlI1tilDQ=;
        b=Biq2o3B7LlDIKgfnSnbrJilPUKQeEPYJTGlZ6bl5f4gPX1avlJ4mroUHZ29tFmy2Bq
         HjE90FaOCJVE9b/C8HYz+VTPHOkf86Th4WIaSOa+IfRaO3pmUsQOuS8E59rB10lk1VG0
         FYmeAd2HWgcmpOwA9Y5KfdNiYSSyFAYRT4Q7mB0juo/w/FWK7OD9ZNMMcWbEIkZoflpN
         bEfdhXoKy/eP0YblIeq7hBM6ObpQanbBpvgqt1yP0ykJFf9e49YCTrBPAloQq0MlPWWf
         SPRACdXf+H0FOgPH1BiP0nqGWr6j7imcc2ldj8+5ALsG2pjAhaSOUbSYevB3eZX83xmC
         luSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zsh6gtDbe5grknv3VRLhITB0vU82A8UlZTRlI1tilDQ=;
        b=Y7TbC7gXw0uLD+XLKMXvUTZjJSFgZLaTtH7dqntGp+wYnStO+LApX6NMX7/qHswXJ1
         mPslmF2NKfNnbqvgQADDO5HKNy9trvIFtrS6GrmrQcYuhSfqTs7BAUkvmceZ1MHJsz+H
         WHyvTUKyyJctNqTHi6IsqQabOPWX8EZdnTiNfsmZuibTo4URAw7QJh+eiOwGd4/RC7Fc
         qIHmgrrKdyt3zXgGgUFppSfkCIlHfMQRpNhWy++rbabMLk/yi0WGQsU8+SnY+rt9yFOi
         FBDmd0K9Kp++5G7TV/YZU0ssLWtwWiV0T7UesYdOAePjn/wNBMtK8h9Lm8LtREns11jy
         6NOw==
X-Gm-Message-State: ANhLgQ2SlhH5OjuEMm5qB270V6ip2buUSEsDsb1XN3QZlM/jwilNLF5I
        j+QqZ0I/uiZAmMTv9UgB43tFpg==
X-Google-Smtp-Source: ADFU+vvMZSuZQI+b8u/gJ1KnAh+1A0JzQOAv2cW3IhX2lESpKk754Woqr8bgDAXDTri5+U/nZGvLhQ==
X-Received: by 2002:a5d:414d:: with SMTP id c13mr2967349wrq.40.1583309726751;
        Wed, 04 Mar 2020 00:15:26 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id b82sm2955012wmb.16.2020.03.04.00.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 00:15:26 -0800 (PST)
Date:   Wed, 4 Mar 2020 09:15:25 +0100
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
Message-ID: <20200304081525.GA2130@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-13-jiri@resnulli.us>
 <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200229075209.GM26061@nanopsycho>
 <20200229121452.5dd4963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200301085756.GS26061@nanopsycho>
 <20200302113933.34fa6348@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200303132035.GH2178@nanopsycho>
 <20200303114825.66b7445e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303114825.66b7445e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 08:48:25PM CET, kuba@kernel.org wrote:
>On Tue, 3 Mar 2020 14:20:35 +0100 Jiri Pirko wrote:
>> >> Also there would be no "any" it would be type0|type1|type2 the user
>> >> would have to pass. If new type appears, the userspace would have to be
>> >> updated to do "any" again :/ This is inconvenient.  
>> >
>> >In my proposal above I was suggesting no attr to mean any. I think in
>> >your current code ANY already doesn't include disabled so old user
>> >space should not see any change.  
>> 
>> Odd, no attribute meaning "any".
>
>OTOH it does match up with old kernel behavior quite nicely, today
>there is no attribute and it means "any".
>
>> I think it is polite to fillup the attribute for dump if kernel
>> supports the attribute. However, here, we would not fill it up in
>> case of "any". That is quite odd.
>
>I see, it does seem nice to report the attribute, but again, won't 
>the user space which wants to run on older kernels have to treat
>no attr as "any"?

Okay.

>
>> We can have a bit that would mean "any" though. What do you think?
>
>It'd be a dead bit for the "stat types used" attribute, but I don't
>mind it if you prefer to go this way.

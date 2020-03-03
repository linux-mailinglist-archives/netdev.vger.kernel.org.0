Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75B1177269
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgCCJba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:31:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53085 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgCCJba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:31:30 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so2264451wmc.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4cmaPLJjC7em8KhQsOS6iBAiQQJ/T6XNo6+pugJAbPk=;
        b=z1980oPzvSR+1gPicabf7M0xmi19T8etTLVcJXVEjdhZW+DNAM7D+2YUAL2EfXNzBi
         SeSdKOdwX4wm3UvL7KhUXzUvGAeYp1jp1eXS+vQaFOHLu7JTVUkavfz8ZPVsdoCPhmM9
         YN30wLSxKqGn4aP1msmcVKfxnUZSXbwQhzOMuKpUVDSbNqjIkqZFzwVKehwFOIhNex3r
         f6u6BnjQ1AJKjijtCh+RdWFPlQBByseaFPnRYgoyvm1Pi0t8L8SHKT0EmJyeOA5tlgf/
         qk3gR4uIErSFzWiHeiLYcY+1u1zO4J8iclP1+/Fp3WV0rTAOQ7bBAWPSehcWyY8VELw/
         Cvmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4cmaPLJjC7em8KhQsOS6iBAiQQJ/T6XNo6+pugJAbPk=;
        b=tmS7N4/m2QaBvcjDCmTji3dU3PkMQ/BLYDg+xqVBGmddECSJqXCaSrcr0wXxQgGw4Q
         hukGzK7dl+BV/hZ8z93GT8FAw7D5g8oea0QNmg5oROOmJVqu9UTqTi6C/nSOn8NJLOY2
         czEL3eZcls5x2Z9ewouj7uo4aiHW+dOiXEdcn8WQfj1TARb4FBZYT4MkQ4Szl0CghhtS
         0W11N8ysPbQ3cS6+KidCfR0ihNmOrSKOF1sAHa/J1pVBIa+fSEBLJT+bYJaeHdlsQSr5
         +bF5sbTWZwrSQF57wRcPs0Zjpn1UbCvwQNjAaU/uV/hemnaqbIeQzemvw2DowE6aFjaG
         y4VQ==
X-Gm-Message-State: ANhLgQ3fs0I7fxZfL9kV+0GMPW2kn8VIxAjvEFjUHmjrmrkmEtZGpt5U
        qksLBvmkh8+ZwSU0RGjxVNxhpw==
X-Google-Smtp-Source: ADFU+vtUSoJAYGVl8kAjzXjZnPVFy9aGGE1ijBK6RLAHjaBJ/QjPSEotQHHLDCc/awxJlM3IiiBOhw==
X-Received: by 2002:a1c:a405:: with SMTP id n5mr3250123wme.125.1583227888440;
        Tue, 03 Mar 2020 01:31:28 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id z14sm32878211wru.31.2020.03.03.01.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:31:27 -0800 (PST)
Date:   Tue, 3 Mar 2020 10:31:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200303093127.GC2178@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
 <3018db4c-1acc-cb56-07bd-33ffd9394726@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3018db4c-1acc-cb56-07bd-33ffd9394726@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 11:35:24PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/2/2020 9:41 AM, Jiri Pirko wrote:
>>> struct devlink_region_ops {
>>> 	const char *name;
>>> 	void (*destructor)(const void *data);
>>> +	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
>>> +			u8 **data);
>> 
>> Please have the same type here and for destructor. "u8 *" I guess.
>> 
>
>So... if I use void **data, this ends up looking a little weird because
>core code has to cast to (void **)...
>
>I agree it looks a bit odd to use u8 ** for snapshot and void * for the
>destructor.
>
>I really do not want to change destructor to u8 *, because that makes
>callers have to write a wrapper function if their destructor is simply
>kvfree.
>
>I'm ok with the cast to (void **) but it does seem a bit ugly.
>
>Thoughts on which approach to take, or to leave this as is?

Yep

>
>Thanks,
>Jake

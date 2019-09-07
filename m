Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99E2AC615
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387986AbfIGK25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 06:28:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40169 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfIGK24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 06:28:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id t9so9619813wmi.5
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 03:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TtNJAAdcCt1tombIgWZu58ZF4oI8n2N1ePG4nF6AjVs=;
        b=LVXT7gYdWzgbEeE2vuwl74RVVeXrSbbxMZzr8yqMtaD//7BC3VUT/Mqp/kkP6Np0XG
         mKwAkZfMcKwLdKxkxkUoH4g8YRU8K43ivXSIapk7NWEa78WzWHDDai8Xh/TQcJcd9biu
         hPNzNBgnKghMclsATIPNUhreLPGnm+yaGotVgEO2bNFx0gPl8JrtnRGiQdxf3hMLTTSX
         JeOfrgpoqh62wP5FOoq3W681r1FUvkckgQX97oWISHlQo/dQdXLy5E6F5fPm0CcinLAH
         /qQOwLfTW29GIkXZUydObzWxsMTgP/5/ylV3ohwC1+T1xVqNPcVWxfVupOEgiW/udMEz
         n7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TtNJAAdcCt1tombIgWZu58ZF4oI8n2N1ePG4nF6AjVs=;
        b=uZAxm6PjeqEmgheiDPJmS3n8wrZhY9VXc+SsoEq6ehcjoeSYtgAqnNI+u1qVT0lHrQ
         ueBuB6TM1tG927ltlX7reBU8v9TBMkwHxPi3L3DoDKWmT2s3ARTpPWhbhUzB2oE5mdwq
         kxhDerbj0tTdODgmW526+ULw0TyGbdF/0SzdCVQgksjmgw0IojvBRRvl627LjKQ7j181
         Pn2FCfgtgdrtJOMbmbqTA66iGSsNNgNm+uPljsqGWYW5xYuX++e0VqCAySIriqKZy/H0
         P4PEr4VzapHb/RQIVfFwobJRf5h6/xtw0YUWNSL13SI60QSAa0iofVvVPdhCKN1LBYRD
         I93w==
X-Gm-Message-State: APjAAAUd5IYE55igw46FyU+5EmBiKfmfSnlIdJLfOk9GLndd86jMePq5
        W8kX1mJ2oyE5wEpD0mKZyoVODwRt/WQ=
X-Google-Smtp-Source: APXvYqwcWzQRA/I1Bykj0GJe3+zCKRdqtZQsNGdRdi80ve+YAK1/VwC2EuvojHCjknIuqLNlkWDaNA==
X-Received: by 2002:a1c:4c06:: with SMTP id z6mr10648686wmf.47.1567852135062;
        Sat, 07 Sep 2019 03:28:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s19sm15086955wrb.14.2019.09.07.03.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 03:28:54 -0700 (PDT)
Date:   Sat, 7 Sep 2019 12:28:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [net-next 02/11] devlink: add 'reset_dev_on_drv_probe' param
Message-ID: <20190907102853.GA25407@nanopsycho.orion>
References: <20190906160101.14866-1-simon.horman@netronome.com>
 <20190906160101.14866-3-simon.horman@netronome.com>
 <20190906183106.GA3223@nanopsycho.orion>
 <8066ba35-2f9b-c175-100f-e754b4ca65be@netronome.com>
 <20190906211730.5c362b48@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906211730.5c362b48@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Sep 07, 2019 at 06:17:30AM CEST, jakub.kicinski@netronome.com wrote:
>On Fri, 6 Sep 2019 11:40:54 -0700, Dirk van der Merwe wrote:
>> >> DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN (0)
>> >> +			  Unknown or invalid value.  
>> > Why do you need this? Do you have usecase for this value?  
>> 
>> I added this in to avoid having the entire netlink dump fail when there 
>> are invalid values read from hardware.
>> 
>> This way, it can report an unknown or invalid value instead of failing 
>> the operation.
>
>That's the first reason, the second is that we also want to report 
>the unknown value if it's not recognized by the driver. For u8/enum
>parameters the value may possibly be set to a value older driver
>doesn't understand, but users should still be able to set them to one
>of the known ones.

Ok.

>
>We'd also like to add that to 'fw_load_policy'. WDYT?

Ok.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAF9194A73
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCZVXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:23:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52410 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgCZVXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:23:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id z18so8799115wmk.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4H7gDmG6uwAvWQ54h/xmZfyOfr/nsyY5k2vd116zv6Q=;
        b=h20hmlfgYSGH2KKRYQY9nj9wl4X9ez6am3gagfHoomq5sCmejpdqyQlDAzFI+vBCCJ
         C3oziAu+baJ5GtwYJbqmEMoeKrCE/uKxTYmetnt3bHj9vL/VJDfCcD+1dC3YCJyoUnB7
         /1lVVELICuwscBlbvFuQSt3MMltMR90/v2VZhWCSbr+UIj0JldcJkLjhC/Ariei8UBkb
         EbOyP2PFDCjV90n7yVioaaKvG2IJC0DO3YISiYd1K7TCG/IJ/D8YtSX1/5Nyrs+7Ycq2
         gMgbccPYTcECat3HUiITLc6+Y31Jn8rcslTBMAmvUHN2Zbvu8AnWGa1Na38yug0UEZtG
         oYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4H7gDmG6uwAvWQ54h/xmZfyOfr/nsyY5k2vd116zv6Q=;
        b=tGAbHhTk2TokvSuMQCG++kIMw0cLmn/t/mr3FEQ9rTV+D537UbXqohl2Dx85C+W6bF
         rKyUHsJmooJEcMc4+KqH6ELOWIGCWKmEco3iWgOm93G7Z+lisjEkJNGZJRgY+kTBcoNv
         CGuUQ04p8KTi848CkK1NJr9Q4zB+TdSATOvEs85ET43+QZyxG4L0uVm06xNVnTJ5xYGR
         IninUEBItX26glfsoLKYzs8Wybhnp7716y6hmSP8enuKN75Ag1Xq9fJ7SG2IbTqpszbd
         wWZFI2F3nGpXOpj+RC6Y1ha952JQSpANGId1ci1wTw3zNcnz1YHNaiXIcQocRa52MIAD
         O7pA==
X-Gm-Message-State: ANhLgQ3pGWbH3BDL+pYGl0P/bs5nb6uVPLBf4kq42OULCo2TgOBm0kGi
        mNdf6ZcnO9rWil5dNc3gjoHfCw==
X-Google-Smtp-Source: ADFU+vsd39r8KMH4/AK75K3sekZl7A7k9zCdwmRDXEjtZL+GUK+U+bYavOQHwTcHUupe1P8EAqMvbg==
X-Received: by 2002:adf:f852:: with SMTP id d18mr12066655wrq.172.1585257797505;
        Thu, 26 Mar 2020 14:23:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p21sm5541219wma.0.2020.03.26.14.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:23:16 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:23:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
Message-ID: <20200326212316.GI11304@nanopsycho.orion>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
 <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
 <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200325190821.GE11304@nanopsycho.orion>
 <f947cfe1-1ec3-7bb5-90dc-3bea61b71cf3@mellanox.com>
 <20200325170135.28587e4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326102244.GT11304@nanopsycho.orion>
 <20200326103913.150b8108@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326103913.150b8108@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 06:39:13PM CET, kuba@kernel.org wrote:
>On Thu, 26 Mar 2020 11:22:44 +0100 Jiri Pirko wrote:
>> >> >>> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>> >> >>>   	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
>> >> >>>   			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
>> >> >>>   		goto reporter_nest_cancel;
>> >> >>> +	if (reporter->ops->dump &&
>> >> >>> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
>> >> >>> +		       reporter->auto_dump))
>> >> >>> +		goto reporter_nest_cancel;    
>> >> >>
>> >> >> Since you're making it a u8 - does it make sense to indicate to user    
>> >> > 
>> >> > Please don't be mistaken. u8 carries a bool here.  
>> >
>> >Are you okay with limiting the value in the policy?  
>> 
>> Well, not-0 means true. Do you think it is wise to limit to 0/1?
>
>Just future proofing, in general seems wise to always constrain the
>input as much as possible. But in this case we already have similar
>attrs in the dump which don't have the constraint, and we will probably
>want consistency, so maybe we're unlikely to use other values.

Agreed.

>
>In particular I was wondering if auto-dump value can be extended to
>mean the number of dumps we want to collect, the current behavior I
>think matches collecting just one. But obviously this can be solved
>with a new attr when needed..

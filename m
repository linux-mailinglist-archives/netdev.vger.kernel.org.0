Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775EF620A1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731869AbfGHOkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:40:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39245 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731854AbfGHOkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:40:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so16749823wma.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 07:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aNM2HHUKYN3Z30rarpgJHb3B+z3yOgtryVi4p7TAV6A=;
        b=K8VWReGcXuKK931JWuikb4bcCWOdIQYUnxzmIWOAqah5atfanD2BcERGVU5HIVeYQx
         kQ+k5ey7K9wvG9n5xXrkJ7XxJB+DQq6v7rfLc1Ape4VOqMpueTEwfk6OF0/SmHUoWOAQ
         TIoEHlU9q8Wc/emW66NaKvCZiJaQ8NShI37Tya7KdkGOZJr9hk0kGGp4w2IasHf1R1fs
         SZ5RUuikOqY3UiPF8z/UhfNbXvzW9Q4KDQOEck+mu2XYWUyIRhqdz9b/UMZuc1CfDoy/
         OemKdHSJwrk+GHb6v+x4fEtrPBK0eYL+aKKujjrhtkx2EN71x5Zd/g1MS5J42XF/stpT
         ahnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aNM2HHUKYN3Z30rarpgJHb3B+z3yOgtryVi4p7TAV6A=;
        b=mLVeGo1RwjW9ZUCePLaHPJ8bnKKQGn9PLRu2t8isa4rwYkxI3sOMl0lJrzSmNq8+80
         uoI44Z/VDY32C1etLp2rP67rnkd/ueAms9dg0as4igjL/Dk2INLYL9idhBY33m0aMcqc
         kR1ePYoAv1hJ5hUXwpu80W44pbedOTiglBglHRnfQPd7Kl+vV9zifdEM8/mIPfntsriY
         ercKCHy/B3rJbrMwZEVz7KPwfOtUX5BoF/tJwSLSQl+XFdCCb57JyoYNEyM+kILKSWqU
         2+LF5jrp6/ZWoPPRVQw7LnN5X9R0Thd2QqRMhu4qzPAG2SRcd+8eCUU2WqRjGMnvkOhP
         Uhkg==
X-Gm-Message-State: APjAAAUI9ORHjvnwZZW8e+PBCyhULiq3KchoIj8Nvf4a6vsvdHAIOx2W
        d8N5igSdYH/WJNlIHIh8+SM7Fg==
X-Google-Smtp-Source: APXvYqzuzB9o4b5WEISaZOIs6OJxClnTRM2VLk8ABJvAaTCPneIdEpjmLXKlFoUQ9W51TCJqBKbqQA==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr17679060wmb.129.1562596809434;
        Mon, 08 Jul 2019 07:40:09 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id o6sm32458519wra.27.2019.07.08.07.40.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 07:40:08 -0700 (PDT)
Date:   Mon, 8 Jul 2019 16:40:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
Message-ID: <20190708144008.GK2201@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
 <20190702130515.GO2250@nanopsycho>
 <20190702163437.GE20101@unicorn.suse.cz>
 <20190703100435.GS2250@nanopsycho>
 <20190708122251.GB24474@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708122251.GB24474@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 02:22:51PM CEST, mkubecek@suse.cz wrote:
>On Wed, Jul 03, 2019 at 12:04:35PM +0200, Jiri Pirko wrote:
>> Tue, Jul 02, 2019 at 06:34:37PM CEST, mkubecek@suse.cz wrote:
>> >On Tue, Jul 02, 2019 at 03:05:15PM +0200, Jiri Pirko wrote:
>> >> Tue, Jul 02, 2019 at 01:50:04PM CEST, mkubecek@suse.cz wrote:
>> >> >+/**
>> >> >+ * ethnl_is_privileged() - check if request has sufficient privileges
>> >> >+ * @skb: skb with client request
>> >> >+ *
>> >> >+ * Checks if client request has CAP_NET_ADMIN in its netns. Unlike the flags
>> >> >+ * in genl_ops, this allows finer access control, e.g. allowing or denying
>> >> >+ * the request based on its contents or witholding only part of the data
>> >> >+ * from unprivileged users.
>> >> >+ *
>> >> >+ * Return: true if request is privileged, false if not
>> >> >+ */
>> >> >+static inline bool ethnl_is_privileged(struct sk_buff *skb)
>> >> 
>> >> I wonder why you need this helper. Genetlink uses
>> >> ops->flags & GENL_ADMIN_PERM for this. 
>> >
>> >It's explained in the function description. Sometimes we need finer
>> >control than by request message type. An example is the WoL password:
>> >ETHTOOL_GWOL is privileged because of it but I believe there si no
>> >reason why unprivileged user couldn't see enabled WoL modes, we can
>> >simply omit the password for him. (Also, it allows to combine query for
>> >WoL settings with other unprivileged settings.)
>> 
>> Why can't we have rather:
>> ETHTOOL_WOL_GET for all
>> ETHTOOL_WOL_PASSWORD_GET  with GENL_ADMIN_PERM
>> ?
>> Better to stick with what we have in gennetlink rather then to bend the
>> implementation from the very beginning I think.
>
>We can. But it would also mean two separate SET requests (or breaking
>the rule that _GET_REPLY, _SET and _NTF share the layout). That would be
>unfortunate as ethtool_ops callback does not actually allow setting only
>the modes so that the ETHTOOL_MSG_WOL_SET request (which would have to
>go first as many drivers ignore .sopass if WAKE_MAGICSECURE is not set)
>would have to pass a different password (most likely just leaving what
>->get_wol() put there) and that password would be actually set until the
>second request arrives. There goes the idea of getting rid of ioctl
>interface raciness...

I understand. That is my concern, not to bring baggage from ioclt :/


>
>I would rather see returning to WoL modes not being visible to
>unprivileged users than that (even if there is no actual reason for it).
>Anyway, shortening the series left WoL settings out if the first part so
>that I can split this out for now and leave the discussion for when we
>get to WoL one day.

Fine.


>
>> >> >+/**
>> >> >+ * ethnl_reply_header_size() - total size of reply header
>> >> >+ *
>> >> >+ * This is an upper estimate so that we do not need to hold RTNL lock longer
>> >> >+ * than necessary (to prevent rename between size estimate and composing the
>> >> 
>> >> I guess this description is not relevant anymore. I don't see why to
>> >> hold rtnl mutex for this function...
>> >
>> >You don't need it for this function, it's the other way around: unless
>> >you hold RTNL lock for the whole time covering both checking needed
>> >message size and filling the message - and we don't - the device could
>> >be renamed in between. Thus if we returned size based on current device
>> >name, it might not be sufficient at the time the header is filled.
>> >That's why this function returns maximum possible size (which is
>> >actually a constant).
>> 
>> I suggest to avoid the description. It is misleading. Perhaps something
>> to have in a patch description but not here in code.
>
>The reason I put the comment there was to prevent someone "optimizing"
>the helper by using strlen() later. Maybe something shorter and more to
>the point, e.g.
>
>  Using IFNAMSIZ is faster and prevents a race if the device is renamed
>  before we fill the name into skb.
>
>?

Sounds good, thanks!


>
>Michal

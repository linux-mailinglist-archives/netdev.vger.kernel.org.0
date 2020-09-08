Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9569260FDA
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgIHKaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730092AbgIHKaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 06:30:00 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445C3C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 03:30:00 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id i1so15318020edv.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 03:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MkPxwm2nE4lIk6cwU906mCxyOMitI0GVkWi2ifNB63M=;
        b=QhILP995YGfGIAxEm4NUHUMlOxnPLx7pHtyh+hZyanabRN0vhDmF1uIYuXTkWSwtjv
         yEUQXcjAzxng1Seu2uuoGzKHImXQjefZl9EjEF49WAPHb2tJnBby9bMMOEn2M2H1lYRY
         RIr3lq5PGFjAPhYSnamiwYsmJODg0/0GZQ6UFHu5sycpopQK+60HaOuXFFPVxnW70uum
         Mv/3FqSOAAKa3npF3icGpfu0lU0j58MBWAnU/1RgMfzc7YifAknoP/2UzprRsuLpql4G
         kthFb8Deho56kW9rVtf0uSCnm/h8LDoyLtOAomGvB6fYwmE7qDsq/dLCbSV99g58mTyk
         mmUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MkPxwm2nE4lIk6cwU906mCxyOMitI0GVkWi2ifNB63M=;
        b=k9LkmVFo2MIQgzbO1vC9UXQxr8ndqu2Nr4Tc6lk8OUVQdBsvKbeqMAyRy2nORXompP
         zFtUJ/RYPX/OZWxMENVM9P2IJX+DuzHDcH8pqwt9iaYIP4QYhsWv+E2HB/4tU9S+H88C
         EAxVXFjfMmogqFhJEBMh2Ddj44+5Lil08ZWfkbYJphOPpsE2AJuPo1TA8EfUF//8jeZ+
         9WmD7HlOuCzVdu5praRTx5HZF/2HaAh7ZKI1daWsOmA1zAU9wqL141HHLVR39qse3bOT
         anvPDo1cnu8wsNFNPleieu7s95ksTYXD6avi5dBjoQxAS6ZCwW2lZ1R8U+i0MOsF+jep
         /pJQ==
X-Gm-Message-State: AOAM530lRBxqMjS1S1LtnMP+vXWsRsT71TnqVgGzqQ8RGsMZVGOJhaSv
        nJsb2NxCB8sBB/4p+s54VlQCM4TtpkE=
X-Google-Smtp-Source: ABdhPJzH+vgw97aIvjKvVSmuB5zI0m1Ggqle51wHvDxiAxcE/2Em+db7i8JBqZYMEEkLIeClvUaobQ==
X-Received: by 2002:a50:bb26:: with SMTP id y35mr27304032ede.234.1599560998947;
        Tue, 08 Sep 2020 03:29:58 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id e15sm14386036eds.5.2020.09.08.03.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 03:29:58 -0700 (PDT)
Date:   Tue, 8 Sep 2020 13:29:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20200908102956.ked67svjhhkxu4ku@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <87y2lkshhn.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2lkshhn.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 12:14:12PM +0200, Kurt Kanzenbach wrote:
> On Mon Sep 07 2020, Vladimir Oltean wrote:
> > New drivers always seem to omit setting this flag, for some reason.
>
> Yes, because it's not well documented, or is it? Before writing the
> hellcreek DSA driver, I've read dsa.rst documentation to find out what
> callback function should to what. Did I miss something?

Honestly, Documentation/networking/dsa/dsa.rst is out of date by quite a
bit. And this trend of having boolean flags in struct dsa_switch started
after the documentation stopped being updated.

But I didn't say it's your fault for not setting the flag, it is easy to
miss, and that's what this patch is trying to improve.

> > So let's reverse the logic: the DSA core sets it by default to true
> > before the .setup() callback, and legacy drivers can turn it off. This
> > way, new drivers get the new behavior by default, unless they
> > explicitly set the flag to false, which is more obvious during review.
>
> Yeah, that behavior makes more sense to me. Thank you.

Ok, thanks.

-Vladimir

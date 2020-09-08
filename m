Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FA5261F6C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732558AbgIHUDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730462AbgIHPYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:24:02 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5A5C0619C7
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:21:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d190so17507425iof.3
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XVUHodVNw+FgDFIw+2wBkiqJS96IEMfn+BC80vbJRiY=;
        b=nJrHRyhtkO4Sv2uew8Ez2DTdGq2DrW5VuvlhU3Ra3MbCX/tO3Y4nfcKicr1ZUoL5kM
         eql5JxdB6Bf9UMiSPVBV7tdp42YRosmn/cQrlCERYPi8iVGkxsCfXyp2LvMh1C09wr4x
         M5QZgh/NkZes6woi69niQWAIwscfM8HylFCZmdA2tepDiCYHZDMeZoKMNltbe0Bp91Qj
         d12NBNan1QfmRsJS5BJx1EmUEB7iozx3eaPNwtwxXqICiWL7tLPMBnx6v6K2JKiWj7fg
         Pj+HeInXLMe7MMqOdUxNvpfJVRb5lKTKCWmCw/2u90jywEDSWFZocDKDD11x8X1F0OfU
         jq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVUHodVNw+FgDFIw+2wBkiqJS96IEMfn+BC80vbJRiY=;
        b=OOPytbPs71c5QZPrL5/qslGBwpi8OGRJw9RhCwHPa9gx5AJ8U8XQ2gSVp6seHjpN9F
         d5+BZt+8ZDC/8xEZ5e8L2EfKH9e+XBGiNj4tA4999pQEP70PAjKfI2Hbj2BP7Gis+wIV
         AGdaXabxro33PaQuK6RrcfHThOQSg91UEi8Of0v0EUI031YE/hDG5b8QMhH91ZfZK8Aq
         kGEaYk2skassIqG00pmX1oi4FXl+bG7X9/aDvuksXDMW9VV/2pfmuzGYR3WtRfascb5g
         gwckRusGzlO89dvNLSmVI9ezL0/Aiwo3Liu6mIGljSRnPS6T2YTWh4hi8sD2++dk3mQn
         VHIQ==
X-Gm-Message-State: AOAM5316a0ZlK/7FkSPsgO4JEQnJNXp3lOYONoqYKJwMoz2F2oJ5fwKP
        TpEQm/bFYXHNsID16JnOgJ8=
X-Google-Smtp-Source: ABdhPJwtMCa7GXA5G6R6jb6W9zVx7AEfihbuGL1XsD3ce3kmX9NmgUvnzvGaiTh52pnogaLuTZgsUw==
X-Received: by 2002:a6b:c843:: with SMTP id y64mr20910348iof.47.1599578469547;
        Tue, 08 Sep 2020 08:21:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id p65sm10753420ill.23.2020.09.08.08.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:21:09 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 11/22] nexthop: Emit a notification when a
 nexthop is added
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-12-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8568a626-0597-0904-c67c-a8badc4e270a@gmail.com>
Date:   Tue, 8 Sep 2020 09:21:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-12-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Emit a notification in the nexthop notification chain when a new nexthop
> is added (not replaced). The nexthop can either be a new group or a
> single nexthop.

Add a comment about why EVENT_REPLACE is generated on an 'added (not
replaced)' event.

> 
> The notification is sent after the nexthop is inserted into the
> red-black tree, as listeners might need to callback into the nexthop
> code with the nexthop ID in order to mark the nexthop as offloaded.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/nexthop.h | 3 ++-
>  net/ipv4/nexthop.c    | 6 +++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 4147681e86d2..6431ff8cdb89 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -106,7 +106,8 @@ struct nexthop {
>  
>  enum nexthop_event_type {
>  	NEXTHOP_EVENT_ADD,

looks like the ADD event is not used and can be removed.

> -	NEXTHOP_EVENT_DEL
> +	NEXTHOP_EVENT_DEL,
> +	NEXTHOP_EVENT_REPLACE,
>  };
>  
>  struct nh_notifier_single_info {
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 71605c612458..1fa249facd46 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1277,7 +1277,11 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
>  
>  	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
>  	rb_insert_color(&new_nh->rb_node, root);
> -	rc = 0;
> +
> +	rc = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new_nh, extack);
> +	if (rc)
> +		rb_erase(&new_nh->rb_node, &net->nexthop.rb_root);
> +
>  out:
>  	if (!rc) {
>  		nh_base_seq_inc(net);
> 


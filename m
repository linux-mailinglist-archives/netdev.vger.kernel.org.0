Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C225A19A2C2
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 02:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbgDAAGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 20:06:43 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:43110 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgDAAGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 20:06:42 -0400
Received: by mail-il1-f194.google.com with SMTP id g15so21299019ilj.10
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 17:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZgdZJr/c1sSSOt26UrU6e+pHGQ9kjfiHj5/B6NAeDGw=;
        b=GzfqMydg31qhHjql7QxRu7Wp0PW/ZC59RWePCvwsgu5W4YeGVd7tBN/K4A5s733Qou
         4VLdJwytLz6mCfuVwe7/EGommUFK2o1NuipbyvAG4Xg4PGwn7u+C5/ty496fbEgUjlFH
         vXTf/GfW5mvwtaA+aQmsDzj7ajErlpnNdwOaW/31cuooPujAfste51V7+1TjeQzDPhaz
         58FGTGJULDv2qkZjUTLV63UzibiMQefhSiX6spt7xwdH4YiHDHpn522GyKKDdeixITLE
         CqbYrOPLF9brdzGfTRDaqaF1XwCe+js216RM11IBhzec6L8B+V9tz7UsvYD0+FWaC9Y4
         G+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZgdZJr/c1sSSOt26UrU6e+pHGQ9kjfiHj5/B6NAeDGw=;
        b=bIN8AqbdOLAOGxtWVjkvWDpvkMmb8qu7noYd8uD3q5ee1uR6mqNYCTyLx/EJeRWeoX
         wN4lEpBFPF8mMuRa0b3URTa7vtu0rlG1Un0FuhNddcTMR71lWIQvinkqEhJGCJ6AwFDv
         djMeZJ74m7kXCeEdPmYELBUA2C+JuLPHehYDdHBLaJ9ObR2Q4E202y1yf2Wfyd9j2WQe
         PZpkCe5HcyMzGsyCymFvtRbiOYPxp4Zbf6bMJJh8zeOYVytgl4SXqY0vBwej5gIcswr3
         iWyjEZn7sDfWW6WlMLyDe2axHiReEjtw11o0dR2hFDGYTq2XJyz8vrWeOiNOMCYkvDK3
         3VPQ==
X-Gm-Message-State: ANhLgQ2a0KqxC7eJ885myPPHyq0wKQmpMo7EhKD5hd1yE/93X1R9LV/5
        mSZm5vi5QjC0fZbDS6eQc76bkQ==
X-Google-Smtp-Source: ADFU+vu+M3XspNurO/FmRzgNlzhghBO4cvzMm9MLjI9ZMcGCWLaewEkffch0nbYh+Q9VUiPFA8AX8Q==
X-Received: by 2002:a92:9f8d:: with SMTP id z13mr19258262ilk.290.1585699584936;
        Tue, 31 Mar 2020 17:06:24 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id y2sm121735iow.7.2020.03.31.17.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 17:06:23 -0700 (PDT)
Subject: Re: [PATCH net] net: qualcomm: rmnet: Allow configuration updates to
 existing devices
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        ap420073@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>
References: <20200331224348.12539-1-subashab@codeaurora.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <b17b2e15-515f-a758-b8bd-e34a62f405bf@linaro.org>
Date:   Tue, 31 Mar 2020 19:06:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331224348.12539-1-subashab@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 5:43 PM, Subash Abhinov Kasiviswanathan wrote:
> This allows the changelink operation to succeed if the mux_id was
> specified as an argument. Note that the mux_id must match the
> existing mux_id of the rmnet device or should be an unused mux_id.
> 
> Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
> Reported-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

This was a regression in 5.6, and got back-ported to 5.5.11 and
possibly further back.  Please be sure the fix gets applied to
stable branches if appropriate.

If you happen to post a second version of this I have a suggestion,
below.  But the patch looks OK to me as-is.

Thanks.

Tested-by: Alex Elder <elder@linaro.org>

> ---
>  .../ethernet/qualcomm/rmnet/rmnet_config.c    | 21 ++++++++++++-------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> index fbf4cbcf1a65..06332984399d 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> @@ -294,19 +294,24 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
>  
>  	if (data[IFLA_RMNET_MUX_ID]) {
>  		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
> -		if (rmnet_get_endpoint(port, mux_id)) {
> -			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
> -			return -EINVAL;
> -		}

My suggestion is this:  Since the endpoint pointer isn't used
outside the "if (mux_id != priv->mux_id)" block, you could
do the lookup inside that block.

>  		ep = rmnet_get_endpoint(port, priv->mux_id);
>  		if (!ep)
>  			return -ENODEV;
>  
> -		hlist_del_init_rcu(&ep->hlnode);
> -		hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
> +		if (mux_id != priv->mux_id) {
> +			if (rmnet_get_endpoint(port, mux_id)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "MUX ID already exists");
> +				return -EINVAL;
> +			}
>  
> -		ep->mux_id = mux_id;
> -		priv->mux_id = mux_id;
> +			hlist_del_init_rcu(&ep->hlnode);
> +			hlist_add_head_rcu(&ep->hlnode,
> +					   &port->muxed_ep[mux_id]);
> +
> +			ep->mux_id = mux_id;
> +			priv->mux_id = mux_id;
> +		}
>  	}
>  
>  	if (data[IFLA_RMNET_FLAGS]) {
> 


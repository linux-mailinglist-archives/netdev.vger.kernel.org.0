Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F30340D1BF
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 04:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhIPCv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 22:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbhIPCv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 22:51:57 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA615C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 19:50:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g14so4601036pfm.1
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 19:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3gWv6A3N5Yoof/ABF4bujeBdmvTFTrxpZ3ifZ7Z7xsk=;
        b=hOaKMvo1/kiv6cwd+a/HUqfJVfZUpygDQMkuaQaPCr8xgggvoxG9W40HCfpb0Dca1R
         F4Twq+CxnURmX3R11GkAX0nUXSctb6t/n955g3uVO1rpAM9c+15hDy8k4dfcI6ypMEmR
         8U0TsNriQE2ZXQ+LtPCTxCkpV9k3oHV6e7iaNJggYl9HWb/V5qzCUJI9K1Kv1hQHeNW/
         EaBO+w6Lu5xVoZLOGZYVn99lk+qpzl5A44jWcAOf2AK0DcUmPc5Zs8inZ0393tm5/YM5
         Dlk7J0QJGjossHqDp5gqM7RXkVsyhGxIhNW+3cCoD0E5W0pnkzgsdcOoGi+sDk5xjSK8
         1uYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3gWv6A3N5Yoof/ABF4bujeBdmvTFTrxpZ3ifZ7Z7xsk=;
        b=1C0rpT9vdjR48brYPH+mny11TOmtpLaoRz7BLm3D+EgFhwc48huAA4uHaVGFARKgeM
         sKtAok2Y2y4UWuoYOhOBBXi84zEbPlqM6DGhy1QzGMPwUKzZ7NdnDRFx1uqDoUQJHhyl
         J/StYczYcuHKsD11QcJbgq8REL5jAgETVIKh5e/hiXRZF+OpVsZnPssnbOG4LMfhtCDe
         2vVOPCGrsV8XiABkuJBeGmbDJ3LQHyFojVdNZmzZuIKw/KYyXkr8YymFSwX5AU6of3Jp
         DxYg0N8cmXL+vQFw0EiIF7z6b6O8zzzEHkVfK/F/nADM3LRQmWDn9GP3nQKZvJPAkhe2
         nUmQ==
X-Gm-Message-State: AOAM532w6DU/nToHeT69L99eET3Sa/Gxds15uNnXyeogXv0xv9y9XQj3
        Or2uYey/OVPEP228gWatRCClcA==
X-Google-Smtp-Source: ABdhPJxV8+ZrX5+vnJALG+G80q/GKoPLRMJuxKfW8NGaZHPOiz8uPoILCwbdg4s4drVHgVBGmqkbUA==
X-Received: by 2002:a63:720d:: with SMTP id n13mr2816612pgc.470.1631760637066;
        Wed, 15 Sep 2021 19:50:37 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id b7sm1187467pgs.64.2021.09.15.19.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 19:50:36 -0700 (PDT)
Date:   Wed, 15 Sep 2021 19:50:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: Remove extra brackets of nla_for_each_attr()
Message-ID: <20210915195034.280bd610@hermes.local>
In-Reply-To: <1631758028-3805500-1-git-send-email-jiasheng@iscas.ac.cn>
References: <1631758028-3805500-1-git-send-email-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 02:07:08 +0000
Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> It's obvious that '&(rem)' has unneeded brackets.
> Therefore it's better to remove them.
> 
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  include/net/netlink.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 1ceec51..5822e0d 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -1920,7 +1920,7 @@ static inline int nla_total_size_64bit(int payload)
>  #define nla_for_each_attr(pos, head, len, rem) \
>  	for (pos = head, rem = len; \
>  	     nla_ok(pos, rem); \
> -	     pos = nla_next(pos, &(rem)))
> +	     pos = nla_next(pos, &rem))
>  
>  /**
>   * nla_for_each_nested - iterate over nested attributes

No.

nla_for_each_attr is a macro and in a macro, there should be
added parenthesis around any use of macro argument to prevent
unintended side effects.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09E81B2960
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgDUOXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgDUOXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 10:23:50 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29698C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:23:50 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t63so3766389wmt.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nSozfmvx6BCjCHhV0nRhcdusB03E31B+pvyu25ADEO4=;
        b=uhv2Z31fHUWf48eX29/Nf2G7yvyNR+8fsuJkEL+eT1nU6AhZW2baU3TRTzaVpPjx+Y
         g5eQkp/uf+NDqyH2Y5uZMgvij3k0+XNO4yAujBpO2djrko+TX7d+PKBdbLy0+SphSpUS
         vO9mxfjBzF6QZynmPi3luQbmccB7FVOWUhLKgGFzsH0D+mDMljXUwSpfROkiaqHurzUi
         ow3znp84rWacgk8z8qa2KeeqjgPycwwk2O5yykTOaqN6WRP8KcIpI4FCVQMCxK5n7gM7
         PZKnjhKRl+le5HkAJVl3tCOwjeYzhkJjy5Thr8AGlNWuiV6d9MWo/zEY6cOpP/ie2uHL
         CF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nSozfmvx6BCjCHhV0nRhcdusB03E31B+pvyu25ADEO4=;
        b=Ew6sA7qg3ZEFSCROIOYOFeB/qwJjoVycOP59hFmv7c14pd13gURXAWUBON+DARMyiK
         487IbdYF/khUBsXVvWKrAM3SvR4EBK7EQsgMxtmgh/kKXNKhy55kVTeCYp0iRPFTCfHP
         RVHaSpWBkR4Pl6DCtIKVSNKOVh/mcq4k9/UqkicmGksvoHaaKdU9cfeebpPutH2HWzGY
         8utHwszmsIKSDIETucD6902Z+EgpCPxprQAVsi1f6S+CqxGXW0GUH8tiPsCCtEQjDts4
         i/tR9aZso6XrRo4cWU7BnhIueui+9iQ5hIYn2qNXb92Jfj64tDX/VY1IjjoUw9UID4LA
         O6iQ==
X-Gm-Message-State: AGi0PuZ3Jf4uldrU89RB5jxBKmAQh3sc1dlUFqMO/B9IK+99rm/LYFOt
        mOB860i7XV4vVcHk0Ug0M55xPw==
X-Google-Smtp-Source: APiQypKaG6lpnNq+6tIPJUTzuiU55dGY0O6Dzt5VhGvxzypxR5IM2iIvX35d8+wA8gYCkI51CKDlVQ==
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr5101081wmm.9.1587479028935;
        Tue, 21 Apr 2020 07:23:48 -0700 (PDT)
Received: from netronome.com ([2001:470:7eb3:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id w83sm3821906wmb.37.2020.04.21.07.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 07:23:48 -0700 (PDT)
Date:   Tue, 21 Apr 2020 16:23:46 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Borislav Petkov <bp@suse.de>, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [oss-drivers] [PATCH net-next v2 3/4] net/nfp: Update driver to
 use global kernel version
Message-ID: <20200421142344.GA22535@netronome.com>
References: <20200419141850.126507-1-leon@kernel.org>
 <20200419141850.126507-4-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419141850.126507-4-leon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 05:18:49PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Change nfp driver to use globally defined kernel version.
> 
> Reported-by: Borislav Petkov <bp@suse.de>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

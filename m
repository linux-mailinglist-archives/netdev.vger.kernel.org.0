Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039703490C6
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhCYLis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhCYLhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:37:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D993CC06175F
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 04:37:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l4so2314559ejc.10
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 04:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6HWoPxM8hpk9JxBFaoub7bFIy6vZThqR9gg08XcEbko=;
        b=dmyFQGi74gKIFq9DVjKs30EVsi5QoIbBhdc9HQS88PneRCRYoL/By5GOedItfwkq3w
         rwzL6+LjwFkPWqBmbTYziTuYlnk183OFpKsAEm8kHhxxUbeBQ2qXI63PgDmlJNs1saCT
         E2moVBwUeqgQK6Cx48X2vAHF4eq+8GOIEXnX/D9unOqilAmy5bSlroNPw0+/P4rAU5ej
         AvgVL/FXzWzmNOzsC6TCWbLP4TcN5THCCcdVLIroHypBCsQkM9as2ENqD+ThwQWAK9Z0
         cWM99bCAzBKHoORQegFN9oYF240SPtT69CT7hD3W6vU6vdOMw/qFL7e6ZsBfN58AU8xJ
         JvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6HWoPxM8hpk9JxBFaoub7bFIy6vZThqR9gg08XcEbko=;
        b=B90jsBiI3sbJ7zMVYRupt0X8Xkyx9itcN1AYZKr1trxIXG7deVld0IsfPvD45oYRJj
         sOrGpSd6WO26QLuaJtrWiOgcwOcWj/XUNwIiMhconpMQwSO8/4FxDQGb324dKlIPmNN3
         hQOVNKq3zhRtc9sW8kBRKSVaWwC1D8GpLqxzTTMFgADw/v1lDsDGi+A94GsvmAoOys+n
         5viaXtME/RMofQFUF7QNOPioyc8FZKayjSlAyJn+gXkggPpiPALg5NQdqbRnZKph0WTa
         0wngqARZgEWnwP1jhi0zP5BUMwxNF+xglS634ZL1ZSRcjBjSIXcPXAR2lFYA8hmxazuw
         WLNA==
X-Gm-Message-State: AOAM532CQD6t80+vUcGUbmCvr3g7d0qbdpKunrP/iFokqJ3Xi+KnWiXv
        XUg58Y9CrnbOyhVNEhg2AzYTiw==
X-Google-Smtp-Source: ABdhPJwfluv3C/XrzGXSCWStwVwpVt5Z13jHN67KqsPWwc1Bi29dt/ow/Y7IN/LT8hhQ75A/rwhLsQ==
X-Received: by 2002:a17:906:1749:: with SMTP id d9mr3579372eje.12.1616672232631;
        Thu, 25 Mar 2021 04:37:12 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id c17sm2623237edw.32.2021.03.25.04.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 04:37:11 -0700 (PDT)
Date:   Thu, 25 Mar 2021 12:37:10 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] drivers: net: ethernet: struct sk_buff is declared
 duplicately
Message-ID: <20210325113709.GA31168@netronome.com>
References: <20210325063559.853282-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325063559.853282-1-wanjiabing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 02:35:55PM +0800, Wan Jiabing wrote:
> struct sk_buff has been declared. Remove the duplicate.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Thanks, nice catch.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

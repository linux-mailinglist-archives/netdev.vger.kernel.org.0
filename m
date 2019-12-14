Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C7411F0F3
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 09:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfLNI1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 03:27:52 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:53249 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfLNI1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 03:27:52 -0500
Received: by mail-wm1-f46.google.com with SMTP id w8so1216315wmd.3
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 00:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HnlEcCOnYPfHXdichRmfeYAMJzTPH1YMq8eGs2nlFVo=;
        b=JIl1lb+0B4stHP+TwpmUZr8KGIcp+L2ENnGEYmt4g7UbyPo5wZFFby3YSFl5Wi2Jx5
         g6yHJkKOMzEcmglMgyKsSBolwQFH60bbHy6G08VJQ6y0NjiBPw9eNSQKcl2DHxNJUyI0
         QzIuDk/Wc1NI3qtT2f2iQigAaXQfcHuXmIXteI4YkHOm1Tq77/4D1e4YnPhEamhkmvBM
         rhoDEN8y0y8ghg77X1r+7OGu8uTbOYs7D1qb4U5idZVY11SlLYdhRTABXzkjV80b2Ddw
         OAFVClt9syT4YzzOUwV5nfsCBXDOQ0kWhPPwFm664icC2iGoCYZMp/RMABU+iJrDXCp/
         mXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HnlEcCOnYPfHXdichRmfeYAMJzTPH1YMq8eGs2nlFVo=;
        b=lnV4IPlbn9edoQ5jqpT2X5E+VLlyaviCtNlu0y4PZsByi7lzE+8mR4RgQvhLKuJYyP
         Dku9NYNJo/RzwFPr2N0+N1a1JVoXx3WWG9amrTeXFmMlGDHnoUZNwYexRKTSlkZvPow1
         5x39db+Q+ZZMyu6gXY/oFz+RBmc8SozqZC8Tpe+cxCeltAg/sJPr5TikmxEkYEiRHGv3
         eEUEUOpoiSFFMkifMhXwFlhE7pMsmTIj0shxRLQKAce/fUbdz7PVsK6Su7tXHU/SNicv
         4yOv2YJIvGhSW8fw5ghIt85qomym522mbMwr/ipScbnT2ljXltw6mefUJvCt/J9IaGiZ
         NYEg==
X-Gm-Message-State: APjAAAXG8oQpjsiPe3wXbjToXOMu9PKcjsBR0ItkJbS+9I7Eu/oAF45v
        pHpnD8zj1IzvYh9+9FijaCemaxIXtXM=
X-Google-Smtp-Source: APXvYqyj/p7ZPJa1PvNrgBuNNKzwLReIIT8KBlVn9Qrr2oMSH32F8rdPJGWdPtwK6zgKqK8b7cdpnw==
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr17790128wmi.37.1576312070597;
        Sat, 14 Dec 2019 00:27:50 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id m7sm13029900wma.39.2019.12.14.00.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 00:27:50 -0800 (PST)
Date:   Sat, 14 Dec 2019 09:27:49 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 5/5] netfilter: nft_tunnel: add the missing
 nla_nest_cancel()
Message-ID: <20191214082748.GE5926@netronome.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <eef81a92304174c58faed2403c7b487b00193626.1576226965.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eef81a92304174c58faed2403c7b487b00193626.1576226965.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 04:53:09PM +0800, Xin Long wrote:
> When nla_put_xxx() fails under nla_nest_start_noflag(),
> nla_nest_cancel() should be called, so that the skb can
> be trimmed properly.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>


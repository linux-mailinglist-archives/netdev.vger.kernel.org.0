Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A829C16475B
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 15:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgBSOpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 09:45:15 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:38812 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgBSOpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 09:45:14 -0500
Received: by mail-qk1-f176.google.com with SMTP id z19so315311qkj.5
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 06:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wh8HqHexRhPwuku2se1ZDnkxF8FSMKWi9ApHV7+VEmM=;
        b=Kqj1R6EFdsyCSUvk8QQ5zWyYelKGmJaZytAA7PvgN7TiTiQUb8/ufNW3FzceZLHlNK
         65mgrBpxiJu2dYEOwpF3WDV4DZJmv45CmkU1hM13IGxMRmmGw0AYY5wp1vIgdBXSwq4t
         hYF2tZ4YptFvCxygexLmZY9r9V+jFUJU3pQoYjhEF14trpvOUiCFDPDlmnESnug4h1Ib
         GXunEeBRzD1qtZKYYlHyNKr1uS00RYZox7/i84HrVJMKm0Ec2F+AS6dr+TmHwMG4q53n
         qQ0zlISKE3I28uEHBcPuppPQ+Lvx3xWMdH6Sbn6ZhpBSoXHHLUbrLLCms8iWRrfUPywX
         m0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wh8HqHexRhPwuku2se1ZDnkxF8FSMKWi9ApHV7+VEmM=;
        b=VQOAAWNA1wiVEy405k932ZpJfT1VBfrvH3ZI8CzF7rqBIeOT2ZTBOdo6govppchBwt
         MikJibPoUhiLFN+1vDBUSyu8D1FNH0+ZHu07ZoNcLhLolZhD7ru97zS0d724ExdKkkZE
         ALApOTTbQMFikzJaApb19n1h8ABv6Lm0FMQNt0G12WRh1+TB5uViguQKrsm1/l4NYtR5
         mOj7mAWpnrBRhIiDRKidHK+QB0vtiwv4NmKPeyUiGoiIJ9Ea7GkcVXSJQ61vQKCcMZsn
         qsMIk1DSJC3xsO/au/kd+OfSQ0xjvu495I7+D5Y0AgfXxmK8sIxotImvWkHAy8Ntmynu
         jfEA==
X-Gm-Message-State: APjAAAV8uyAWG378ArP3pF8ewsKUodyMT+aGbrDdOPIaD9o/+Em558Mm
        LFrwLltxKcd8yQGOyRdIy54=
X-Google-Smtp-Source: APXvYqwkOT+FPQASjkl7entCDUTn7n6dCmmFUow78YURayUDkAUdITMHRAK/p18Z6xf5lsEOOubTdA==
X-Received: by 2002:a37:9407:: with SMTP id w7mr23369863qkd.55.1582123513389;
        Wed, 19 Feb 2020 06:45:13 -0800 (PST)
Received: from ryzen ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id t187sm1066853qke.85.2020.02.19.06.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 06:45:12 -0800 (PST)
Date:   Wed, 19 Feb 2020 09:45:10 -0500
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
Subject: Re: [PACTH net-next 5/5] net: ipv6: add rpl sr tunnel
Message-ID: <20200219144510.2dqsxrbs26azzh6m@ryzen>
References: <20200217223541.18862-1-alex.aring@gmail.com>
 <20200217223541.18862-6-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200217223541.18862-6-alex.aring@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 17, 2020 at 05:35:41PM -0500, Alexander Aring wrote:
> This patch adds functionality to configure routes for RPL source routing
> functionality. There is no IPIP functionality yet implemented which can
> be added later when the cases when to use IPv6 encapuslation comes more
> clear.
> 
...
> +
> +static bool rpl_validate_srh(struct net *net, struct ipv6_rpl_sr_hdr *srh,
> +			     size_t seglen)
> +{
> +	int err;
> +
> +	if ((srh->hdrlen << 3) != seglen)
> +		return false;
> +

I added here a:

/* check at least one segment and seglen fit with segments_left */
if (!srh->segments_left ||
    (srh->segments_left * sizeof(struct in6_addr)) != seglen)
        return false;

which makes sense to do. No zero segments and check if seglen is the
same as 16 * segments, because we don't support to set compressed
segments yet and I don't know if we ever will.

> +	if (srh->cmpri || srh->cmpre)
> +		return false;
> +
> +	err = ipv6_chk_rpl_srh_loop(net, srh->rpl_segaddr,
> +				    srh->segments_left);
> +	if (err)
> +		return false;
> +
> +	if (ipv6_addr_type(&srh->rpl_segaddr[srh->segments_left - 1]) &
> +	    IPV6_ADDR_MULTICAST)
> +		return false;
> +
> +	return true;
> +}
> +

- Alex

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB7F1E59E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 01:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfENXdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 19:33:05 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:37109 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfENXdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 19:33:05 -0400
Received: by mail-qt1-f181.google.com with SMTP id o7so1202842qtp.4
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 16:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=facrwBnrSkM5fH0amRSEkXCCLGYc8wE2tpuB9XoZQhs=;
        b=SF+B6tpeeD5HjEZ75n9BiIlFuPPlEnq9/CJtcuQcLwtkrkQQwBYS+kjRc0WhC6cjPr
         qJqllz3feQVyjdkX5QDEjsqAcLokEJ2Uw9atAVitSv0kFyUqL3wi0Phn/e1dr+463duD
         zZftLpB7THV4Av1ZJzWqhsW+crRZ+Z5MRSnwF37Dz5n9Cm420O/yud5I7vQi7kUc7Qa3
         s/j0qVasp1EfIyPqrnkc8CXIyE7GlR4JkmwjCbiMP+E2G0YSsaR1KbFWYHAxGCdRW4FP
         eY8dMus8/K+Fx0omdgzMNwjhjtrb4IdQG0SXAb+G+3q5rNJdc4urL/V4Y9Zuoi9zec2v
         F9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=facrwBnrSkM5fH0amRSEkXCCLGYc8wE2tpuB9XoZQhs=;
        b=mQX2m70NpoqKrZwFHkyGZawVfErkZDQ6krJLww/n2FWclVxNiBUDsSmEBHBt+VJkEf
         GCuXbOOKVsut5dNPQtOGflyLTyU1C3vL0wllNewt5C2VRpC7F8OMvdoCsgagGmS2pug7
         G1/Dw57fBG2i+J4IJGDgVKsmPy/dJnB1nIuTVhKBS+UI1hKnIOCoxehMYSg1BHeZJ4gX
         K8Uk3HE9ldHfP3C1rf6u9HExG9KQG9iHTWhc+J+6FMy3Hdsg/wf/ioRrLk8pn2d/3Sfb
         ncRdY2YNXtuuggwCtIRXP4W1CwoQcs2mtHyXHSnIbrW2IMlhbWDYMiXe0dibCYqkmUDr
         xyhA==
X-Gm-Message-State: APjAAAX8/VF+fr2idW6ImTRHiiygQx9A0grL6GeeueKjorQ4+b0jRc36
        EtAdnfPIyRrvP0X8My5Dl+6IXw==
X-Google-Smtp-Source: APXvYqw0Q6+mA7WvS//Jt1CMKNY059P4Tq1LChQIDmHCAGNxyiXOZxOUk84BMw1ipkHfQH/DcWzPUg==
X-Received: by 2002:ac8:41d3:: with SMTP id o19mr5277561qtm.191.1557876784297;
        Tue, 14 May 2019 16:33:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u5sm110726qkk.85.2019.05.14.16.33.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 16:33:04 -0700 (PDT)
Date:   Tue, 14 May 2019 16:32:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [RFC 2] Validate required parameters in inet6_validate_link_af
Message-ID: <20190514163243.3f2a420f@cakuba.netronome.com>
In-Reply-To: <20190513150513.26872-3-maximmi@mellanox.com>
References: <20190513150513.26872-1-maximmi@mellanox.com>
        <20190513150513.26872-3-maximmi@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 May 2019 15:05:30 +0000, Maxim Mikityanskiy wrote:
> +	err = -EINVAL;
> +
> +	if (tb[IFLA_INET6_ADDR_GEN_MODE]) {
> +		u8 mode = nla_get_u8(tb[IFLA_INET6_ADDR_GEN_MODE]);
> +
> +		if (check_addr_gen_mode(mode) < 0)
> +			return -EINVAL;
> +		if (dev && check_stable_privacy(idev, dev_net(dev), mode) < 0)
> +			return -EINVAL;
> +
> +		err = 0;
> +	}
> +
> +	if (tb[IFLA_INET6_TOKEN])
> +		err = 0;
> +
> +	return err;

While at it could you forgo the retval optimization?  Most of the time
it just leads to less readable code for no gain.

The normal way to write this code would be:

	if (!tb[IFLA_INET6_ADDR_GEN_MODE] && !tb[IFLA_INET6_TOKEN])
		return -EINVAL;

	if (tb[IFLA_INET6_ADDR_GEN_MODE]) {
		u8 mode = nla_get_u8(tb[IFLA_INET6_ADDR_GEN_MODE]);

		if (check_addr_gen_mode(mode) < 0)
			return -EINVAL;
		if (dev && check_stable_privacy(idev, dev_net(dev), mode) < 0)
			return -EINVAL;
	}

	return 0;

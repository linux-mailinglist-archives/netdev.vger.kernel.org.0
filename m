Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A4814A847
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 17:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgA0QoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 11:44:13 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40270 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgA0QoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 11:44:13 -0500
Received: by mail-qt1-f196.google.com with SMTP id v25so7855311qto.7
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 08:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qbRHIhQ34I1+DCuzOiuk96LiOU3TGSlVsW8GL5CoCvw=;
        b=m40ffIE7hL8VQ1xHhKKwyk7qt4kNkA5dYzherU+xaC0DCkBZbKw2rg1Z4OSum/PY0v
         qLzHiBh+goxkjoEp23dBcfHK57tDzP96c/rOWeY/OPgnoGqxCVy7qykdvfGLtrToUNBM
         2hSThMFa+zcX/CyMz37LqE1AoJ0H5/o4/aHIeqVyAkWcaCuEScNA19lhTvIqcgfjzZ+/
         Ukv+YEhyy9iP3vJhCrKJIMmx9o6Ji6V9NhfK0WRWM0ok5LdAau8KidoMZXkOZ+CaVI4C
         JxqnRFMOmhYPRIgY/LJ0bpZgD3EK5PKfvqmdd7UUxpg3ob3qdgLwICVCQ/iEOcrLi075
         5TuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qbRHIhQ34I1+DCuzOiuk96LiOU3TGSlVsW8GL5CoCvw=;
        b=qmu6gCxN4+ZwQy04QtRooKxF8+JAbqeyI15SqwRKrryrXsDSfF2mYp6KqcSvOlX8vH
         N1bRvMTZo8WE7wYMOJygGASsgMzK1qYZ/JeI2PbCa3g98Y9j9bWarVgsH1JP+3shw5na
         gk0AK7gRmx80b9bkv4Fe6z1WnYpaxmbn6HSSQKV90b20vzfya66ZIB0FUkn+9C2PUfFQ
         Iyoz4+ZKMRYSd6VaXcsOSMFZGF/Qn5ecUCJtpRuaWP+KiUu50Hmn4bd01rbBcj9E+5Z9
         YRl2rkDD5CE3LqIKUx0RgOfHO3Bv8CJHD+fztCZIQ5uuZkJq4xMcl05yopMqzv4uqUYB
         HKqw==
X-Gm-Message-State: APjAAAVP/509VT42WtmovCy1Xl22crJpOTXUVKOdyIcxd9pFCt/7jzFd
        mv7JQ2s/v4b+4FmMyiTvvIJNERbK
X-Google-Smtp-Source: APXvYqzGUo43QL7ZafC1SH8FHTTulvfHFgnF7vB1Lswoblw2Uda/b0GumxV8FFWTOddLZPhooEvMbw==
X-Received: by 2002:ac8:958:: with SMTP id z24mr16665274qth.40.1580143451981;
        Mon, 27 Jan 2020 08:44:11 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:58fc:9ee4:d099:9314? ([2601:282:803:7700:58fc:9ee4:d099:9314])
        by smtp.googlemail.com with ESMTPSA id f23sm10034981qke.104.2020.01.27.08.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 08:44:11 -0800 (PST)
Subject: Re: [PATCH iproute2-next 2/2] macsec: add support for changing the
 offloading mode
To:     Antoine Tenart <antoine.tenart@bootlin.com>, dsahern@gmail.com,
        sd@queasysnail.net
Cc:     netdev@vger.kernel.org
References: <20200120201823.887937-1-antoine.tenart@bootlin.com>
 <20200120201823.887937-3-antoine.tenart@bootlin.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f1acfe75-43c7-38ca-7b93-16862b40f49e@gmail.com>
Date:   Mon, 27 Jan 2020 09:44:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120201823.887937-3-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/20 1:18 PM, Antoine Tenart wrote:
> MacSEC can now be offloaded to specialized hardware devices. Offloading
> is off by default when creating a new MACsec interface, but the mode can
> be updated at runtime. This patch adds a new subcommand,
> `ip macsec offload`, to allow users to select the offloading mode of a
> MACsec interface. It takes the mode to switch to as an argument, which
> can for now either be 'off' or 'phy':
> 
>   # ip macsec offload macsec0 phy
>   # ip macsec offload macsec0 off

seems like this should fall under 'ip macsec set ...'

Sabrina: thoughts?

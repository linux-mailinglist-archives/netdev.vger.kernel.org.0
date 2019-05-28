Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD7C2C1DB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 10:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfE1Izf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 04:55:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46048 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfE1Izf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 04:55:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id b18so19240257wrq.12
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 01:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iXrkMhatCJCrve8N1tRZZKPPlbJnePDZNiznEcpn1JA=;
        b=F3Ux1fpmlS2UOoEzsNR277uTiCxln0drSma6m51XEYQDlRTyFRdDLbb0nS26B74Cu1
         ZKqQf/iBZEuaPXWrEO1KyqRQ4DPBBoja1aWCN5MasG1zDeRdTcxBxxP1snLNy+yIbRJo
         pA1RNIYkwHngPaBmZUuwwVAN2eKWSkIm4akmhg+iCDTWyOGoIboKzbjxy46LvULgb7U0
         /OIS0niAT0nu1qz6mCidL+wYWNSwuQERwUasSAMfFAGWvceFfb6ww4SubLkVj+2I1w4W
         EBpGqrkeeiNWm4LKZl0aRFfZsxWihRI0bE8Dnz3EfRdFTZiWrEv4j2Qy9T2lzCLZEMUj
         vu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iXrkMhatCJCrve8N1tRZZKPPlbJnePDZNiznEcpn1JA=;
        b=iee0Hz0My1ffjybBfwKo1ta6+pPiGzCl1qJf1BWCAqReAdL8Ub/nPPwCvAMF80JNRW
         iSO7PF19X6IVQkt3SemSRwdx2YalnUC7nODK9gCriDG5IXpubAzbVDERijDunq6ow8db
         t/4t9FPhYUlmc9Aqcjo41Pgv/zT9pWaQMNz02v7g0/cXu6uLH8LBUdAetpTaDJsCpZ9e
         COXzcH7yERhRHVy5fsitU6SrOl99Q2sw4UGbawhoMa1i+dCM/uQXsYUTLgwq3rVt8EHo
         ahqEHTDP+ouR+1gPcCo4ht6qGc3i1wFtjKyEYnJNVPtVmjxpaO+GZ8pC+KgKJpAPLhdy
         4cZQ==
X-Gm-Message-State: APjAAAXWjc56gnD2zsOXVsn6HfywzFRK5SuU0tfperJeV/RtFi9c1WDy
        yWMt6EnPikvTrLF4Fz7kwhTGlA==
X-Google-Smtp-Source: APXvYqwFbmDZdl6RWCXl2xpG/MPD7IKiQIFJGTEWZLsUYl9teDd4I0KJJtFpjQsMK3hIAuA1PFw0bg==
X-Received: by 2002:a5d:4e46:: with SMTP id r6mr77516637wrt.290.1559033733518;
        Tue, 28 May 2019 01:55:33 -0700 (PDT)
Received: from localhost ([5.180.201.3])
        by smtp.gmail.com with ESMTPSA id g16sm11890129wrm.96.2019.05.28.01.55.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 01:55:33 -0700 (PDT)
Date:   Tue, 28 May 2019 10:55:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: Re: [patch net-next 0/7] expose flash update status to user
Message-ID: <20190528085531.GA2699@nanopsycho>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <a4a0c438-95e7-9f23-072e-33d55fc9f9a5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4a0c438-95e7-9f23-072e-33d55fc9f9a5@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 27, 2019 at 08:14:32PM CEST, f.fainelli@gmail.com wrote:
>
>
>On 5/23/2019 2:45 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> When user is flashing device using devlink, he currenly does not see any
>> information about what is going on, percentages, etc.
>> Drivers, for example mlxsw and mlx5, have notion about the progress
>> and what is happening. This patchset exposes this progress
>> information to userspace.
>> 
>> See this console recording which shows flashing FW on a Mellanox
>> Spectrum device:
>> https://asciinema.org/a/247926
>
>It would be great to explain why you went that route instead of
>implementing a MTD device (like what sfc) which would have presumably
>allowed you to more or less the same thing using a standard device
>driver model that is establish with flash devices.

This patch is not adding flash functionality. It only adds the
visibility into already implemented flash process.

Also, re MTD, let me refer you to the discussion 2 years ago:
Subject: Re: [patch net-next 0/9] mlxsw: Support firmware flash
From: Yotam Gigi <yotamg@mellanox.com>
Message-ID: <0daa5c5a-377c-767f-ea19-26c1f22bd30c@mellanox.com>
Date: Sun, 28 May 2017 10:26:49 +0300

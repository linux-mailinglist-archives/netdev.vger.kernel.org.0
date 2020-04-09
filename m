Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6BD61A39D1
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 20:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDIS2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 14:28:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38502 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgDIS2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 14:28:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id f20so769798wmh.3
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 11:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SUipMijg++U+hCp0dBuNgfFV7atHTeGceiAPS9eHKhQ=;
        b=1SXKbRBOQ0481Xu7DGK37xGbNqM7jb9J9CybdyfrTa2MdPV7v7itLKjQrqDfTWyx+H
         80Va4eYECSW4QHZZJqqDDXyZIF1ntTYDe8X8tuRUFYJXgNtSGiv+nsQPSjVUHpjGDXID
         AsJZlbaEMeoTaUL7Yj3PGk+Trr6rPAEKkYevMw1RMlW8SXu6cuyaCyweg5CSi18WxKhg
         65WFrPlxUiSZjmqKcPePkH2JXrx8OY/M46SXEdQs6yr1c9v6MRg4gURL2/7A9viEUSvF
         EK/aukB0u+VS9YxRqIipcOWvkmyKtoivalbXANhzYPc9a+Hh8aqYf1QVacyKnLJUaCZh
         Za0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SUipMijg++U+hCp0dBuNgfFV7atHTeGceiAPS9eHKhQ=;
        b=VohpQNVvtfT5puHzJuXyZy0SFlY4g0RzfUtFebqilnbRJLdTMfwoZvKPwPs3zGDgHI
         55s4zPAmYxPc8lSppBiHOOaKfwP27Kb37O04/axz26b6GjDxyUWGYX4FYJHFMkfVT2Oz
         cLIoT4uhwOpA5DOp0dGDeZ0Vr8jmce9yPGhOk4+KkwiKNH8Z/d5ObkjnsLgWMBPitwky
         msCxiVzG4sG1qd3XyifokW2Au215ZvLAYsr2fCWLELLqY/m0dHstekBtSVqnJ+Jop/MA
         9Hss73IS5oLFBnr+pyXM9NoFzWWpPg7N6oKKvZd4OqFhUcgELPGRuFDPId64oAD1jXDX
         qrOA==
X-Gm-Message-State: AGi0PuZkWWi1qBB3T8qgEyInSMi99cE6egNdNMuvEMKCvJGdDHWc8pqb
        1fFrZ3Gw2+MmYW00VnFHMpPXWA==
X-Google-Smtp-Source: APiQypL9KNT2To2HK4txrxKyRzv8Els0L2sjwromX39OPr1aBHqQziAgBKhdCAm63UAzowvwj+gBtg==
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr1167604wmj.33.1586456927660;
        Thu, 09 Apr 2020 11:28:47 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e23sm31236449wra.43.2020.04.09.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 11:28:47 -0700 (PDT)
Date:   Thu, 9 Apr 2020 20:28:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next] devlink: fix JSON output of mon command
Message-ID: <20200409182846.GL2354@nanopsycho.orion>
References: <20200402095608.18704-1-jiri@resnulli.us>
 <11d5b161-80ae-e006-9ce1-e9d04a99a021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11d5b161-80ae-e006-9ce1-e9d04a99a021@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Apr 09, 2020 at 04:43:42PM CEST, dsahern@gmail.com wrote:
>On 4/2/20 3:56 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> The current JSON output of mon command is broken. Fix it and make sure
>> that the output is a valid JSON. Also, handle SIGINT gracefully to allow
>> to end the JSON properly.
>> 
>...
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  devlink/devlink.c | 54 +++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 52 insertions(+), 2 deletions(-)
>> 
>
>does not apply cleanly to -next

Odd, rebasing and reposting.

>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F0AB2495
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 19:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbfIMRZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 13:25:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34767 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfIMRZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 13:25:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id r12so18533349pfh.1
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 10:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iPjikPoudV3Vtag5496mrgHXzlTn60UpJBwfAmM9+aQ=;
        b=O10rmJTl6wkgzO1vAriN5mUwIWhTZTAam53SlXbpTsLw4c+kYCN/XWKzgxJQekraSK
         uVtUUJHepKWz/N/66A9ldQcdd/ishZ4gv2sSEoeYcdr4bJxFAW+7g2H6EgAIhoC7N7NW
         BixxR+OKSy2pWtdSDv4H1tPzZZpIcWCI82UCNjqcjydTws4y3PieF6MUKiU2/Ym8Z85T
         H0t9+YVDqisPC1pTgxI51LmMTym2hPKsHc9eO9eJG7STgXO0Ptm3AZ8uG5ckIelZO+f4
         UG9evNLz91FQuXphIZcLHoEr8G+QU517YluW15UhfOdaeJSRByqrlVgJDn8/tRrwt1oa
         2tyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iPjikPoudV3Vtag5496mrgHXzlTn60UpJBwfAmM9+aQ=;
        b=LAjaR5PRzY/CdoEfX5KmJlFHKah/eE3Pc+rGzl9Y+bBSCERHwRg6s1smSDtF7tZXMD
         c/LOPG3Ga53eJa79sRhhpqMiIGCYwULamMM8oyQCm/W9YwKwi92jj4LFE3D0rgQJ61L8
         EVIQAG2rdgEg8jMCpRayaC++UGvdy8xO+B5Tyn4erwUjxpk8xrEKhSaLqc+T8+jPZq/y
         yVD7rn8215eTcfwmzNS9fCPEGYPHyBWlTKc21eD4bc9PxFJn3T5zRmRyR7ZgGaOGBw0f
         EU6IB30zsE5H7Kl7SaxbBKHHv0bJme2fsW+9T2/R7urpY1aPdJ+Hv+BOeoAynuIcfjWj
         ttxA==
X-Gm-Message-State: APjAAAWkTdq0qc9Y3cZNnsq4q8FnzQC/VltPb8AQHx4ap8BD+QhsEjlW
        6yX4SJ3kPMEjXyuqezl2puVD31o6
X-Google-Smtp-Source: APXvYqww/8NE8ad2S+M7aB6NccovOFJMKrd/BgZW/mnxW1/2HjZIjRvn757ru9JlpZPvBZyinvqFqA==
X-Received: by 2002:a62:ce81:: with SMTP id y123mr16521129pfg.115.1568395509681;
        Fri, 13 Sep 2019 10:25:09 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:f0f8:327c:ea9:5985])
        by smtp.googlemail.com with ESMTPSA id l11sm23439877pgq.58.2019.09.13.10.25.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 10:25:08 -0700 (PDT)
Subject: Re: [patch iproute2-next v4 0/2] devlink: couple forgotten flash
 patches
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com, f.fainelli@gmail.com
References: <20190912112938.2292-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2c201359-2fa4-b1e4-061b-64a53eb30920@gmail.com>
Date:   Fri, 13 Sep 2019 11:25:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912112938.2292-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/19 12:29 PM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> I was under impression they are already merged, but apparently they are
> not. I just rebased them on top of current iproute2 net-next tree.
> 

they were not forgotten; they were dropped asking for changes.

thread is here:
https://lore.kernel.org/netdev/20190604134450.2839-3-jiri@resnulli.us/

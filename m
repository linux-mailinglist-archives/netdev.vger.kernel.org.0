Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1822CB2A05
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfINGAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:00:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38764 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfINGAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:00:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id o184so4782700wme.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B5RyNiDOxDsdkwnbKYcqgnkEDpXQGDzSW0CX26WZeWQ=;
        b=rV/YuXTG1S52o6Wz061TjpLeHZFiXtbXZ5mkn5XW9c+VMXr1BO1lNzW7xptxoaLMku
         OsYVxcGZgEMV0IqmXvs7Bn+6ufWX/BeaBkuZTio5n6lnVZJWzHthBwB351qcmVaWdfPm
         D4Yg/1CBO2Unwyk2EMYbEq8sLtTRUfyeWONUsgQe3o7ZOD70X3yCNHvEV7sKidyYo0oN
         hZeMpmQqwAExULsd9V/K9PPJ73RJwDMFVmGZw18T59TJ8NJBJaxp1QUQ5u7gUWelgLFs
         /mfxRZROJ5u2kmd8JZfikiez2Bqg2X0VgzeQBkptsX9ZRijXJHY38xKL6wa5U93YqZ6F
         NSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B5RyNiDOxDsdkwnbKYcqgnkEDpXQGDzSW0CX26WZeWQ=;
        b=pnJQHppfp0SDjqUoRthbO+nJyvP/aEmgG/Pvu8KkZ7CR1S5UjBXuJLdP/tpu/Ch/+p
         r5JkTh1hmKmwirZ8dBU4Xr3FP8lhF0Wz5Ev0cvCoRrVWJi+kSurYnmF2SLTEaFQPoc9F
         X3rydzEeDHrY/3SxCqa4uPdAGAGssjremXAapiSmAfoXYojobRqwW/a0/NKRln2Y11sU
         xPXFy3rNjV7T0YNpmrJNy14MAAqJze/opV4fZaWZsRXMzCEHGLGMXktJX7Y9aZi81pIQ
         vj5eE7917lqkDHJK67kvGibCXe8OxO3IWkvAjHygBDUqvlzppyP0aUbK9uS529v77y6P
         A1YA==
X-Gm-Message-State: APjAAAXAKv7IzHl8Kovd58PkaCD4Bkkwhk+oZlz4AK+JaHjZ+cvvgq+V
        6SZ3XYuZYmqgQfB2SpuyyC2OrA==
X-Google-Smtp-Source: APXvYqxgwEyv4EZkmUS+D2Ymj0OBXnNCXUP6odRcoHkyleai/Cc6FL1H1/qeMIq5f+pcydmTc6/iSw==
X-Received: by 2002:a1c:cc10:: with SMTP id h16mr6211618wmb.130.1568440814326;
        Fri, 13 Sep 2019 23:00:14 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i26sm3793801wmd.37.2019.09.13.23.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:00:13 -0700 (PDT)
Date:   Sat, 14 Sep 2019 08:00:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
Subject: Re: [patch iproute2-next v4 0/2] devlink: couple forgotten flash
 patches
Message-ID: <20190914060012.GC2276@nanopsycho.orion>
References: <20190912112938.2292-1-jiri@resnulli.us>
 <2c201359-2fa4-b1e4-061b-64a53eb30920@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c201359-2fa4-b1e4-061b-64a53eb30920@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 13, 2019 at 07:25:07PM CEST, dsahern@gmail.com wrote:
>On 9/12/19 12:29 PM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> I was under impression they are already merged, but apparently they are
>> not. I just rebased them on top of current iproute2 net-next tree.
>> 
>
>they were not forgotten; they were dropped asking for changes.
>
>thread is here:
>https://lore.kernel.org/netdev/20190604134450.2839-3-jiri@resnulli.us/

Well not really. The path was discussed in the thread. However, that is
unrelated to the changes these patches do. The flashing itself is
already there and present. These patches only add status.

Did I missed something?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA702D38F8
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 03:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgLICrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 21:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgLICr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 21:47:27 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6552C06179C
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 18:46:46 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id q20so34349oos.12
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RAcX5IS/r69U0yVcwBKACAXybXXN4EAaO9w0ZRKIzBE=;
        b=uduX7vHHH21OXnQlnmID7bj51+0bDcXZO8J/4jfvq0kCzZl957ewptdz4426ZPGBco
         S8Rwu40HRZS87prDwTS5X66s7YplN0z5bjOLIwJsemmIqL2tbSM4gui3LHLgal9v7/cv
         7nLzuPMYNQbFvD3bQpRHH6EDSJ6f6z1WM7gENv143t7IxALMORg5ZjlixcfY2XyLiTks
         gFdEfsfc9VAUjD2Myp85863EojuU3yD/pyAbeR/VjzPb25UIFbOVh5XhtMLiaR/GbFqQ
         UXcyHNrVYFk6wk986Iw7vD/el+380Iy5loDkAfaQCYRCLAL7YFz6eXyBY5Tt7DHK4is5
         0ITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RAcX5IS/r69U0yVcwBKACAXybXXN4EAaO9w0ZRKIzBE=;
        b=dy/5HCeX2uHGOi8cUnfNevO/BsNCNY9u88hiVbd7UukJH+zkAZAHocMgrn1pvefrxs
         i12fDX8be05upaeESFMAn5VDJnIltlBwccGJHGvwMXoyQmG54oA87a07ZqV8UF/w96za
         h9fgoAKg2MotQ6INYZvRquqX4Tjx8BgK6yHsPoJaG6FGiYN9QspFYUTeif/6MgIyP1Ri
         ZOYnk+je4X7P5zhxK2ih2K9SZLAUhsd+LVMH7TLcv67kKOce96/QdPN4fhCOuZY7XkaB
         vitvNMRjJBsvaquGnDIaOYYA/eIKq5Y1yM4ss4NiQ0dZCZRmIcrINmZteIXUFQCiIE8d
         OiUQ==
X-Gm-Message-State: AOAM531cMzvngvcafRH5vgQdWFWvcJRf46SEw4iZl8mCpEfZnaK3Tsrj
        HjL/4vl9MZgN24tXTb6yU51E1qhL+GwIOg==
X-Google-Smtp-Source: ABdhPJxQH9oi/kUfMCb29QbcBK2IZC3qOS43M2SmQwXWIpSKhDE3Vqy3GlF9yC1k8RXMZtWXz4Pryw==
X-Received: by 2002:a05:6820:54c:: with SMTP id n12mr177775ooj.79.1607482006168;
        Tue, 08 Dec 2020 18:46:46 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id u130sm55058oib.53.2020.12.08.18.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 18:46:45 -0800 (PST)
Subject: Re: [PATCH iproute2-net v2 1/3] devlink: Add devlink reload action
 and limit options
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
References: <1607319322-20970-1-git-send-email-moshe@mellanox.com>
 <1607319322-20970-2-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7bb89ef8-78bf-1264-6921-1d9f15ec2b12@gmail.com>
Date:   Tue, 8 Dec 2020 19:46:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1607319322-20970-2-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/20 10:35 PM, Moshe Shemesh wrote:
> +			print_string(PRINT_ANY, NULL, "%s", reload_action_name(action));

That line should be:
			print_string(PRINT_ANY, NULL, "%s",
				     reload_action_name(action));

to fit preferred column widths. By print strings in my previous comment,
I meant don't wrap quoted text.

Fixed and applied.

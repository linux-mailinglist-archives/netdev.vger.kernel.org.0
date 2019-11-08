Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E84F3EF9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfKHEkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:40:11 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45053 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfKHEkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:40:10 -0500
Received: by mail-pl1-f194.google.com with SMTP id az9so2360826plb.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 20:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZDX3C3knIy0ktGqKMNv8GEV/k+SrZl4b/T/1TdMR5cY=;
        b=n/oc4nUA96+Yui5QIoSTMzI5Q1OHBQrMMWiZdLry7TUtHWzoTX9PyDt8o7jVCoZnOQ
         PgZDgXzmzuKHL60bLHMj9fe6KqFvCSSmJ4r8HHCr44+Y+asF+vWDcFgyPyCpFRuksF2S
         gJen6zdxcKpBsTiAigWtLuyGgw7UUTcWFT9idIdUIzlC88a4dpUEJ8HDdDwY5GdCy+GV
         yRZ3rl2iQgJo00nGS5sR3EuhiL6MqqHZwb7QiX6kLM/WXkZg4bTGIYFCdNmkSBHzPpoK
         N44DmjLgGk5dus1SbyDNeJF2YA1KvW5/4qmQ4dHo//p6+JfPQ7+5iv8xmrvIv+DBLZZk
         JdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZDX3C3knIy0ktGqKMNv8GEV/k+SrZl4b/T/1TdMR5cY=;
        b=apfjSWK2GY6cZb2sFQW5OTTtEWVOes2BrrkYU5IarZQ2kS42s6UZTeVN2CaLooGUYp
         cm5faaF2vGiv69qxUquN8PlQ0yktBPQNmyZogGKg+XqjPo4FahRERYg4fg3Q+n7EnG5A
         0VzXulVAC9CS0YpdmS/ZD6vMrmemRezWDPcNWB5H0kCZwvcpI/VVngsexq3FVvhf9SNz
         9HkeV8MUk8uTHe6ALvdgRNHQZqlScqLvR+GTdBbZKDU7Sau2CxiO8HoaEXvtibYPnrYg
         LmxLdrkZQ/Jm8rGqsYuxVZR13CE7578GuYBsUCiuQHX5HV32b57u8ZUhtXS4uHNMiqNb
         i9Vw==
X-Gm-Message-State: APjAAAUVtTL8dWWYkf4mgkhsiW78/Cg9sY9tsWfm0ik1gikYauLMZSzU
        5P2wJ2vEN3Cp6VN3jGX9TQ/1pw==
X-Google-Smtp-Source: APXvYqyeD+Z7PZI9qBf2pB6F8DTEbOZyyqYvNWGKkNIbDK2KIhVwP63uYbbSBfZ49wlATNDTg0GVQg==
X-Received: by 2002:a17:902:d693:: with SMTP id v19mr8281144ply.220.1573188008369;
        Thu, 07 Nov 2019 20:40:08 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g3sm4071880pfo.82.2019.11.07.20.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 20:40:08 -0800 (PST)
Date:   Thu, 7 Nov 2019 20:38:59 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     dsahern@gmail.com, oss-drivers@netronome.com,
        netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Arkadi Sharshevsky <arkadis@mellanox.com>
Subject: Re: [PATCH iproute2] devlink: require resource parameters
Message-ID: <20191107203859.0f98cf83@hermes.lan>
In-Reply-To: <20191105211336.10075-1-jakub.kicinski@netronome.com>
References: <20191105211336.10075-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Nov 2019 13:13:36 -0800
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> If devlink resource set parameters are not provided it crashes:
> $ devlink resource set netdevsim/netdevsim0
> Segmentation fault (core dumped)
> 
> This is because even though DL_OPT_RESOURCE_PATH and
> DL_OPT_RESOURCE_SIZE are passed as o_required, the validation
> table doesn't contain a relevant string.
> 
> Fixes: 8cd644095842 ("devlink: Add support for devlink resource abstraction")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied

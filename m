Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080A82AE3B1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbgKJWvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730254AbgKJWvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:51:48 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01EBC0613D1;
        Tue, 10 Nov 2020 14:51:46 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id e18so212104edy.6;
        Tue, 10 Nov 2020 14:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DIJDZdaQQSS9aflu5DDVVbzLNzWkzQwKwKyH1TaqCPw=;
        b=jTUwTuAKwWCdgsy3w3QAZY3kOTE71vNfJUXdb++4Ws52Ir3eJxELN2u5xjfToFUuy2
         5Sj44RnIUVFN5X7luyajGXg83BCjMYJCky2bAlzVsAgP5ERRllFHnn3S0cCK9NH5LWHj
         ictBUeWa03mta1/NjJ06ARtFnzBz+Dej5caZfR5E4tEFG0bzcbhwo65ol1yOmETFC0Sq
         NWHVNH/0PKWxaqryDcROBjHEAFxwNX6nXqP4NPqfzPVzFA7bEPpoiUFew9crw5Cd+kXA
         L51f+JXqf0lW9GuFhRHqpiMMXDUS4Y0bx5TIF4YAMpyHhKuxD0qcP9gNwQHU/Lsoea89
         MeLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DIJDZdaQQSS9aflu5DDVVbzLNzWkzQwKwKyH1TaqCPw=;
        b=VH8ur0/T5cMSpUKNT9Y8Ec9CB3bQQ42LZF+TEOfGCXn750jg1AsblQFPuFMr96tNtm
         tTg3yqsM8AlANxVfyzlN1N5FExm+EdtNpgF4a3OcoAdfPkfrgG9W4vkwqWCxhJoVI1/e
         VUTYFAPoBIjTEe5L/4qt23PTvtZnnjZTbQvJmnMBbBdIZFHAHAtHq1dJKasZ+HFCNkGD
         j9ERkvnbpxsgG+cvxc/GiLaL3iy/oVM2fYirDJLrlFVC5amgFSBqk7dFzON27l93EViI
         GEfwS0oNbg+89d3Hw0ylYiD8Q5tU2YB9eydbH+/l/lL3YoUX64OvHDRKl+DHB23uCi4f
         GiqA==
X-Gm-Message-State: AOAM530z7yhnqBnh72EV+R34ife+eQUdjf/5eub5Enk7FjjRjf2Dc3p/
        nA67MpC9HfsNZ1jpeLfV2cw=
X-Google-Smtp-Source: ABdhPJzqp7IpwjgTjE9NidMp39dFRyHleO5uzlJJFqvYWVmx+SQXIfKOqXXQsjSr8mrXtnReoc5kKw==
X-Received: by 2002:a50:a105:: with SMTP id 5mr1750224edj.165.1605048705408;
        Tue, 10 Nov 2020 14:51:45 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id y18sm79353ejq.69.2020.11.10.14.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:51:44 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:51:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] MAINTAINERS: Add entry for Hirschmann Hellcreek
 Switch Driver
Message-ID: <20201110225143.jlojjh6dvwgrq3p6@skbuf>
References: <20201110071829.7467-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110071829.7467-1-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 08:18:29AM +0100, Kurt Kanzenbach wrote:
> Add myself to cover the Hirschmann Hellcreek TSN Ethernet Switch Driver.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

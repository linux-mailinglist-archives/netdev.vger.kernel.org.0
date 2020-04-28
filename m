Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBAB1BB444
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 04:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgD1C6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 22:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726047AbgD1C6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 22:58:52 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F94C03C1A9;
        Mon, 27 Apr 2020 19:58:50 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n24so7755658plp.13;
        Mon, 27 Apr 2020 19:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/byDlkt6s+cQBuQif6rcML0PxVzE1MoIoVjA0VLFhMA=;
        b=Fa6uqLYAD7a6+7BnYHMVXak0/2gRK0gawoyDOvbRcNDGpYwwVc2/ZUEBfvLabZ/t/b
         vT9mks4QIGJ9IzsJoDE1EiaZS6Ah4vZiBuhezaX+SW72zIOnX96f/p5LKgE6b3d5CRgJ
         Ll067Ob3EN6STbQQzDzmEAb2+Y+MCfR8Vu1sDqXHfzaO54Xv7rWMaqOzB8VaZ8F3azLs
         vO2zCf/1egB4yptnyhvjNd1jEW60yr22n4V4Uw9RlcPjso7k00W/HhAKjFymj+0h1syJ
         pU+hfS51t0rEnvArouSp587+OoJ1PbsPU21YePxWBRr+13Gc2OVBbfCHDQt8c7Y/Ub8x
         f/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/byDlkt6s+cQBuQif6rcML0PxVzE1MoIoVjA0VLFhMA=;
        b=S3d2awxjG7YNF3F1/wqJoY3P43RY/GIOLy4eaP2jK21dbQIqhFOS/gUz+jWcUS1ka1
         Sffum93/c4lLOQoxhHaWD/stRcCtZ4cGX17blOkCNdEPnTFZkco8Jvo0oGGzBvrzkjsW
         GoeFvLPye7qtrF8oCJTqd3mdyzJzVXhUdpW90wULmUTZMrytQi+b9wwy1c0sO01sZrc9
         nvu9v/bisjgy9WNJpGZLdYcr56gPZGgSCXTtbk8ZysO2ISgxnGcFwIHEso7tqlvJjb65
         LlHOeIao2qY61RfXiyneDSc2F5WK5y5gpWS2cGFFLsyHQTBNyQ2j4Tapk/W4ogw/7maG
         7E6w==
X-Gm-Message-State: AGi0PuYnO0bMS2ceALJJV9DMgDKhMYv97QiEKH2B6SsXkSjyQc7Zq3yl
        sGCifAwyrYxUbRadWyp6P1iXvOiU
X-Google-Smtp-Source: APiQypJSMABkEKdshyCULU8a9vVj94Mjqb0HBNI2eoxM2bEA72MsgymuG6edVsTQXxXkkYn7PGcvbA==
X-Received: by 2002:a17:90a:fb4e:: with SMTP id iq14mr2281878pjb.146.1588042730010;
        Mon, 27 Apr 2020 19:58:50 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id u3sm6702844pfb.105.2020.04.27.19.58.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Apr 2020 19:58:49 -0700 (PDT)
Date:   Tue, 28 Apr 2020 10:58:44 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] ethernet: ks8842: delete unnecessary goto
 label
Message-ID: <20200428025844.GA31933@nuc8i5>
References: <20200425115612.17171-1-zhengdejin5@gmail.com>
 <20200427.111547.346558310845161759.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427.111547.346558310845161759.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 11:15:47AM -0700, David Miller wrote:
> From: Dejin Zheng <zhengdejin5@gmail.com>
> Date: Sat, 25 Apr 2020 19:56:12 +0800
> 
> > the label of err_register is not necessary, so delete it to
> > simplify code.
> > 
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> 
> It's not unnecessary, it's documenting the state of the probe.

David, Thanks for your information, and abandon this commit.

BR,
Dejin

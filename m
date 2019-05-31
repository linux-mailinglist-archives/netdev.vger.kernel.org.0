Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8891D30FA2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfEaOIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:08:45 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45514 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaOIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:08:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id w34so4100793pga.12;
        Fri, 31 May 2019 07:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCYPGRHtk4nDgd7aDMAHWcLe9ARejuOtDU+i3zRXCIw=;
        b=aWgGiNy/HLKgfAhinVo71aSeq4fHfBMEQv1ECNcrAiJRN/9MJCZ0SDPT4sFEfbPySD
         exbAOUfCfV17WAoxapwG6JlWC9JRXSqtGoKqDpwgiGBVM1SyQhOOGmEBuXrJFzFRkeDK
         grWEj9FiuQ4nRl8ToScZG9y/spyvuNAB4YoB1EiDQqLFJvlzl0D/dnvNJXR+eRlOMhFY
         58l7rS2o5kc9U1DFd7SSzmTPNxegJNy9d1Og2xatZOetFrIfpihQHyI6CMGgax16K3vt
         wNDL0EVPJINps4Y5WtHbzb7i5ItF1djycmr0rdd2hoohMgFbm6ovTpJh+9Y/TMuJewA2
         s+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WCYPGRHtk4nDgd7aDMAHWcLe9ARejuOtDU+i3zRXCIw=;
        b=On8GRI+0OJhxwRjJT9rLgFHeU/DqI9qPbBDjw9YMBlWlMPyrvxdTSLIYbcte9MuUWl
         JhGp6nP5808f0fl5B8oJTMFZ47mIWesK0lnBT6z7pScpRMhvyBmb3kBqA8GLDi03MxqX
         UxeITpUQOivCBMuSUUd21j6Kpqvy2R+zop643qw14JINltExqw5rTYtbX4FO7xdpTwV3
         V/9QOsFoK2V0MM28XEgaIF4NbsMfWqfAo3V/T/me3fMkCc09M/yf73F8nYjMaS2WKFED
         6tKwUykq7HnEGJjeb1ePYE0pAEop+QOcBI2MjtaWxkRmqrWRo6tmD+Dapsy/CoXdE/VI
         qgow==
X-Gm-Message-State: APjAAAXwHAGrPEj4s6Sp/5kvR0X/QSlqIl5ecUfLM2rSF+u2HT6jkg9X
        M8ycBq2xrLknu3+aUacc2OI=
X-Google-Smtp-Source: APXvYqyVYnKObn0Yo6WNXMyOkwCtyqQYUyWocDPape0gkXWWzVv3ZSk5Am/RuDxTed3taruC/lxAqA==
X-Received: by 2002:aa7:9dc9:: with SMTP id g9mr10280250pfq.228.1559311724900;
        Fri, 31 May 2019 07:08:44 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 127sm6313018pfc.159.2019.05.31.07.08.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 07:08:43 -0700 (PDT)
Date:   Fri, 31 May 2019 07:08:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190531140841.j4f72rlojmaayqr5@localhost>
References: <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
 <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost>
 <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost>
 <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost>
 <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 04:23:24PM +0300, Vladimir Oltean wrote:
> The switch has internal logic to not send any other frame to the CPU
> between a link-local and a meta frame.

So this is guarantied by the switch?  What happens when multiple PTP
frames arrive at the same time on different ports?  Does the switch
buffer them and ensure strict ordering at the CPU port?

In any case, the switch's guarantee is an important fact to state
clearly in your series!

> Hence, if the MAC of the DSA master drops some of these frames, it
> does not "spoil any chance" except if, out of the sequence LL n ->
> META n -> LL n+1 -> META n+1, it persistently drops only META n and LL
> n+1.

LL = link layer?

> So I'd like to re-state the problem towards what should be done to
> prevent LL and META frames getting reordered in the DSA master driver
> on multi-queue/multi-core systems.

Ok.

> At the most basic level, there
> should exist a rule that makes only a single core process these
> frames.

This can be done simply using a data structure in the driver with an
appropriate locking mechanism.  Then you don't have to worry which
core the driver code runs on.

Thanks,
Richard

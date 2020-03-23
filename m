Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2483F1901D6
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCWX0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:26:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34330 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgCWX0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:26:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so8038309pgn.1
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 16:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oeCK/P7Vf7agbJreaxV5dmA7cMhPfIVzkRcH3J13yEU=;
        b=gXZD1PjqRDAqfPYcWfKY+5Q9nysmZCSHHoT1DM2M9949vFeq5AMXfg3XBwLPUjv3mC
         y/gVmR/Cc8NL5aklotbWjNDVTCGvvY3fvCspnwkIoSZjFNx6RvZCQEJFhrFCfiH7Z0YT
         Ezu7v/LUeIVk9ZGGtXdDToU9YsNkJ3Kb5V08rUnM8utBhuYwF72hL3Tq+HyHHyx9DNhW
         snlRXZX52zepUuU2EafGC/sHNPpn7gs8NEno0IesaXSjlG63iCFK2JRIrylbgNRhvfbP
         qklJZMi5dIrdXiRTxBjGuPw70GmpRFDTLvboyiy1No2q0ply+C2kGOHZroYls0Q6+Npu
         Bmmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oeCK/P7Vf7agbJreaxV5dmA7cMhPfIVzkRcH3J13yEU=;
        b=rQWSTtF6/PEEUrwmqiMJ97FckSKI+OcAdxdTpNbnAW1GEyzzKJhDa9byjAomGjHzAP
         EP3jMNHKNWCzzFo3uvJEK7l7p7q8cBABrN3p0cUjs20obccZrbUsqdaR4JxxtC8mH5yb
         ATpcw7xzPt57AOavTcu93RZNd4aKt5ckMqNOCD3uVgInyeua3vh7Zcm8190D8+K5HKzt
         EiR1lr1zbTucXZe9A9ns6bOLx+axTf6X6TumHG6+GvfhMlrEhd8pbMFnR7o7ZuwGi1Vy
         wC5hhZy7vxwNIzTmZundLPQgV+ywXwwLFiwxAziS+hDYQbSOxniqM3xe+1BkKUDnZhxW
         BtwA==
X-Gm-Message-State: ANhLgQ3TvNImCbRZwnKG6zsR/Yscg055bsxP3DD1xB2AE+a4XoFmkWTy
        je+G/5LtDan2Hj0JiHSDAzHt3phg
X-Google-Smtp-Source: ADFU+vupj6wz71RNy1GO7qP8OVH4joSeBlLfM+kq+H1OSVDxf9rwV0l8jdudCycRlYjY0v4O/u10oQ==
X-Received: by 2002:a63:c050:: with SMTP id z16mr23615520pgi.177.1585006011337;
        Mon, 23 Mar 2020 16:26:51 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d23sm14529733pfq.210.2020.03.23.16.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 16:26:50 -0700 (PDT)
Date:   Mon, 23 Mar 2020 16:26:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, christian.herber@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: sja1105: configure the PTP_CLK
 pin as EXT_TS or PER_OUT
Message-ID: <20200323232648.GC9140@localhost>
References: <20200323225924.14347-1-olteanv@gmail.com>
 <20200323225924.14347-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323225924.14347-5-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:59:24AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1105 switch family has a PTP_CLK pin which emits a signal with
> fixed 50% duty cycle, but variable frequency and programmable start time.
> 
> On the second generation (P/Q/R/S) switches, this pin supports even more
> functionality. The use case described by the hardware documents talks
> about synchronization via oneshot pulses: given 2 sja1105 switches,
> arbitrarily designated as a master and a slave, the master emits a
> single pulse on PTP_CLK, while the slave is configured to timestamp this
> pulse received on its PTP_CLK pin (which must obviously be configured as
> input). The difference between the timestamps then exactly becomes the
> slave offset to the master.
> 
> The only trouble with the above is that the hardware is very much tied
> into this use case only, and not very generic beyond that:
>  - When emitting a oneshot pulse, instead of being told when to emit it,
>    the switch just does it "now" and tells you later what time it was,
>    via the PTPSYNCTS register. [ Incidentally, this is the same register
>    that the slave uses to collect the ext_ts timestamp from, too. ]
>  - On the sync slave, there is no interrupt mechanism on reception of a
>    new extts, and no FIFO to buffer them, because in the foreseen use
>    case, software is in control of both the master and the slave pins,
>    so it "knows" when there's something to collect.
> 
> These 2 problems mean that:
>  - We don't support (at least yet) the quirky oneshot mode exposed by
>    the hardware, just normal periodic output.
>  - We abuse the hardware a little bit when we expose generic extts.
>    Because there's no interrupt mechanism, we need to poll at double the
>    frequency we expect to receive a pulse. Currently that means a
>    non-configurable "twice a second".
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

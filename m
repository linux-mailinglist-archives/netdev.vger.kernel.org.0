Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120B42D4EA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 06:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfE2EwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 00:52:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40911 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfE2EwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 00:52:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so780104pfn.7;
        Tue, 28 May 2019 21:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oOyS0vBmfamb8+yO3gJqspDXkEPlXAfKJCpG2N2EeyM=;
        b=QbwoGt5Uz2JJgJIR8grk5mFsVJuw+N08pb3u7+eLVXlQfYduk4sRjKenlblF1sKKCO
         TqO/plVTKwynlb1ADimBQOhmudFBemGld7wkzAVw+sJidC0KCRuehDfExq+/R4pjETNB
         3CqRzqRmSjIP/UtDdNvTmOFc9lewarNDiL7zGvUl+aEbaxFtzhgUNhtSdmyV8crlLePF
         g2snFqcaSCTt8mdhk9GE+9ciYu5fyhx/FsYkHCp1HuNCGrZaxsFZEdsGUeaTZKx25ASC
         C8EXKbvlG1qfUGdw8FChAAqm0VhUTToUUg79ZMljF36wL0Ok3hJZF4kLRod09PTbIB3C
         rGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oOyS0vBmfamb8+yO3gJqspDXkEPlXAfKJCpG2N2EeyM=;
        b=qi6tvL1GAmU8BqHHeLtLY5E9/S586irVZRoIueKPe/0Yf55yUfmRBbPbeAuacwY7Hh
         CyZi6TZ9EsVxT3ja2c+2TJlSIZx8zE1wojwxcFBdcPJZrbC5U3IbW1URzFavAf/sk30F
         G6BS8WPmPbtGCdjxJXanBHDTcodrCZqEqACkoptqVi0bIBQDDGL2onfeJo8CJaVeChjo
         A4hI9LvqTuXNHhsXhFNKh7C/cERKsPuLCG5P6A/HBLD53i/ftsTWozFjCV63lClUvcT9
         9y8jGdcNhuZV7f/rRTlhhXNNl73qGYsmZsdXgDWokY2Yq7nl0N//OATenjLj+kLSS7Im
         cHvA==
X-Gm-Message-State: APjAAAWWVg1jLnhUfPK/QjpDQXNXLJue9DVB4pcD2dzgzWJhCRaIDegq
        4+jxDuKxB34L13IBVllKGzU=
X-Google-Smtp-Source: APXvYqwgLum9Em/F8hygcLRS0GKIDiYKDpIp4VCUji/EOks6RDGleFyc+3SH5I9e5beVsooBV1n0jg==
X-Received: by 2002:a17:90a:c583:: with SMTP id l3mr9343876pjt.55.1559105530237;
        Tue, 28 May 2019 21:52:10 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u1sm16125184pfh.85.2019.05.28.21.52.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 21:52:09 -0700 (PDT)
Date:   Tue, 28 May 2019 21:52:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, john.stultz@linaro.org, tglx@linutronix.de,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190529045207.fzvhuu6d6jf5p65t@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528235627.1315-1-olteanv@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 02:56:22AM +0300, Vladimir Oltean wrote:
> Not all is rosy, though.

You can sure say that again!
 
> PTP timestamping will only work when the ports are bridged. Otherwise,
> the metadata follow-up frames holding RX timestamps won't be received
> because they will be blocked by the master port's MAC filter. Linuxptp
> tries to put the net device in ALLMULTI/PROMISC mode,

Untrue.

> but DSA doesn't
> pass this on to the master port, which does the actual reception.
> The master port is put in promiscous mode when the slave ports are
> enslaved to a bridge.
> 
> Also, even with software-corrected timestamps, one can observe a
> negative path delay reported by linuxptp:
> 
> ptp4l[55.600]: master offset          8 s2 freq  +83677 path delay     -2390
> ptp4l[56.600]: master offset         17 s2 freq  +83688 path delay     -2391
> ptp4l[57.601]: master offset          6 s2 freq  +83682 path delay     -2391
> ptp4l[58.601]: master offset         -1 s2 freq  +83677 path delay     -2391
> 
> Without investigating too deeply, this appears to be introduced by the
> correction applied by linuxptp to t4 (t4c: corrected master rxtstamp)
> during the path delay estimation process (removing the correction makes
> the path delay positive).

No.  The root cause is the time stamps delivered by the hardware or
your driver.  That needs to be addressed before going forward.

Thanks,
Richard

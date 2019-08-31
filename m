Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37181A44CA
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 16:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfHaOrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 10:47:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32882 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfHaOrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 10:47:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so5033316pgn.0;
        Sat, 31 Aug 2019 07:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1vNkl17wUr355bA9XUF4U0DgDqgVJ+SrUpJnpFJZhcg=;
        b=f/N2GqwB3jQeO8xF37anOuMwbzWXerJaartbtrl1HPCN4hOCYZ9ziQqNKg6qbvgI//
         dEDvtY6ORvjILsrGguz1aD6l3N2T8HlwZTXYxmQK+EclfRkXA0fKCYzdSMfi4a5haxzM
         WAAZcrphBP2EGi8nfdzRU0BdIzptz1EAZM1HOmpaCjzgpDg6qSpt8zgGl6tnfZCyZ+/u
         oZwZxNQ03z+znf6C8XpPUCmo/ceelTESr4h3YhaKOvHT3WM/5+o1DoUoAUYFZj7ja8/U
         kpvStSP5bupxf3XbjX3YKD2hRkBScDBw8OXvccLSnTeZvV2SSNo3fWdHqojlxJs6sa4J
         MVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1vNkl17wUr355bA9XUF4U0DgDqgVJ+SrUpJnpFJZhcg=;
        b=jSAazNTJX9frwkTj/MeExKHvU/XtZ4hBzPXiy3jM0ZOgzluX8tGqiYsRPDteOEC/uB
         VcmwSfw9AXn9DV63yv0N8LCxgFNxtwqnnL7hcI77+x7JA8PND6mETrUEEF33DPIWz253
         QMNfRXrPVP4tsvXi88JZt2JiTLSaQtN29QQf8PONf1LXTFE45v8TWeSdXnHcd4ChPKQ+
         ij2jiwmkm7byoFoKHCszgWUzxEYF/9MfGDPPUFw97aX2CzMss0aN76NMprjTXV66AuNh
         H84ItMKNFUzuKQlMiz8mlfDNIMDwSTrDp7Ayj4ofVH253CIU3dw4L1EV/GGdT0dOuRlw
         Z4yw==
X-Gm-Message-State: APjAAAVJY9FQ9GUovw2sbpBP3VybnGeBPVxHQ60XqylaDaeqOGjmd4F/
        +iqDoei8YLebJ6Bn4hipcmk8bGP2
X-Google-Smtp-Source: APXvYqzSVpdqFNu3k5jxrf8I2vetrtv86WH0vY9neGkTCE8zTqvbZejF9gozPh/RO+kb7OjnluVH/Q==
X-Received: by 2002:aa7:8b46:: with SMTP id i6mr24126455pfd.190.1567262855667;
        Sat, 31 Aug 2019 07:47:35 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id l6sm12196621pje.28.2019.08.31.07.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 07:47:34 -0700 (PDT)
Date:   Sat, 31 Aug 2019 07:47:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
Message-ID: <20190831144732.GA1692@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
 <20190829095825.2108-2-felipe.balbi@linux.intel.com>
 <20190829172509.GB2166@localhost>
 <20190829172848.GC2166@localhost>
 <87r253ulpn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r253ulpn.fsf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 11:00:20AM +0300, Felipe Balbi wrote:
> >> @@ -177,9 +177,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
> >>  			err = -EFAULT;
> >>  			break;
> >>  		}
> >> -		if ((req.perout.flags || req.perout.rsv[0] || req.perout.rsv[1]
> >> -				|| req.perout.rsv[2] || req.perout.rsv[3])
> >> -			&& cmd == PTP_PEROUT_REQUEST2) {
> >> +		if ((req.perout.rsv[0] || req.perout.rsv[1] || req.perout.rsv[2]
> >> +			|| req.perout.rsv[3]) && cmd == PTP_PEROUT_REQUEST2) {
> >
> > Please check that the reserved bits of req.perout.flags, namely
> > ~PTP_PEROUT_ONE_SHOT, are clear.
> 
> Actually, we should check more. PEROUT_FEATURE_ENABLE is still valid
> here, right? So are RISING and FALLING edges, no?

No.  The ptp_extts_request.flags are indeed defined:

struct ptp_extts_request {
	...
	unsigned int flags;  /* Bit field for PTP_xxx flags. */
	...
};

But the ptp_perout_request.flags are reserved:

struct ptp_perout_request {
	...
	unsigned int flags;           /* Reserved for future use. */
	...
};

For this ioctl, the test for enable/disable is
ptp_perout_request.period is zero:

		enable = req.perout.period.sec || req.perout.period.nsec;
		err = ops->enable(ops, &req, enable);

The usage pattern here is taken from timer_settime(2).

Thanks,
Richard

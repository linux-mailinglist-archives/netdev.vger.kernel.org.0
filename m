Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4AF29C81F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829247AbgJ0TBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:39 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:45665 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371405AbgJ0TAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:38 -0400
Received: by mail-ej1-f66.google.com with SMTP id dt13so3733698ejb.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=az8VFET1WhsSjz7mH2nI1tqLyWgLT5pqSsqd01E44jk=;
        b=gYvXflCF2nRHKouN8rUg+66r7LcT/A3JBhr4+mN74JJ/6/B1k9eJmIM+CJko6qSSa2
         7WtM6lbLi81z7J+F9NdPIZ0S+nAR5zNNI6sxHzV/8LXPvxqafU1vocHiiOYBlbf4CacE
         /mujn1sPyp3vgsceIfkSVmkjUb+PffH8hdZSp/iKSb01qJywdPB6GolXrgRzBFxEVlUF
         pYR1oC3ekR77u7zMDqAh2qkNJxI5zCo+Zzu62slZryqkoeoC3llJnDvK0kNz9OstOPVy
         KrVDYALkoi3VmPsZuM1VAdBnKGQQki9LwfA9Ea+HXC/WJRLNR/AYh8Ob8rpc5WAEf1Dl
         3qog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=az8VFET1WhsSjz7mH2nI1tqLyWgLT5pqSsqd01E44jk=;
        b=PshdIAcCpGdw6xlPyFf71A8NKXCKUa5400q6BfNmWQd2lP02RbFbZjSOzO/XLquE4U
         2+r6GmhWRrKtUsExKEofgLrKkJ6K6lM/iMSq0CIdbIbp7mj8VylaNsOobQzxDeaM///s
         5AdCJlld3aX2Kerjhu7zRfp07k0jBJGihCSez88Nm1H65mSxnh53hLEHIUYTmyva/qO5
         1t83Jqed/6ZlYkC8NDOII0ZexcpxlxZeA6PhwgtpnuWT0+D3wIk+mPyVyf01WRYJnDez
         m9CQIQNMIlpft7ANbqPc35wuozBCcpTLtOtAsdbkZCREYCcWZj3vdPwqNKR3XDl2koTs
         q/pQ==
X-Gm-Message-State: AOAM532Hj72hqYsKRT03eHAKFDxH9Dnq7kgGZRQwKTyuOHHA4F3ca/Ub
        ph7PuedLQ/GhHtDvuruJjPs=
X-Google-Smtp-Source: ABdhPJy1BoIY1MAWnz+HMbho+sy2I/qs43uxBWGIPAHTYCZ0JSip9nhSKS6BG2SvOEHF57UnU5JiAA==
X-Received: by 2002:a17:906:c095:: with SMTP id f21mr4085503ejz.108.1603825236230;
        Tue, 27 Oct 2020 12:00:36 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id i17sm1480938edr.49.2020.10.27.12.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:35 -0700 (PDT)
Date:   Tue, 27 Oct 2020 21:00:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027190034.utk3kkywc54zuxfn@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027160530.11fc42db@nic.cz>
 <20201027152330.GF878328@lunn.ch>
 <87k0vbv84z.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0vbv84z.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 07:25:16PM +0100, Tobias Waldekranz wrote:
> > 1) trunk user ports, with team/bonding controlling it
> > 2) trunk DSA ports, i.e. the ports between switches in a D in DSA setup
> > 3) trunk CPU ports.
[...]
> I think that (2) and (3) are essentially the same problem, i.e. creating
> LAGs out of DSA links, be they switch-to-switch or switch-to-cpu
> connections. I think you are correct that the CPU port can not be a
> LAG/trunk, but I believe that limitation only applies to TO_CPU packets.

Which would still be ok? They are called "slow protocol PDUs" for a reason.

> In order for this to work on transmit, we need to add forward offloading
> to the bridge so that we can, for example, send one FORWARD from the CPU
> to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.

That surely sounds like an interesting (and tough to implement)
optimization to increase the throughput, but why would it be _needed_
for things to work? What's wrong with 4 FROM_CPU packets?

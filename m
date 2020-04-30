Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ABB1BECF0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgD3AWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726279AbgD3AWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:22:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD49C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:22:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d3so1880944pgj.6
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yTsv7V2khja28H4GAsx3q04P4vwATxNN2ArNlfsJ6gk=;
        b=AB7RvWGJXL2J7U3tk+CsmB/UfS1ujYnjsuNtGypA2P7a9L2EuYFMN5M5tOcpzsiL+1
         jgRSO7oNCIj9Mumh8z/Pfr0r8wC8GxTYTBZncF9JOtQmiDxtB4A0Focz5QQxUmtKD7jh
         g1XDpU1ni4DzYFaI5ntTQC0679HF7tpi4je68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yTsv7V2khja28H4GAsx3q04P4vwATxNN2ArNlfsJ6gk=;
        b=QGONYVfgc15QcyjuzrMBseDidBmtCBLx6qVJyU/zoQ0/YT5nZr/EfQSeOlSz1n3hIl
         evQl5AoBdP3aqrnejH8R6GU1v+N7BjoVM9V/9ndXX8xzk7C6EPnVw2xrb5VeaMZuPu44
         Qc3HVDs+8tcaTFeaemMX1oi/WcOJuEwuq9wgBpPHbw3WU33x/rh1avM0VYq36tWD8ZbC
         GU/1+2UXDIvtMVCvYAx8YdGf1UjbQK3P0W0P6UFRE83wf2lirorUSs4OhV9QmrXr7sYR
         vZ1Et1LCZnmU70ZaaeSawh+YcTnLaZ09QlWCdYoO7bV8D+Tur5hTk6GISz1TSwEc3P2S
         pjKw==
X-Gm-Message-State: AGi0PuYATH8T6crWqwbAZQOlxOW6MrmyREHxTSfDXrX138/27m9z74ef
        S7jIzjzp9UJj8MuKIiyqDGkHz3EZ00Y=
X-Google-Smtp-Source: APiQypKHASZfp/13ZJAO8uvwDtYLFYnIehOII+R3A+/H90JlQgxFFp/TPlfXV7+tvNtnJtTq9HA0pQ==
X-Received: by 2002:a05:6a00:12:: with SMTP id h18mr753411pfk.293.1588206141305;
        Wed, 29 Apr 2020 17:22:21 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id t20sm327544pjo.13.2020.04.29.17.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 17:22:20 -0700 (PDT)
Date:   Thu, 30 Apr 2020 09:22:16 +0900
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2 1/7] bridge: Use the same flag names in input
 and output
Message-ID: <20200430002216.GA76853@f3>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
 <20200427235051.250058-2-bpoirier@cumulusnetworks.com>
 <CAJieiUh0c1LCud2ZNuD5MygrBO=Yb1OgqHawxjgkX1j+6NHMrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUh0c1LCud2ZNuD5MygrBO=Yb1OgqHawxjgkX1j+6NHMrQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-29 08:12 -0700, Roopa Prabhu wrote:
> On Mon, Apr 27, 2020 at 4:51 PM Benjamin Poirier
> <bpoirier@cumulusnetworks.com> wrote:
> >
> > Output the same names for vlan flags as the ones accepted in command input.
> >
> > Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
> > ---
> 
> Benjamin, It's a good change,  but this will break existing users ?.

Nikolay voiced the same concern. The current output looks like

ben@f3:~$ bridge vlan
port    vlan ids
br0     None
tap0     1 PVID Egress Untagged

tap1     1 PVID Egress Untagged

docker0  1 PVID Egress Untagged

ben@f3:~$

"PVID Egress Untagged" look like 3 flags to me. Anything we can do to
improve it?

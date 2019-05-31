Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52A930824
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 07:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaFvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 01:51:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42905 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfEaFvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 01:51:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id e6so2140966pgd.9;
        Thu, 30 May 2019 22:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=MYPRUYP3oA69esLexspX9AtoNHw46k56bcJTABkkFBI=;
        b=mTgy1pHCOm1tPYRZVq1qiDAGtbY+RUvW6RZjOqsW1Ew6dpgvX4oyhILZuX+Z79B2xn
         RF/KYBJr5h4xPvBUmQaVxgPok8ptZxdGp0d5FKq6/ylayxT+2sFCyv7GEFEDYQXbYTc8
         ngC15hhxkFtNySHQkeGnqA9/1eXXBZ67p8jvABBD+ttCtPZmXxNLaXfFMd9/yvobEBBw
         MaI695nR57S+UzJKHOciZHuHRFNqyWAXzK09paRVw///rF3r2ZJJLTc+RUnzXOVfaJcX
         GcQ5bV1T0/ZfJhEJ0jpjkg7sw5bP2x/zSM095uvuNvmn7N9BXjD/8u/i+xle/bK70Ihv
         y/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MYPRUYP3oA69esLexspX9AtoNHw46k56bcJTABkkFBI=;
        b=fJC2a6jpien5bJF9xC9UmK8Q1pbfzWj73e4pMCLaIgxQof4yHr1YpP/fMYTWdvWSUO
         lTyNaRJfPRIEPgf52DV+uVL/Hdtj56ns7E5FSbbro6X6sX8/wAl9zQpSwEHtVPHMcDjL
         naP1hncH3xTd5f3ekqWBzERYmgPw7ENSI/dZgUgcTTJsopIuWl5LNtH2wtEJaSJsuFOO
         0jabnuZ5A/vH957YeAaiLicmHDpAfaWzNRmcHczXVvLEN6G80EMZKMbo7oV/u8mwBwJZ
         BfPFLHpDMvAtapbgcur6Fv5R8VmzxpucTWlKwWOH1HqM6Z9WvPP52PFvhoUbtQSt4hIj
         gJZQ==
X-Gm-Message-State: APjAAAU220d4NIptD6O2RtU7+2s/o3A5GQCrBbbthiPSXjSyimg4Tk24
        v8kP1fgzFL2ZqEzkZBlkiWE=
X-Google-Smtp-Source: APXvYqwSBur997yXvEG2Vlf7EJ76X8k3avsZ1enlSrzADo4EdOSveBbR/gIK8f17lYJkl1yyQHJvGA==
X-Received: by 2002:a17:90a:9602:: with SMTP id v2mr7185080pjo.59.1559281895654;
        Thu, 30 May 2019 22:51:35 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id l63sm5044813pfl.181.2019.05.30.22.51.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 22:51:34 -0700 (PDT)
Date:   Thu, 30 May 2019 22:51:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mark.rutland@arm.com, mlichvar@redhat.com, robh+dt@kernel.org,
        willemb@google.com
Subject: Re: [PATCH V4 net-next 0/6] Peer to Peer One-Step time stamping
Message-ID: <20190531055132.7qrjuqgtw6qw4mgh@localhost>
References: <cover.1559109076.git.richardcochran@gmail.com>
 <20190530.115507.1344606945620280103.davem@davemloft.net>
 <20190530.125833.1049383711116106790.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190530.125833.1049383711116106790.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 12:58:33PM -0700, David Miller wrote:
> I had to revert, this doesn't build.

Sorry I missed macvlan, and thanks for the 'uninitialized' warning.
It was a real latent bug.  I wonder why my linaro 7.4 gcc didn't flag
that...

Anyhow, I rebased v5 of my series to latest net-next, and I'm getting
a lot of these:

In file included from net/ipv6/af_inet6.c:45:0:
./include/linux/netfilter_ipv6.h: In function ‘nf_ipv6_br_defrag’:
./include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function ‘nf_ct_frag6_gather’; did you mean ‘nf_ct_attach’? [-Werror=implicit-function-declaration]
  return nf_ct_frag6_gather(net, skb, user);
         ^~~~~~~~~~~~~~~~~~
         nf_ct_attach


Thanks,
Richard

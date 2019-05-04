Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BCD137A1
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 07:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfEDFsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 01:48:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33182 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDFsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 01:48:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id s18so1008413wmh.0
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 22:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QJMBA4T907Zq8CUmgYL1TMjVQTOwnSECONXuNLpfnKs=;
        b=nGNYvm5q8CPOKoJu7dmjYeJr3evL8MacEbrvlRW8f3CvHErZpikiZw+gi2T+rya16k
         FpeT9mvLUamEHo/d9+hf4AaDPYDqXCweLfqGwBISaZgzkeFI2sRdZSlEn6WHrKLED+83
         JjcH+mD2BbsoiBBOEKfwxcqRG29TSxTIO731jCE7GXewwOFgpeGpr3616KHnpJDiXldH
         qUZzsxgGD49PLdAaM+MywrsovBQqEzvmHP3ZOwl0YUL1DtHkhE6B1OiM1yVmsNjgmN1I
         4XFbSwfHqUuqlqHND1zqPsZlapgCNnFJsqXB/DfUuQhiluvSD7Mnkp2WwU/PI5rfYn2m
         l6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QJMBA4T907Zq8CUmgYL1TMjVQTOwnSECONXuNLpfnKs=;
        b=Qc4RPP68RtQZCPRu9vpQRwsrtQ5FAZ4Nr8cI+2COoB46RL71bihkHJ/0R1/caE9IrM
         sq5XfDvMU7lMlqWv0ZhbrHdVqgxlTet2I6NlUTNX3w0JxLoKnUtE+D4dTkzc3ONEWfAv
         VIhywwLn38wQZoRQsXdy3JaUzNcw03nKbpT3ulUx+XYRpj6DDb4nPm2Jq3SOG2eYERgH
         EvM+UzfouLHnh+nJnL+9obLAZvVlSOMYb9Z1S198WRH3AQsjFryP0OWDJVwsEFZwm+Gs
         IOiQZo9HpoQefi+vFrm8T49agbrB8LtBTnu7WRWwdfCh+mYD9mPiiGY7IwQGj+FpdiFP
         j8wA==
X-Gm-Message-State: APjAAAU+CQSeJq6AA7neCz8qDMQKAd/KD364hgfKCol0J2td587G+kZQ
        JbiDTp0I3yJ3F5pFvBJNpYIbUg==
X-Google-Smtp-Source: APXvYqzCqPkiUqOnqISI5YKOUj7yshawrmws6qu7uzAE4Ew/AUNP+0UIEaNMKKlnoKH0T2hkHgf7SA==
X-Received: by 2002:a1c:f910:: with SMTP id x16mr8826096wmh.114.1556948889058;
        Fri, 03 May 2019 22:48:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c6sm3830135wmb.21.2019.05.03.22.48.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 22:48:08 -0700 (PDT)
Date:   Sat, 4 May 2019 07:48:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] flow_offload: Re-add various features
 that disappeared
Message-ID: <20190504054807.GB2189@nanopsycho>
References: <alpine.LFD.2.21.1905031538070.11823@ehc-opti7040.uk.solarflarecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1905031538070.11823@ehc-opti7040.uk.solarflarecom.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 03, 2019 at 04:59:28PM CEST, ecree@solarflare.com wrote:
>When the flow_offload infrastructure was added, a couple of things that
> were previously possible for drivers to support in TC offload were not
> plumbed through, perhaps because the drivers in the tree did not fully
> or correctly implement them.
>The main issue was with statistics; in TC (and in the previous offload
> API) statistics are per-action, though generally only on 'delivery'
> actions like mirred, ok and shot.  Actions also have an index, which
> may be supplied by the user, which allows the sharing of entities such
> as counters between multiple rules.  The existing driver implementations
> did not support this, however, instead allocating a single counter per
> rule.  The flow_offload API did not support this either, as (a) the
> action index never reached the driver, and (b) the TC_CLSFLOWER_STATS
> callback was only able to return a single set of stats which were added
> to all counters for actions on the rule.  Patch #1 of this series fixes
> (a) by storing tcfa_index in a new action_index member of struct
> flow_action_entry, while patch #2 fixes (b) by adding a new callback,
> TC_CLSFLOWER_STATS_BYINDEX, which retrieves statistics for a specified
> action_index rather than by rule (although the rule cookie is still   
> passed as well).
>Patch #3 adds flow_rule_match_cvlan(), analogous to
> flow_rule_match_vlan() but accessing FLOW_DISSECTOR_KEY_CVLAN instead
> of FLOW_DISSECTOR_KEY_VLAN, to allow offloading inner VLAN matches.
>This patch series does not include any users of these new interfaces;   
> the driver in which I hope to use them does not yet exist upstream as  
> it is for hardware which is still under development.  However I've CCed
> developers of various other drivers that implement TC offload, in case
> any of them want to implement support.  Otherwise I imagine that David
> won't be willing to take this without a user, in which case I'll save
> it to submit alongside the aforementioned unfinished driver (hence the
> RFC tags for now).

We need in-tree users of the API.


>
>Edward Cree (3):
>  flow_offload: copy tcfa_index into flow_action_entry
>  flow_offload: restore ability to collect separate stats per action
>  flow_offload: support CVLAN match
>
> include/net/flow_offload.h |  3 +++
> include/net/pkt_cls.h      |  2 ++
> net/core/flow_offload.c    |  7 +++++++
> net/sched/cls_api.c        |  1 +
> net/sched/cls_flower.c     | 30 ++++++++++++++++++++++++++++++
> 5 files changed, 43 insertions(+)

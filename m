Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D5F137BF
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 08:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfEDGXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 02:23:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34192 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDGXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 02:23:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so3799984pgt.1
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 23:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=njROTgSjEcbKBtd66ukNSidMMDCdmNt251/sKhb+qnk=;
        b=TGOWX1Y0wgwbff4qaBLfbIjULLRnrJSML+8L6xs3toCnbBozbFWA5p1gkpzEZrh4uT
         0Iw5AWlb5k5ljhF+BrxdCEkbF9E6O7cs2jyiitBusM+Qb8Sed7D2c1aIhVK4aJSmJyBH
         Dh97SZsOBPkF9gcvjy3t3STx+us709XHnyVpcP199kDvWGoeaM6YISHcafmD84evOGE0
         +f4aoIy/T1Urg5PJ8rM/E9smqDiVoQFgD1G3gamtaUYSlh7mZmOOe6Ww5kiTKbX0K00T
         Cw3uM15Gnri7ZHJubpKNWPCQ7gNkwU74mt2mnKb9PjLePHwlGjGB0HEVyCFDKESymgAJ
         VJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=njROTgSjEcbKBtd66ukNSidMMDCdmNt251/sKhb+qnk=;
        b=ChzFd22knefYL0DZHfBBNI897Awnlh2ZRIXREyMY64Tzt/CDs61A79Uf5ctePcx818
         /8EMOLhvA2FuxRWr9EhiTOeX0CTiyGYLzeL+AF8SV8s8ilPNQvIPD+Im8bG6XOTgaO8N
         W/0Wyy8u8GfXkw+TFgH3jYnYiqm82RnBpkrukTtuJkknDSgDYZ5S02Qa0KS178RoyUL6
         aeOHKP1JOEFMcvvQ3ITto+b+Y/zqROpsYl3ccltVYdHfCwnlZLuf/BkXMISbHQCamxkG
         OzjqeJilrnD2v6mLytxeV9AXcS5TBLHQBBImqi076ceBekY8MIcCk1f+1gVvQ25PXjqC
         RBGg==
X-Gm-Message-State: APjAAAVkMxGB7OvS4KImqqzp/SWVfC9cxjnJcu5SsuiBsk1rrwwx59Lm
        2xzEy2pCMy2KQL6gGKm4knLRhw==
X-Google-Smtp-Source: APXvYqySeaLxdsi/do5BwCJGnDCUb0eGgwukJsjyTbVO3wQemzoTkDbKNPWoPFMz6WEsJ1XvtutysQ==
X-Received: by 2002:a63:af0a:: with SMTP id w10mr16176710pge.67.1556951022441;
        Fri, 03 May 2019 23:23:42 -0700 (PDT)
Received: from cakuba.netronome.com (ip-184-212-224-194.bympra.spcsdns.net. [184.212.224.194])
        by smtp.gmail.com with ESMTPSA id d67sm6662804pfa.35.2019.05.03.23.23.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 03 May 2019 23:23:42 -0700 (PDT)
Date:   Sat, 4 May 2019 02:23:27 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        "Or Gerlitz" <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] flow_offload: Re-add various features
 that disappeared
Message-ID: <20190504022327.49372c1e@cakuba.netronome.com>
In-Reply-To: <alpine.LFD.2.21.1905031538070.11823@ehc-opti7040.uk.solarflarecom.com>
References: <alpine.LFD.2.21.1905031538070.11823@ehc-opti7040.uk.solarflarecom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 May 2019 15:59:28 +0100, Edward Cree wrote:
> When the flow_offload infrastructure was added, a couple of things that
>  were previously possible for drivers to support in TC offload were not
>  plumbed through, perhaps because the drivers in the tree did not fully
>  or correctly implement them.
> The main issue was with statistics; in TC (and in the previous offload
>  API) statistics are per-action, though generally only on 'delivery'
>  actions like mirred, ok and shot.  Actions also have an index, which
>  may be supplied by the user, which allows the sharing of entities such
>  as counters between multiple rules.  The existing driver implementations
>  did not support this, however, instead allocating a single counter per
>  rule.  The flow_offload API did not support this either, as (a) the
>  action index never reached the driver, and (b) the TC_CLSFLOWER_STATS
>  callback was only able to return a single set of stats which were added
>  to all counters for actions on the rule.  Patch #1 of this series fixes
>  (a) by storing tcfa_index in a new action_index member of struct
>  flow_action_entry, while patch #2 fixes (b) by adding a new callback,
>  TC_CLSFLOWER_STATS_BYINDEX, which retrieves statistics for a specified
>  action_index rather than by rule (although the rule cookie is still   
>  passed as well).
> Patch #3 adds flow_rule_match_cvlan(), analogous to
>  flow_rule_match_vlan() but accessing FLOW_DISSECTOR_KEY_CVLAN instead
>  of FLOW_DISSECTOR_KEY_VLAN, to allow offloading inner VLAN matches.
> This patch series does not include any users of these new interfaces;   
>  the driver in which I hope to use them does not yet exist upstream as  
>  it is for hardware which is still under development.  However I've CCed
>  developers of various other drivers that implement TC offload, in case
>  any of them want to implement support.  Otherwise I imagine that David
>  won't be willing to take this without a user, in which case I'll save
>  it to submit alongside the aforementioned unfinished driver (hence the
>  RFC tags for now).

Thanks for making this clear, I'd also like to make a disclaimer
that my comments on the patches are not an indication that I think 
these patches are worth merging right now :)

> Edward Cree (3):
>   flow_offload: copy tcfa_index into flow_action_entry
>   flow_offload: restore ability to collect separate stats per action
>   flow_offload: support CVLAN match
> 
>  include/net/flow_offload.h |  3 +++
>  include/net/pkt_cls.h      |  2 ++
>  net/core/flow_offload.c    |  7 +++++++
>  net/sched/cls_api.c        |  1 +
>  net/sched/cls_flower.c     | 30 ++++++++++++++++++++++++++++++
>  5 files changed, 43 insertions(+)


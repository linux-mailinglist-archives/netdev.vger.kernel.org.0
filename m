Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2617182523
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgCKWoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:44:21 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45399 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729799AbgCKWoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:44:20 -0400
Received: by mail-qk1-f194.google.com with SMTP id c145so3797191qke.12
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SbIvSmmQeGQqWtW/2yAu4gZzrLp8oN8jciHho/fNeSU=;
        b=dRBFPJ5NqXODNCPNUtwGL0d9vaHYg0fvFhbj8I3rLgJuCb0GOIYZEwqaoVA/BvpG65
         q/fPAjIpEPUQV5iuOkinDWFkX5I2jkQj4o/qdiUXaK4ABGDhGE8BVut854X0z+UyLc95
         Eev9YSdJBFPOcaXboszCxSFtJXq9xqF2//AEaOfp8i1SAeb7oyMVPzfXfSjekE1Uosp8
         BdeGqmavMm60ovKNpWNoZIxe2GJ8BvHRdR5KtJXd/g1vZY00R3EyyzIdgnCaKuQR+dfU
         watv0XicJ1AXrIdTLoDZsQAK49Uoi3KmLIC9BG6kTXyUkDVheUxy2VrcbsPuoZMJcqeq
         eLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SbIvSmmQeGQqWtW/2yAu4gZzrLp8oN8jciHho/fNeSU=;
        b=BpXyLma2ehfMQNz84rijoYBQYH01d9XcYnHxSNibgGjpbe9sBG1Ck1Ky3Bi+Hi907Z
         wyOzUwda4jmtwY3boiSbbBSOA1eNWFl8y4g5T3m1l4EKALto7C3PfRs1tm396/UnaTfk
         hV5FyKIbjNQ4rrGOyCOu3qORr2rVchNICoYFAu6Gix/7xYDzh5RXweC4iEzNKrUQeqeI
         GnGUkxIrwBVcdUxGraayb3RoL5t8XjKy2bb0vFSP+IADdPvloE2HMhzAAGmqlAlkBCbr
         aWODotZ1eLhI/+xXchy6askHEB7K80LcWctBw64wUc87ExV6zp9gBbb+8NPTOckMYGVR
         zjiw==
X-Gm-Message-State: ANhLgQ1tHb9Xy/jG5ITDsymN7XPBO0YXeRQcAyOVxTLWifBtoxCi2rao
        aumhc0qE5uy71kTIRDgXdtqZbf27Kio5Kg==
X-Google-Smtp-Source: ADFU+vtQV4JUsfDZ3AIrBfHyhH+fEBYeN5x+OBMGwhkLr/+6d9l7c3+HgQdh1FDFifyyXgePjy8zTQ==
X-Received: by 2002:a05:620a:1eb:: with SMTP id x11mr4839679qkn.135.1583966658355;
        Wed, 11 Mar 2020 15:44:18 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.211])
        by smtp.gmail.com with ESMTPSA id v1sm7991882qkd.74.2020.03.11.15.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 15:44:17 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 15B0FC58F6; Wed, 11 Mar 2020 19:44:15 -0300 (-03)
Date:   Wed, 11 Mar 2020 19:44:15 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next ct-offload v3 00/15] Introduce connection
 tracking offload
Message-ID: <20200311224415.GL3614@localhost.localdomain>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <20200311191353.GL2546@localhost.localdomain>
 <511542c9-2028-a5a8-4e4a-367b916a7f1c@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511542c9-2028-a5a8-4e4a-367b916a7f1c@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 12:27:37AM +0200, Paul Blakey wrote:
> 
> On 11/03/2020 21:13, Marcelo Ricardo Leitner wrote:
> > On Wed, Mar 11, 2020 at 04:33:43PM +0200, Paul Blakey wrote:
> >> Applying this patchset
> >> --------------------------
> >>
> >> On top of current net-next ("r8169: simplify getting stats by using netdev_stats_to_stats64"),
> >> pull Saeed's ct-offload branch, from git git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
> >> and fix the following non trivial conflict in fs_core.c as follows:
> >> #define OFFLOADS_MAX_FT 2
> >> #define OFFLOADS_NUM_PRIOS 2
> >> #define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)
> >>
> >> Then apply this patchset.
> > I did this and I couldn't get tc offloading (not ct) to work anymore.
> > Then I moved to current net-next (the commit you mentioned above), and
> > got the same thing.
> >
> > What I can tell so far is that 
> > perf script | head
> >        handler11  4415 [009]  1263.438424: probe:mlx5e_configure_flower__return: (ffffffffc094fa80 <- ffffffff93dc510a) arg1=0xffffffffffffffa1
> >
> > and that's EOPNOTSUPP. Not sure yet where that is coming from.
> 
> I guess you fail at what this patch "flow_offload: fix allowed types check" is suppose to fix
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a393daa8993fd7d6c9c33110d5dac08bc0dc2696
> 
> That was the last bug that caused what you decribe - all tc rules failed.
> 
> It should be before the patch I detailed as seen in git log here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/log/
> 
> 
> Can you check you have it? im not sure if compiling just the driver is enough.

I had this one, in both tests.

> 
> if it is this, it should have fixed it.
> 
> if not try skipping flow_action_hw_stats_types_check() calls in mlx5 driver.

Ok. This one was my main suspect now after some extra printks. I could
confirm it parse_tc_fdb_actions is returning the error, but not sure
why yet.

> 
> there is a netlink error msg most of the cases, try skip_sw or verbose to see.

Yeah.. that probably would be easier, thanks. I'm using it under OvS
and without skip_sw, got just no logs for it.

> 
> >
> > Btw, it's prooving to be a nice exercise to find out why it is failing
> > to offload. Perhaps some netdev_err_once() is welcomed.
> >
> >   Marcelo

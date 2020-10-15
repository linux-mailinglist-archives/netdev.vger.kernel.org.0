Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0683128EE52
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 10:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbgJOIPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 04:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387916AbgJOIPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 04:15:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE933C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 01:15:10 -0700 (PDT)
Date:   Thu, 15 Oct 2020 10:15:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602749709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kXi0AV4ZSGJ6xK6fGDVSvykffD8W53/teT5BVDLdh5o=;
        b=eN5XY3K2nKNnzARr0GjqW1HB+6S3oG1YwD7qv4BHlR7X1aja65Sc5gxZZL4euPAHM5yHzs
        B1svAdeMzieVVHPFmJXLrl1uH01pgokIOMhdB6n8Kf22PNS2YKmCQyJFvIvQbcHqhj31gv
        jwX0ml5w6Cj/h0TFdURjAmPAp35+Htkw14QAB9JhYjlo4QKXjpm5Yt5F9qoJTarHuj77GJ
        +HJshx8VcNKIDnXdCs6LMvYcQCE1+pBDL+tb2k1bl3rW36SnAq5+Oy8kabQ/FecGwHT1QC
        OET8LS9kjSr0KwxaaQMMMsoBf9OkArNZql5/0oi6wve0FxWhI98/9012s549DQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602749709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kXi0AV4ZSGJ6xK6fGDVSvykffD8W53/teT5BVDLdh5o=;
        b=Sci56VQDr5w0fuA2ujRJgl/OO9i/V276dnTg2reiLBo9TXiBNBF/UVRSP62eBYPVB5GQjn
        gaZSdPhmXlW3TmBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        jlelli@redhat.com
Subject: Re: [PATCH net-next] net: openvswitch: fix to make sure
 flow_lookup() is not preempted
Message-ID: <20201015081507.lzacl6qcskzredn4@linutronix.de>
References: <160259304349.181017.7492443293310262978.stgit@ebuild>
 <20201013125307.ugz4nvjvyxrfhi6n@linutronix.de>
 <3D834ADB-09E7-4E28-B62F-CB6281987E41@redhat.com>
 <20201015075517.gjsebwhqznj6ypm3@linutronix.de>
 <80D4D885-0E28-4B29-8C1E-34F5FBB6CF38@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80D4D885-0E28-4B29-8C1E-34F5FBB6CF38@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-15 10:11:31 [+0200], Eelco Chaudron wrote:
> Thanks for your reply! Yes I had it replaced with local_bh_disable() in my
> v2, as I noticed the hard IRQ to softirq part earlier.

Okay. Resend the complete thing once you ready and I take a look.

> Thanks,
> 
> Eelco

Sebastian

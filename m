Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3D5BE5F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfGAOeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:34:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38021 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727064AbfGAOeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 10:34:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AA39621FC1;
        Mon,  1 Jul 2019 10:34:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 01 Jul 2019 10:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dead10ck.com; h=
        message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        W71MN8JnqffLQ5MZmuiO5lF4wUj46V9qQyxbK4q2Jm8=; b=aD9v0GWC3W5rGJ0N
        hZrs6CE3D3Ghop3TDwsx6S8MFMwVgqcGbPF08Al22+9pR8bxmDSxyKd14CsjHcJS
        nwIg9371XXXuyIHqRlKvxnEzXnXjW6leYkcLTAFanR+AaZ90BFlDJFDOjkqaRl02
        p8nbK2DnK/Jniogy5uEaXQ2LXcOFCZu5AefuI26xL5rLBR1kNkuvJ6mRTBau6WnA
        B7JEL0Nvm0cILzSis5bSsvbLsrUrvMFvItWi+7Rs54vrHoY0Ch4vLDYAsLMdseE4
        H3p1aLcudIo+nqtnLz9+PpIi4ekznW0iod8hAtf67D7EtFI0TI3BxwIkJVb1aOK8
        x08QHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=W71MN8JnqffLQ5MZmuiO5lF4wUj46V9qQyxbK4q2J
        m8=; b=MWat1hzZ8ewg4/ly7nL+MXVdJHBrDNAwPUp5CclsqLGYbSPXYLRgcQICR
        VfFcLK0d/0wJY9bZACcJFwhUvBCxc3/Nc7xQcZ11QmGqV8qqHCHupKCAXVuZyLbF
        bsrktldB4daL9BSpEWULhM0rXEpdaZXZ7XnfPaXXgzve5O6wB476zeXbKB9n3Fmq
        DxfwfkqmyfHP8jacxnRTRLolN4emXqz0P1gAfScE2vRBWDhHOK7lZwrcVfGfLBD4
        U7P5PmbAIgmG7/jfBvOg5r1hY8abdt7jiFAaDtTS6bJAnDptfZHcVHU09uX/hB0t
        eNxsOtuhkSHa56O42pEyjzrFDFSKA==
X-ME-Sender: <xms:5RkaXeg9zFJyhL7d9fKp2jec9rAX-rQvX5B-6xAeakVDu8XPikKSXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepkffuhffvffgjfhgtfggggfesthejre
    dttderjeenucfhrhhomhepufhkhihlvghrucfjrgifthhhohhrnhgvuceoshhkhihlvghr
    seguvggrugdutdgtkhdrtghomheqnecukfhppedujedurdeikedrvdeggedrheejnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehskhihlhgvrhesuggvrgguuddttghkrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:5RkaXU5Pe4SgI3dTU7x5NY8mkn58j_AR93gUg0sylnp5esnz9VX2IQ>
    <xmx:5RkaXRRvMQo00SfWTo1q8IoZXKdwcIay2H8yDcj_bQ_6X8Duq27OOA>
    <xmx:5RkaXRXIXdeb3tEH260c58h3it14WZSPq-SC2hPHfoqygeSzHNPFDw>
    <xmx:5RkaXSmDSuf2P6dLd62S_tXTMWsr0MDUpw7p-PKcIU8fOscZci3nBg>
Received: from fedora-x1-dead10ck (unknown [171.68.244.57])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E362380087;
        Mon,  1 Jul 2019 10:34:12 -0400 (EDT)
Message-ID: <7cc8efb985c2e770a328919e1b99d93f30d7295a.camel@dead10ck.com>
Subject: Re: iwl_mvm_add_new_dqa_stream_wk BUG in lib/list_debug.c:56
From:   Skyler Hawthorne <skyler@dead10ck.com>
To:     Marc Haber <mh+netdev@zugschlus.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Mon, 01 Jul 2019 07:34:11 -0700
In-Reply-To: <20190625130317.GB31363@torres.zugschlus.de>
References: <20190530081257.GA26133@torres.zugschlus.de>
         <20190602134842.GC3249@torres.zugschlus.de>
         <20190625130317.GB31363@torres.zugschlus.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I'm also still experiencing this issue on 5.1.15. It's making it
very difficult to use my work laptop in my office, since it has many
access points and frequently has to reauthenticate. I hit this bug 1-3
times per day, and the only way to fix it is a hard shutdown. Has there
been any effort to identify and/or fix the cause?

-- 
Skyler

On Tue, 2019-06-25 at 15:03 +0200, Marc Haber wrote:
> On Sun, Jun 02, 2019 at 03:48:42PM +0200, Marc Haber wrote:
> > On Thu, May 30, 2019 at 10:12:57AM +0200, Marc Haber wrote:
> > > on my primary notebook, a Lenovo X260, with an Intel Wireless
> > > 8260
> > > (8086:24f3), running Debian unstable, I have started to see
> > > network
> > > hangs since upgrading to kernel 5.1. In this situation, I cannot
> > > restart Network-Manager (the call just hangs), I can log out of
> > > X, but
> > > the system does not cleanly shut down and I need to Magic SysRq
> > > myself
> > > out of the running system. This happens about once every two
> > > days.
> > 
> > The issue is also present in 5.1.5 and 5.1.6.
> 
> Almost a month later, 5.1.15 still crashes about twice a day on my
> Notebook. The error message seems pretty clear to me, how can I go on
> from there and may be identify a line number outside of a library?
> 
> Greetings
> Marc
> 
> 


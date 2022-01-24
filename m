Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86715497D98
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 12:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237055AbiAXLHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 06:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiAXLHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 06:07:45 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2FEC06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 03:07:44 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3FDECC020; Mon, 24 Jan 2022 12:07:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643022462; bh=906aLdz+I0qRY+XLR4gRuQlCFXv/vWmRdftupy1Lgho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hSTRij+LjZvgH3iI09q+YCYC3/nYSyMJggUHag9ITyl6B5rvvi0AnqpANX7T9j7Kb
         Oa+XwWV9Qtr8wpS21mW4DxN/0j61pRDt8poCjpBlVotPKkRoft0tPeIlMsnmIYaaqH
         ScrB4XB+AjB9Bq1qfpaub3Mw7yuOO/Lgj9CWMd6N/ggG5vPP07rxMnh5Jlmh5S+KVy
         MAriMAuIfRh38qi0D8nCAF/z7EtcYl/oKXOAq3ECAL8rxbtiDxvemSiIEf8WZamcK5
         sCJDIz2fKZShc8VrWHEVefKlyJCEOn93Ppo3kWur1kAFXwxxcxQu9FDfIPpNnteLpx
         WWWCMz9JGatjw==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 026DDC009;
        Mon, 24 Jan 2022 12:07:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643022461; bh=906aLdz+I0qRY+XLR4gRuQlCFXv/vWmRdftupy1Lgho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sv12hwipGD3L76wBT+IIKrDkWsrmRVO5141hMCyIXuXjEQUg2XALVqYYkpn3ZbMHG
         +cSn0wJXYRHnQDWD8U6qzQL04bqaNMcJSPtD0p25tce0zyC45PffOjv58nNq5Ux5Hn
         +3dysbxuHI2Cz/Jpx18wAbLrp1PcfzGkoAa/zmr0lRE6wWQbDj1obn+cEhyc5t0TK9
         PmAkcaBqOo5KfstN8QQDr+wcVrKk64QD/JMm21w03PmlT7XnhRKh3R3/9HYkS16Zca
         KhIoiavYKcaHcfBAggLg7g8LL32YlEh9BIzLHza9izYT9iEZPe/MeX1nw8jBNYzfDw
         +o+ThYtJCR8yw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b04e8f30;
        Mon, 24 Jan 2022 11:07:35 +0000 (UTC)
Date:   Mon, 24 Jan 2022 20:07:20 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Nikolay Kichukov <nikolay@oldum.net>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Message-ID: <Ye6IaIqQcwAKv0vb@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <29a54acefd1c37d9612613d5275e4bf51e62a704.camel@oldum.net>
 <1835287.xbJIPCv9Fc@silver>
 <5111aae45d30df13e42073b0af4f16caf9bc79f0.camel@oldum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5111aae45d30df13e42073b0af4f16caf9bc79f0.camel@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay Kichukov wrote on Mon, Jan 24, 2022 at 11:21:08AM +0100:
> It works, sorry for overlooking the 'known limitations' in the first
> place. When do we expect these patches to be merged upstream?

We're just starting a new development cycle for 5.18 while 5.17 is
stabilizing, so this mostly depends on the ability to check if a msize
given in parameter is valid as described in the first "STILL TO DO"
point listed in the cover letter.

I personally would be happy considering this series for this cycle with
just a max msize of 4MB-8k and leave that further bump for later if
we're sure qemu will handle it.
We're still seeing a boost for that and the smaller buffers for small
messages will benefit all transport types, so that would get in in
roughly two months for 5.18-rc1, then another two months for 5.18 to
actually be released and start hitting production code.


I'm not sure when exactly but I'll run some tests with it as well and
redo a proper code review within the next few weeks, so we can get this
in -next for a little while before the merge window.

-- 
Dominique

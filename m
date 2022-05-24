Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817E0532524
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiEXIUz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 May 2022 04:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbiEXIUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:20:54 -0400
X-Greylist: delayed 559 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 May 2022 01:20:53 PDT
Received: from mail.oldum.net (86-87-34-132.fixed.kpn.net [86.87.34.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B7AF5DBDC
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:20:53 -0700 (PDT)
Received: from [10.1.0.200] (unknown [10.1.0.200])
        by mail.oldum.net (Postfix) with ESMTPA id 46BFAA7531;
        Tue, 24 May 2022 08:10:36 +0000 (UTC)
Message-ID: <2380b79f721caf9e6b99aa680b9b29c76fd4e2f4.camel@oldum.net>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
From:   Nikolay Kichukov <nikolay@oldum.net>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Date:   Tue, 24 May 2022 10:10:31 +0200
In-Reply-To: <Ye6IaIqQcwAKv0vb@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
         <29a54acefd1c37d9612613d5275e4bf51e62a704.camel@oldum.net>
         <1835287.xbJIPCv9Fc@silver>
         <5111aae45d30df13e42073b0af4f16caf9bc79f0.camel@oldum.net>
         <Ye6IaIqQcwAKv0vb@codewreck.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dominique,

On Mon, 2022-01-24 at 20:07 +0900, Dominique Martinet wrote:
> Nikolay Kichukov wrote on Mon, Jan 24, 2022 at 11:21:08AM +0100:
> > It works, sorry for overlooking the 'known limitations' in the first
> > place. When do we expect these patches to be merged upstream?
> 
> We're just starting a new development cycle for 5.18 while 5.17 is
> stabilizing, so this mostly depends on the ability to check if a msize
> given in parameter is valid as described in the first "STILL TO DO"
> point listed in the cover letter.
> 
> I personally would be happy considering this series for this cycle
> with
> just a max msize of 4MB-8k and leave that further bump for later if
> we're sure qemu will handle it.
> We're still seeing a boost for that and the smaller buffers for small
> messages will benefit all transport types, so that would get in in
> roughly two months for 5.18-rc1, then another two months for 5.18 to
> actually be released and start hitting production code.
> 
> 
> I'm not sure when exactly but I'll run some tests with it as well and
> redo a proper code review within the next few weeks, so we can get
> this
> in -next for a little while before the merge window.
> 

Did you make it into 5.18? I see it just got released...

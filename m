Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444FB5EE9DB
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 01:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiI1XGA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 19:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1XF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 19:05:59 -0400
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265072BB0A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:05:58 -0700 (PDT)
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id 58E99160E52;
        Wed, 28 Sep 2022 23:00:05 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 7ECB72002C;
        Wed, 28 Sep 2022 22:59:56 +0000 (UTC)
Message-ID: <8101cb98ab2993bf24720507be13f8d54233a161.camel@perches.com>
Subject: Re: [PATCH linux-next] net: atm: Convert to use
 sysfs_emit()/sysfs_emit_at() APIs
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, zhangsongyi.cgel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zhang.songyi@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Date:   Wed, 28 Sep 2022 16:00:02 -0700
In-Reply-To: <20220927070134.7cde492d@kernel.org>
References: <20220927064649.257988-1-zhang.songyi@zte.com.cn>
         <20220927070134.7cde492d@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: nx7gnb8wofr4s6pb9yy8gkff9qni1bjy
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 7ECB72002C
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/vpFXlWlXx/p7iE1oC4hX+AXIdI5C4TU8=
X-HE-Tag: 1664405996-276980
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-09-27 at 07:01 -0700, Jakub Kicinski wrote:
> On Tue, 27 Sep 2022 06:46:49 +0000 zhangsongyi.cgel@gmail.com wrote:
> > From: zhang songyi <zhang.songyi@zte.com.cn>
> > 
> > Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> > should only use sysfs_emit() or sysfs_emit_at() when formatting the value
> > to be returned to user space.
> 
> Is there an end goal to this?

To make it easier to validate all other kernel uses of
sprintf/snprintf/scnprintf.

> If the code is correct let's leave 
> it as is. ATM is hopefully going to be deleted soon.

<shrug>  The code is correct as-is.

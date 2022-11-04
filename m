Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989FA619FB0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiKDSWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiKDSWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:22:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1273969DE4;
        Fri,  4 Nov 2022 11:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA974B82F44;
        Fri,  4 Nov 2022 18:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C3BC433C1;
        Fri,  4 Nov 2022 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667586086;
        bh=XC/QgoFABCtt5id0P0eOyEaGKme/20TWFv03eLRsm0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gFh/dAArvATpn5/naOaRff19syg7p5VcCSiqiLWJd+8gwl1tCEgjwzhm3LyrkyZyd
         O5SnGIqqgaPIpVDa21wwtWJrvuAhRNNcpTb8elxQIF1mX5V9fSZRqg2DAcnYOu7dmL
         AGXpqefK+eZXlMGY1qBTaggUTfKuOluZdjyc5qzEVJhd1qY82ooa6zH6NyCYbeA1z5
         EmAHBCkpiPsoew2esAlpP8a32gOb2DAvgmC8qJ9YNvxxmemoTB2ejknjPj2INt8SGl
         i51LidOxiEjD66AuLnov9PEHQZlSd++86yxXuzvEcofgToZnMR4r+8cF660mCh9JHR
         W0SuRMjJS+UQg==
Date:   Fri, 4 Nov 2022 11:21:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+7cc0a430776e7900c5e7@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, jacob.e.keller@intel.com, jiri@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paul@paul-moore.com, razor@blackwall.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] bpf-next boot error: WARNING in genl_register_family
Message-ID: <20221104112125.1e640a6c@kernel.org>
In-Reply-To: <00000000000092429f05ec933622@google.com>
References: <00000000000092429f05ec933622@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Nov 2022 09:11:43 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b54a0d4094f5 Merge tag 'for-netdev' of https://git.kernel...
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=144ee346880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53cedb500b7b74c6
> dashboard link: https://syzkaller.appspot.com/bug?extid=7cc0a430776e7900c5e7
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

#syz dup: upstream boot error: WARNING in genl_register_family

cmon now.

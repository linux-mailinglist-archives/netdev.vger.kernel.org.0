Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAF34C60A8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbiB1Bjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiB1Bjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:39:40 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79E4220DD;
        Sun, 27 Feb 2022 17:39:01 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id CD60CC021; Mon, 28 Feb 2022 02:38:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1646012335; bh=ppd2glzcFuscrKkv8TaEP18WFv+ORpmIkkSFkUHICKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=soJF5RcOsYnglkImQtb9pIl/qP0khiWeql+7Q6WwujVLmRGcXKH3MDHyZJoDXkoNZ
         nfLwdNmR94ipRhpfU/yGGtQ0CCPAl+7FpblPZV8W/XGjkCEuWOVtaj1L3iJZNb1N2c
         CdFOmEkUilyqU7UyR5ey2DFe4qxL2CTrCOVK5hn01HnX0h1O+PjEcdIRgQrW8XJmxl
         H+hkzWGGaj+LESdwk6Ju5LgHdmiE30kl8numPoA7Ri/9ofIaiBnajtGSDvwJu4XUQA
         5b720TWpoaAk8d9fQ/2jmPHL9z5lscohyyh4S3MA6L5C1XoE86p8B9XZe5Z5DVVfvD
         as1TbQlailyOw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 12DEEC009;
        Mon, 28 Feb 2022 02:38:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1646012334; bh=ppd2glzcFuscrKkv8TaEP18WFv+ORpmIkkSFkUHICKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1PSLUt443Hf1hB90umtNGuJtN+Kh6sjXkX8fXCfBQZMFA0VTGkp2DjToqsTKDv02n
         bxMx5jkWll/W/NDF6NCs8nWS1/04hJh9N3rUtC8UPxDJBokFK26va6822UCXfQ9xxN
         TZejmVbF+paZ96VIN1n1A8vABAf9WTp8XyDdVH0Ejy9JeFmI/7lGwA8J4AfcKDsF3O
         Wogq7gjlWn8wiNDOYgOE9uLcnb5zNlpwVm5cNs1qNHmP9+Mv8DVxtqDl+E49qffKqP
         gMWaZZ+ipQvc9z3R1bgkEFr2Lp1z6fNdJFhRMv4YwFM4rRCWZF1lgGPFCUVnwZaWhD
         Xf4n2h+Q2d0OQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 9b6fd6d8;
        Mon, 28 Feb 2022 01:38:48 +0000 (UTC)
Date:   Mon, 28 Feb 2022 10:38:33 +0900
From:   asmadeus@codewreck.org
To:     syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, ericvh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux_oss@crudebyte.com,
        lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] WARNING in p9_client_destroy
Message-ID: <YhwnmR5hbseg0EJd@codewreck.org>
References: <00000000000011f0c905d9097a62@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00000000000011f0c905d9097a62@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote on Sun, Feb 27, 2022 at 04:53:29PM -0800:
> kmem_cache_destroy 9p-fcall-cache: Slab cache still has objects when
> called from p9_client_destroy+0x213/0x370 net/9p/client.c:1100

hmm, there is no previous "Packet with tag %d has still references"
(sic) message, so this is probably because p9_tag_cleanup only relies on
rcu read lock for consistency, so even if the connection has been closed
above (clnt->trans_mode->close) there could have been a request sent
(= tag added) just before that which isn't visible on the destroying
side?

I guess adding an rcu_barrier() is what makes most sense here to protect
this case?
I'll send a patch in the next few days unless it was a stupid idea.
-- 
Dominique

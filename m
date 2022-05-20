Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4324452ED80
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349964AbiETNt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 09:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiETNtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 09:49:55 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665B716D487;
        Fri, 20 May 2022 06:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GJGrGL+DVcHuhI2r84CqAD4dzEKyqLSzvpB5MkYxmUM=; b=qWlrAWtiiSwwBulv4IYFR9fEOz
        6FcXu7NOEcQVvL4/TxgBlw1rhpVym0B86FlkPfClxMuSXzIJJ+V5/ZRkFy1Gs2XhmLPpzXGO9Xgn7
        PqBOMo//RkZZe761KFF5z6INgOjL6ocASL7q9oUygcJaH+j34p0EFc43B8hRdM2+Dg1s=;
Received: from p200300daa70ef200f0b63cecc7e2566c.dip0.t-ipconnect.de ([2003:da:a70e:f200:f0b6:3cec:c7e2:566c] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ns30a-0002dC-NH; Fri, 20 May 2022 15:49:36 +0200
Message-ID: <39b34170-cf98-72fc-881f-ce0e42573f66@nbd.name>
Date:   Fri, 20 May 2022 15:49:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: linux-next: build failure after merge of the net-next tree
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20220520145957.1ec50e44@canb.auug.org.au>
 <20220519222044.1106dbd7@kernel.org> <YodFzAu0gSSMdJIz@salvia>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <YodFzAu0gSSMdJIz@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20.05.22 09:39, Pablo Neira Ayuso wrote:
> On Thu, May 19, 2022 at 10:20:44PM -0700, Jakub Kicinski wrote:
>> On Fri, 20 May 2022 14:59:57 +1000 Stephen Rothwell wrote:
>> > Hi all,
>> > 
>> > After merging the net-next tree, today's linux-next build (x86_64
>> > allmodconfig) failed like this:
>> 
>> FWIW just merged the fix, if you pull again you'll get this and a fix
>> for the netfilter warning about ctnetlink_dump_one_entry().
> 
> Thanks.
> 
> Felix forgot to include the update for the mtk driver in his batch it
> seems.
I didn't forget. It was in the series I posted for -next but I had to 
remove it to rebase the patch onto nf (as requested by you).
The affected code didn't exist in nf.git.

- Felix

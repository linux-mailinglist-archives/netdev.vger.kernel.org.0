Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9C3646215
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 21:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiLGUGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 15:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLGUGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 15:06:47 -0500
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3FE6C732;
        Wed,  7 Dec 2022 12:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4pkkDfj8/z2wjP6+ipYSIxvDx4P21iaoCI856nFOG6M=; b=kQyixU2x6dnB0K07KIYpnRwABm
        oT8G6d0gCHz3uklCVoq7plYNvPogI2/9UdjXT5vKYE0CPiMn4l6qo9PzbJM8ae0R4yaf/fXS81est
        t957us+egt3vB0f2cIBmiGsXkJ+7KXEaEB8E3Zr/LHtrz+Oa0uN45yEj+Fk1e8lsgPn4=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p30gn-0000x9-G3; Wed, 07 Dec 2022 21:06:45 +0100
Message-ID: <4a4b3448-bfcf-1640-3a57-dcaba35398c4@engleder-embedded.com>
Date:   Wed, 7 Dec 2022 21:06:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 2/6] tsnep: Add XDP TX support
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
 <20221203215416.13465-3-gerhard@engleder-embedded.com>
 <619913f8fc11ab502e73d526eee7ada6066843a2.camel@redhat.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <619913f8fc11ab502e73d526eee7ada6066843a2.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.12.22 11:26, Paolo Abeni wrote:
> On Sat, 2022-12-03 at 22:54 +0100, Gerhard Engleder wrote:
>> For complete TX support tsnep_xdp_xmit_back() is already added, which is
>> used later by the XDP RX path if BPF programs return XDP_TX.
> 
> Oops, I almost forgot... It's better to introduce tsnep_xdp_xmit_back()
> in the patch using it: this patch introduces a build warning fixed by
> the later patch, and we want to avoid it.

Ok, I will move tsnep_xdp_xmit_back() to the RX patch.

Gerhard

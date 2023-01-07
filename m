Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DBE661180
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 21:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjAGUNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 15:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjAGUNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 15:13:05 -0500
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B14C757
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 12:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1MqPvtgRiL7eKBkzO0pA+IjQLvlEWiry8049TjXHBxA=; b=HzNiFKzzMeTJYIV6zeRjowtOjd
        astnQ1U2GVvwntQtJpbm62tiS+/NwbPgv/n3lhkl6oomQ+RbuaBwqJJ3PoQeM0YFWled88ZlTCBXy
        JQMaLh4FEm2EWfNkHiVFpSFaLlvP4+1W2avF6pxkY4G9LpfNmg2+/2gFRohuQlikIvq4=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pEFYp-0008RB-Cz; Sat, 07 Jan 2023 21:12:59 +0100
Message-ID: <8622241f-a7f3-953a-8045-45eee88fff6c@engleder-embedded.com>
Date:   Sat, 7 Jan 2023 21:12:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 9/9] tsnep: Add XDP RX support
Content-Language: en-US
To:     Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com
References: <202301071414.ritICMHu-lkp@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <202301071414.ritICMHu-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.01.23 09:46, Dan Carpenter wrote:
> dd23b834a352b5 Gerhard Engleder 2023-01-04  631  static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
>                                                          ^^^^
> dd23b834a352b5 Gerhard Engleder 2023-01-04  632  				struct xdp_buff *xdp)
> dd23b834a352b5 Gerhard Engleder 2023-01-04  633  {
> dd23b834a352b5 Gerhard Engleder 2023-01-04  634  	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
> dd23b834a352b5 Gerhard Engleder 2023-01-04  635  	int cpu = smp_processor_id();
> dd23b834a352b5 Gerhard Engleder 2023-01-04  636  	struct netdev_queue *nq;
> dd23b834a352b5 Gerhard Engleder 2023-01-04  637  	int queue;
> dd23b834a352b5 Gerhard Engleder 2023-01-04  638  	bool xmit;
> dd23b834a352b5 Gerhard Engleder 2023-01-04  639
> dd23b834a352b5 Gerhard Engleder 2023-01-04  640  	if (unlikely(!xdpf))
> dd23b834a352b5 Gerhard Engleder 2023-01-04 @641  		return -EFAULT;
> 
> return false?

Of course. Will be fixed. Thanks!

Gerhard

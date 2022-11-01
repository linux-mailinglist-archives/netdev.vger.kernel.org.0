Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC161432A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKACXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKACXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:23:18 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B22EF5C;
        Mon, 31 Oct 2022 19:23:17 -0700 (PDT)
Date:   Tue, 1 Nov 2022 10:23:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667269395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=svdmwz/pCHv3q1/l2SZlym1qdlsRzR5nzCtSCTk4U60=;
        b=HLW/VaGAbaDAbMP3aSuPFx5Obr8Zc29eh7hL7MkG3gz7lIpWkKwLzw5+PuH60slIyyF9S2
        atnGQ44f49pLKsWVaGtlesc2sshPlAoUr5n/RQL5RdYwJIctqQSPRzysc+vXsTbs4Ggpv0
        7rb0y3HuL65d1VnO1WsSiNRFkUHcD1A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: hinic: Convert the cmd code from decimal to hex
 to be more readable
Message-ID: <20221101022310.GA11966@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
 <20221027110241.0340abdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221027110241.0340abdf@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 10月 22 11:02:41, Jakub Kicinski wrote:
> On Wed, 26 Oct 2022 20:59:10 +0800 Cai Huoqing wrote:
> > Subject: [PATCH 1/2] net: hinic: Convert the cmd code from decimal to hex to be more readable
> 
> Please put [PATCH net-next] or [PATCH -next] in the subject,
> to make the patch sorting easier for maintainers.
This series is based on net-next, if need to resend, I will add
net-next prefix.

Thanks,
Cai
> 
> > The print cmd code is in hex, so using hex cmd code intead of
> > decimal is easy to check the value with print info.
> 
> > -	HINIC_PORT_CMD_SET_AUTONEG	= 219,
> > -
> > -	HINIC_PORT_CMD_GET_STD_SFP_INFO = 240,
> > -
> > -	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
> > -
> > -	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 249,
> > -
> > -	HINIC_PORT_CMD_GET_SFP_ABS	= 251,
> > +	HINIC_PORT_CMD_GET_SFP_ABS = 0xFB,
> 
> This deletes some entries. Please don't mix changes with mechanical
> conversions.

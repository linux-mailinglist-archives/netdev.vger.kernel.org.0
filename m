Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031CF610954
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 06:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJ1EhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 00:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJ1EhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 00:37:21 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BAE19C065;
        Thu, 27 Oct 2022 21:37:20 -0700 (PDT)
Date:   Fri, 28 Oct 2022 12:37:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666931838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dFVXPn1M19HpiAHHbE8USZnNXUb4j26XgQkVogvtxns=;
        b=mbwyeWbI68ULZLYrd44rnilxvMxW3KwBdKXQdbCyPquf064ResGh/JHTst+x6sdnn2aHn7
        ywahp6xVsheoAIeDRjUL1dqliGjTNPge7ETx/UdejAkW+deexzmdRIsrK0Fn7WBmlVYHzo
        d73Jap9pa8lDC3gxjehgYktsQFywvEE=
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
Message-ID: <20221028043714.GA3164@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
 <20221027110241.0340abdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221027110241.0340abdf@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
will revert these lines and resend

thanks,
Cai

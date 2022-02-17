Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAAE4B9F73
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbiBQL5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:57:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiBQL5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:57:15 -0500
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com [66.111.4.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397EE151D3E;
        Thu, 17 Feb 2022 03:56:59 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3B6395801AB;
        Thu, 17 Feb 2022 06:56:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 17 Feb 2022 06:56:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=StCX2Y8GpWpcYeqcy
        T6SGLw8IqrV08t+NG5xjrAMMOg=; b=P0W9UYDDp4O7tzqIka52IOQCVWw63oonP
        LGW9E3y5isBwtAwenpGZnpE/nBIQpC/7Eh0WcFdrqKKOvIBFHcxvlebLacAN5Ibc
        zFFaQagnG6nz31DGLDTdSgj7ZqyZdIuwL+w7AZ/VRv8yl0a3a4Iru5IjC3VrlV3M
        A4ou4b2tmp8e8nkswBl0VleCTPneG5kU6wbgfJgZoYyxVFwoWsQR9accxkC9MxJc
        VqIskOE+J+ydbmeaELiWH3IfMb70PIiLX3rJj/6TUqkQ3nz5HKV/HnvKRl9TpltR
        HQlxqSQQJqRAvJSLjz7XAuXQcwpBPxDhxxXuMoYyq1hB5/lO1CyyA==
X-ME-Sender: <xms:CDgOYuEpHTbLluHGqUBjfNjm7jfr30cFm7Mf6m4sHQr1L1zIwLFDqw>
    <xme:CDgOYvUWbT-MZOKYrPA_vRGK1M8CkiighD_e9Z58JBIZC9MwAKbRNDpagqK1fNnho
    f7bZoJ5xuXXbfc>
X-ME-Received: <xmr:CDgOYoI8T5vGpKYxhiUuirhRIOxUHvxne8Ruzet2d2AWSsBENTOPIxY-iJftrOwa8TEWCJe7VebkTq70dkuB0TeV8T4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeekgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CDgOYoH71BkvmSiTsliD34qcuIkbfuXY4vio0JLYYYsY7CcX0bIxiA>
    <xmx:CDgOYkXA1E6sJlLA3xzjDau5gKhi9-N3vkXeWLs03TjFam6m9nUrPg>
    <xmx:CDgOYrN31ksrzOA9DaZqrgJ5e7RmPlWZHnJI0KCrTCRlmEuPgZcpOg>
    <xmx:CTgOYmjmR0kxWR5BSyfhsHOSeQg5kSwX7tiXl7Zl6_PLW5RBO-QtBQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Feb 2022 06:56:55 -0500 (EST)
Date:   Thu, 17 Feb 2022 13:56:51 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jianbo Liu <jianbol@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com, claudiu.manoil@nxp.com, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        saeedm@nvidia.com, leon@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com, roid@nvidia.com
Subject: Re: [PATCH net-next v2 0/2] flow_offload: add tc police parameters
Message-ID: <Yg44A/JcKmsTU6N4@shredder>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217113439.GE4665@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217113439.GE4665@corigine.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 12:34:39PM +0100, Simon Horman wrote:
> On Thu, Feb 17, 2022 at 08:28:01AM +0000, Jianbo Liu wrote:
> > As a preparation for more advanced police offload in mlx5 (e.g.,
> > jumping to another chain when bandwidth is not exceeded), extend the
> > flow offload API with more tc-police parameters. Adjust existing
> > drivers to reject unsupported configurations.
> 
> Hi,
> 
> I have a concern that
> a) patch 1 introduces a facility that may break existing drivers; and
> b) patch 2 then fixes this
> 
> I'd slightly prefer if the series was rearranged to avoid this problem.

Not sure what you mean by the above. Patch #1 extends the flow offload
API with tc-police parameters that weren't communicated to drivers until
now. Drivers still ignore the new parameters after this patch. It is
only in patch #2 that these drivers reject configurations where the
parameters are set.

Therefore, the only breakage I see is the one that can happen after
patch #2: unaware user space that was installing actions that weren't
fully reflected to hardware.

If we want to be on the safe side, it is possible to remove the errors,
but keep the extack messages so that user space is at least somewhat
aware.

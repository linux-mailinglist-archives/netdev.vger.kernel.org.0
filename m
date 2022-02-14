Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439574B51F1
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiBNNl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:41:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354511AbiBNNly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:41:54 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368CEB849
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 05:41:46 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 178035C007F;
        Mon, 14 Feb 2022 08:41:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 14 Feb 2022 08:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WwQWSbZAOWwyoj/cA
        sf2jBtYg9z6KhLN1lGVrzwGN40=; b=LWK3qTijKasxJvT2Z9VGVs8+alT5bj8ia
        N2x7Q4DzmBALkPrBz1QwKaJ9E2k3xIdcNF0Yr8+2fbif/2lud/IE/cOAlD3X1KdQ
        y+fVsuw2oTjg0PeuaX6N+msKfJfbisENyRmWozlWtMIFMmJaL6V2NOiGzh7cPbVU
        I+bRafIufsDsVc8/t/4wrQurjWyNAEI0KvqfoV8C4GH1hdOhHTUuFulhGdLkbqrK
        XCklz3630/+ziH8PMcY3gFv5GW1xrnaSsuQRcgroIdJpcGb1mxIQNgUbZJ56CG0l
        6f02iufhb96wNdTWt+UXXq2etmDHhzsiTM4h4fI978vHfj91k1Sow==
X-ME-Sender: <xms:F1wKYqKgLrBlwcCCYbIYc8TUQp2mz35d0IQ05kJstwRXH4M0somg5g>
    <xme:F1wKYiINesFj7ZDy1kUdkVqapdjhJPqJuVN40pEgRdZLBxAl8fZo3D2ulUYEqRalX
    GZmoAfLWXM9CzU>
X-ME-Received: <xmr:F1wKYqt7fJeLfeEVGwAiqIW3zlcINb9EI3BiZE02sQb5n5ss4ssQKh5uxXFa_MwJwlpLyKw3fY6RQHheyxizoiEwZbU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedvgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:F1wKYva1o-cobiw40So04aboa9uIwwZaf5vjF4a3e7MQRo_g3wiueg>
    <xmx:F1wKYhZCOwXZGREI5mfu-v3FKt82Sa2x9bbCOr7Pkv9YJ0EqXnB2SQ>
    <xmx:F1wKYrCDyfhsbQ6zwj2KK4P40TdwIfaBD8xkpDNwy-IsnDT2drW4mQ>
    <xmx:GFwKYgULuXB4qdDNm2oOjGqpwGN_6vlssNkU2dgf6XDemcNqRvtXwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Feb 2022 08:41:43 -0500 (EST)
Date:   Mon, 14 Feb 2022 15:41:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        idosch@nvidia.com, ozsh@nvidia.com, roid@nvidia.com
Subject: Re: [PATCH net-next 0/2] flow_offload: add tc police parameters
Message-ID: <YgpcErPYfkWRhh0G@shredder>
References: <20220214100922.13004-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214100922.13004-1-jianbol@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 10:09:20AM +0000, Jianbo Liu wrote:
> Add more tc police action parameters for flow_offload. They can be used
> by driver to check if police can be offloaded.

DaveM / Jakub, please ignore this version. We will send v2 with better
validation of "ok" action, Cc all relevant maintainers and amend the
cover letter to contain the motivation for the patchset (i.e.,
preparation for more advanced police offload in mlx5).

Thanks

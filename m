Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B728234C4B8
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 09:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhC2HQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 03:16:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52401 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231163AbhC2HQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 03:16:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A96875C0004;
        Mon, 29 Mar 2021 03:16:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 03:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CyyF/r
        2NLDa6WBNVAwayptZdU9XoxfGXylJPadw9FQo=; b=ojHJB/N7pQZm8hOFuzzMcv
        rJCPaBoDi4f3/8/OjhSBiYMA00QdS118R29Q4urdxOLkmoTuW7ydqRy8UrE4fM0W
        XSo8DUkuq6x5e4bF4VmDqrWcoIiuLdsXEO3QRBhgP5tc1wukQVe4wUhsCA7VcgNJ
        wA9pMNlRrr9KnwlmKshI/2l7+v4PX3bnBQiVHDPXDXvOvVNJGRnCSCw+qsBh9hdh
        WZE+oIMVLH1r1tVzRtQ1KBASIZsh+wJWfDFdMaOTsDnejDG3PS87QPpgLJkUfs3d
        1RaCB5AXhkWTnGh/+nMEx7DQSuMsKhQ8++A+Bsuhtl9QG8Mbz4heADOKdxsKYYow
        ==
X-ME-Sender: <xms:x35hYGxpd4TGD-lcEtgZm0zB11NxBfen_ROmvQCtWJCLVXc702ETBg>
    <xme:x35hYCQHFc-6nNuQj9EzaCkgjCkiUVF1fRFz3Fq5G7qOrXsSBvUS2ZwMV4alUvPDm
    fYCBlMtlYlmT9Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehjedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:x35hYIW67tTOQ_lwSGTMi2EidvW6GByJwuT3YaX52Orp9mqeAqxlsA>
    <xmx:x35hYMhUuLIruN_Qrer3DL3EfwdpXAIyszbwCOTzkwjrO6IDMSxkVw>
    <xmx:x35hYICNS4mxneVubxiE7zA-ACO98Ar52yuqL1oTaUVLG35RUZwFoA>
    <xmx:x35hYH4rgj_QDvjNKbpoyowctDWwRExu8DFKYfum2r0Q7se9gjZnCQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D42CE1080064;
        Mon, 29 Mar 2021 03:16:22 -0400 (EDT)
Date:   Mon, 29 Mar 2021 10:16:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH net-next 2/2] selftests: forwarding: Add tc-police tests
 for packets per second
Message-ID: <YGF+w91qOhR05lyb@shredder.lan>
References: <20210326130938.15814-1-simon.horman@netronome.com>
 <20210326130938.15814-3-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326130938.15814-3-simon.horman@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 02:09:38PM +0100, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Test tc-police action for packets per second.
> The test is mainly in scenarios Rx policing and Tx policing.
> The test passes with veth pairs ports.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

FWIW (I see it was already merged):

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks!

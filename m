Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08CE2FE9FF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbhAUM0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:26:48 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38907 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730616AbhAUM0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 07:26:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B4AAB5C011A;
        Thu, 21 Jan 2021 07:25:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 21 Jan 2021 07:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DSGIPE
        wviBJva3VGDzbXmz78MH5d3GMIAYRhq7Tqha4=; b=H1arxmeRvS6xH8cEwdztZi
        ICCNESdiJvMS52DWR2LRY+EOzaiXSCFp4KEFTSsdKvn+AiZq0sGTFUrbr+9j7Hn0
        DnxZluq0FKuV/z/TJ0BxOSBqas/MV80hc2a/80PwtqBnS5AmlJvG03mT75NW8ZbD
        VQvDXFtwow5hDOFgbYJKvSm/EQDxzEfjTkWLh+oVlS+b7Bd6w6hGXPsOriY4LrQ3
        omtGU7KnIpf3K9DM5Y93P5HsrKJzqlgloMq6X9E+OMEJtkZD19mU7Un6rOzXDbpV
        ctCF7I6HIXSPxhuxYzdhVvS2kbsHXqgeomXbwslVlgmUFqcKI9RvfUmcLVif7J8A
        ==
X-ME-Sender: <xms:wXIJYBiKNzVMkpNR-yokHZEzLPQ9iCyQbkJDXbFUJNl7YRNk3H-VdQ>
    <xme:wXIJYGB4zfRCzkE9pp9EmWSxL7SLjUkKO4Eva0BM_50kif4JkFlV3mqPlRIXiORmJ
    LBm7NTHKhpUHy8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wXIJYBHZggVk5e78sYppc5JofDvsP2DERqFiWMsgU2eZlNCghTCxkg>
    <xmx:wXIJYGQeSwYiL_KDLcfyOdDrNJPKpVdUbAzlmPwRgqku2uGqgLW5og>
    <xmx:wXIJYOyMvSNvru9UtF1lpH_P9X5z2eyOkePVBr6zFHowsprxRHbTPQ>
    <xmx:wXIJYJ_L3ARElEocYDqdr_ZSKUNrqAqNMjwyDk2C4iDOea3091zTKA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC4FB24005B;
        Thu, 21 Jan 2021 07:25:36 -0500 (EST)
Date:   Thu, 21 Jan 2021 14:25:34 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH iproute2-next] devlink: add support for HARD_DROP trap
 action
Message-ID: <20210121122534.GB2647590@shredder.lan>
References: <20210121112954.31039-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121112954.31039-1-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 01:29:54PM +0200, Oleksandr Mazur wrote:
> Add support for new HARD_DROP action, which is used for
> trap hard drop statistics retrival. It's used whenever
> device is unable to report trapped packet to the devlink
> subsystem, and thus device could only state how many
> packets have been dropped, without passing a packet
> to the devlink subsystem to get track of traffic statistics.

This patch should also be marked as "RFC".

> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
>  devlink/devlink.c            | 4 ++++
>  include/uapi/linux/devlink.h | 4 ++++

Missing man page and bash completion extensions:

man/man8/devlink-trap.8
bash-completion/devlink

>  2 files changed, 8 insertions(+)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index a2e06644..77185f7c 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -1335,6 +1335,8 @@ static int trap_action_get(const char *actionstr,
>  {
>  	if (strcmp(actionstr, "drop") == 0) {
>  		*p_action = DEVLINK_TRAP_ACTION_DROP;
> +	} else if (strcmp(actionstr, "hard_drop") == 0) {
> +		*p_action = DEVLINK_TRAP_ACTION_HARD_DROP;
>  	} else if (strcmp(actionstr, "trap") == 0) {
>  		*p_action = DEVLINK_TRAP_ACTION_TRAP;
>  	} else if (strcmp(actionstr, "mirror") == 0) {
> @@ -7726,6 +7728,8 @@ static const char *trap_action_name(uint8_t action)
>  	switch (action) {
>  	case DEVLINK_TRAP_ACTION_DROP:
>  		return "drop";
> +	case DEVLINK_TRAP_ACTION_HARD_DROP:
> +		return "hard_drop";
>  	case DEVLINK_TRAP_ACTION_TRAP:
>  		return "trap";
>  	case DEVLINK_TRAP_ACTION_MIRROR:
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 1414acee..ecee2541 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -261,12 +261,16 @@ enum {
>   * enum devlink_trap_action - Packet trap action.
>   * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>   *                            sent to the CPU.
> + * @DEVLINK_TRAP_ACTION_HARD_DROP: Packet was dropped by the underlying device,
> + *                                 and device cannot report packet to devlink
> + *                                 (or inject it into the kernel RX path).
>   * @DEVLINK_TRAP_ACTION_TRAP: The sole copy of the packet is sent to the CPU.
>   * @DEVLINK_TRAP_ACTION_MIRROR: Packet is forwarded by the device and a copy is
>   *                              sent to the CPU.
>   */
>  enum devlink_trap_action {
>  	DEVLINK_TRAP_ACTION_DROP,
> +	DEVLINK_TRAP_ACTION_HARD_DROP,
>  	DEVLINK_TRAP_ACTION_TRAP,
>  	DEVLINK_TRAP_ACTION_MIRROR,
>  };
> -- 
> 2.17.1
> 

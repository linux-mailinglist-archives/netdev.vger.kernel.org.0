Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82749458C05
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 11:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhKVKHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 05:07:47 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36105 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229983AbhKVKHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 05:07:46 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D1015C01B7;
        Mon, 22 Nov 2021 05:04:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 22 Nov 2021 05:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7AB/rq
        zonUOWzLAzTKIR/r2isQMsfo/GkiwD4h91rPk=; b=Akr3wk7NneWaUex6gfdwC6
        e0KL0P7VzRwGjLuFL7R8Oi+JaazQk8xb+7CjQFxwgIufRHr24cno03AtgGOMc9d3
        qgCS3uRRtLm1VsYKH+pRGx7LObiuRURpBEV9934LzBhl4BO2jsXACOFqU+lpLbYA
        en8N549cMme6P4rmduc+oIo9M+O3+UXtIoV+QOk4q7DJaQCKXZVKPwqfQaXC/Nwk
        2YD4Sf11QRo1GDyYbEDKRfoUYuDGK166iVS1RDKd2vm3N8kPspPZ1eBlUXs7PSmO
        AKNAWVi3RAc9YV4ItosimB+veoxFZEeihYSufuVYi04SHEFMBiVGSeq1n2giJDHA
        ==
X-ME-Sender: <xms:NmubYaWGVb8BbouvrXjNEhgIuIDB7KK8riveWMZQhe-v2RcqFDThZA>
    <xme:NmubYWmudMwKizhwZ-vdWdWJNV6EqINS3fxfpIPUKYyyuIme-3mFGHi-hrEYKV1Ye
    Ff_UmqNO8HpSgQ>
X-ME-Received: <xmr:NmubYebwjLDRorb1nmqe3MLAoLKBt6AKLmsJ_1Nj-OOX-J0meFpdNAiQhUBtFNzZkp9lQeuZhLUjH_y1w_Fk5CR21Bvu9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeggdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NmubYRWiXJkFDZNH7F7v7_0KAoaCIy5DgwuRh9EP5tcMpQprASXKAA>
    <xmx:NmubYUmlr2MdpbCBj1W4uvGEi_c0dGxweruN9xVZ6olzR8idtfQe_w>
    <xmx:NmubYWeSe2491GE5y021DYO2URvUF254sh9FJ7mnvuxF1jEmnTuyvg>
    <xmx:OGubYTuHm6Sqk2mvtv8oN4rnjiXPiRI2NTTcokAqwTAW2BCkFyVKmw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Nov 2021 05:04:37 -0500 (EST)
Date:   Mon, 22 Nov 2021 12:04:35 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Bernard Zhao <bernard@vivo.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bridge: replace simple_strtoul to kstrtol
Message-ID: <YZtrM3Ukz7rKfNLN@shredder>
References: <20211119020642.108397-1-bernard@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119020642.108397-1-bernard@vivo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 06:06:42PM -0800, Bernard Zhao wrote:
> simple_strtoull is obsolete, use kstrtol instead.
> 
> Signed-off-by: Bernard Zhao <bernard@vivo.com>
> ---
>  net/bridge/br_sysfs_br.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index d9a89ddd0331..11c490694296 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -36,15 +36,14 @@ static ssize_t store_bridge_parm(struct device *d,
>  	struct net_bridge *br = to_bridge(d);
>  	struct netlink_ext_ack extack = {0};
>  	unsigned long val;
> -	char *endp;
>  	int err;
>  
>  	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
>  		return -EPERM;
>  
> -	val = simple_strtoul(buf, &endp, 0);
> -	if (endp == buf)
> -		return -EINVAL;
> +	err = kstrtoul(buf, 10, &val);

Base 16 is valid.

Before this patch:

# ip link add name br0 type bridge vlan_filtering 1
# echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
# echo $?
0

After this patch:

# ip link add name br0 type bridge vlan_filtering 1
# echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol 
bash: echo: write error: Invalid argument

> +	if (err != 0)
> +		return err;
>  
>  	if (!rtnl_trylock())
>  		return restart_syscall();
> -- 
> 2.33.1
> 

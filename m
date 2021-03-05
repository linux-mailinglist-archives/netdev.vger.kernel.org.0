Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC48232E07C
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 05:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCEEQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 23:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEEQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 23:16:58 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12D1C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 20:16:57 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id o3so1077892oic.8
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 20:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pLE6LrErkteEvjTyTX4HsuZriLBrcXFoYPG4nl9vr3s=;
        b=h3eXsVpFCPATqpl0jsGZZDU7elotfdSPapSbAPxHyLDo7rvwUDwCHZVDm9WTqjU2GP
         VAHhFHlu0T82rGaGrCqZe2ktAVHu+6z91QNxeFNbI8yzinisedYQuKewsM8UitbICSNb
         YkyzlCaUrZKVS5fe37d0EcIM5RMIgAwtywxqs6Zmgj/LYFgVBD1tfZbjJgK+ZQLvEpvg
         7FcoKJAz3XkrBHhGLd66oblWpyQNd0s2nsSomyHOR814q1hVjHHJWYZqQYXIBOb+Nc8C
         IaquvD19PyWYgrE3o006a6SQc+Q7b0blxuwFx0POC6nnoAAdshrCnD+psz+tUOTWVywI
         kklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pLE6LrErkteEvjTyTX4HsuZriLBrcXFoYPG4nl9vr3s=;
        b=oJfUYottap/5n5J/MaqBiA+A48j+zNpavgQuAbAWzSWkk7kEs5YV5EZMRuqKvxZmq2
         wK2Vyg5vltt8/tx5G/qdVTNxLbFBmO+t9bhc9H5Oki1zgKAA/UdhrOZQkyYOdK1EN8bb
         7zjxnAHtdGr/GZqOOeqdjo4y1Lxo47rIVaPUJd7OL1mfBP4qrezMwIZ4c2sD+OA7JMRx
         Dq8RSQfLIPCxdohMhNZprDYmcFrHL6KFJaKz6QSHl/DH4g33rq9FMUdn6g++k6QhH7mb
         thYtTOWeYcQ9y09deR4mmYW1BvdZ+T+PwxuRIvIlPR2l9TF2P2Pg+GWgTTxwfCkZXBmR
         sKjA==
X-Gm-Message-State: AOAM532iYioTQc3tbNpVY8BuRMjuUAFq9zL09sgf50MeWwoFit7QNqCy
        Aq2TUdkoEL9Qdfms5R6piQikZR096QVIRg==
X-Google-Smtp-Source: ABdhPJzPHR7yC6WXTaxS1OQmaUR/1OUHowqXfDyQOf1tnfWDDQXPHbv9kX0y5ajby72DNhds55JAHQ==
X-Received: by 2002:a05:6808:aa6:: with SMTP id r6mr5617024oij.128.1614917817303;
        Thu, 04 Mar 2021 20:16:57 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 7sm361716otd.46.2021.03.04.20.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:16:56 -0800 (PST)
Date:   Thu, 4 Mar 2021 22:16:55 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] net: qualcomm: rmnet: kill
 RMNET_MAP_GET_*() accessor macros
Message-ID: <YEGwt/or/Wuqqqtb@builder.lan>
References: <20210304223431.15045-1-elder@linaro.org>
 <20210304223431.15045-4-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304223431.15045-4-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 04 Mar 16:34 CST 2021, Alex Elder wrote:

> The following macros, defined in "rmnet_map.h", assume a socket
> buffer is provided as an argument without any real indication this
> is the case.
>     RMNET_MAP_GET_MUX_ID()
>     RMNET_MAP_GET_CD_BIT()
>     RMNET_MAP_GET_PAD()
>     RMNET_MAP_GET_CMD_START()
>     RMNET_MAP_GET_LENGTH()
> What they hide is pretty trivial accessing of fields in a structure,
> and it's much clearer to see this if we do these accesses directly.
> 
> So rather than using these accessor macros, assign a local
> variable of the map header pointer type to the socket buffer data
> pointer, and derereference that pointer variable.
> 
> In "rmnet_map_data.c", use sizeof(object) rather than sizeof(type)
> in one spot.  Also,there's no need to byte swap 0; it's all zeros
> irrespective of endianness.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 10 ++++++----
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h      | 12 ------------
>  .../net/ethernet/qualcomm/rmnet/rmnet_map_command.c  | 11 ++++++++---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c |  4 ++--
>  4 files changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index 3d00b32323084..2a6b2a609884c 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -56,20 +56,22 @@ static void
>  __rmnet_map_ingress_handler(struct sk_buff *skb,
>  			    struct rmnet_port *port)
>  {
> +	struct rmnet_map_header *map_header = (void *)skb->data;
>  	struct rmnet_endpoint *ep;
>  	u16 len, pad;
>  	u8 mux_id;
>  
> -	if (RMNET_MAP_GET_CD_BIT(skb)) {
> +	if (map_header->cd_bit) {
> +		/* Packet contains a MAP command (not data) */
>  		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
>  			return rmnet_map_command(skb, port);
>  
>  		goto free_skb;
>  	}
>  
> -	mux_id = RMNET_MAP_GET_MUX_ID(skb);
> -	pad = RMNET_MAP_GET_PAD(skb);
> -	len = RMNET_MAP_GET_LENGTH(skb) - pad;
> +	mux_id = map_header->mux_id;
> +	pad = map_header->pad_len;
> +	len = ntohs(map_header->pkt_len) - pad;
>  
>  	if (mux_id >= RMNET_MAX_LOGICAL_EP)
>  		goto free_skb;
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> index 576501db2a0bc..2aea153f42473 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> @@ -32,18 +32,6 @@ enum rmnet_map_commands {
>  	RMNET_MAP_COMMAND_ENUM_LENGTH
>  };
>  
> -#define RMNET_MAP_GET_MUX_ID(Y) (((struct rmnet_map_header *) \
> -				 (Y)->data)->mux_id)
> -#define RMNET_MAP_GET_CD_BIT(Y) (((struct rmnet_map_header *) \
> -				(Y)->data)->cd_bit)
> -#define RMNET_MAP_GET_PAD(Y) (((struct rmnet_map_header *) \
> -				(Y)->data)->pad_len)
> -#define RMNET_MAP_GET_CMD_START(Y) ((struct rmnet_map_control_command *) \
> -				    ((Y)->data + \
> -				      sizeof(struct rmnet_map_header)))
> -#define RMNET_MAP_GET_LENGTH(Y) (ntohs(((struct rmnet_map_header *) \
> -					(Y)->data)->pkt_len))
> -
>  #define RMNET_MAP_COMMAND_REQUEST     0
>  #define RMNET_MAP_COMMAND_ACK         1
>  #define RMNET_MAP_COMMAND_UNSUPPORTED 2
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
> index beaee49621287..add0f5ade2e61 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
> @@ -12,12 +12,13 @@ static u8 rmnet_map_do_flow_control(struct sk_buff *skb,
>  				    struct rmnet_port *port,
>  				    int enable)
>  {
> +	struct rmnet_map_header *map_header = (void *)skb->data;
>  	struct rmnet_endpoint *ep;
>  	struct net_device *vnd;
>  	u8 mux_id;
>  	int r;
>  
> -	mux_id = RMNET_MAP_GET_MUX_ID(skb);
> +	mux_id = map_header->mux_id;
>  
>  	if (mux_id >= RMNET_MAX_LOGICAL_EP) {
>  		kfree_skb(skb);
> @@ -49,6 +50,7 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
>  			       unsigned char type,
>  			       struct rmnet_port *port)
>  {
> +	struct rmnet_map_header *map_header = (void *)skb->data;
>  	struct rmnet_map_control_command *cmd;
>  	struct net_device *dev = skb->dev;
>  
> @@ -58,7 +60,8 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
>  
>  	skb->protocol = htons(ETH_P_MAP);
>  
> -	cmd = RMNET_MAP_GET_CMD_START(skb);
> +	/* Command data immediately follows the MAP header */
> +	cmd = (struct rmnet_map_control_command *)(map_header + 1);
>  	cmd->cmd_type = type & 0x03;
>  
>  	netif_tx_lock(dev);
> @@ -71,11 +74,13 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
>   */
>  void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port)
>  {
> +	struct rmnet_map_header *map_header = (void *)skb->data;
>  	struct rmnet_map_control_command *cmd;
>  	unsigned char command_name;
>  	unsigned char rc = 0;
>  
> -	cmd = RMNET_MAP_GET_CMD_START(skb);
> +	/* Command data immediately follows the MAP header */
> +	cmd = (struct rmnet_map_control_command *)(map_header + 1);
>  	command_name = cmd->command_name;
>  
>  	switch (command_name) {
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index bd1aa11c9ce59..fd55269c2ce3c 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -321,7 +321,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>  		return NULL;
>  
>  	maph = (struct rmnet_map_header *)skb->data;
> -	packet_len = ntohs(maph->pkt_len) + sizeof(struct rmnet_map_header);
> +	packet_len = ntohs(maph->pkt_len) + sizeof(*maph);
>  
>  	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
>  		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
> @@ -330,7 +330,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>  		return NULL;
>  
>  	/* Some hardware can send us empty frames. Catch them */
> -	if (ntohs(maph->pkt_len) == 0)
> +	if (!maph->pkt_len)
>  		return NULL;
>  
>  	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
> -- 
> 2.20.1
> 

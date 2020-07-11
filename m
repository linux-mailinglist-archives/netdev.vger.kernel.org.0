Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892D721C633
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGKUiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgGKUiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:38:13 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A861C08C5DD;
        Sat, 11 Jul 2020 13:38:13 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d4so4115763pgk.4;
        Sat, 11 Jul 2020 13:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9yxWqLAujS3P0ixpFdXfloKeUJCd/J3seY5CVD80kVg=;
        b=qQ0OZElsZtT4gMww/mF4mdziBQk3R+yOv0WzDYO2cC+GF3dxAEPeJYl3/IZtkwfedm
         wsXEw7dNB64MIe6+AxLipPikY6yHGNsNbx3gl2h2pSBjXgJdmwy1kev945k4d46I6B94
         I4rNNscWX1dTiJ+Cu5xUWB+0W5vXBy2WQuNbWpn0uLPDtcXovmJG4cXh9A5AGCgzclnD
         E1LoslhymgwttWovOKnXN2D+f04WbAFLwkk+3P+22IOw9JljCh0BS1XT2c6gXwVEfCMw
         A2fYhe19GrdsSmufASld9Ne8gG1almp1CvJ6tqftfBrvywXiIifEApexZdfsyeIaL069
         lgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9yxWqLAujS3P0ixpFdXfloKeUJCd/J3seY5CVD80kVg=;
        b=XH481C40QPvc+B9XP1N0VkB53d2Z+ex8QJDyiLUEF6PGrQmvDoOdX1JMRj780mKS19
         1ifkFR+BRlGi5O0TOjvrtqkxbhVTXnrVXVN/18GusSulFyUqEj1dUU44l8jjTSmPxJKc
         HD2wz5G5IS9lHafsHuhQQYvOvNPa+toId4nNH2l3ZNUJMOZd3Z0bUZW/Q+Gj2aj3ieWq
         QBnmokYBMKa5eKk8X5rmaOUQBdaIbveOBb1loV7ZbZhHc2SjSeA+97fFula7xVdkbcce
         Q7mZTPUxlZq8yRWRMjcpWdf1Uwbq6lo8FkOSXtwZrU9f2p4sKbNuJprv8IOmkAUCoGc1
         8Tuw==
X-Gm-Message-State: AOAM530zCMRkfg1tiEzbo+fZ8Xaoz+Pm2uul+2bX6Ndtvb4K1moJ5tD8
        klIqm+ptpyU0S9ILMJUAeTU=
X-Google-Smtp-Source: ABdhPJwU60o/LtYa7R9yYYeXcfP729m2X78MAhuEz+boLIXxsl+evCtfQxtqxln1gUWKi76QoQwZsg==
X-Received: by 2002:a63:5a17:: with SMTP id o23mr63695545pgb.218.1594499892883;
        Sat, 11 Jul 2020 13:38:12 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id t187sm9385064pgb.76.2020.07.11.13.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 13:38:12 -0700 (PDT)
Date:   Sat, 11 Jul 2020 13:38:10 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 4/8] net: dsa: hellcreek: Add support for hardware
 timestamping
Message-ID: <20200711203810.GB27467@hoboy>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-5-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710113611.3398-5-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 01:36:07PM +0200, Kurt Kanzenbach wrote:
> +static void hellcreek_get_rxts(struct hellcreek *hellcreek,
> +			       struct hellcreek_port_hwtstamp *ps,
> +			       struct sk_buff *skb, struct sk_buff_head *rxq,
> +			       int port)
> +{
> +	struct skb_shared_hwtstamps *shwt;
> +	struct sk_buff_head received;
> +	unsigned long flags;
> +
> +	/* The latched timestamp belongs to one of the received frames. */
> +	__skb_queue_head_init(&received);
> +
> +	/* Lock & disable interrupts */
> +	spin_lock_irqsave(&rxq->lock, flags);
> +
> +	/* Add the reception queue "rxq" to the "received" queue an reintialize
> +	 * "rxq".  From now on, we deal with "received" not with "rxq"
> +	 */
> +	skb_queue_splice_tail_init(rxq, &received);
> +
> +	spin_unlock_irqrestore(&rxq->lock, flags);
> +
> +	for (; skb; skb = __skb_dequeue(&received)) {
> +		unsigned int type;
> +		u8 *hdr;
> +		u64 ns;
> +
> +		/* Get nanoseconds from ptp packet */
> +		type = SKB_PTP_TYPE(skb);
> +		hdr  = parse_ptp_header(skb, type);
> +		ns   = hellcreek_get_reserved_field(hdr);

You might consider clearing the reserved field at this point.  Some
user space SW might consider non-zero reserved fields as corrupt!

(The LinuxPTP stack doesn't do this, but still maybe others are more
pedantic.)


Acked-by: Richard Cochran <richardcochran@gmail.com>

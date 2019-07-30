Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165BE7B2EA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387819AbfG3TIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:08:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46194 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387756AbfG3TII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:08:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so64055533qtn.13;
        Tue, 30 Jul 2019 12:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=69tEdrH7C4uZgWGRDxRFgxd5fRarFFp82Fzw8ANraiM=;
        b=C4/XzLrSlBsHh18iv2/8L6xgDVBIyS5Juw2p1an44yyqcJqtxhjxeKH0/mmuPciL22
         csbKPBV+1sURYHrnxWqwNaZPUF3KtYqfmJLVzXnbK9lMdv0LWJOcWufwgkcl27BiQeQD
         VpYmTZNiS8Uvl358fZZy0lOPLeYVuXGAvbEK11D4OfHaOuxi4fMWRWqfefNgQDpISKYU
         ZoQzEOKHDPVVZ+CZ7yp2qD+GVK0cBF/ZXPbqnzhKvytp4y319ccL2FXbJi5zerpRgqZf
         O/fggf8mLo0yMUsu7OH4dupMgZF2Q6VYyg0UbpPtkuywoy1B6Zar6drWaFHXkdigu1jk
         ay3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=69tEdrH7C4uZgWGRDxRFgxd5fRarFFp82Fzw8ANraiM=;
        b=b+tNFvRkXytPX9hT+0kPFZQYlBNecyxOhtO6p4roNJjy/6k/ZrNr9/u3XECExCNm5L
         0sN0ySUtm8cOewQ/wUyOeaZ1cvYOxmGCHdKe/yvq5Aea55h1ShpOw6EeipkqFrwp1MjN
         dItgVRmvtznaheCLr3bnojuF4cI2+vGWVRPp1T/mnJ+FOxc9ZEc/HuOHBtnpzesXkuo1
         dCH5mRt5j9c1tW/in5A3yYNJH/rMkebUPm4dqsMYCPL0UKeuiyoNe/vS0VvJtdva2kbj
         arAWo0mH7vTeOFpjYSP7f4wiSj0NimgKRiOzHydHWcii6lfDv8+HBo2htNsQpisoTZAo
         Y67g==
X-Gm-Message-State: APjAAAVKEDqcyVJANikKhKPn4tbs4/cGRaSW9yl8HujvsqzK0T/NfFtL
        4J7Sgkg+cycSn/pAAyadujM=
X-Google-Smtp-Source: APXvYqzwg/cfSBynIJet++I5kPCGTwqyHKX4s8j6sc/mQAA29QrX2e6XTe6K8gGVIJjOEJKKavH6Yg==
X-Received: by 2002:ac8:31ba:: with SMTP id h55mr83446669qte.363.1564513687458;
        Tue, 30 Jul 2019 12:08:07 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.104])
        by smtp.gmail.com with ESMTPSA id j2sm30148427qtb.89.2019.07.30.12.08.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 12:08:06 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1D655C0AD9; Tue, 30 Jul 2019 16:08:04 -0300 (-03)
Date:   Tue, 30 Jul 2019 16:08:04 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, wenxu@ucloud.cn, jiri@resnulli.us,
        saeedm@mellanox.com, gerlitz.or@gmail.com, paulb@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: map basechain priority to
 hardware priority
Message-ID: <20190730190804.GQ6204@localhost.localdomain>
References: <20190730105417.14538-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730105417.14538-1-pablo@netfilter.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:54:17PM +0200, Pablo Neira Ayuso wrote:
> This patch maps basechain netfilter priorities from -8192 to 8191 to
> hardware priority 0xC000 + 1. tcf_auto_prio() uses 0xC000 if the user
> specifies no priority, then it subtract 1 for each new tcf_proto object.
> This patch uses the hardware priority range from 0xC000 to 0xFFFF for
> netfilter.

This makes more sense, thanks Pablo.
Nit below.

> +u16 nft_chain_offload_priority(struct nft_base_chain *basechain)
> +{
> +	u16 prio;
> +
> +	if (basechain->ops.priority < NFT_BASECHAIN_OFFLOAD_PRIO_MIN ||
> +	    basechain->ops.priority > NFT_BASECHAIN_OFFLOAD_PRIO_MAX)
> +		return 0;
> +
> +	/* map netfilter chain priority to hardware priority. */
> +	prio = basechain->ops.priority +
> +		NFT_BASECHAIN_OFFLOAD_PRIO_MAX +
> +			NFT_BASECHAIN_OFFLOAD_HW_PRIO_BASE;

Weird indent here.

> +
> +	return prio;
> +}

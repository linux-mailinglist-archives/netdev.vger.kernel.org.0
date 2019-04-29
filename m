Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B6EAF6
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbfD2Tfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:35:54 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43665 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbfD2Tfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 15:35:54 -0400
Received: by mail-pl1-f196.google.com with SMTP id n8so5541540plp.10
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WW32euiKqkhb9ifNcHKwLEs/3YhPVQ13TzEvlZyd16I=;
        b=u3R8TGmp4yAsvfQcVUOlpXJIj2NVgc8i7jwXK8U8sJ+3guGAagxNGt7ZHaB37k8cde
         SZ/2FpJ7wjdsSW2MMXziWmEj/38xB4yMKpmo5LUNxrL9E65v3ZxqFSAimShYmCis/P6F
         jOYa0ER82Whq+dVGZnLSCPm8L28aDMq588XieVMhfjPjJmODwkgNezrg4FfCeTrKwVtM
         H09R+SnvFSxoaST+AK24GFLFQQSgI6voXI4E24NGLNBhYp2/uA6EpZDCPNvbuZXsobbh
         CHgexOTLeuwa0y+5lC7CNJ5vKM7UoZC1Jx3bnFlBRjTfjyzQMnr3xIj6Is8EQoqVBZgI
         fhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WW32euiKqkhb9ifNcHKwLEs/3YhPVQ13TzEvlZyd16I=;
        b=XyuT3i7Wm2o45mhBMG9KleDlnkJ+7tF1IEHZWV8t4F9KbkX3cyx6If2k2KRDVleIoX
         w284FHlADm+sevJFsdQ6qwov/ZUE2FL1A1rrXbvAj7KMV9RjRJX+0Vry2UIaV3s5NkA/
         BEf7CbYuBks22LLn/hQrHwNHQWoX16NrpG6WtHShMil+fy5dRCjZ9YbegLwfb4u1Z+JI
         rE/7wk4/E4ZFFdnQIBE6Msynr9tGGVbScBGBS8Aew1fU9sPNCGTJTvlOM55yboUqJuWj
         /BLwa8l5vP96yBtSj6yo+tPwiX494UUzNigVYtjpx9gFRNyUklRE6iggbjkGocU09Oim
         Q1sw==
X-Gm-Message-State: APjAAAWg7bnn1zGYCNlZC47H7iqdAhmOgPL+SoBq0CNe3zlP9nq123zX
        Jq8Z+Ny8Xj8hiErB0Fr84iNebw==
X-Google-Smtp-Source: APXvYqw/JUFnYX/IUEDTZgc5D62cR9LbE8nKcm60Z2W7Nfd4Px/ZGXo4OAnwgh4nfqx0j8n0StVe4Q==
X-Received: by 2002:a17:902:820a:: with SMTP id x10mr25248265pln.316.1556566553367;
        Mon, 29 Apr 2019 12:35:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k186sm58353005pfc.137.2019.04.29.12.35.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 12:35:53 -0700 (PDT)
Date:   Mon, 29 Apr 2019 12:35:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v7 net-next 4/6] exthdrs: Add TX parameters
Message-ID: <20190429123520.419ed9d4@hermes.lan>
In-Reply-To: <1556563576-31157-5-git-send-email-tom@quantonium.net>
References: <1556563576-31157-1-git-send-email-tom@quantonium.net>
        <1556563576-31157-5-git-send-email-tom@quantonium.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 11:46:14 -0700
Tom Herbert <tom@herbertland.com> wrote:

>  /* Default (unset) values for TLV parameters */
>  static const struct tlv_proc tlv_default_proc = {
> -	.params.rx_class = 0,
> +	.params.r.class = 0,
> +
> +	.params.t.preferred_order = 0,
> +	.params.t.admin_perm = IPV6_TLV_PERM_NO_CHECK,
> +	.params.t.user_perm = IPV6_TLV_PERM_NONE,
> +	.params.t.class = 0,
> +	.params.t.align_mult = (4 - 1), /* Default alignment: 4n + 2 */
> +	.params.t.align_off = 2,
> +	.params.t.min_data_len = 0,
> +	.params.t.max_data_len = 255,
> +	.params.t.data_len_mult = (1 - 1), /* No default length align */
> +	.params.t.data_len_off = 0,
>  };

This looks cleaner if you skip the unnecessary 0 entries
and also use additional {}.

static const struct tlv_proc tlv_default_proc = {
	.params.t = {
		.admin_perm = IPV6_TLV_PERM_NO_CHECK,
		.user_perm = IPV6_TLV_PERM_NONE,
		.align_mult = 3,  /* Default alignment: 4n + 2 */
		.align_off = 2,
		.max_data_len = 255,
	},
};



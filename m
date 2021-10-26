Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A150143AF1A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhJZJe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:34:56 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52452 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhJZJez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:34:55 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CD3CC218C8;
        Tue, 26 Oct 2021 09:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635240750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9qilr721qCba8tJ1cy2UrgK3xQhoGmYpIzbQkugFRss=;
        b=LZGdo1ptByXCmq9WADo71rP+xgGMyEnbY67v8flwtPL3BZi0dSgvb9WzxvxQN4P58jxDfd
        eugoXc3pAFV4LaO04qYEEACMx3WQB4t3xzowF7q4yZU1SpQMO5EWrtSiDldItqGNEKhJs4
        z3s3uXuaJfVHqi7cYgWq76oIXqbEckw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635240750;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9qilr721qCba8tJ1cy2UrgK3xQhoGmYpIzbQkugFRss=;
        b=jfeX8QM/GK2iidt7b/J/yevHgs0tHyzxLKPvf2O5+Okjv9kRMOwTdjmSgyVYeZ151TN9sp
        HRZdn5jH5eeF9IAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C12013E4F;
        Tue, 26 Oct 2021 09:32:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gYd8Bi7Ld2GtdQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 26 Oct 2021 09:32:30 +0000
Subject: Re: [PATCH][next] gve: Fix spelling mistake "droping" -> "dropping"
To:     Colin Ian King <colin.i.king@googlemail.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211026092239.208781-1-colin.i.king@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <a7155c22-c487-9a76-d3b3-628c0e27d3b0@suse.de>
Date:   Tue, 26 Oct 2021 12:32:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026092239.208781-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



10/26/21 12:22 PM, Colin Ian King пишет:
> There is a spelling mistake in a netdev_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

you could fix the second instance as well:

grep -nri droping drivers/net/
drivers/net/wireless/mac80211_hwsim.c:1279:		/* Droping until WARN_QUEUE 
level */
drivers/net/ethernet/google/gve/gve_rx.c:441:				    "RX fragment error: 
packet_buffer_size=%d, frag_size=%d, droping packet.",


> ---
>   drivers/net/ethernet/google/gve/gve_rx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index c8500babbd1d..ef4aa6487c55 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -438,7 +438,7 @@ static bool gve_rx_ctx_init(struct gve_rx_ctx *ctx, struct gve_rx_ring *rx)
>   		if (frag_size > rx->packet_buffer_size) {
>   			packet_size_error = true;
>   			netdev_warn(priv->dev,
> -				    "RX fragment error: packet_buffer_size=%d, frag_size=%d, droping packet.",
> +				    "RX fragment error: packet_buffer_size=%d, frag_size=%d, dropping packet.",
>   				    rx->packet_buffer_size, be16_to_cpu(desc->len));
>   		}
>   		page_info = &rx->data.page_info[idx];
> 

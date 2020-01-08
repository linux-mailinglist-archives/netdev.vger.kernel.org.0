Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B730134463
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgAHN5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:57:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37592 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgAHN5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 08:57:31 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so3494178wru.4
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 05:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tjibdcrm0F2gBrVSaGaYRxNAqKq2VCoLQH5KirTsjuc=;
        b=m/kaMwLbBcSL4lPor8Mo+VgfcRizesHQjejcmUNPWa7XkwV5ZIn7hrCEOLYXHV9/T8
         AaorCkeLtPS27njH+cQJo1u7AjgxISd32W4iSFFzARbEBSavlQnGrJCL1+RmIuxT1/V9
         EYPiqhCCxh3giok7xWROLKif3J9WBqOWxHUSYERvNjIB4pLaQOVgoAWB1wgDn7N/cp8Q
         HrcG/pYdnG8SQgS4r0w4ZaOZ+aZ4otAmnLWRyQCl4LOoZrfCY4PUhSiPeeKtzqoBKh+r
         dxN7riv+TNU9KNrl55J3szBIMR2vXJqksOoHTGffMk69SAmPkAk7inrwmVnwG/M5ps9W
         UZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tjibdcrm0F2gBrVSaGaYRxNAqKq2VCoLQH5KirTsjuc=;
        b=dBSD6mfOYD31sP/wWffFo6o/3naiALrrC/HyCtNB0154pfBanI+Y52Kuq/NHomyIOn
         AGaogklvp4gHu+2yh/Ef/C8wZTntGdrfj9dqIz9Ul7zthutvF4Nma11WTtBippFfk/9l
         MQM/c6MJeGYG7E02ETVIis/I/HLKSrrBTp99UlogFdXY1Vl6n1qWiiPpVuJpUTdpMxyh
         H+Z+uRGXb2AoTDY5DBJ3YkxWOucAvsATr7UIM8V5VJDV0r1i31eYZ5Oxt9kTeS1gPWOc
         nD8125xCUijmGRfLHji1rLHdBAj6OnCZzlh9eXhD+63vqJ3EPYMiJQtIB5+uO6hJK4me
         p58w==
X-Gm-Message-State: APjAAAXI1d5dErV74TDSJItu3sxo65q0uhs6labyANbAj+JTldREm2px
        +V1DLVIjGSr7TCxOk/n4X4SznQ==
X-Google-Smtp-Source: APXvYqx0hay0UMpM7/Vwis+yM8OlqmCCEDSkMJxGOVcZg7bXXpcCn/9V1E3VQGokgXSL6zJJcnAMOA==
X-Received: by 2002:a5d:404b:: with SMTP id w11mr4973101wrp.171.1578491850026;
        Wed, 08 Jan 2020 05:57:30 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id p15sm3678288wma.40.2020.01.08.05.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 05:57:29 -0800 (PST)
Date:   Wed, 8 Jan 2020 14:57:28 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: remove redundant assignment to variable icid
Message-ID: <20200108135728.GA19220@netronome.com>
References: <20200107180013.124501-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107180013.124501-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 06:00:13PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable icid is being rc is assigned with a value that is never
> read. The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  net/bluetooth/l2cap_core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 1bca608e0170..195459a1e53e 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -5081,7 +5081,6 @@ static inline int l2cap_move_channel_req(struct l2cap_conn *conn,
>  	chan->move_role = L2CAP_MOVE_ROLE_RESPONDER;
>  	l2cap_move_setup(chan);
>  	chan->move_id = req->dest_amp_id;
> -	icid = chan->dcid;
>  
>  	if (req->dest_amp_id == AMP_ID_BREDR) {
>  		/* Moving to BR/EDR */
> -- 
> 2.24.0
> 

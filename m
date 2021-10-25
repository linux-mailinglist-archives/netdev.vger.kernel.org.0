Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE88439773
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhJYN0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhJYN0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:26:07 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E0AC061745;
        Mon, 25 Oct 2021 06:23:45 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id n1so16633802edd.0;
        Mon, 25 Oct 2021 06:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yTBMjjMrdazRANwBzBLPu9MzeYKj7kmUXGzwCTyy3lM=;
        b=LQdOwrEEEAY0vyqei2WTvbHGpLC5LdSlLjtrBy4ZngPEn+0i7NFxMVa0M9RhYL2wJY
         fGnTUyf0ut0lYIudO74OwkqPviAaakqYM7b4m4UMfymy/STAd3x5Gck8sx9vZe1NLjKt
         Nu4s080NNnvWgRxAnDyPyQxFO2oCh6+i7/c7AjJMe1n6ZEL/SpEfXwSeDn1okcKTiTR1
         In3e5pyCHCycun1MVkFpGu/MfYw8DQluK0JswnwrhUgzaBJXrBeCMeT+OR7Uidqwmy9V
         FhwLktkJco7jzJMu6DXejIJG2JUuICkWizZelkbggvW10F5V2VHADuXV4tN63o74H2Ks
         kLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yTBMjjMrdazRANwBzBLPu9MzeYKj7kmUXGzwCTyy3lM=;
        b=wapVQD2uEAjN130AYJrPoIb4KZRq+uLJV2S7NeiGozSQHVAZ+klnKIZmHjx7YaaO7h
         Pi0ro2WXpB9VhrVe56iCxdYTyxH72ua+ryIYESCT1M36taEoIsweCnu3U6CCnMBOZ4NZ
         7fSDyilEZMSM+7fyi1v248HpSRK0dOfcR08jolVL3QfZKx1zfXpFcdIaiMGEq2Bx4yRK
         mY8WDV81WObcGNvW3QKCnbbW/jJzyajnuRXOJ5dPXD5rGUjOy2HKxGQkDQo8nkE0hXPF
         KfE/IPL1ccL55M9zVTNDh4xOuLMlrhXVAV5tUsFrseexe+Pd8aZtX4/LvVnLsnjMvpRP
         WXYw==
X-Gm-Message-State: AOAM530sZTnWX4TNA5ZTWtNXwrRiaLFQfEfYqPAJmtWtQaBkejdpzHeN
        /2u7YSDGZ7zutvBW+mdWa2I=
X-Google-Smtp-Source: ABdhPJyyLQSRbVPT69UKVmezlJ/kVUWUXgYUlMgV4jzSA9RMdoOpK4+QJTv0NymtjL3OmLrdCObHnA==
X-Received: by 2002:a17:906:c005:: with SMTP id e5mr22321246ejz.480.1635168153977;
        Mon, 25 Oct 2021 06:22:33 -0700 (PDT)
Received: from skbuf ([188.25.174.251])
        by smtp.gmail.com with ESMTPSA id r15sm5881046edd.96.2021.10.25.06.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 06:22:30 -0700 (PDT)
Date:   Mon, 25 Oct 2021 16:22:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net-next 6/9] s390/qeth: fix various format strings
Message-ID: <20211025132229.4opytunnnqnhxzdf@skbuf>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
 <20211025095658.3527635-7-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025095658.3527635-7-jwi@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 11:56:55AM +0200, Julian Wiedmann wrote:
> From: Heiko Carstens <hca@linux.ibm.com>
> 
> Various format strings don't match with types of parameters.
> Fix all of them.
> 
> Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---
>  drivers/s390/net/qeth_l2_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
> index adba52da9cab..0347fc184786 100644
> --- a/drivers/s390/net/qeth_l2_main.c
> +++ b/drivers/s390/net/qeth_l2_main.c
> @@ -661,13 +661,13 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
>  					 card->dev, &info.info, NULL);
>  		QETH_CARD_TEXT(card, 4, "andelmac");
>  		QETH_CARD_TEXT_(card, 4,
> -				"mc%012lx", ether_addr_to_u64(ntfy_mac));
> +				"mc%012llx", ether_addr_to_u64(ntfy_mac));
>  	} else {
>  		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
>  					 card->dev, &info.info, NULL);
>  		QETH_CARD_TEXT(card, 4, "anaddmac");
>  		QETH_CARD_TEXT_(card, 4,
> -				"mc%012lx", ether_addr_to_u64(ntfy_mac));
> +				"mc%012llx", ether_addr_to_u64(ntfy_mac));

You can print MAC addresses using the "%pM" printf format specifier, and
the ntfy_mac as argument.

>  	}
>  }
>  
> @@ -765,8 +765,8 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
>  	int err = 0;
>  
>  	kfree(br2dev_event_work);
> -	QETH_CARD_TEXT_(card, 4, "b2dw%04x", event);
> -	QETH_CARD_TEXT_(card, 4, "ma%012lx", ether_addr_to_u64(addr));
> +	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
> +	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
>  
>  	rcu_read_lock();
>  	/* Verify preconditions are still valid: */
> @@ -795,7 +795,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
>  				if (err) {
>  					QETH_CARD_TEXT(card, 2, "b2derris");
>  					QETH_CARD_TEXT_(card, 2,
> -							"err%02x%03d", event,
> +							"err%02lx%03d", event,
>  							lowerdev->ifindex);
>  				}
>  			}
> @@ -813,7 +813,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
>  			break;
>  		}
>  		if (err)
> -			QETH_CARD_TEXT_(card, 2, "b2derr%02x", event);
> +			QETH_CARD_TEXT_(card, 2, "b2derr%02lx", event);
>  	}
>  
>  unlock:
> @@ -878,7 +878,7 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
>  	while (lowerdev) {
>  		if (qeth_l2_must_learn(lowerdev, dstdev)) {
>  			card = lowerdev->ml_priv;
> -			QETH_CARD_TEXT_(card, 4, "b2dqw%03x", event);
> +			QETH_CARD_TEXT_(card, 4, "b2dqw%03lx", event);
>  			rc = qeth_l2_br2dev_queue_work(brdev, lowerdev,
>  						       dstdev, event,
>  						       fdb_info->addr);
> -- 
> 2.25.1
> 

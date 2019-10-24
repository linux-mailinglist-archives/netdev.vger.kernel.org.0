Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBAEE34F6
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409284AbfJXOEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:04:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34287 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbfJXOEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:04:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id k20so14337249pgi.1
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 07:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LzKMc+KJEQurq8v/8ez91cmyiKwiP5tr+Isvpi2+sjY=;
        b=P4yb7raX14OnohPRrSYKLP25xLFl1WixYxDVLBOBwKwO6FvSBY4TtzntWuw/vi6P/f
         5bKnbh36Vq5Xf/toebLk41Tqx9boFHac+EjVvAK6EAbaFpZIbYab9QUBraPSYxMOcRRX
         l3Al870OPwU6L2IMgjZBGCLn67XUmshQ+HCBQErWUlhFr/6AHHaC4txhR19A1yHMSI/9
         jvDgI8I9OZgFhmDkoZ+4jgtzikHBSporvHKb3ZB3+Pr+hdRPZ2elJRe8xa8b7p3ZUYiV
         pW1raTVvsZI2V9bGkyCunD3TJTCdQGr5HXFbqKFO08sw6S8o29s2k/VRviY3mPFUMCVR
         c8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LzKMc+KJEQurq8v/8ez91cmyiKwiP5tr+Isvpi2+sjY=;
        b=WlMzomW+TXmVB70LFpRm3a33XWsHD9VN2wd2j5Mo4TsG819A/xMKy6v6a462ZsFPGN
         wPT+Fpwtgzc7C3V4xGy+VPamD7XFJ3XQ9CVTH+MVVTYyagypr0bOpJAiEhMFAIe77VNn
         pX0ELZb1o12O6P6iKs76Lt1cgWbhoraeoBVaDknpXhnN4P9Ygs8XAm+HNYlP6MAkZQWq
         JEDExktwxRZ64UeFPJc7fgqvEkv04eitCWYAXy5f+dLqgxdtB3cIs89mjEtUZQi7i/V8
         plmMgjRzjhA1HMXozulzhE7ganh32M799AM3QxnPl+defcBYS2BuyRSCjp9Md1XlIp9j
         +e4A==
X-Gm-Message-State: APjAAAXgSaaDS0N3TRzKVOsoJTb8mAyNffG8MuBi/AuDBLIFDoMomucO
        PakEsKeiNMabvjGlkrNeOi4=
X-Google-Smtp-Source: APXvYqxh2t16LNc0KbmFIN7yF3TG8mnmR1ylThpbEDvtyijb0sdYVTmFMB8lfyfYxMrm8VkDO+iE5w==
X-Received: by 2002:a63:b25d:: with SMTP id t29mr16424227pgo.395.1571925871921;
        Thu, 24 Oct 2019 07:04:31 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q6sm29217053pgn.44.2019.10.24.07.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 07:04:30 -0700 (PDT)
Date:   Thu, 24 Oct 2019 07:04:28 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v3 net-next 03/12] net: aquantia: add basic ptp_clock
 callbacks
Message-ID: <20191024140428.GA1435@localhost>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
 <cc5ad0d429db914b3615d9a32224e1dc141ba91e.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc5ad0d429db914b3615d9a32224e1dc141ba91e.1571737612.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 09:53:27AM +0000, Igor Russkikh wrote:
> +/* aq_ptp_adjfine
> + * @ptp: the ptp clock structure
> + * @ppb: parts per billion adjustment from base

Kdoc needs update.

> + *
> + * adjust the frequency of the ptp cycle counter by the
> + * indicated ppb from the base frequency.
> + */
> +static int aq_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> +{
> +	struct aq_ptp_s *aq_ptp = container_of(ptp, struct aq_ptp_s, ptp_info);
> +	struct aq_nic_s *aq_nic = aq_ptp->aq_nic;
> +
> +	mutex_lock(&aq_nic->fwreq_mutex);
> +	aq_nic->aq_hw_ops->hw_adj_clock_freq(aq_nic->aq_hw,
> +					     scaled_ppm_to_ppb(scaled_ppm));

If your HW has sub-ppm bits in its frequency word, then it does make a
difference to actually use the low order bits (instead of truncating
as you do here).

> +	mutex_unlock(&aq_nic->fwreq_mutex);
> +
> +	return 0;
> +}

Thanks,
Richard

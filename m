Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CBE505B68
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345453AbiDRPmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345494AbiDRPmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:42:04 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E162CE02
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:06:45 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k29so19333806pgm.12
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3piYIJAQxSf3ZdSiYSldVFCzbIdi/p7S0xJYocViPog=;
        b=eWjvN+qCpQxEuTbXGL71Vb/UYOlxOzwKl41lkCDkku1RPfipLk5BUAlnpdCEDTG6Xy
         C0/WR//AKjxFTStn61WJ4VuBhOhhK6KPUK5zyIIRbAWSDJRY55xXEwBMNmFaWrKNGXGy
         pQhW7SuNwEUVLDlbYYo19kU99hAfN6DCC1Z1cVMPAgDhigkLlAmyjxvnbj8aYdsmdXSn
         j0EInSe6L0V+aTakjxsRV6XE5g+0RKeeRNPybUXOlQV6tzdjJf6QDP8RXMPhBwaBD6UH
         xSHevWKqn/LNY/SNe7Ya0xG0CUJztn63GkgtOK3r8TaikxV029WuZqYI0hnR+sH+v+m4
         7DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3piYIJAQxSf3ZdSiYSldVFCzbIdi/p7S0xJYocViPog=;
        b=kP9uTNakydqAU/FGTrqHixwp2JmGXM27Dsgz1CCYwPXxokIfuahgy7VhId98pzs5f/
         QxJX7I94ZEOi47UDGJ4QWq/ZAQgOdX70nhBGxmL3ixqR3FrgQIJXDOuUny57//Z/PMoQ
         frsEzfX9I8wqo9RGy/bcIRc3c/n/ZwrqbdoOkqZGhwG51vIkWLBpOk9EwCyMflkwPVAQ
         vOtTHYvzOWMBGld7SAGpwiUgLadLi3Ym7SIuYmLcudYTswMX89vp1Z9IeCJSMOArrPMy
         IXUHsPBKy8484JU+Amj7WtmUhJy2B5ygVGIB1d1aZFAcS/LE5MlXwwFFnjjg4iIL7KPa
         r/Ig==
X-Gm-Message-State: AOAM531GhG1zQFBJf4H1qtsQX7jIAwicUPqQqk1z/jxHQ9aDLqPrkRNF
        57pl4CGjnemCm3rIugvxRTSWEA==
X-Google-Smtp-Source: ABdhPJwlsmXOqV9LSODPmpJA5FJd8FtjGsFnkv80Ij+4kjZ/CMx66zQ9rqDmPpYQ37f+rgpZDLdARQ==
X-Received: by 2002:a05:6a00:1a8f:b0:50a:8c2d:2edf with SMTP id e15-20020a056a001a8f00b0050a8c2d2edfmr1499950pfv.82.1650294405157;
        Mon, 18 Apr 2022 08:06:45 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id j63-20020a636e42000000b003987df110edsm13411569pgc.42.2022.04.18.08.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 08:06:44 -0700 (PDT)
Date:   Mon, 18 Apr 2022 08:06:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baligh Gasmi <gasmibal@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH] ip/iplink_virt_wifi: add support for virt_wifi
Message-ID: <20220418080642.4093224e@hermes.local>
In-Reply-To: <20220417225318.18765-1-gasmibal@gmail.com>
References: <20220417225318.18765-1-gasmibal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Apr 2022 00:53:18 +0200
Baligh Gasmi <gasmibal@gmail.com> wrote:

> diff --git a/ip/iplink_virt_wifi.c b/ip/iplink_virt_wifi.c
> new file mode 100644
> index 00000000..28157d85
> --- /dev/null
> +++ b/ip/iplink_virt_wifi.c
> @@ -0,0 +1,24 @@
> +/*
> + * iplink_virt_wifi.c	A fake implementation of cfg80211_ops that can be tacked
> + *                      on to an ethernet net_device to make it appear as a
> + *                      wireless connection.
> + *
> + * Authors:            Baligh Gasmi <gasmibal@gmail.com>


Please add SPDX license header at start of file.

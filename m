Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0402825C9
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 20:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgJCSKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 14:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgJCSKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 14:10:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318ACC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 11:10:07 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y14so3060470pgf.12
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WKaRvvIuGMV9Y9SbY0J9Fqf4v5aSqCYAHGluZJyVI8Y=;
        b=m8zTfgZ5nk9zsbwak/95hsjBMrNTButQ1J5Cb8nADIOZ2+S/Qja97ZlIRUThOFMEpn
         80b4Y65Lz9DvoRex/MutNcLqtVYUQ86W0HSClKEa1/O4qcXg7Pn1OLAuliH48TzWtpOs
         o3nQ7zFB+G0PhCmXvKvL7C3MysBAURfGO9uxOXnnBObYjp4nvRsvLmSHdakiMnc0ltcD
         5DOA+Aq3rHA/oFrxHjJfY6+F+Yo0ryRJznFx0SngphDI6k9enN/ldQf/VqV/di0HGmZ1
         PpnGaqY0xy+ENWG/uQBFFNyXPCualnpUoFlnef/EByBtxmTi60RiT1ufCfnj0WC3leI9
         XTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WKaRvvIuGMV9Y9SbY0J9Fqf4v5aSqCYAHGluZJyVI8Y=;
        b=fcqfna9wN0y9KRUNWM5th/cAVbWrXtyR6W63al4DtCRnLyjI02Tzeu27y4ESPR4O3P
         K6HoKnaG6ifLjQEsFWvAPei85DY0T4YJOMkOoA8ZMIg0Sdz7hqF2Wt+fsoEtYpQL1fgF
         JnT9vWY7R7PWlGax98/4O3aId8oE8P7VZg42CosoGTa163xdMtmO9eGbj/QmwYAp6M3U
         +8eYDItSANvE6m4ZeC+ibjdkjPEjepzF++kcWeHgeH+GWmQa9KVVFDClm9EWQDoQNSEI
         THnW5TeJ7hXTXJEAfqjqM/d/TE6kkhZVgTRdnnwtN3f07TFY9C+x0LNu6NaCwfu8PQ0K
         Drog==
X-Gm-Message-State: AOAM533KHivqB4Sn7VdfKUD4Ekf8Tj5IURZp0A9a6WKV2qXT3nBzLLzJ
        g3WrMu/+VTfgeMZC96kx3x75mg==
X-Google-Smtp-Source: ABdhPJxxRGSwyvauZGdczsNIUBw0WVAFLO9XyQLYPB9rMnifnyGsOSSL0g0Vez7LEq2jerA2D4AWWQ==
X-Received: by 2002:a62:54c4:0:b029:142:2501:34d3 with SMTP id i187-20020a6254c40000b0290142250134d3mr8644081pfb.44.1601748606618;
        Sat, 03 Oct 2020 11:10:06 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a5sm5683044pgk.13.2020.10.03.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 11:10:06 -0700 (PDT)
Date:   Sat, 3 Oct 2020 11:09:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next] drivers/net/wan/hdlc_fr: Reduce indentation in
 pvc_xmit
Message-ID: <20201003110958.5b748feb@hermes.local>
In-Reply-To: <20201003173528.41404-1-xie.he.0141@gmail.com>
References: <20201003173528.41404-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  3 Oct 2020 10:35:28 -0700
Xie He <xie.he.0141@gmail.com> wrote:

> +	if (dev->type == ARPHRD_ETHER) {
> +		int pad = ETH_ZLEN - skb->len;
> +
> +		if (pad > 0) { /* Pad the frame with zeros */
> +			int len = skb->len;
> +
> +			if (skb_tailroom(skb) < pad)
> +				if (pskb_expand_head(skb, 0, pad, GFP_ATOMIC))
> +					goto drop;
> +			skb_put(skb, pad);
> +			memset(skb->data + len, 0, pad);
>  		}
>  	}

This code snippet is basically an version of skb_pad().
Probably it is very old and pre-dates that.
Could the code use skb_pad?

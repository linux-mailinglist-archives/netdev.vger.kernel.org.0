Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017882AACF0
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 19:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgKHSsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 13:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHSst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 13:48:49 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E49DC0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 10:48:48 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u2so3441813pls.10
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 10:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V8z/17AfRc+zwPmHdko+gVQ+WGXr0fm9n7jf667C6nE=;
        b=QmQ0hAdrX9CXzVPURRhSnih+9LCzh1uXhFi7eiLneQ/iqOkGGDv9xy43X7EKBgNvDm
         IJJvQXGq0orkEcQrFbrxY6xg8Lj7z43tYa8zClj5gF0r1btZsbF1/cJ7IrMQM3mUg1eH
         BfC27gK21aDdZt86lsz0HnblM8/2LCOJamZe++LUMdBe3uclzpSashRt6TnKJwNM6G66
         wxIjlEv/qK0T5/Y10V1UaOFWjlezNXneiUBJkeF6x+vjAqbPeIiWOIfTcoIXOeoOufZZ
         pIddAI8/Bwcvu/l4Y/aqicFBELkBIMoJQTMOyhJHgXo7E1ptLeMdcl3x9DUSUaz8lO3t
         6gFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V8z/17AfRc+zwPmHdko+gVQ+WGXr0fm9n7jf667C6nE=;
        b=ulaBYNA1eprYePzdi4FYH/PAjRMPOcVwMjivzWGUa9oJGpt7vfAj+/g7gVA6wd0OKx
         50to983a6LQ7AtM12zxh5EJb1DWeoo2XBJWbe9gYXCZu7+li6tonjQrYJlkMKKCE00Dq
         3qxR/WxF4uaiJnvQhZ+EcI4HLoyVVjAI3CaNcmAcSObzKVRFH4eFhx+XkbnjnUkYbUc5
         GtZ8OozgK1ZV/lncNsfEKZ0O6MQRpGPH2zQ2qhHkHn3Ua2PUMpfKRbN7J8X9YNqnom2p
         UGardCMdmORj3734LSbUihGfRaTr4gk9UfD3jKzByDlpaxNisMnxlUcUhKKf05g6LgOr
         g6ZA==
X-Gm-Message-State: AOAM5314ku5W1gUIC25TTVhENXw5qVjMm2SaVlgSyfapvxOUL/f0SbZE
        xCdUVWms91aNjdu++PIU2c3piJsQ1i6fP1mf
X-Google-Smtp-Source: ABdhPJz8flxbELaNUORY9s8CEurpwjUdR248TespRNNtiIoHNMW+LYqNTc/5zjhzXWUqId3hHV96iQ==
X-Received: by 2002:a17:90a:5d93:: with SMTP id t19mr8833961pji.220.1604861327908;
        Sun, 08 Nov 2020 10:48:47 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j11sm8908213pfe.80.2020.11.08.10.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 10:48:47 -0800 (PST)
Date:   Sun, 8 Nov 2020 10:48:38 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc-vlan: fix help and error message strings
Message-ID: <20201108104838.52b1abca@hermes.local>
In-Reply-To: <d135c4b67496e00dbb4ad91f5a38feee2d4ea075.1604314759.git.gnault@redhat.com>
References: <d135c4b67496e00dbb4ad91f5a38feee2d4ea075.1604314759.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 11:59:46 +0100
Guillaume Nault <gnault@redhat.com> wrote:

>  * "vlan pop" can be followed by a CONTROL keyword.
> 
>  * Add missing space in error message.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17A4307F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbfFLT7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:59:17 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:33105 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387468AbfFLT7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:59:17 -0400
Received: by mail-vk1-f195.google.com with SMTP id y130so941725vkc.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 12:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Ybob6G4/RgxkIUDWvbYn3Dj2Z5pOioBKuJ32kUZtOb4=;
        b=VUFgYUy/L2lnjtYNdM6Qtqgd/edTRKpJPk3wvG+vRsDfwQblECyair288QVyMWN6Xx
         2KCbIUt80VMbCkDhwsem9Z7I9ThHvXOb6KwzE+b2Bf2WiZr2ZAoYxkpz8zlbB9pEZDiy
         QdF8tDPqWu0zQiHNUX7yWE2wL0OJt6jrZQ3X7MJbrI1+obKoB9hgX2cAycK9l2jG/E93
         /0YXsl6PD/jGQ4zqqx/uhocrfyYaHR0RbnZj5xAwLV/isuQi6sLZ6lnjBPO1koSNo79U
         YR3VHsiMtrCBF0iBW6mt2YyKndEjR8C3GNxLJ/eYnsWXCCRbGLquLt6Z0LiYMoUckT66
         fZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ybob6G4/RgxkIUDWvbYn3Dj2Z5pOioBKuJ32kUZtOb4=;
        b=gfRAb0eQgPRD0jPAVdu7Nvf36kPo7c5nH3E1VFXa6q6TcNvCm3dAE8s+C33+XFx+zy
         Qwdk/ePJATgqQu4dTXMY9Ps0BJcyx+pj2drL0OKKIWvP5sAc/uC6CyYA1zL4+6l2ymlM
         FyUm7mDrFbAb7pJ4aHBKR1YIvILn6cQ4XiWbrop2Koq38CiNYsr3qBrrGAcazuNTuH8g
         NTFQLu9mbVIzQmu4SB9Qlyj03pXFuSMhGD7dg1IGBtjOOyEKyJQPDiPYnrorYsV841/K
         1U9nRqQY/llJ9k1NTr+hgbrWgLEhOAuHg4wicabKV4LD+rRmZa16gvj7VqUKE46A7kh4
         c4OA==
X-Gm-Message-State: APjAAAXem6/xPF85ON0X31EYGUAEz4VJz77MJYcIWvRox0FshLHTEAmd
        E0D/h7pHk5rPVMRy2Uut7+/1pw==
X-Google-Smtp-Source: APXvYqzf7zquRH5DAjzGb65HiAYfn8puj5zPaUOZhtehgtgFrm66azwNRJtGNYQxusE1XqozQ7PZMg==
X-Received: by 2002:a1f:6347:: with SMTP id x68mr19508435vkb.64.1560369556242;
        Wed, 12 Jun 2019 12:59:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g41sm461937uah.12.2019.06.12.12.59.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 12:59:16 -0700 (PDT)
Date:   Wed, 12 Jun 2019 12:59:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     peterz@infradead.org, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] locking/static_key: always define
 static_branch_deferred_inc
Message-ID: <20190612125911.509d79f2@cakuba.netronome.com>
In-Reply-To: <20190612194409.197461-1-willemdebruijn.kernel@gmail.com>
References: <20190612194409.197461-1-willemdebruijn.kernel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 15:44:09 -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> This interface is currently only defined if CONFIG_JUMP_LABEL. Make it
> available also when jump labels are disabled.
> 
> Fixes: ad282a8117d50 ("locking/static_key: Add support for deferred static branches")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> ---
> 
> The original patch went into 5.2-rc1, but this interface is not yet
> used, so this could target either 5.2 or 5.3.

Can we drop the Fixes tag?  It's an ugly omission but not a bug fix.

Are you planning to switch clean_acked_data_enable() to the helper once
merged?

Thanks!

> diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
> index 42710d5949ba..8c3ee291b2d8 100644
> --- a/include/linux/jump_label_ratelimit.h
> +++ b/include/linux/jump_label_ratelimit.h
> @@ -60,8 +60,6 @@ extern void jump_label_update_timeout(struct work_struct *work);
>  						   0),			\
>  	}
>  
> -#define static_branch_deferred_inc(x)	static_branch_inc(&(x)->key)
> -
>  #else	/* !CONFIG_JUMP_LABEL */
>  struct static_key_deferred {
>  	struct static_key  key;
> @@ -95,4 +93,7 @@ jump_label_rate_limit(struct static_key_deferred *key,
>  	STATIC_KEY_CHECK_USE(key);
>  }
>  #endif	/* CONFIG_JUMP_LABEL */
> +
> +#define static_branch_deferred_inc(x)	static_branch_inc(&(x)->key)
> +
>  #endif	/* _LINUX_JUMP_LABEL_RATELIMIT_H */


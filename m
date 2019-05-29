Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262162E0FC
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfE2PYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:24:53 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36485 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfE2PYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:24:53 -0400
Received: by mail-ed1-f65.google.com with SMTP id a8so4396415edx.3;
        Wed, 29 May 2019 08:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AOhqzUAxlGKodCRxuMU8esRv5KCDTyEceuRVZE5YKAE=;
        b=LUKPaIyVSPlGbsomElQBWm+G2NzC4TQ5UZT1oNDTO7H9QTtKu4MRZl//GYb9DXHgwI
         mu7aQXd5rXFZWII08OmS27B+UyYOitWuw8Uhgd7qpwi4ZBLu5iiNEkPxqFLX06KXdjp9
         Jo3FpFaIojk76y+KdH/Y75ZyuY30lJTk+rbmNpgzTU9WH2GF+c6gjddfoUoRlNu9hQE7
         W8skTqoI0bqW0GDqKRK2kSRsQmjrBbkJPMJZn/vr5PqyvjvGNqZRmw75hre1qZxPLzDL
         3HOowpldPD/YJVUVIXiW7EPP1T2tweSVPusuyKZ2+upaWW4MM3jmiZQ9HE3uNxEucypW
         PHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AOhqzUAxlGKodCRxuMU8esRv5KCDTyEceuRVZE5YKAE=;
        b=tkIktp4LJc9mrUmB9v6R/80AmroAIXVkPzZz30DDj8M3lKPNPJPuu8MMzzm+Scp8sU
         e1DZ/pv8rDCLFDG9QG/vZfZ/LVuvydAfmWVziaHdhQfOgrKzx3ScwMY/Az0TgYplAeso
         FtYab531yjElxw3aLerTOHfjmmE3mFQmzZMvRRbg0hSebFvC9LQ1eNTyoe/M62wMXaSG
         56Zh7522jiItm0xRN4posTXumci9uq3HslLREj8W1Ae2EaOVe+YmCYIWOrMZMqCgtL6Q
         sK61cb+X77fd/OzV4+VFlfzsn0HwVBFkNAcPUDy9x58tI+pSqMB8NAUtGwCYuYkWa9+W
         li+g==
X-Gm-Message-State: APjAAAUvGyuf5hv4o76EVj88qMzN1GV8wTS56+q+dOF0xmO1GS/1Gs/G
        DZZ9ZZOg0WAnnnMBXKHiDyi5aDHrTQS5KWjmGtXmIBFp
X-Google-Smtp-Source: APXvYqw4Gdm33WaVTrLAwQDiQTnH8/jR2O5WoGqdKuN5IW0fBkle1XlH3LFyPrI+u4eGsFdB9bJjYEOQQ4i43AdnxaI=
X-Received: by 2002:a50:92a3:: with SMTP id k32mr135287797eda.123.1559143491526;
 Wed, 29 May 2019 08:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190529143432.19268-1-yuehaibing@huawei.com>
In-Reply-To: <20190529143432.19268-1-yuehaibing@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 May 2019 18:24:40 +0300
Message-ID: <CA+h21hp=AAfK_Syvu1wSD8gH7hNhbE8FbH=hM0Nt=bzxBWxVRQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Make static_config_check_memory_size
 static
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 at 17:35, YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix sparse warning:
>
> drivers/net/dsa/sja1105/sja1105_static_config.c:446:1: warning:
>  symbol 'static_config_check_memory_size' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_static_config.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
> index b3c992b0abb0..7e90e62da389 100644
> --- a/drivers/net/dsa/sja1105/sja1105_static_config.c
> +++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
> @@ -442,7 +442,7 @@ const char *sja1105_static_config_error_msg[] = {
>                 "vl-forwarding-parameters-table.partspc.",
>  };
>
> -sja1105_config_valid_t
> +static sja1105_config_valid_t
>  static_config_check_memory_size(const struct sja1105_table *tables)
>  {
>         const struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
> --
> 2.17.1
>
>

Acked-by: Vladimir Oltean <olteanv@gmail.com>

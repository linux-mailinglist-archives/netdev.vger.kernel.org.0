Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45F49C4C1
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfHYPs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 11:48:28 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36049 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHYPs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 11:48:28 -0400
Received: by mail-qk1-f194.google.com with SMTP id d23so12286957qko.3
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 08:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=h4+inaCnbIBFhDKg2+KllPT7M5dOj0n22xmmtmVKWVY=;
        b=COqjTt9xsU/wOjkB4gn+K07VQJ//67JsXTAEGSNnsjLcgdSZ93xGQ+Jc+XOOvtKC9w
         C4ln/6BwNLNxDM1HfHCvo1ynLHPcvi1RRNAgDFInE/vw/svC3DbsWGon+yUWvxjjz2/T
         X39WQ7rcytUChjkPlLHk2bYl90VWtVFPzhIcGddpzuOTSqcq4ticnsZRXK/AqVkEn+vD
         h5Pt3qQOgDzenI6/uk+mxiUJ/b7FvhG7jjUL4+Hg16endudI7Q2gNRfVvatLi/9sIjVH
         M9hzB0IooeUNmPiZiIrx0lA9yZNvErhq3ZrzF0xtgyNmyTfyr/82eUwZrRYNRIeJvi3Z
         D2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=h4+inaCnbIBFhDKg2+KllPT7M5dOj0n22xmmtmVKWVY=;
        b=Vh/9r8v+rJFvSoZy010dN80MOwAn+NqlB2cYcoqNLyD3OnOw/W4V26g6kVWwY3rxyV
         11kuOSD14jO9hy69D453F7g9zqpfHh+r3WyJZR+TACd4xz69L+Qc4cNLaYG6Iv4tYsX6
         YrnOjsQB9iK657kkiQ+ZQoFJSmY1DOZYtegyMyDSImVR5LyipHnId0P0jz1teMCwovQN
         JjrU1ieOuv2z8E9T/kN4Xn5gdeTGJ0u5WQ76EX41zlOTNDvYW34M0I1UK5ArtnS6WqD7
         t94TAnjcLKmuI5/pVo1OU/soAdO9uvwcvjsihOesAV2LsZwt2DCwxxlTgvY6mJGK20hz
         nEVA==
X-Gm-Message-State: APjAAAXqD2W5GYDm2nDZWW7z521i3SMM0SJhEhztSKNXvT62dq137Kjc
        F7JwAX30jCm72NstsFlhS9T1FO8X
X-Google-Smtp-Source: APXvYqxmNn100i3ksUm0F2UtI2MKPY3Cmcn+NZXOSf4SclV8c9WDq/Dz0+5vrnH4rHQVj3ifrgdqZg==
X-Received: by 2002:a37:e309:: with SMTP id y9mr13124259qki.105.1566748107518;
        Sun, 25 Aug 2019 08:48:27 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y1sm5260919qti.49.2019.08.25.08.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 08:48:26 -0700 (PDT)
Date:   Sun, 25 Aug 2019 11:48:25 -0400
Message-ID: <20190825114825.GD6729@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v3 3/6] net: dsa: mv88e6xxx: create
 serdes_get_lane chip operation
In-Reply-To: <20190825035915.13112-4-marek.behun@nic.cz>
References: <20190825035915.13112-1-marek.behun@nic.cz>
 <20190825035915.13112-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sun, 25 Aug 2019 05:59:12 +0200, Marek Behún <marek.behun@nic.cz> wrote:
>  void mv88e6390x_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
>  {
> -	int lane = mv88e6390x_serdes_get_lane(chip, port);
> +	int err;
> +	s8 lane;
>  
> -	if (lane == -ENODEV)
> +	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
> +	if (err) {
> +		dev_err(chip->dev, "Unable to free SERDES irq: %d\n", err);
>  		return;
> -
> +	}
>  	if (lane < 0)
>  		return;

[...]

> -int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
> +/* Put the SERDES lane address a port is using into *lane. If a port has
> + * multiple lanes, should put the first lane the port is using. If a port does
> + * not have a lane, put -1 into *lane.
> + */
> +static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
> +					    int port, s8 *lane)
> +{
> +	if (!chip->info->ops->serdes_get_lane)
> +		return -EOPNOTSUPP;
> +
> +	return chip->info->ops->serdes_get_lane(chip, port, lane);
> +}

Using an invalid value is only useful if it can be interpreted by the other
functions of the API. So I would've make lane an u8, assuming it gets modified
only on success, which would result in calls like this one:

    u8 lane;
    int err;

    err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
    if (err) {
        if (err == -ENODEV)
            err = 0;
        return err;
    }

But at least it is well documented, so we can eventually fine tuned later:

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>


Thank you!

	Vivien

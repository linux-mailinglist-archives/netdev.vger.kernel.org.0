Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4D09C4CD
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfHYQMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:12:17 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33665 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfHYQMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 12:12:17 -0400
Received: by mail-qt1-f193.google.com with SMTP id v38so15777123qtb.0
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 09:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=gggxrlzabhE4vKqKZ3+DTwOHu3O67NMNvwtq8OgNBgk=;
        b=sxQjMm69Y2hMnkflsuUtgQNbv3HsQhh9op2Khdoin0UOtcvIoWmmI0DkA/Ft5jWp+d
         d37Uo3ddvwLYh7x4RM3U9cpNvRW6FUqvO+Bt5E4YsjP9BTd7d6YWDwYIfitwD+gBxTTV
         /A1r0Y/bzJE1njHUUoQ1yRPi4+aEX2VcCMpMlXLrX1zBIR3sbTZFxYEEdK2fx0WECWRe
         iWPvsMOgp5XQwCQ5NOnETwjdZhQIhaZkvMU9xaG421NmhyNb4c805ZA8T9xjJYJe2/Vp
         KMXTL6Atc/9UXcYcF00zK5AMMMt2Zu8RjMUsjgAKlcmiO9C9bED5os30W1gyvf7iN+NO
         OBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=gggxrlzabhE4vKqKZ3+DTwOHu3O67NMNvwtq8OgNBgk=;
        b=STlp4WtIuHgv/CUf0OmJoF7jcXbrUSjDRPJPq4JaEaTn8KGV5PxP9ljPcg8LCzK2rF
         v9MC/9VjfQd0B4uuLoRsg2rZK5c/J+r30CltlBwm8V3fXycc3Y2HtadO9gv2XL38hXRc
         xnXsY9Cgn8RzmzgtDx5dc2SpwsJwPjLj6qU8atY5VnUnMOiI75f7Veq8hhgFya/o51Kv
         4U0t5rhq4tJc1utHTwCjF2mNua/Qem8JyIJzheq3Nw4kKA2oQ2DRwjwosrpQP5sjnG3o
         J1rKc4xXMN7sWzJp7Z6sFpQUSrq1p5J5Cc5eKkmIWn1eX5E5QY5NQXapVjVyJBmiovgm
         siwQ==
X-Gm-Message-State: APjAAAWKsMx/XfYxioVAeTfjJQXGOdklWgDgrVG8gODFVAOCLyOlKJKi
        xGJHa+R0QtTd6R/fH+IVLiE=
X-Google-Smtp-Source: APXvYqzmB+TqX7+jdrw7Kd/0IlcZjf2vuz7G4ZfcserHxR2Htvm2qqQ9rqUrfNGaMCAdnhTlU4Al+g==
X-Received: by 2002:aed:3a82:: with SMTP id o2mr11408731qte.3.1566749536404;
        Sun, 25 Aug 2019 09:12:16 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o34sm6981702qtc.61.2019.08.25.09.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 09:12:15 -0700 (PDT)
Date:   Sun, 25 Aug 2019 12:12:14 -0400
Message-ID: <20190825121214.GJ6729@t480s.localdomain>
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

On Sun, 25 Aug 2019 05:59:12 +0200, Marek Behún <marek.behun@nic.cz> wrote:
>  int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
>  {
> -	int lane;
> -
> -	lane = mv88e6390_serdes_get_lane(chip, port);
> -	if (lane == -ENODEV)
> -		return 0;
> +	s8 lane;
> +	int err;
>  
> +	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
> +	if (err)
> +		return err;
>  	if (lane < 0)
> -		return lane;
> +		return 0;

In fact you're also relying on -ENODEV, which is what you return here (and in
other places) instead of 0. So I'm afraid you have to address my comment now...

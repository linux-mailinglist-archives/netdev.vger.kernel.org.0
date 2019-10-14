Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2BAD6758
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbfJNQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 12:32:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43671 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfJNQcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 12:32:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id a2so10674404pfo.10;
        Mon, 14 Oct 2019 09:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bbNv5r8ZEgo2klckjtwCJ+uy/NE4DajxSSdHBiONtmQ=;
        b=NRIWBDA0wuXd5nMa/NwBMp+dyszRzh9iqKIYIjzInlea9AXBF3mHK4at9kYSD1nyqc
         L4HTojjcteGw2rPkOJ4tby1uv/A6dNv0mS1/W0L/SzyjdwhVlk1+8HlEJCB5NqYToN2P
         JLeuVsNu1V3W1e6YT0gZ7uhfZjQ2pfpdg+257lCYr4MBcZmFXXrY7V7IdJHvbo2eA72H
         JX0XapMdZib0E8vEyWNKP/l/WwIqfs/DFW++usD0K59lxLQwEeRjREOpSA/zyxEglhgx
         +OdzDaewbJ8OvnS56Ix5+5uOy7t2/ytNF3TwLJMPvpDWT9tGDFjIzd8243aCMc2PfuuF
         8WPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bbNv5r8ZEgo2klckjtwCJ+uy/NE4DajxSSdHBiONtmQ=;
        b=fMoR2rSuHyPurthDJDxGRcilRZrn3Kvwerb5hjKSGsYf9b5AAaXjYM9Oo7r/wTrqDk
         RnTvOShZeROwPs0as2S1aDQNer471rBF0bY6zAMyL1/vMr1K112QnA2f+Fnbi09PlLZ2
         ZHrKlLLOCCSkbI/LuYES06lvvAjjRaFDhq2cWpLHO62pv5vJTY9WIqDY+yab44HxWOUX
         FA8bXQ/WShBAzUQa1pyKS6KwmN/wxTQzGHQKXPweqzGWjvuTiYlsqnRUfCyuySbrvYge
         skjx6ZSU/VxkY5vud5vYVcUo/u7BlLWLHUXqGLcREX8nE675TzUiRBk2WG/LvOFl2p+S
         4koA==
X-Gm-Message-State: APjAAAUmbmqXj5ZaM8Wr1vqyZiT+5SihTpX0B29/lMwZeVPWKIHmYWUP
        XQKtDseyPU9iS10uc8UcrpI=
X-Google-Smtp-Source: APXvYqyclCbmg0wJ8cc81qELuVbQ7yuoTJSvsz+o1UUSRHChV7nWd0u41mTuR4sdHiqyefPpPE5dug==
X-Received: by 2002:a62:e70d:: with SMTP id s13mr33923023pfh.224.1571070725204;
        Mon, 14 Oct 2019 09:32:05 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id v8sm50105279pje.6.2019.10.14.09.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 09:32:04 -0700 (PDT)
Date:   Mon, 14 Oct 2019 09:32:01 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH 0/3] net: phy: switch to using fwnode_gpiod_get_index
Message-ID: <20191014163201.GM229325@dtor-ws>
References: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
 <20191011204242.GH229325@dtor-ws>
 <20191011.140540.2027562826793118009.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011.140540.2027562826793118009.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 02:05:40PM -0700, David Miller wrote:
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date: Fri, 11 Oct 2019 13:42:42 -0700
> 
> > I see that the patches are marked as "Not applicable" in the netdev
> > patchwork. Does this mean that you decided against pulling this
> > immutable branch, or you dropped them because of kbuild complaints (that
> > happened because it could not figure out how to apply the patches)?
> 
> I can't, because the dependencies don't exist in my tree.
> 
> So submit this into the tree that will have the dependencies.

Argh, Gmail decided to stuff your original ACK and this reply in spam so
I completely missed it and just fished them out of my spam folder, sorry
about that.

OK, I'll add your ACKs and forward to Linus Walleij then. I should have
had him on the original emails...

Thanks!

-- 
Dmitry

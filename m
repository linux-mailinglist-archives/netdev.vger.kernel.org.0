Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E4E5B802
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfGAJ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:28:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36224 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfGAJ2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:28:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so12987607wrs.3
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 02:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TVa7BZVGfSVHKC1+sJSJ5WBILZeAdecNHAPrES+3RKs=;
        b=iDY+VZ1wRI1OPEac3QL2xiuSiPkoFTgMTLjTZEcXN8q2Xzo/6K4vSW7fr7OcVPahCj
         nXhow62k/jxQv78mjB3svVK4wzDC0PmlNFiGG6qgY8/5tY0feXEm6r7iVRxVR5k2u/TG
         vE/tRUogaurnERVEzqlxjlkBxxzz28UIctLpVU7/3CrVHPU++ZlU4rL/w2grLAr3lZOm
         fBLsWiRbMwVqhF6euib4QAgCHp1NGXJ6hwAVGMv5d7dnTKjDA81ygzlNJ6hT8GSIRD3m
         Lq7hQeUFZ51qtOxxhjACltKfrvvxV73IEU05taCQC51w6POgrsFretSW5QM/M7DMI28C
         vzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TVa7BZVGfSVHKC1+sJSJ5WBILZeAdecNHAPrES+3RKs=;
        b=TIDMVA0On23hDhOmzgIq0y/V9/noDXSUXMfr3Ip1+pnd0bjsEMd27qR0/ykel8Gyol
         Qlk6XIVon9KD17CD2MsfAjViXhbtth/buz1KR44B1L9OD1w+JjeFa3C+qffdY//fRKre
         gguKBo4GcLH/e4YIjxqtVeLypuJkN7zOJr9K5bFv+fRdJeXJ7dr/Hd9sCJSBmxvjckpA
         A1qH636aDpQHZ5LhFcRU+GZjoaA+XGiOn6/j741XBg+5jXLwmTKTxG0fqhByXrDOTXji
         eROuB+hsiYUr1oW32C1uUso+rPu3lbv6q5ylbgauFpiSg/nKyXdawwpOO6liVsGHaAW+
         I92w==
X-Gm-Message-State: APjAAAXhA7la7fs+W8f106a6TgP6e04ryZCYF0Z8Q34h2j2r1FAOs3cp
        seNG9+6PCGEpNqvS6pOPu1FaqQ==
X-Google-Smtp-Source: APXvYqxneWhpoTvhpq7f1pi7fSRdiJa0zWAskBXvTDhAqoU5KKOZI4ypp/mWX1zt5551OuU+Q8kmMg==
X-Received: by 2002:adf:f483:: with SMTP id l3mr19511140wro.256.1561973279389;
        Mon, 01 Jul 2019 02:27:59 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id t1sm14508384wra.74.2019.07.01.02.27.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 02:27:58 -0700 (PDT)
Date:   Mon, 1 Jul 2019 11:27:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] bonding: add an option to specify a delay
 between peer notifications
Message-ID: <20190701092758.GA2250@nanopsycho>
References: <20190630185931.18746-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630185931.18746-1-vincent@bernat.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jun 30, 2019 at 08:59:31PM CEST, vincent@bernat.ch wrote:

[...]


>+module_param(peer_notif_delay, int, 0);
>+MODULE_PARM_DESC(peer_notif_delay, "Delay between each peer notification on "
>+				   "failover event, in milliseconds");

No module options please. Use netlink. See bond_changelink() function.

[...]

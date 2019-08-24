Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C3B9BFE5
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 21:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfHXTpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 15:45:05 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39385 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbfHXTpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 15:45:05 -0400
Received: by mail-qt1-f193.google.com with SMTP id l9so14471566qtu.6
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 12:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=3Hi8DLGaMoYen/EinqUwacfRJbZ+z3xP+OAMpzo+G4k=;
        b=TrzJe5qcZ2dYJBS8HHlrmMZ4GwUSaTFe8FHXOznCoyrwJpQ3JZo2mavzndnczWgPz8
         EGk2YaYLZtat1IYq4wFk8TPU1AhJvrhVsJmrVPOfEvujGJRcg80nf6Nm+hPxdNZIDnYl
         wblzFtMqINW1eL0HOObjS2x8ILPv3GCysDWstxvsVf6dhMKwBigBSz63BKM80/Z9KxWh
         iVC6ziPuaOp6uYIqQutMOYTGZh71eTsJBM5MCZtQuoIDgkWiXFM6FkVIv2XND+83zoBq
         EJmVdcDtQ7oQ40JSOXPrqqkyPdE49eBPR5tRtmC5fv5OBgYdmz5NYyg90lNyANINrwRE
         /jEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3Hi8DLGaMoYen/EinqUwacfRJbZ+z3xP+OAMpzo+G4k=;
        b=PkcKWTFq549Xrc3ZJbhKubGhTJ1xZjuA3BrrBGvSICxjomS2/bbhAgEZyzOaO5DyKm
         IlEwGIwQcuSg7Zb2kdyOJX6fruEGwjHVr1SCOKcodGVmYcFh0fCPXh0VlxGnjZo+7Xt5
         ujP4XKwbI5+F09bLaSCaiZuTXxkAW8wZ3tw0DzCcXw/T4fwi8FkdQhXKPUeXPjSQpFCZ
         ZTPRl1r6JlMGrNDhHZ9N5gtDI5pefJ6aOQNoV4mhRDOeHMwOzamBiXiy8g6LR78SdX93
         55SLtSZhfdJbIfS1s5bg/6e+ZsmjXEWLkORuxvAsnmIsr6091uVCcjZgtrWXjurlJ61u
         gprg==
X-Gm-Message-State: APjAAAUUfpjxxK0IFH/6wtVcrFb63lwisw5xxKcs77zAV5rnY05LNwKq
        ujzcuS3vkEPEARSl1ETeKHg=
X-Google-Smtp-Source: APXvYqxGpm0jhIhp/GqFVuJuc1Pt1MM2/BHmvFJZRvL8PWQeGsH9RZYRwwZOhlzE3dXjZpTEjAfDsA==
X-Received: by 2002:a0c:b656:: with SMTP id q22mr9358454qvf.183.1566675904240;
        Sat, 24 Aug 2019 12:45:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 18sm3436802qkh.77.2019.08.24.12.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 12:45:03 -0700 (PDT)
Date:   Sat, 24 Aug 2019 15:45:02 -0400
Message-ID: <20190824154502.GD32555@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v2 4/9] net: dsa: mv88e6xxx: create
 chip->info->ops->serdes_get_lane method
In-Reply-To: <20190823212603.13456-5-marek.behun@nic.cz>
References: <20190823212603.13456-1-marek.behun@nic.cz>
 <20190823212603.13456-5-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Fri, 23 Aug 2019 23:25:58 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> +	/* SERDES lane mapping */
> +	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);

I would prefer to keep the return code strictly for error checking as commonly
used in the driver:

    int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port, int *lane);

Also the "lane" seems to be an address, so maybe u8 or u16 if more appropriate?


Thanks,

	Vivien

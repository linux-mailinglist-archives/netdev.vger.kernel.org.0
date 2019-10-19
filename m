Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5AFDDA9B
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfJSTOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:14:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40084 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:14:04 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so9027739wmj.5
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 12:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fGjGgZAvR0xYF5RiXrzh4GSVMjnHPrljcIDz/WICNo8=;
        b=CKhMHLtNCdZndvHRJ4e5qsRD0gJhCgBzIhpvT94545MS1yrj1jEAmyCdSAbXj+9XNh
         MSzON9/UqpnlHwDifh2SQvi3tIeX5wOFFYir5ia5/y0Qqz9SWPpeH7MEv7p/qo+DU1/W
         J4dWxLPlSNqAur9NBXIXULZgoidnR33p8aRw6rFZBQ7FL+iqoTFkIS/F0ZqDLKtYhMRP
         3Rdr9qIiff5OpzaN+zA1auJ8bjsXrQS2IZGn/98AIzOwqhHpX+xoahHdU1m6z/TqNUJH
         CvKzLORSIFEjhW8xbwqUDD0l3xBn/IOWCLl2MwPW49a8mvyaqN+F2xEOG/zgca2gQFNQ
         2ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fGjGgZAvR0xYF5RiXrzh4GSVMjnHPrljcIDz/WICNo8=;
        b=c/7EHiksByx7A2oJgzRbJTGrQ6ipg3axx9vBMYlnvkjx8R7DNGUNKHIj1yldZZWu1W
         9BP3tPs1P6ZFxPdBqRNlDI12ZNKnWqcQbkvbvUoblmb2jfMaJLbdDgmtqAGXs30qNK9s
         7OPIps+kGA2Mq7QGfLBoPpKP9S2Ty8daLlhPg7AV8k3Ptk4AT6aQNNhqd8pJt3weg8D4
         +vhbcdeYgWe5H1bZEK28PRX1F1aGeJ9sdJrhJWDQnlYkh1KToBrlTk/RkOsJJfvEbS8c
         BubLGzEmlgJAvESAiP7om65yxe2vMTiJ4RAD2iU4ogJTG4tI5sl9d9NMHsCTU0abHHaF
         y0Ew==
X-Gm-Message-State: APjAAAVvFC03b+Z95fpQJcc3oSRtc2dzdCw6J+vAVHUNc5hAKICsM4c4
        0Qj1jtew4kUDoW4jeiKxmPSJsQ==
X-Google-Smtp-Source: APXvYqzVxcnZfQC2fTOcaFRTI2rXEiBd6NSlhFueDj5j/BiqNNPBw7RyTj8jczIgMfuAtQ/neZFbVA==
X-Received: by 2002:a1c:99cd:: with SMTP id b196mr12608956wme.105.1571512442697;
        Sat, 19 Oct 2019 12:14:02 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id p5sm9336532wmi.4.2019.10.19.12.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 12:14:02 -0700 (PDT)
Date:   Sat, 19 Oct 2019 21:14:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: dsa: Add support for devlink device
 parameters
Message-ID: <20191019191401.GK2185@nanopsycho>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019185201.24980-2-andrew@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Oct 19, 2019 at 08:52:00PM CEST, andrew@lunn.ch wrote:
>Add plumbing to allow DSA drivers to register parameters with devlink.
>
>To keep with the abstraction, the DSA drivers pass the ds structure to
>these helpers, and the DSA core then translates that to the devlink
>structure associated to the device.
>
>Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Jiri Pirko <jiri@mellanox.com>

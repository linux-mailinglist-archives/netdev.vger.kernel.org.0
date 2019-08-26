Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B749D5CD
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387852AbfHZS2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 14:28:12 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44486 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfHZS2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 14:28:12 -0400
Received: by mail-qk1-f193.google.com with SMTP id d79so14802036qke.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 11:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=AaAJlFhImYkNQwto2hzbdiLb3S7JOZnj2f/W8AiyG1o=;
        b=eH+tLORUmMX4RHfAFxwsiyzu4rYBy4xhWQVPBlHI75BEgPUaw044oQZ9mSEns9jRWn
         DDueASJgyiyGkM5zWLsd+M31iSe+fT7TG+nDGENpQfhhaDh3GyASRjvmYPTlkLBpWeOi
         NSWJpJ5QrEdzSKM+AQ1n87ZqflmU0p0OWxsrUdeiqII5iRnXWCmpjWZmZMgiTGtQEGLS
         v7barqbzF4PfA6aQapFuA5S/zR9zr81tRckozlyXSmUXBrbefbVYCD760cWJVslkd8eI
         /p8c1wNMn1S2l+c+F8FcAKbqLhBEiUnLUHT9aQHBAgdTsSPw0X/RAp3sWTQzct88IfhB
         qNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=AaAJlFhImYkNQwto2hzbdiLb3S7JOZnj2f/W8AiyG1o=;
        b=FHsNIrgM+oZ7F2KBxoAOfW9w/WGthEAdntiY5RlJZHfgUY+E9CyhSFW4wjlOtJWodD
         M4GpVF/rVnn4SSRqi+yGmtqNw+pVrVdJTmyCybLZ9sa7ki5XMet/37CkQGT6wAsOIrgJ
         sMrNhgbJ/yd1mFFhK9Zvaqxc2FAs0u/kSFTln+/n6dAXWZkOhgDKtqENK6pMKXt2hLb6
         V0UHqHRfcvOJcBA3aGJerKzM8Gdmr3SaPx16B+ssUisr129Z6ivRmJiVTbziU/wJbEHu
         kFgwkzgVssMtUmis9UfORdgQGxjQWSEO9ezbiEpHTlsg1o08gbOzGqXlffeRSiGD0SGr
         /wEA==
X-Gm-Message-State: APjAAAV1P0tSlJ2BExkrae1yK7BZfoRH0bvzErp9ccaU6MoX+p+Xnvl9
        V3/pzEUCOCkZQhXQCVmA9Vc=
X-Google-Smtp-Source: APXvYqylqdmhWWtYNkyGn/W6fhzauYZ0sFyknGWZFQyXvF5urAHdBPq2LWYojvtZQg+dWJIJ2/WYbA==
X-Received: by 2002:a37:6109:: with SMTP id v9mr17316308qkb.432.1566844091350;
        Mon, 26 Aug 2019 11:28:11 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f133sm6462768qke.62.2019.08.26.11.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 11:28:10 -0700 (PDT)
Date:   Mon, 26 Aug 2019 14:28:09 -0400
Message-ID: <20190826142809.GC9628@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC] net: dsa: mv88e6xxx: fully support SERDES on Topaz
 family
In-Reply-To: <20190826200315.0e080172@nic.cz>
References: <20190826134418.GB29480@t480s.localdomain>
 <20190826175920.21043-1-marek.behun@nic.cz> <20190826200315.0e080172@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 20:03:15 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> What about this?
> 
> It adds a new chip operation (I know Vivien said not to, but I was
> doing it already) port_setup_extra, and implements it for Topaz.

So what feedback do you expect exactly? That is *exactly* what I told
you I did not want. What's gonna be added in those "port_setup_extra"
implementations next? And from where should they be called exactly?

Ask yourself what is the single task achieved by this function, and name this
operation accordingly. It seems to change the CMODE to be writable, only
supported by certain switch models right? So in addition to port_get_cmode
and port_set_cmode, you can add port_set_cmode_writable, and call it right
before or after port_set_cmode in mv88e6xxx_port_setup_mac.

Also please address the last comment I made in v3 in the new series.


Thanks,

	Vivien

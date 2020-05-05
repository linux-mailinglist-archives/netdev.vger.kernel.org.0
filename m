Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8C1C62FC
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgEEVXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEVXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:23:06 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99A5C061A0F;
        Tue,  5 May 2020 14:23:04 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id q7so378404qkf.3;
        Tue, 05 May 2020 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=OZOGzu+oBJij+crVPXC6j4FuHIOBZ0Y5yruBwGyqEOg=;
        b=phNbBISD4EHq+BETM88YyjRUXDdSFCfacPpfFEkkqXAeteZzjX8Y2S+W+w+klAuan1
         Opn3R8FwPk016fp7vmQ1OvnhJajCugE/cX/17i+uWllYua9Guf4LiavNuZvvBgeRxyj7
         7lJFFoiaMi13zyB62+VksFiYJPg1jM8YgIdCOfdTRRZs4fA0q6ATXKyYcYH10fwOn+Dt
         +Kbt2xWTVWaAJE5YrLD/90uA+31WWa+8e9cplKgespzwLn17hS1RmXOycfuDj50b/ZRI
         AD/dfbovAQ7pWJ4XeSseq3clzeTkVp5hxP7xokb8yx3TdpJ/vwNSMHRuGPOholc83hGV
         +yBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=OZOGzu+oBJij+crVPXC6j4FuHIOBZ0Y5yruBwGyqEOg=;
        b=pASrVvM6JV/zfPjQ3LmSe50FTHq94x5joImUEA6/QKmm9BGt49RMdfB7qoO6Sv0mtt
         YKij3VD6JsFngG5ymezgTcUpn1YCq/Zq5+tAEH84Ej9Hl5+CmQeiUi9zkBqmXil/hOqq
         vsZ2OY3uIZ+eRaxQuwcykiEy5e5ylprXsIJbxKQLO8WUw0C/BiK7zIW21rCl4rmh/j7e
         lVksCIfJISi07uPfwvJcOj1mJ3UF03Uk2pPkFgLQxHkG6SpxMBS4HsJl9qq6tmHy8F3O
         rN/NlRjKPnsZuyHyDqpi57vfSUKVZSFEcitcGBV6xHQwpUbKk/D//Qi6jf0ym9H6SfVD
         Jc4Q==
X-Gm-Message-State: AGi0PuZt7OEKoRsa+H8loBqwKVH50DznZYGjvqgZ2HYZS4NiwAXrvo0v
        svds129WQ6NtRETq1TWqzMMIeLXNs7k=
X-Google-Smtp-Source: APiQypLc7y3yB72dymEd1J8JGtixv7IHpcMAzcgO3nR2cXIQwg6Agh0oEYlRZAOIm5cSi2cCQX24lA==
X-Received: by 2002:ae9:ee0a:: with SMTP id i10mr5765549qkg.367.1588713784090;
        Tue, 05 May 2020 14:23:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g16sm57496qkk.122.2020.05.05.14.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 14:23:03 -0700 (PDT)
Date:   Tue, 5 May 2020 17:23:02 -0400
Message-ID: <20200505172302.GB1170406@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net] net: dsa: Add missing reference counting
In-Reply-To: <20200505210253.20311-1-f.fainelli@gmail.com>
References: <20200505210253.20311-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 May 2020 14:02:53 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> If we are probed through platform_data we would be intentionally
> dropping the reference count on master after dev_to_net_device()
> incremented it. If we are probed through Device Tree,
> of_find_net_device() does not do a dev_hold() at all.
> 
> Ensure that the DSA master device is properly reference counted by
> holding it as soon as the CPU port is successfully initialized and later
> released during dsa_switch_release_ports(). dsa_get_tag_protocol() does
> a short de-reference, so we hold and release the master at that time,
> too.
> 
> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

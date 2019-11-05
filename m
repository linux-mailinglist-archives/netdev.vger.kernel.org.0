Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CF8EF781
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbfKEIrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:47:25 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34650 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEIrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:47:25 -0500
Received: by mail-wr1-f65.google.com with SMTP id e6so18446707wrw.1
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J9c8v+w8MtQiPloBjV49Fn/94tX4yMi8C3LoaMSKaaQ=;
        b=dxN0r7tHUoTV1A13sRn7bvF1/wWpdhsTaPsPcjFrhUwcL7afOrd89z4ZKVJmdR/q4x
         FBAANZXNz9wlGLzfzgss2971nn0diKC8yYlD5+/sJAjQnMsMgBMCThlDcOyf5+22vnTs
         avtdCTFWUu9QAOwjcShF9379erphQ6FqRKMKbOK1gIgZIOp8LJ9OXGnGaVcEoznNDsPZ
         +KHRNnQGNUkVJsxs0Asa6hwCjXNFKCzRcJXpz6IyyQ9nnHYTgPfyu738U61iCgs+EFLv
         yVHYANlPEytFCMrLgMSgEsjuEiNqSoep9v03u+CG09gLi/DOZktyo3CJk/tMiRO1QCz8
         LwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J9c8v+w8MtQiPloBjV49Fn/94tX4yMi8C3LoaMSKaaQ=;
        b=FjCgA/YH1OibJ4l/TXMLGZTiIT0psLAc2rYNP38lgRC2s/1jhayA/8ngpZju2cqwez
         Up6lzHpTG6I47lZMn8rizoNWTEn985wmvqiY9ZnIVWngRdnYfpy80j8YI6CnR0vsCDHZ
         vhdUhM8mbMdfNyUxng+EQuBTasXDgxFyu+sIhc4PVqAoFNXhLd6L7lEwbg9EhR/pfQLB
         sWfT+cZeC7M72y9hSnIxrPJq7DbxtTzO5ffe7bHlroDVGyP+kx0vV4C6ldzo5fZQ58r8
         3qRXYu7S5utNR0Me3QYm21Spo14tu7CnhLolnmSm5HhwMWOg9BIfRWSTiLomdjnNF8j8
         URhA==
X-Gm-Message-State: APjAAAWVpSWtAjC9z1Ol8/deI50NDYOmuA9PMFJZGwuqoVfFdBRXVdo2
        cNK7VoTCPqOjhByGy0Se+HAXkQ==
X-Google-Smtp-Source: APXvYqwG14d5ESyIO3DPT2xn/qcWJBOIi6j1Ehpzm2picnSMOfqBqYPm9hlkqryvBtUnX7VBGSVDjw==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr26505819wrr.75.1572943643676;
        Tue, 05 Nov 2019 00:47:23 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id m13sm7184928wmc.41.2019.11.05.00.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:47:23 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:47:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Add ATU occupancy via
 devlink resources
Message-ID: <20191105084722.GB3465@nanopsycho>
References: <20191105001301.27966-1-andrew@lunn.ch>
 <20191105001301.27966-6-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105001301.27966-6-andrew@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 01:13:01AM CET, andrew@lunn.ch wrote:
>The ATU can report how many entries it contains. It does this per bin,
>there being 4 bins in total. Export the ATU as a devlink resource, and
>provide a method the needed callback to get the resource occupancy.
>
>Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Jiri Pirko <jiri@mellanox.com>

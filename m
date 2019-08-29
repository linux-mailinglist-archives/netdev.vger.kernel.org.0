Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3493CA2A01
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfH2Wpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:45:34 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36198 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbfH2Wpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:45:34 -0400
Received: by mail-ot1-f67.google.com with SMTP id k18so5114914otr.3;
        Thu, 29 Aug 2019 15:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z3MZ8AyPdUYVrg2y3uydcIMZSUELqZaas3HS02wvz+I=;
        b=QNmbk7txwQ1MthXWZUmUSeJcgrZpiFd7oE3QwnzIf5N+gRLhLJVs63yqSSAeg/gp/7
         5oTG+pdXyHFNMPYpdANSNyyDm7/kAnDqoq+/mkD58ihey18iB/MZ6Lrb6GkKuGqpq9yd
         zHK+HEs+WUvkFi6AK14Md6EnaL2F5VSeI1yAqj4AQCQBi067RGo0yay9AdXvpuQ0K0Es
         mKEdpwa0PVlU2iGms/zmhRhzTIiNAO6ySIKlOxJUSqKFl3FcCpfwNhC20quEqk56YdPl
         hJ9qvJtrWYLsV6OggEm8K+zj4nFTdCBFiNtKp/vyabwVzK9UnM4QsNrzjp+e1Aa9g1Iv
         BsYA==
X-Gm-Message-State: APjAAAXexBysOdpmNum7CCjRD56chxw71QxSRKH+yvt1tclSYZLLzrOX
        ni5xHE54tGNgA5zxqYVnmemIs+I=
X-Google-Smtp-Source: APXvYqw08hxUksZnk+Z/aXJB+kDBH9rNUQIyw+xfm7lS1bkszIUlI8PcYNTsMz6OZ0Lj4Fh9S9QXRQ==
X-Received: by 2002:a9d:5601:: with SMTP id e1mr10326552oti.370.1567118732666;
        Thu, 29 Aug 2019 15:45:32 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 63sm1280975otr.75.2019.08.29.15.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 15:45:31 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:45:31 -0500
From:   Rob Herring <robh@kernel.org>
To:     megous@megous.com
Cc:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, Ondrej Jirman <megous@megous.com>
Subject: Re: [RESEND PATCH 1/5] dt-bindings: net: Add compatible for
 BCM4345C5 bluetooth device
Message-ID: <20190829224531.GA747@bogus>
References: <20190823103139.17687-1-megous@megous.com>
 <20190823103139.17687-2-megous@megous.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823103139.17687-2-megous@megous.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 12:31:35 +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> This is present in the AP6526 WiFi/Bluetooth 5.0 module.
> 
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>

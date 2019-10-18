Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0994ADD15F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406194AbfJRVsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:48:39 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37605 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403776AbfJRVsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 17:48:39 -0400
Received: by mail-qk1-f194.google.com with SMTP id u184so6728860qkd.4
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 14:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=x6es0hqVWlUEfRxAPpRdpfGhDBbv+wJBmR59LOWFiPw=;
        b=fsVlcwE7EQtlG/UwcQE3kHQBWgNM6zqrwfMFMSzlg/vPVooU9VxTBbe+h6LfSUogqx
         UX2Y8kgHqZShWMxBKbhVOe8D/j6+aqS5VYizFejPHuW6lvxaT43kIT3AGbmnZ1fvLIX8
         +H/bWHSVWCwWCb+ozxl5Q9U3LBQoofUUwNBP2HyEO1PZm7HvX50x2gIdCPoqiiG2IM/T
         zWZkYPRzQZBhY0zUrq1ZFYTw0eXjX4bVBLbCQUojr1EGVtw3prGwuXQVi+bgJqN+L4uo
         C1HnnIoK9nvpBaaBe/QEDAWruTG/BBNtX70WBAo5vz8Dnyd6XWFMQ0gbGithQz1NjaHZ
         LaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=x6es0hqVWlUEfRxAPpRdpfGhDBbv+wJBmR59LOWFiPw=;
        b=DkMhLA/UvbfcorABqSTgbny3KzL5W1mzT8XSi9KI3jRG2wL7CuqgxOV2WYO7MVpXNR
         +ebqjEMPjT9+j6n3FlZEVKbNUVM3Q5p9iV9QGAW+FF1VjCgTKSkLlYhYp2X2BH85zuse
         OFARnRANyXAVPvSlP4MOIKn+rnhxhROrEW6L5BpqEu4JxYd/bVnGNcNhed6c9LzAnkIk
         UudoyGbVVsxD+f/P5IaZHXaylfZSb9nnbBOi7mTFQhGhrT9Y66ksE8YJ+oXqw0hY6Mf8
         VtzrTFUawaBMc9R5INOZuMlv9TljcXWgKS68C+GHUnasLNZgAP5gJNGISKgCJuj9AUOt
         cvNA==
X-Gm-Message-State: APjAAAWRmq1ooqomKnJ0oLP4Qe+ja8cPrIZ4H6EbTFesDWz4TjQ/6T+4
        8xsYkj28hfqexf7YAJQDlgkoT8A7
X-Google-Smtp-Source: APXvYqwWxZLrZuSgFh7YVFAzavTpoRUrQ+J+xuGNv86gYug5yy17wHuXRSmkdP/2ZgYNv15Zu1ywrw==
X-Received: by 2002:ae9:e30f:: with SMTP id v15mr9478895qkf.202.1571435318233;
        Fri, 18 Oct 2019 14:48:38 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c185sm3895493qkf.122.2019.10.18.14.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 14:48:37 -0700 (PDT)
Date:   Fri, 18 Oct 2019 17:48:35 -0400
Message-ID: <20191018174835.GB3037198@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
In-Reply-To: <20191017192055.23770-3-andrew@lunn.ch>
References: <20191017192055.23770-1-andrew@lunn.ch>
 <20191017192055.23770-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, 17 Oct 2019 21:20:55 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> --- a/drivers/net/dsa/mv88e6xxx/global1.h
> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> @@ -109,6 +109,7 @@
>  /* Offset 0x0A: ATU Control Register */
>  #define MV88E6XXX_G1_ATU_CTL		0x0a
>  #define MV88E6XXX_G1_ATU_CTL_LEARN2ALL	0x0008
> +#define MV88E6161_G1_ATU_CTL_HASH_MASK	0x3

If a respin is needed, can you use the 0x1234 format for this mask, so that
the position of bits are documented as well like with the other macros.


Thank you,
Vivien

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C572712AE4E
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 20:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLZTWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 14:22:20 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:41111 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfLZTWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 14:22:20 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so20416254ioo.8;
        Thu, 26 Dec 2019 11:22:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R5ux+aGvRE7UtpZWNEHDpq3k2THh0opmzfMyK7lQA+4=;
        b=hCDpSSLieOlbhG3SHdorTCIA19wv9VFFzfgKI0QhrVn8COMWCEV/+WOBsm0RdhQcgU
         tC+S2PVEJsaObsFa0wxPWXKrZixMnaCV3qYiSQH/CBoP+MZgFtR8QvM0pqxzurro3KR+
         C2gokJpNj6BDEG4dKIMth64lTzczX2x7eCLfypvtGX51clFnu02j/nbFcC6/xL/2xWfi
         7Zwi1L39kC2BXWg1CFRHlxve0pjqo4IGQgQ8AB1MmDWJfRVEUUDbv5z8ENOsJXEOyn4z
         FvDkhXkZ40rAVLRLci69UnGh9qmyYVgrHmTohrtcHVqZBtwOJ4pd8g9eBzkG0qIxZPBf
         MOUg==
X-Gm-Message-State: APjAAAXOOcui/iY7xHkcB4TDWzOYhThowj1jFLawMutEXKxcRNnfPspb
        lc7OUoZlsZq6PrnWrdH57g==
X-Google-Smtp-Source: APXvYqx2j8ZzstKCwh9JS77NHZuPA/MpsLy6K80JazDbIQ1Q8wufCtUxnmt94zLihf2RNl8QRxlb0w==
X-Received: by 2002:a02:6558:: with SMTP id u85mr37591000jab.42.1577388139118;
        Thu, 26 Dec 2019 11:22:19 -0800 (PST)
Received: from localhost ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id b145sm8844951iof.60.2019.12.26.11.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 11:22:18 -0800 (PST)
Date:   Thu, 26 Dec 2019 12:22:17 -0700
From:   Rob Herring <robh@kernel.org>
To:     vincent.cheng.xh@renesas.com
Cc:     mark.rutland@arm.com, richardcochran@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] dt-bindings: ptp: Rename ptp-idtcm.yaml to
 ptp-cm.yaml
Message-ID: <20191226192217.GA17727@bogus>
References: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1576558988-20837-2-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576558988-20837-2-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 12:03:06AM -0500, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Renesas Electronics Corporation completed acquisition of IDT in 2019.
> 
> This patch removes IDT references or replaces IDT with Renesas.
> Renamed ptp-idtcm.yaml to ptp-cm.yaml.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
> ---
>  Documentation/devicetree/bindings/ptp/ptp-cm.yaml  | 69 ++++++++++++++++++++++
>  .../devicetree/bindings/ptp/ptp-idtcm.yaml         | 69 ----------------------
>  2 files changed, 69 insertions(+), 69 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-cm.yaml
>  delete mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> 
> +  compatible:
> +    enum:
> +      # For System Synchronizer
> +      - renesas,8a34000
> +      - renesas,8a34001
> +      - renesas,8a34002
> +      - renesas,8a34003
> +      - renesas,8a34004
> +      - renesas,8a34005
> +      - renesas,8a34006
> +      - renesas,8a34007
> +      - renesas,8a34008
> +      - renesas,8a34009


> -  compatible:
> -    enum:
> -      # For System Synchronizer
> -      - idt,8a34000
> -      - idt,8a34001
> -      - idt,8a34002
> -      - idt,8a34003
> -      - idt,8a34004
> -      - idt,8a34005
> -      - idt,8a34006
> -      - idt,8a34007
> -      - idt,8a34008
> -      - idt,8a34009

NAK. You can't change this as it is an ABI.

Rob


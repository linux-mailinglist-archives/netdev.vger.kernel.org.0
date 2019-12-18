Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C639E1252C7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLRUJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:09:46 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44352 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfLRUJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:09:46 -0500
Received: by mail-ot1-f66.google.com with SMTP id h9so1374508otj.11;
        Wed, 18 Dec 2019 12:09:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ZSxO98aPLLC/x4t0APo2oe/C+Fl49wOHPK8QDcSVcs=;
        b=FzYqfy0K1d5bn861vfKxwC9D8NPtZdTEqygjPPm+GBJK64xJEa21LoVaWLUiKuP4a9
         5HMuYrJ8DZfrZDMLVApZJ6F7XHOHxZDL0bNOf9Ob+nvOSuQrTaMgpwrKdBG5K5J4Ihq4
         8BvCh9nhC72vJH3EA9d0Latc9j0fn9TknZEq7DN9jIUbgl4FLAt/NudkIff8gyutobWm
         NeuffH+iOEH/Uc+y4Z6zPOIA2e1GJG9qYXXy01KtBWZ+YAbA2faugxKkqzLbw+dFXIZI
         +imuwGvLKLndg58S8I8Ys9jNHGF1yQdtJUc4+Vp2dBExRag+J9P7XlW1mzJVXGBSkyd0
         MtDQ==
X-Gm-Message-State: APjAAAWe2YEMedt5nGwyLUJ2fpXm42QFzEntRBsHFCVl46lz+GS0s3TW
        aQRTB2vl/uEqJi+pJ145CQ==
X-Google-Smtp-Source: APXvYqw4HOFv+5SFjVJ9zdWA5YDbnoRffSIopcau3o/VDEg9lnuJl+5wWlK8tmDGOr9t+0bL0exxdQ==
X-Received: by 2002:a05:6830:20d3:: with SMTP id z19mr4240310otq.330.1576699785137;
        Wed, 18 Dec 2019 12:09:45 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id g5sm1162477otp.10.2019.12.18.12.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 12:09:44 -0800 (PST)
Date:   Wed, 18 Dec 2019 14:09:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v6 2/5] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191218200943.GA7130@bogus>
References: <20191217072325.4177-1-o.rempel@pengutronix.de>
 <20191217072325.4177-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217072325.4177-3-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Dec 2019 08:23:22 +0100, Oleksij Rempel wrote:
> Atheros AR9331 has built-in 5 port switch. The switch can be configured
> to use all 5 or 4 ports. One of built-in PHYs can be used by first built-in
> ethernet controller or to be used directly by the switch over second ethernet
> controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/dsa/ar9331.txt    | 148 ++++++++++++++++++
>  1 file changed, 148 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/ar9331.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>

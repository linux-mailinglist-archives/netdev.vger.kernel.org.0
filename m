Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674462D482D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbgLIRmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 12:42:44 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45712 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbgLIRmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 12:42:43 -0500
Received: by mail-ot1-f65.google.com with SMTP id h18so2157791otq.12;
        Wed, 09 Dec 2020 09:42:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ux4Sk94uLr3t/Ycz0/4r2TD0W2V25BvuMDypuy7cUw=;
        b=rrsvBlbNTTgmSVy13Q1mQvNz9ohgsoshc45IwTTPOa80Mm1L1XBwdF2KN4Bjy30D9S
         1leSAVZ39q74rKoM1cYNDx4dw+XaXxZ9yFMv055b+n4jcnPe5wogS0sjjY/El8mfRmhU
         5ZNfmmmpRFuOrWmAzZcZCwL6eWq5nqzCEQBNVoKeuBuGc/uvf2QaMnUF0OJoJgrY9+de
         GwESGfGtj0bNt8PkYFNuYziZwetWX2v69rrKqOIGLOewWgwp2TF+gC+9G3GnLqISbAQ7
         Y2WBJH5eUCttR39dAOGnUsaybdQlUdpMDrUsSgHUKEncxmGOA+cUDJ8ElOlpkMvMqivD
         wfdQ==
X-Gm-Message-State: AOAM533G13OqnWKF73ParLw+fWD2lKCHuz5V0RUcrQrD+/nwvfTTpbOM
        +5oSc3KrodCi2QSGP40XJ4I23TWLEQ==
X-Google-Smtp-Source: ABdhPJyqDWbKXuuDf0HEfz8Ky1Z7aK1vmyy1JNFBJkxbozv7GaH7XFyZbqjuHFDqkDK/XUAAvmk45g==
X-Received: by 2002:a9d:7a48:: with SMTP id z8mr2771119otm.146.1607535722765;
        Wed, 09 Dec 2020 09:42:02 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id z12sm551330oti.45.2020.12.09.09.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 09:42:01 -0800 (PST)
Received: (nullmailer pid 662198 invoked by uid 1000);
        Wed, 09 Dec 2020 17:42:00 -0000
Date:   Wed, 9 Dec 2020 11:42:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     "xiao.ma" <max701@126.com>
Cc:     devicetree@vger.kernel.org, xiao.mx.ma@deltaww.com,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, jiajia.feng@deltaww.com
Subject: Re: [PATCH]
 dt-bindings:<devicetree/bindings/trivial-devices.yaml>:Add compatible
 strings
Message-ID: <20201209174200.GA660537@robh.at.kernel.org>
References: <20201202072610.1666-1-max701@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202072610.1666-1-max701@126.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Dec 2020 21:26:10 -1000, xiao.ma wrote:
> From: "xiao.ma" <xiao.mx.ma@deltaww.com>
> 
> Add delta,q54sj108a2 to trivial-devices.yaml.
> 
> Signed-off-by: xiao.ma <xiao.mx.ma@deltaww.com>
> ---
>  Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Applied with subject fixed. 'git log --oneline <file>' will give you an 
idea of what the subject should look like.

Rob

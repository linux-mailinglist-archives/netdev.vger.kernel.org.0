Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1763011B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfE3Rc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:32:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36475 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfE3RcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:32:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id d21so2849524plr.3
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LhxifK8xasEWnbFFnTXMwCyoLy9ibJpitW1E7bHtvu0=;
        b=Prx5Q5humckgCTW5K6BFasRyLQyDf1ZKWmrcKxSQtXHHyDPL//qsUi3vKv3OArk9du
         Mbuj0UdqqicP+A0uwARJg8DJgMHySGTr3KXYhukg/hmisGTHu8nC3uqlulEGFZNbOQQx
         mRftqvifFUhAI/MJU/5JcnIEc23kPqUnh27avuPFrZoPXfZ2m869NZ6CZl4g0qByme/l
         qngCL75aNOc3wRQjaDYorF2nTMqC8+uHLc6UfojzsLn9J8IZQaYZs1Yvw9V4vYxX53bN
         aZDUZhAOo4tct/6c4eDcgY4ioVQOrhVADts9j49QQDZcvF5XlWKxLciBdEXPV1XVCmQi
         F/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LhxifK8xasEWnbFFnTXMwCyoLy9ibJpitW1E7bHtvu0=;
        b=HUJTgkKLqTFNjo39+wMWE6SJTZSJM0Rx3R34YzCgHkDmMgaVCTrbR/XNbtp2xEwy6o
         pxuCRFHdZ7MaBH7fRlSFC7fwe6QGxBFf2sM+fcNMqXsi5pnnq77YH0fjtgjlBWdQO/ae
         ar4e32L6xJipL8DXWLMMgQD0bim7nCQwzLUWPpZ/8y4AtpHOldss4pzUHKoAUf1mOnKw
         LnDP5fjW8rWcW1FjNVATn7a+CL39+j35GRH2IVQ9FfrA1/eYtQbO2AGhA8+x0cn0uXxe
         cVS5MVEx78H9hjl8NsTsNuQ//yNIyjN5hZX2KWKrpx9XBN6bWTfK72uXkOpVE+qrNHYz
         yG1Q==
X-Gm-Message-State: APjAAAVvyNANPoxGR4jpANFu5OvHfSxUnfU+Hi/Odfumhy7/I376L52L
        U7rGU+fkBremruotMnIuU3BFozIR8oc=
X-Google-Smtp-Source: APXvYqypgyhBvV3Tvf/yomdQVuSP3HKMIy3/tg7S2TzCj27V7MF3QbvsHg5QEV1Ms1IPuyA+74OPRA==
X-Received: by 2002:a17:902:a708:: with SMTP id w8mr4503781plq.162.1559237543157;
        Thu, 30 May 2019 10:32:23 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h8sm709674pgq.85.2019.05.30.10.32.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 10:32:23 -0700 (PDT)
Date:   Thu, 30 May 2019 10:32:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH iproute2-next 1/1] tc: add support for act ctinfo
Message-ID: <20190530103219.048b4674@hermes.lan>
In-Reply-To: <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
References: <20190530164246.17955-1-ldir@darbyshire-bryant.me.uk>
        <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 16:43:20 +0000
Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> wrote:

> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 51a0496f..b0c6a49a 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -105,7 +105,8 @@ enum tca_id {
>  	TCA_ID_IFE = TCA_ACT_IFE,
>  	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
>  	/* other actions go here */
> -	__TCA_ID_MAX = 255
> +	TCA_ID_CTINFO,
> +	__TCA_ID_MAX=255
>  };

This version of the file does not match upstream (the whitespace is different).

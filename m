Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0F62A666D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgKDObv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730001AbgKDObo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:31:44 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12CDC061A4A
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:31:43 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id x7so22293206wrl.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JzET7Jlv2jmxts2RjmfLSE+ugQqnI/OJZGsydNl/hiQ=;
        b=XVduVZ4WIbPCg68dNfG7zMB9KvvYx2zIKcmFVH2smYgXUc9lpTHnxYr7gYN1sg4ctR
         SQ5JVmnsvQTgYGJ/gK/3UlEpQ8qv3xSWDirRNoxToUkD/J5X0Juy1XcCbscFNz6cCi8M
         Fxtj5zYA5b7eVvq2r1/K1Ul0y4FVLz8tWszrlH4gPwG+goPm5zMheXSrZok73VWCTODp
         mb+fi8FfCdilZTsQgT0EQ9DxJBZBPzn8+lRI0/+ZPhNqSu138HpXjbG8EzTjf2renSTn
         idFDXeh3wflQRS1C6h1e4FcfLb9os9kJ7i5A1/kh6+n/nBVIShalEbRDtzkaKvQ6k1Wc
         Oakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JzET7Jlv2jmxts2RjmfLSE+ugQqnI/OJZGsydNl/hiQ=;
        b=euQ6FIk3VyGOKz+XMeBoBs2i4VaXCd7+GhBxFY/kFqp8p+y7eFdLJQr5qwIJNV3cBU
         qCb038kV4P17VujVoOIfqIgUHVSu2a0leJ49oJ4ZGGPyOLq/ceKAXwI6WtTPUnh9IpuU
         VU1G5q3kQFv8y2CB4HuRT0bJa1FA5ZHE5CLWMUqyrQZ3i0mWO7ZROHI8I8cqptoklOkz
         JsIad+dikedocHxdYC+oz4IRHX1gtVHlLn50OS5VdgsH0/SUBF+Fz0KIZ3XOM8O8x2G5
         POQ1Zd4nB39XkCEv1T9H+YWJARcpt7MZ25f9r1hCnNFYW7PH8PTvlbr2lgrRl7vtc7SM
         5jEA==
X-Gm-Message-State: AOAM533OXKXDSoB1a+fazt6/QkMx4mN4Ct1ctREezLCv2G9bzBKEP7o2
        QUNBNuKTeMpozGUuPEsqr2c7G8HJ/qKFZTG2
X-Google-Smtp-Source: ABdhPJwSesSTNRgKVguedg8+wTQ02tqZOuutPWhVXdm2jZTyaTQhO8YfIvGuGSNwOVQyr76Ixk6G5A==
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr30907421wrn.73.1604500302647;
        Wed, 04 Nov 2020 06:31:42 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id v14sm2659853wrq.46.2020.11.04.06.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:31:41 -0800 (PST)
Date:   Wed, 4 Nov 2020 14:31:40 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Dustin McIntire <dustin@sensoria.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 02/12] net: ethernet: smsc: smc911x: Mark 'status' as
 __maybe_unused
Message-ID: <20201104143140.GE4488@dell>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-3-lee.jones@linaro.org>
 <20201104132200.GW933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104132200.GW933237@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020, Andrew Lunn wrote:

> On Wed, Nov 04, 2020 at 09:06:00AM +0000, Lee Jones wrote:
> > 'status' is used to interact with a hardware register.  It might not
> > be safe to remove it entirely.  Mark it as __maybe_unused instead.
> 
> Hi Lee
> 
> https://www.mail-archive.com/netdev@vger.kernel.org/msg365875.html
> 
> I'm working on driver/net/ethernet and net to make it w=1 clean.  I
> suggest you hang out on the netdev mailing list so you don't waste
> your time reproducing what i am doing.

I believe that ship has sailed.  Net should be clean now.

It was it pretty good shape considering.  Only 2 sets.

Wireless alone was more like 4.  And SCSI, well ... :D

Maybe that was down to some of your previous efforts? 

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

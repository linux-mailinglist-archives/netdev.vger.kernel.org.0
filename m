Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D2C76336
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 12:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfGZKK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 06:10:58 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40989 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGZKK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 06:10:58 -0400
Received: by mail-oi1-f193.google.com with SMTP id g7so39880457oia.8;
        Fri, 26 Jul 2019 03:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PNbBPnX465bO/iHYUql8hJxHjiShHO4VBCJbc58eum0=;
        b=NsvmIADRZ57CP2p7Ho68q+fx2U75fRpq5kr0UboAGLj6Id7cvbFd4UwuCBpGl5bn2n
         gEeBnYGW3UaKhB++QOy96ktL18gY0lBmJ3yH+SG9gm61hBwYfx7yC1/14Fuiuvt6q3p0
         UxdZDqrnvNlgTjcRuR+A2J81jrUjPzp6l8gGg1kmEFAUQA2z/kjxy4I21los3fPpfOJ0
         mdauYplpLJ1zCC8oJ5SzUNYLWFhKX7C1fGTkJO6YOCcD3/kv+aeCB58N9GUn1NcO7Zjc
         Sh+cailfzPDVm19q2zbHNc7VvtE75S9WDZx8ZJV1evhjlIntC7UM9NiYofZSxdwJKR0z
         p+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PNbBPnX465bO/iHYUql8hJxHjiShHO4VBCJbc58eum0=;
        b=SQKXkmwEv42xX3ov35M19HGPi1HsnqPjo1W0fMsa3cTHg3ZlXMPvejXpKrzCYugFuP
         bmzxyvCbVpY+ot/Prvas388r3U/fnaXWxfo2C8URAYT6C+MlQuS48HYtlyqYRaszdBF6
         gRzL9m5OMBe/dY5YdZNqRejm6La7tFn9OE7A3MNL+gCXN+/TCq9yg6v780JxqF5iRNZ9
         z5VY3g8T/7S6CbgvTBjC7O39yjc82eGXcAYHgercu+VcHdVp6mfc3n/NTNHgPXGY6y9s
         tOeluGxQTzZ9Lwkno1GnOnlgJ69AyINYL6iGsMfdyFTn8QcTJMc0Zl/xEDJSecFH4Om8
         1Vcg==
X-Gm-Message-State: APjAAAU04uGDkGWhYX6hDhSBrfGopY4Uxvgbxg3gd2WCvAG4Wgp6xyI3
        YZy4PBPkIr5TiczNUpHS/g==
X-Google-Smtp-Source: APXvYqzUoe7Bbm12mN0YHsVCYgmCsjlUkR4jX1fDlc4O7IwKvtGF6z7+Hlv+bdkgY5zEXgt1is35/A==
X-Received: by 2002:aca:5050:: with SMTP id e77mr41854917oib.52.1564135857484;
        Fri, 26 Jul 2019 03:10:57 -0700 (PDT)
Received: from ubuntu (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id 17sm4040687oip.26.2019.07.26.03.10.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Jul 2019 03:10:56 -0700 (PDT)
Date:   Fri, 26 Jul 2019 06:10:54 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz
Subject: Re: [PATCH 2/2] ip6mr: Make cache queue length configurable
Message-ID: <20190726101054.GB2657@ubuntu>
References: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
 <20190725204230.12229-3-brodie.greenfield@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725204230.12229-3-brodie.greenfield@alliedtelesis.co.nz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 08:42:30AM +1200, Brodie Greenfield wrote:
> We want to be able to keep more spaces available in our queue for
> processing incoming IPv6 multicast traffic (adding (S,G) entries) - this
> lets us learn more groups faster, rather than dropping them at this stage.
> 
> Signed-off-by: Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>

Reviewed-by: Stephen Suryaputra <ssuryaextr@gmail.com>

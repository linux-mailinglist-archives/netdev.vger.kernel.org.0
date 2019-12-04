Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAE6113589
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfLDTOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:14:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43677 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbfLDTOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:14:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id h14so292375pfe.10
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z2aQYh9nMSEc2ys3FVCi0kvVQBKQjCjIPvW/pOADya0=;
        b=iCqgkpqBxdhC9w+J9UzuR7fdQyPieAh22YBtpk36wlIUh859hWH3rF9fOTPlfA7jtE
         0WyDr+yNXOvDJ7PkXRjKD1zxRAnZ2U5rml9PWeBxGFvTpNZ7rzGhc2vLsRMGE2/cacni
         KB0bDSgJvwagT5uQk/nvmLTFthOJt+eg6BOVdw4L+7gMEIynPeaQUjTtQ87oP/5RMZVw
         q88ilm2vawA9iyOr/j/5Xzf6p/2nmDKjki1wtRux10OXFMEuo33vNSIAZWQWryMM/GdJ
         PHTq3kx0HTh6L+wTRWWyVnuWiwE5qn1nV0mb5kQobTRAYAOKCF3pA/jBgadI4CMEif42
         PEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z2aQYh9nMSEc2ys3FVCi0kvVQBKQjCjIPvW/pOADya0=;
        b=Xc6rOVYsNexvywuNTAda/XrtRqoGiIUu+7TZ4btMw6lqEDZ70CmqgYO9sxKowqSlru
         8hmJxzMwe3jMK3WCKQzDR9ORH8GxQXJWPYVZbVpiqGGfKk4E/w4Rh+g5pmEFNWUDwVGa
         RbPscTZzAxXWHswrMgmJImW/L9P8sMwjMKcSjDzqOJa/ermipXTxu2gC1/C8ObCP4pEc
         Fl7xp0+PahtWRVm7uNfgCi9F1lT5ojxBoSbC85ITa2hxx0q0EAeuctttcD0dRFTWrp13
         +B/My2cC0P6ui750AdNWpMj7/ViqJMZFqjJn1uM/CZoVw6b5zyqepD+5ez8BnUZQC8mX
         5stg==
X-Gm-Message-State: APjAAAUINfuDNgpygtu9z10HVs/GxRDMRkZxWvZlEt4cXVFAAtQsT3q0
        QHe1jY4Cy+XzuerQbnwbFk96AcZPBhuifg==
X-Google-Smtp-Source: APXvYqwmuXyRJDv6g2doOzl2OFlwNxX2rKrEGM3QiXG3YPBfCgHmvyNCKkNd1+3C6fSlnY8yDLV5eA==
X-Received: by 2002:aa7:9afb:: with SMTP id y27mr5029863pfp.91.1575486849505;
        Wed, 04 Dec 2019 11:14:09 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w4sm7355363pjt.21.2019.12.04.11.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:14:09 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:14:06 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] iproute2-next/man/man*: Fix unequal number of .RS and
 .RE macros
Message-ID: <20191204111406.2924122d@hermes.lan>
In-Reply-To: <20191202001804.GA29741@rhi.hi.is>
References: <20191202001804.GA29741@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Dec 2019 00:18:04 +0000
Bjarni Ingi Gislason <bjarniig@rhi.hi.is> wrote:

>   Add missing or excessive ".RE" macros.
> 
>   Remove an excessive ".EE" macro.
> 
> Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>

Man page fixes do not have to wait for next.
Applied.

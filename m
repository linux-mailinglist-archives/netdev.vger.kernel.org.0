Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B78FB7D16
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbfISOla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732606AbfISOla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 10:41:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CEF62067B;
        Thu, 19 Sep 2019 14:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568904089;
        bh=TJHkQTtaGQHKS5CUibyY3os9gYsyoVt2bCM2nr2IE3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YK7tcTHra9Le/h5CmSNa6LtWZSL5o4cwJ5rVAf2P+1X+wlsuAy/k+IOGQEI6mrRXo
         NX6UgrRnJtjB5Tjxdh20rmvLJCYDLM1AjucKjmmdkioeymP65FUmeYdUixedjjrzog
         rf26ghS7hGTSkoavOfnR5yDqRvo+1cLM2ntxQSpI=
Date:   Thu, 19 Sep 2019 16:41:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Le Goff <David.Legoff@silabs.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3 00/20] Add support for Silicon Labs WiFi chip WF200
 and further
Message-ID: <20190919144126.GA3997726@kroah.com>
References: <20190919142527.31797-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190919142527.31797-1-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 02:25:36PM +0000, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Hello all,
> 
> This series add support for Silicon Labs WiFi chip WF200 and further:
> 
>    https://www.silabs.com/documents/public/data-sheets/wf200-datasheet.pdf
> 
> This driver is an export from:
> 
>    https://github.com/SiliconLabs/wfx-linux-driver/
>    
> I squashed all commits from github (it definitely does not make sense to
> import history). Then I split it in comprehensible (at least try to be)
> commits. I hope it will help readers to understand driver architecture.
> IMHO, firsts commits are clean enough to be reviewed. Things get more
> difficult when I introduce mac8011 API. I tried to extract important
> parts like Rx/Tx process but, big and complex patches seem unavoidable
> in this part.
> 
> Architecture itself is described in commit messages.
> 
> The series below is aligned on version 2.3.1 on github. If compare this
> series with github, you will find traditional differences between
> external and a in-tree driver: Documentation, build infrastructure,
> compatibility with older kernel revisions, etc... In add, I dropped all
> code in CONFIG_WFX_SECURE_LINK. Indeed, "Secure Link" feature depends
> on mbedtls and I don't think to pull mbedtls in kernel is an option
> (see "TODO" file in first commit).
> 
> v3:
>   - Fill commit log of patches 18, 19 and 20
> 
> v2:
>   - Add TODO file (and dropped todo list from cover letter)
>   - Drop code relative to compatibility with older kernels

dude, slow down.  wait for others to look at this.

there's nothing I can do until after 5.4-rc1 is out, so there is no rush
at all...

thanks,

greg k-h

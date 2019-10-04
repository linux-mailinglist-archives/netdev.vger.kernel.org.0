Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79883CB60D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfJDIXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbfJDIXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:23:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49FA215EA;
        Fri,  4 Oct 2019 08:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570177425;
        bh=y0a26l5BoLt6LDIhhczFXqNAIo+MU2bPPx6nwZoc6ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pc7kKbLNjQ60Htp2grrbUQKS6/ezg4x7E2dvUqm7GjZwB/+c01cbuC/1jTgthnBwS
         FYO0NB/mrWJG5TxGokI8FzLZf56xeesfHRx/lS98REBrATcIqoZBTxyVbvyC4JHiQS
         eAlEvYuj7lqvu3QDYCyPIxqk3KM0oRlAMRi6A2Kg=
Date:   Fri, 4 Oct 2019 10:23:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Le Goff <David.Legoff@silabs.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3 01/20] staging: wfx: add infrastructure for new driver
Message-ID: <20191004082342.GA94454@kroah.com>
References: <20190919142527.31797-1-Jerome.Pouiller@silabs.com>
 <20190919142527.31797-2-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190919142527.31797-2-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 02:25:36PM +0000, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Instantiate build infrastructure WFx driver. This driver provides support
> for Wifi chipset Silicon Labs WF200 and further:
> 
>    https://www.silabs.com/documents/public/data-sheets/wf200-datasheet.pdf
> 
> This chip support SPI and SDIO bus.
> 
> SDIO interface has two particularities:
>     1. Some parameters may be useful for end user (I will talk about
>        gpio_wakeup later).
>     2. The SDIO VID and PID of WF200 are 0000:0001 which are too much
>        generic to rely on.
> 
> So, current code checks VID/PID and looks for a node in DT (since WF200
> targets embedded platforms, I don't think it is a problem to rely on
> DT). DT can also be used to define to parameters for driver. Currently,
> if no node is found, a warning is emitted, but it could be changed in
> error.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Personally, I think you are going to find that this is going to take
more work to get this cleaned up in the staging tree and then out of it
into the "real" part of the kernel, instead of just doing the needed
work out of the tree now and then submitting it "properly" to the right
part of the tree.

But hey, who am I to judge people who like to do extra work!  :)

I'll go queue this up now, good luck!

greg k-h

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A68246A4EE
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347574AbhLFSxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:53:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53632 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLFSxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:53:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66B15B811FE
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 18:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E103FC341C2;
        Mon,  6 Dec 2021 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638816613;
        bh=KUo/7zxwDVrVx/uIA9h8zRjEosQYJbHJ9RW3EnsqWKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UDRKSWUUipfRyHs+fPErSB21z+2yB7ki9A6/JUNkuywj1JhI6Kq5DpFQoY8boEZ11
         wWAXxVjchcmEADOqlIEYplOBq7Xlj19EeZ71wDeuPQK50YwoIT1KtPghgTslJRjEf5
         fAUYfIrC9DF6fPLWAC18ep3Dqk+YDQsD/nmG9szoc6gOPkgFXMeOukiUrTXPHbfZTA
         SCezNgI8OaT+kczSp8I31OOM1hGGI2rSCvW1O9Xd0jBkcdWGbO1cue1SMFzDr+mvUD
         NMK2E6iLBCBrf5YVtgpzRuD1YPmm32WcztpaJW/MHfRM+vdxRN7gH8sGIkq7VSjgHl
         3eV661XOTRZ6g==
Date:   Mon, 6 Dec 2021 19:50:07 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jackie Liu <liu.yun@linux.dev>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: fix uninit-value err in
 mv88e6393x_serdes_power
Message-ID: <20211206195007.4892af4f@thinkpad>
In-Reply-To: <Ya4T5x0EOktaF2FU@lunn.ch>
References: <20211206101352.2713117-1-liu.yun@linux.dev>
        <Ya4T5x0EOktaF2FU@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 14:45:11 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, Dec 06, 2021 at 06:13:52PM +0800, Jackie Liu wrote:
> > From: Jackie Liu <liuyun01@kylinos.cn>
> > 
> > 'err' is not initialized. If the value of cmode is not in the switch case,
> > it will cause a logic error and return early.  
> 
> Same fix as: <20211206113219.17640-1-amhamza.mgc@gmail.com>
> 
> At least here some analysis has been done why there is a warning.
> 
> Should we add a default?
> 
>        Andrew

indeed it should be err=0 

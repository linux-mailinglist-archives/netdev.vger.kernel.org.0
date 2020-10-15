Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B7B28FB27
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 00:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbgJOWYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 18:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbgJOWYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 18:24:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4240920776;
        Thu, 15 Oct 2020 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602800693;
        bh=vW2vkyOsUS/1+J06kIFHt1vg0A+dDdmryUp49IH19ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hvOqiLGgk3exYmwcNEcl4DgDkzifViuRitY4f/71zFTqH/XGrOj3SGscbcBgMC6aJ
         dZWX27RlBgGXKpAa+20uPviVHtIR6nPId+FeI8wD9+74dQtBp4JNvWVuo7jm8Eq5Jd
         O4K5SAaBaVLwQAIgBTSnXH/7kE7PNDH3ooNitX/Q=
Date:   Thu, 15 Oct 2020 15:24:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Greg KH <greg@kroah.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        petkan@nucleusys.com, davem@davemloft.net,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: rtl8150: don't incorrectly assign random
 MAC addresses
Message-ID: <20201015152451.125895b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016085922.4a2b90d1@canb.auug.org.au>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
        <20201011173030.141582-1-anant.thazhemadam@gmail.com>
        <20201012091428.103fc2be@canb.auug.org.au>
        <20201016085922.4a2b90d1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 08:59:22 +1100 Stephen Rothwell wrote:
> > I will apply the above patch to the merge of the usb tree today to fix
> > up a semantic conflict between the usb tree and Linus' tree.  
> 
> It looks like you forgot to mention this one to Linus :-(
> 
> It should probably say:
> 
> Fixes: b2a0f274e3f7 ("net: rtl8150: Use the new usb control message API.")

Umpf. I think Greg sent his changes first, so this is on me.

The networking PR is still outstanding, can we reply to the PR with
the merge guidance. Or is it too late?

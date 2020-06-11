Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D611F5F14
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 02:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgFKANu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 20:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgFKANu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 20:13:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9A1206A4;
        Thu, 11 Jun 2020 00:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591834429;
        bh=hMfs0xT9sYpNNQR3gpMQLQF+wFwaPC5pMqiwChI4BPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aqw9dNPM3i3Mu412dMuizjjiDWbeHvPTm4Tz0MgdqLZzaHoOjf8sYlnALiSzBIHav
         Z8fXxEXn7hf1kZNPoIblb/znEtk7FoKLeFH9i2dIJ+tCmNJOSgjC8W9V+/8mfrXlTD
         6JUGqDZk3b0XNoyM4zG4qdfFsIbB1OuDxs9UGPJU=
Date:   Wed, 10 Jun 2020 17:13:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: networkng: convert sja1105's devlink info to
 RTS
Message-ID: <20200610171347.1634ce2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200610.170826.949931991037316223.davem@davemloft.net>
References: <20200610235911.426444-1-kuba@kernel.org>
        <20200610.170826.949931991037316223.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jun 2020 17:08:26 -0700 (PDT) David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Wed, 10 Jun 2020 16:59:11 -0700
> 
> > A new file snuck into the tree after all existing documentation
> > was converted to RST. Convert sja1105's devlink info and move
> > it where the rest of the drivers are documented.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Applied with Vlad's ack/test tags.
> 
> Please integrate those and add a v2 next time in this situation.
> 
> Thank you.

Ugh, sorry.

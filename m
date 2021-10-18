Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66277432A50
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhJRXXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhJRXXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 19:23:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B8C26108E;
        Mon, 18 Oct 2021 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634599303;
        bh=w4e/Ret++yDFtIPgdPdshC0SVcKGv2PYtRXjzYDNCZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tXeXimXLVdA80gBERP2WEyWGruwYi+1SJrsXXyLOLUKWbceZmDapKAl+1T2XQL+un
         pgpgvVFYOm2o85Xqollkz5CRAWfTMIzb7AYqmEqsQL1dHeV4YfcMH/5ZHWY9QiTiJx
         w/BNn9zRiaRxmM4G07yq3Jv9a1yLDKliKUUE42duU86w+NWq6qTUnL3+VyZysPoOGJ
         3x8dpbyNH+8de1tqvPLcMpHA6lPD0K3u4gFYnCn/t5LsQHCkM07V2hnCrqqLf/HXzf
         OUaplzGlUm2oTisz7kHk8CKie6x5FjbZwMhk36n4lKntBDGQDSQIol5c46g84+nZVb
         i5he0nqTU+huQ==
Date:   Mon, 18 Oct 2021 16:21:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [net-next RESEND PATCH 1/2] net: dsa: qca8k: tidy for loop in
 setup and add cpu port check
Message-ID: <20211018162142.6739e218@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+_ehUzrSO39rAubFTf2Jvew_cp7aEJVwpE=qih9pWNQKht3NQ@mail.gmail.com>
References: <20211017145646.56-1-ansuelsmth@gmail.com>
        <20211018154812.54dbc3ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+_ehUzHm1+7MNNHg7CDmMpW5nZhzsyvG_pKm8drmSa6Mx5tNQ@mail.gmail.com>
        <20211018160614.4b24959c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+_ehUzrSO39rAubFTf2Jvew_cp7aEJVwpE=qih9pWNQKht3NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 01:14:30 +0200 Ansuel Smith wrote:
> > > So anyway i both send these 2 patch as a dedicated patch with the
> > > absent tag.  
> >
> > Ah! I see the first posting of both now, looks like patchwork realized
> > it's a repost of patch 1 so it marked that as superseded.  
> 
> Should I resend just that with the correct tag?

Please fetch the latest net-next/master, and rebase your branch with
these changes. git will figure out what's already applied. Resend the
rest as [PATCH net-next v2].

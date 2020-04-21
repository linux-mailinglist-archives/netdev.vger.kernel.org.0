Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E171F1B2F1E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgDUSaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUSaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 14:30:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD94206B9;
        Tue, 21 Apr 2020 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587493812;
        bh=SOv9Y2+M5thjB26cpcHNXWECu35R258RilKk1up/KKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V6X2BWz3msD8SJ4m4vsVs/+63auJfCHeTY6fBO0lr546r+mWB3dYuCzvUmNHcjdk4
         GCGDl0+vuBa1swUtIqC5MwcG3q2Z2xNULaOeVzDVMyGByjlESKs2iD9ak2Bmr/IkEL
         W3Qi4mR0pjjUsL1U+jpXBIoSf2qJeUgB0tBPWVnY=
Date:   Tue, 21 Apr 2020 11:30:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <aelior@marvell.com>, <irusskikh@marvell.com>,
        <mkalderon@marvell.com>
Subject: Re: [PATCH net-next 2/3] qede: Cache num configured VFs on a PF.
Message-ID: <20200421113010.6ba2fe5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421145300.16278-3-skalluru@marvell.com>
References: <20200421145300.16278-1-skalluru@marvell.com>
        <20200421145300.16278-3-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020 07:52:59 -0700 Sudarsana Reddy Kalluru wrote:
> The patch add changes to cache the number of VFs configured on a PF.

Please use pci_num_vf() instead.

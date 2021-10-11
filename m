Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1918429845
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 22:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbhJKUpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 16:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234738AbhJKUpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 16:45:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD15B603E7;
        Mon, 11 Oct 2021 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633984993;
        bh=C+7VmPtFL4EyBuzUK0X9irTTMPuFTDECR6vYejMEEqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=EY1x5nMHRbf9c7fvwQBAhNOvEfE73xU2Hz4XPERCzifkOm9ppMfryoiAXbMORMynE
         e1JnO97AP0jDOmlvSklLmidC0RMsiVYJLTMi2zIaxDjBd/uyhuuBR5pT+TZtpVTZVJ
         kUMEFjd/AGmzPvCvVTm9WC6lnVHfe8RtwXb3mvOtBRlfZZUDdIxcQTJjSK6f1zgtkf
         eqJxyTReYRO7wq0bPlVNBfMDTxs5xCz8PbEnJChoZ81t+oU/nXphAZ5F1YvmRWcEnu
         qhaYHljY2NrWiZOjndou6YX6/yyFNbu1ZyRhBQr41PQyz0inSy+FAR0JL9Ylr2aZcN
         qzdfsPHrfFB+w==
Date:   Mon, 11 Oct 2021 15:43:11 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/5] PCI/VPD: Add and use pci_read/write_vpd_any()
Message-ID: <20211011204311.GA1689065@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008164249.26e04562@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 04:42:49PM -0700, Jakub Kicinski wrote:
> On Fri, 8 Oct 2021 17:53:40 -0500 Bjorn Helgaas wrote:
> > Ideally would like reviewed-by and ack for the cxgb3 parts from Raju,
> > Jakub, David.
> 
> Raju's ack would be best, there isn't much networking there, 
> but certainly no objection for you merging the changes:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks, added your ack.

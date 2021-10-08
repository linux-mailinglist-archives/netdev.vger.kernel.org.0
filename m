Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD41427456
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243817AbhJHXos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhJHXoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 19:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADF9260F94;
        Fri,  8 Oct 2021 23:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633736571;
        bh=JbbAavGnxL8nsqyWmfzkPuh5K4VEGTCwznOeHApKIWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S+GirTn/HDtsF+sAPzD0xRY4HHInS4CNYWAwvx4FDR18byh5xdPFlJN+11CpMb1p5
         d33IpvVdhF+x4foem6jkwwrRfQhhjNkKZ3VCk/WdV9hPRm8gSvYrIhI362nbnopwph
         GaWswd36C7GbM66EU2RQFvnOPwPiZBhNW45joRKDyJLOD9gHFmxyaPyzzX6C9muL2Y
         x+j8FSXVxfdu5tdKc8c7wOTBplsno65qIC+q0dnVGp9qnSCpvIs6Vf1o2QDMjU25J+
         fGdKmpeZjXTmI8l9+LosTeOb5EZR+xTnBN9yiu+JZpyfSRKA1nkX0XyZQOdK+v+9qA
         Fskkww5LS1C9A==
Date:   Fri, 8 Oct 2021 16:42:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/5] PCI/VPD: Add and use pci_read/write_vpd_any()
Message-ID: <20211008164249.26e04562@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008225340.GA1388382@bhelgaas>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
        <20211008225340.GA1388382@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 17:53:40 -0500 Bjorn Helgaas wrote:
> Ideally would like reviewed-by and ack for the cxgb3 parts from Raju,
> Jakub, David.

Raju's ack would be best, there isn't much networking there, 
but certainly no objection for you merging the changes:

Acked-by: Jakub Kicinski <kuba@kernel.org>

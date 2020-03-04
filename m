Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5792B1795D6
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgCDQ7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgCDQ7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:59:07 -0500
Received: from localhost (173-25-83-245.client.mchsi.com [173.25.83.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 600C921D56;
        Wed,  4 Mar 2020 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583341146;
        bh=FQJSk9E9cGV2olbAq15IXg0ngbl4HxcZVCftTjJCUfY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=2Zr9+YkuiQdVRJO0bZKlDvnpapkcJZFRtX9xUaJMXM5KPRxd3LP586Og89lfK0nag
         Y30aIlJgJd3hhq46DRh7mi7mSly3xSJ0C3/8elWdxa/ClPJ4YpCYE4l/kQHsij+QyA
         ijNVi4YJUhxK5oQdpc1Pj7MpJuuri/cKNVv31U7s=
Date:   Wed, 4 Mar 2020 10:59:04 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, mlindner@marvell.com,
        stephen@networkplumber.org, clemens@ladisch.de, perex@perex.cz,
        tiwai@suse.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v4 00/10] PCI: Add and use constant PCI_STATUS_ERROR_BITS
 and helper pci_status_get_and_clear_errors
Message-ID: <20200304165904.GA231103@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303.185937.1365050844508788930.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 06:59:37PM -0800, David Miller wrote:
> 
> Bjorn, please review and let me know if it is OK to merge this via the
> networking tree.

I acked the relevant patches and you're welcome to merge it via
networking.  Thanks!

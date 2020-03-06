Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6817B3C5
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCFBau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:30:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCFBau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 20:30:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E60F15537995;
        Thu,  5 Mar 2020 17:30:49 -0800 (PST)
Date:   Thu, 05 Mar 2020 17:30:48 -0800 (PST)
Message-Id: <20200305.173048.1775019045524971221.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com, kuba@kernel.org
Subject: Re: [PATCH v2 0/6] PCI: Implement function to read Device Serial
 Number
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303022506.1792776-1-jacob.e.keller@intel.com>
References: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
        <20200303022506.1792776-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 17:30:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Mon,  2 Mar 2020 18:24:59 -0800

> Several drivers read the Device Serial Number from the PCIe extended
> configuration space. Each of these drivers implements a similar approach to
> finding the position and then extracting the 8 bytes of data.
> 
> Implement a new helper function, pci_get_dsn, which can be used to extract
> this data into an 8 byte array.
 ...

Series applied to net-next, thanks.

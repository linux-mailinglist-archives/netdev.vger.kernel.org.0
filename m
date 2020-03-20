Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE7518D950
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCTU3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbgCTU3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 16:29:06 -0400
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7CAB2072C;
        Fri, 20 Mar 2020 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584736146;
        bh=CBE4Hpl5hWgtKq0+RxoHiNLqVoA/AcQ+0tzOzUVCEag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=CXJDRjWdSHh7htiOtO28bb2i50AdEGQorWO8awQ1r89tsJUgDbe065O9MIhaCQ2mi
         GqM/tIuXVv82Cn8sQM/vtiQo8zEDBtOwZyYV/XMJZpaz6VkdHTYEKG4D/vPNKTiDaN
         vhPJNwdno569XIpqvuekBl9FBQaivQ+cn2CEs7Mo=
Date:   Fri, 20 Mar 2020 15:29:04 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     linux-pci@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 06/11] PCI: Add new PCI_VPD_RO_KEYWORD_SERIALNO
 macro
Message-ID: <20200320202904.GA261671@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584458204-29285-1-git-send-email-vasundhara-v.volam@broadcom.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 08:46:44PM +0530, Vasundhara Volam wrote:
> This patch adds a new macro for serial number keyword.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  include/linux/pci.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index fc54b89..a048fba 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2184,6 +2184,7 @@ bool pci_acs_path_enabled(struct pci_dev *start,
>  #define PCI_VPD_INFO_FLD_HDR_SIZE	3
>  
>  #define PCI_VPD_RO_KEYWORD_PARTNO	"PN"
> +#define PCI_VPD_RO_KEYWORD_SERIALNO	"SN"
>  #define PCI_VPD_RO_KEYWORD_MFR_ID	"MN"
>  #define PCI_VPD_RO_KEYWORD_VENDOR0	"V0"
>  #define PCI_VPD_RO_KEYWORD_CHKSUM	"RV"
> -- 
> 1.8.3.1
> 

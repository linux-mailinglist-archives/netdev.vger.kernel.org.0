Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F674338682
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhCLHXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhCLHXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:23:14 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C8FC061574;
        Thu, 11 Mar 2021 23:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=V8EvGHE3k1YiRgMTrp7qLTuS6RkrDfzz7tTWOsyRx1s=; b=IV+NIpbCNRcnzQeairHNU++m3P
        M0+ScjK2vSAC9UaJMEB/U2JPPw89zKdm20JfMTETRTQE764i04dLcOFCWVH5hlNfKs4RF3LYInms7
        t+F7IlBWzSzlWXDpWlPJ7KuKO2nDMTl+zwqa8XB2A2txK5hjqDWr+x5Kk/S6UDMUQhFIQVum7J5tn
        I9Dk5LFIshWH00OtkPBE0N/mT2ZqKsCvX2qmriGgyOtz7HwvcFvXKXg8sKgu2xNkPyM/1EmwLlsmS
        cdySHkcDopAAkNwgXujV+W/TFMh1U3tjQ0Oc1PuFoxKOaxouoqOxt5iqr+Ni/IakUhk3UhO+4cH6Q
        hToUQCOw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKc8a-0011F1-La; Fri, 12 Mar 2021 07:23:10 +0000
Subject: Re: [PATCH] net: ethernet: dec: tulip: Random spelling fixes
 throughout the file pnic2.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210312070542.31309-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fe57b506-b737-e3a5-025f-a9cad45a1dca@infradead.org>
Date:   Thu, 11 Mar 2021 23:23:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210312070542.31309-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/21 11:05 PM, Bhaskar Chowdhury wrote:
> 
> Random spelling fixes throughout the file.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ethernet/dec/tulip/pnic2.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/dec/tulip/pnic2.c b/drivers/net/ethernet/dec/tulip/pnic2.c
> index 412adaa7fdf8..04daffb8db2a 100644
> --- a/drivers/net/ethernet/dec/tulip/pnic2.c
> +++ b/drivers/net/ethernet/dec/tulip/pnic2.c
> @@ -107,7 +107,7 @@ void pnic2_start_nway(struct net_device *dev)
>           */
>  	csr14 = (ioread32(ioaddr + CSR14) & 0xfff0ee39);
> 
> -        /* bit 17 - advetise 100baseTx-FD */
> +        /* bit 17 - advertise 100baseTx-FD */

OK above. But:
https://en.wikipedia.org/wiki/Autonegotiation

>          if (tp->sym_advertise & 0x0100) csr14 |= 0x00020000;
> 
>          /* bit 16 - advertise 100baseTx-HD */
> @@ -116,7 +116,7 @@ void pnic2_start_nway(struct net_device *dev)
>          /* bit 6 - advertise 10baseT-HD */
>          if (tp->sym_advertise & 0x0020) csr14 |= 0x00000040;
> 
> -        /* Now set bit 12 Link Test Enable, Bit 7 Autonegotiation Enable
> +        /* Now set bit 12 Link Test Enable, Bit 7 Auto negotiation Enable
>           * and bit 0 Don't PowerDown 10baseT
>           */
>          csr14 |= 0x00001184;
> @@ -157,7 +157,7 @@ void pnic2_start_nway(struct net_device *dev)
>          /* all set up so now force the negotiation to begin */
> 
>          /* read in current values and mask off all but the
> -	 * Autonegotiation bits 14:12.  Writing a 001 to those bits
> +	 * Auto negotiation bits 14:12.  Writing a 001 to those bits
>           * should start the autonegotiation
>           */
>          csr12 = (ioread32(ioaddr + CSR12) & 0xffff8fff);
> @@ -290,7 +290,7 @@ void pnic2_lnk_change(struct net_device *dev, int csr5)
>  	                csr14 = (ioread32(ioaddr + CSR14) & 0xffffff7f);
>                          iowrite32(csr14,ioaddr + CSR14);
> 
> -                        /* what should we do when autonegotiate fails?
> +                        /* what should we do when auto negotiate fails?
>                           * should we try again or default to baseline
>                           * case.  I just don't know.
>                           *
> --


-- 
~Randy


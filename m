Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D302733A8FA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 01:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhCOAA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 20:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhCOAA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 20:00:26 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11001C061574;
        Sun, 14 Mar 2021 17:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=VKgsPJd5YLDIyowg2wWgg3uZMUxmlOyx72YY0oI48Nk=; b=YpvKzo6wRq67/Ji5j3Mgijh+rg
        T9IgYFJtakgKKXbanMW/DZPtonul63/tHD+UgalHQbcqb3HwgqaTZhTvsldXzowVlF7B/ZTs2FkMz
        gOMuS4qcxGpc3GSa80nGvvEu75PlsgbP/OYpnJkaRV81DHXpBUF3gRDaWyGeLwGEejF/3kSHaHRD7
        blViHiK01WfC+PG9R5X250Pw9suI7PM6RE2acikYvW+Ardz1tZ8EByN4JSejQtrItx5G4nkBDKR+7
        Z1ozRlwWFdod95XvNMeVD1vde5qLnou3QmwlqreXgR0eOmxxVqEPm2pKnOkuF8WCA3GY5YRcMJhY2
        Eg0rYNJQ==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lLaek-001Eva-Tq; Mon, 15 Mar 2021 00:00:23 +0000
Subject: Re: [PATCH] ethernet: amazon: ena: A typo fix in the file ena_com.h
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        davem@davemloft.net, kuba@kernel.org, shayagr@amazon.com,
        sameehj@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210314222221.3996408-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1808939e-2226-b69e-4b5d-31fec1b3a74c@infradead.org>
Date:   Sun, 14 Mar 2021 17:00:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210314222221.3996408-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/21 3:22 PM, Bhaskar Chowdhury wrote:
> 
> Mundane typo fix.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/ethernet/amazon/ena/ena_com.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
> index 343caf41e709..73b03ce59412 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_com.h
> +++ b/drivers/net/ethernet/amazon/ena/ena_com.h
> @@ -124,7 +124,7 @@ struct ena_com_io_cq {
> 
>  	/* holds the number of cdesc of the current packet */
>  	u16 cur_rx_pkt_cdesc_count;
> -	/* save the firt cdesc idx of the current packet */
> +	/* save the first cdesc idx of the current packet */
>  	u16 cur_rx_pkt_cdesc_start_idx;
> 
>  	u16 q_depth;
> --


-- 
~Randy


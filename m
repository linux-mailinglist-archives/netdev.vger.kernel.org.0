Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F89E2A71
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 08:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437768AbfJXGa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 02:30:27 -0400
Received: from nbd.name ([46.4.11.11]:38942 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbfJXGa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 02:30:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xDfZuzNaf4heI4PEB4riPS2rBYIQORF5PqAALeNL0/8=; b=dlj8EmGcaI8lCUzn+PUdZVQRme
        iHPaSNOulXuYkdsV/kuAppTJjUsB4SKg6x0n4cjwLbXjqX9d/mZ/qc4IhFBc9te53g7wQstX2eTKU
        B7cTNNJ1Td/1zi4PsT/MYm96H7v416XI2h9sUETMU6lZFslANEEFyqScyNzfjYYdXfNw=;
Received: from p4ff1389f.dip0.t-ipconnect.de ([79.241.56.159] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1iNWdb-0001El-IX; Thu, 24 Oct 2019 08:30:23 +0200
Subject: Re: [PATCH wireless-drivers 2/2] mt76: dma: fix buffer unmap with
 non-linear skbs
To:     Lorenzo Bianconi <lorenzo@kernel.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
References: <cover.1571868221.git.lorenzo@kernel.org>
 <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <d1cf048c-3541-091e-7237-14199ddc89bc@nbd.name>
Date:   Thu, 24 Oct 2019 08:30:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-24 00:23, Lorenzo Bianconi wrote:
> mt76 dma layer is supposed to unmap skb data buffers while keep txwi
> mapped on hw dma ring. At the moment mt76 wrongly unmap txwi or does
> not unmap data fragments in even positions for non-linear skbs. This
> issue may result in hw hangs with A-MSDU if the system relies on IOMMU
> or SWIOTLB. Fix this behaviour properly unmapping data fragments on
> non-linear skbs.
> 
> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/dma.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> index c747eb24581c..8c27956875e7 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -93,11 +93,14 @@ static void
>  mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
>  			struct mt76_queue_entry *prev_e)
>  {
> -	struct mt76_queue_entry *e = &q->entry[idx];
>  	__le32 __ctrl = READ_ONCE(q->desc[idx].ctrl);
> +	struct mt76_queue_entry *e = &q->entry[idx];
>  	u32 ctrl = le32_to_cpu(__ctrl);
> +	bool mcu = e->skb && !e->txwi;
> +	bool first = e->skb == DMA_DUMMY_DATA || e->txwi == DMA_DUMMY_DATA ||
> +		     (e->skb && !skb_is_nonlinear(e->skb));
It seems to me that these conditions could be true not just for the
first entry, but also following entries except for the last one.
I think we should add a 'bool has_txwi' field in struct mt76_queue_entry
to indicate that the first dma address points to a txwi that should not
be unmapped.

- Felix

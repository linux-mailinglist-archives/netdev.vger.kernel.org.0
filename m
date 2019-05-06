Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D13B143DD
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbfEFELO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:11:14 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42406 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFELO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:11:14 -0400
Received: by mail-yw1-f66.google.com with SMTP id s5so2840755ywd.9;
        Sun, 05 May 2019 21:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZG6yX+dIIIOkAbndjIKZSBlSKQ8nnVPhJPelxK27FAo=;
        b=C1aj3s7z+lostEBcHHmXNnU+TQA5pSw6ndOUOfykpjTyVGCjcJcDqkteayH8mqzDCS
         LlAbP5iFyhuYqvfwlUne6hYM/H7O3L5keuOmQPAxp9xQEscGwR6IXLswVQOhOBwnssus
         68IRPCeEp8cQ9+TVGEkUtQUhbABUC0bvQ6BCDsrkEGrbazjjaWVwLsf9QXajK4RrAU7k
         KxXO8T2M4zQGuq/Xdyhj5G2Bw4lFKzMcRihS+JB0YBVZIdM+/NcCtWI9uYFXLzmPQS2p
         ILSvPQiTGM+5uBt5rc8NSqbMho7mobYW8sXJGqve+e18NQerURoIp2oB+ILveCltve6x
         OqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZG6yX+dIIIOkAbndjIKZSBlSKQ8nnVPhJPelxK27FAo=;
        b=T8jkkecdUPtuofiqh3MtVS3yCR/+zZX8aqGrUUYsIHhn0E1aHAMoSp8s5qPn4csGO/
         DIXlgTN/17+v9ZZKcnCCjGMXB05PScqeipRN/dM7tj6+4DLGFItYlkamNTK5fCNfueKU
         EtxjOSuD6wdb+3xNvMs6uoFIbXmMkL4gOCpqMtoP/L3FT6b2z7XiVVOI3GBYh9t2lGLk
         t8lv20bqgqmxweDdJ1K4TJWlpac1RZdn9/AjRdkYwD4CqF7+8q8wdLXO86RHCLdChm2s
         0bBNqo6y1vc2WulMFnZuqz1QOWNd59cipUunPjM4FD41AIn1imd31FCdXYyi/HOm52Fy
         DIRQ==
X-Gm-Message-State: APjAAAWbFaIalx0CM+M7StjI5UjkY6fwaMkK+4bcQ9FDnZFgeGu1M2pD
        cYZLSaaJrhUd3J7UH3rSbB2Y7N0/JbUwKEYQybE=
X-Google-Smtp-Source: APXvYqyH4XjfN/4h5z/sYyUgOpJMRICyPENNLXKmmT5lo7PNaZkCMv7a24jbC7IIDugnHv9gV1FXgY+L4PMUYdukgr8=
X-Received: by 2002:a81:9a96:: with SMTP id r144mr16017123ywg.353.1557115873186;
 Sun, 05 May 2019 21:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190505211623.3153-1-colin.king@canonical.com>
In-Reply-To: <20190505211623.3153-1-colin.king@canonical.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Mon, 6 May 2019 06:11:02 +0200
Message-ID: <CACna6rzqzzST4zu-6umnezmznnfoUqQP6V-yfyePaqCX8NakQQ@mail.gmail.com>
Subject: Re: [PATCH][next] brcmfmac: remove redundant u32 comparison with less
 than zero
To:     Colin King <colin.king@canonical.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        Network Development <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 May 2019 at 23:33, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The check for the u32 variable idx being less than zero is
> always false and is redundant. Remove it.
>
> Addresses-Coverity: ("Unsigned compared against 0")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> index 9d1f9ff25bfa..e874dddc7b7f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> @@ -375,7 +375,7 @@ brcmf_msgbuf_get_pktid(struct device *dev, struct brc=
mf_msgbuf_pktids *pktids,
>         struct brcmf_msgbuf_pktid *pktid;
>         struct sk_buff *skb;
>
> -       if (idx < 0 || idx >=3D pktids->array_size) {
> +       if (idx >=3D pktids->array_size) {
>                 brcmf_err("Invalid packet id %d (max %d)\n", idx,
>                           pktids->array_size);
>                 return NULL;

It was added in the commit 2d91c8ad068a ("brcmfmac: set txflow request
id from 1 to pktids array size") and was probably meant to handle a
following brcmf_msgbuf_process_txstatus() case:
idx =3D le32_to_cpu(tx_status->msg.request_id) - 1;

So this patch is wrong/incomplete.

You should change that to a signed value OR add an extra check in
brcmf_msgbuf_process_txstatus() to make sure it doesn't pass -1 as u32
argument.

--=20
Rafa=C5=82

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279EA34363C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCVB3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVB3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:29:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0AAC061574;
        Sun, 21 Mar 2021 18:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=AqW9JD6/7mom6xu9Dcxz5BZBRWoot1QLwxkOIDf3a8s=; b=HK7Rxrw4THkM64RSyQNfGmMpcQ
        vjTFcAbIh16vmxIOEN0IVTufyj8Zd4POPiSH1CZiMi1mRcEQkem1YJ/Cp/BPuFFLeqRhN9x29KzKQ
        lADE7GCX2byee7KcwIQrJ6ksJ+8WvQtnjXsYi11tMfkk4JA+XcetEHMtpytH64heSvDq9gul/7waY
        RzZPtBSYS+ehlkxgj9MPp/XlJlBepwLAQPf+9Ak439zhPwlJCPgBzYqKP0bYFdlVy7ZfQqBkcsGd5
        0xosVWeJEhXY3KsBzwBcNFySSvaZOACSzu1CoqjsmPJpBrSftCjXmgpI2A8PaSU37JInkWsE+pja8
        OYF1gpRQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lO9NK-00AfHH-Tc; Mon, 22 Mar 2021 01:28:59 +0000
Subject: Re: [PATCH] NFC: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210322005430.222748-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f39712a5-c15b-ca61-66da-fa7041e35eaa@infradead.org>
Date:   Sun, 21 Mar 2021 18:28:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322005430.222748-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 5:54 PM, Bhaskar Chowdhury wrote:
> 
> s/packaet/packet/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/nfc/fdp/fdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
> index 4dc7bd7e02b6..5d17f0a6c1bf 100644
> --- a/drivers/nfc/fdp/fdp.c
> +++ b/drivers/nfc/fdp/fdp.c
> @@ -176,7 +176,7 @@ static void fdp_nci_set_data_pkt_counter(struct nci_dev *ndev,
>   *
>   * The firmware will be analyzed and applied when we send NCI_OP_PROP_PATCH_CMD
>   * command with NCI_PATCH_TYPE_EOT parameter. The device will send a
> - * NFCC_PATCH_NTF packaet and a NCI_OP_CORE_RESET_NTF packet.
> + * NFCC_PATCH_NTF packet and a NCI_OP_CORE_RESET_NTF packet.
>   */
>  static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
>  {
> --


-- 
~Randy


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2435A481
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfF1Ssh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:48:37 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34974 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF1Ssg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:48:36 -0400
Received: by mail-yb1-f194.google.com with SMTP id i203so4583391ybg.2
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0P1Y//StJz44s7/YZiM+cINw7p7Yh+9CFilXpnVTxQ=;
        b=umHm/BsCRb8IzduSRjjF+2RoYF9GucD8xkNXBcbbtkmIFwersM/sM+9MWaQrSorKt2
         TmbhY632T7iPUsDNZT85rUaoZ6+kVrTQXbhd+oD7ZIZcHIhniC501Yq4oDdSiU/04hYm
         ZEdG7pq/ftop4ayY52UuIsE5WXcEOzWraSc7zeUUxR4ViI4SO8OtnYTEDOoMxWFVsvES
         +C7BjToBRpkZp/ldCK2Dssv0ZtrGQM3MI0X79m+rk6W5n3dR+tXM5xjzEnLAFFpxaJEu
         1DG/DiHQr6xOfzvEFw144KvpRuIr4XtKUCcem4dhqcxAf2jwxMmLsLVasHUuuaQyqD3T
         PqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0P1Y//StJz44s7/YZiM+cINw7p7Yh+9CFilXpnVTxQ=;
        b=DJ+0NyyWc+3nrpC0/8SzP+8pcyZMpUeIexPiGA7XS0lGAKQl5Cdli0TC4maBmPKGJL
         4FEOu95esnyBBAWV54m1vwdLC4iwrBKqwT3ZDOFGcY3zY7vLZA0xvkoXUSGjjVwRvvGV
         decy0RwELGb+i+DEo76QYcsiLi1BYcMfADm9uDny5mHQNaRsJQccr8IXCkonsHuQ40nH
         s+VlwYvLQVJuM2Qoq/l39nLUmnPLTeMR8dMQJDhPCrapBBnX30hYAq6NswI5bztZAQuX
         vHb6momV3Saa9fv/WLlBrkc8yD2dhyVUmg1ppqVWvYegWDk/HDDzk1bG46YokqFzUfsH
         /GKw==
X-Gm-Message-State: APjAAAWaol6hilSaqIvMqMhAu9VrRCY5p+5h48RIGl1RJIUcYIcrOwFb
        n/lFdsO7AqtL4Eig/2uuWu557Rn9
X-Google-Smtp-Source: APXvYqyrKhnCXgBVxnFuOrlsCfQIGSdZe1RePe3GTWBJcIKegno609j23hVdrgCpyUCLh2UQuA4wlw==
X-Received: by 2002:a25:d47:: with SMTP id 68mr7250664ybn.75.1561747715057;
        Fri, 28 Jun 2019 11:48:35 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id 200sm725504ywq.102.2019.06.28.11.48.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 11:48:34 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id j190so3531672ywb.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:48:33 -0700 (PDT)
X-Received: by 2002:a81:4d86:: with SMTP id a128mr7047569ywb.291.1561747713444;
 Fri, 28 Jun 2019 11:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com> <1561722618-12168-3-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1561722618-12168-3-git-send-email-tanhuazhong@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 14:47:57 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdWa0dMz15m79SLsNAw9zkp3+3MSfKiRwKnjZ7QAyq1Uw@mail.gmail.com>
Message-ID: <CA+FuTSdWa0dMz15m79SLsNAw9zkp3+3MSfKiRwKnjZ7QAyq1Uw@mail.gmail.com>
Subject: Re: [PATCH net-next 02/12] net: hns3: enable DCB when TC num is one
 and pfc_en is non-zero
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 7:53 AM Huazhong Tan <tanhuazhong@huawei.com> wrote:
>
> From: Yunsheng Lin <linyunsheng@huawei.com>
>
> Currently when TC num is one, the DCB will be disabled no matter if
> pfc_en is non-zero or not.
>
> This patch enables the DCB if pfc_en is non-zero, even when TC num
> is one.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
> index 9edae5f..cb2fb5a 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
> @@ -597,8 +597,10 @@ static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
>                 hdev->tm_info.prio_tc[i] =
>                         (i >= hdev->tm_info.num_tc) ? 0 : i;
>
> -       /* DCB is enabled if we have more than 1 TC */
> -       if (hdev->tm_info.num_tc > 1)
> +       /* DCB is enabled if we have more than 1 TC or pfc_en is
> +        * non-zero.
> +        */
> +       if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)

small nit: comments that just repeat the condition are not very informative.

More helpful might be to explain why the DCB should be enabled in both
these cases. Though such detailed comments, if useful, are better left
to the commit message usually.

>                 hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
>         else
>                 hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
> @@ -1388,6 +1390,19 @@ void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc)
>         hclge_tm_schd_info_init(hdev);
>  }
>
> +void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
> +{
> +       /* DCB is enabled if we have more than 1 TC or pfc_en is
> +        * non-zero.
> +        */
> +       if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
> +               hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
> +       else
> +               hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
> +
> +       hclge_pfc_info_init(hdev);
> +}

Avoid introducing this code duplication by defining a helper?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790ED57569F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 22:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbiGNUxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 16:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiGNUxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 16:53:01 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D4D6758F;
        Thu, 14 Jul 2022 13:53:00 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id w2so3553037ljj.7;
        Thu, 14 Jul 2022 13:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qoOEVRog5Z9OnfGA667isDqDOO6aHHg3XsYmCVgJlPE=;
        b=ZnNjcqwzm3TIowpCiyQqSnvZJMN8vS+WW7Ol5NU9/gR8pS4CKS1AmfxY0Ro7cTwsMP
         I+bTKCR2CO8lFyZUwUd/Av5EltJz6B1oH0nmmT20JY0XdWEhPL1XROurGi9xgJe6uwPY
         uuUjY7EsmJkzrWH5EvWDtEqeXLPU4Y35BsZnW6ZLGkrFZ8QSQAcCNpkA2eAi4olMWEjH
         UG1zufCHg0GGv87BI7dMsHPZSr/u6uYawXe6qwD6JMc9Ld7e4GwTSn5yNN2V806qUxHN
         QedKIBMvV4S3OJJVgvN74CHFg1+yR9zON2h7pUz2nSyYRXCGkiBtZ/6wI0lUi+buMmL7
         ZGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qoOEVRog5Z9OnfGA667isDqDOO6aHHg3XsYmCVgJlPE=;
        b=NoJBwFv7ZYJtiUrl5oFT1vwWUk9TsHDh66AVSV5juFMduX/NeY3RxL6R5+BO5mP0Cx
         0euI6RMIJYPzAJJbPjena02UiepM0bUZhK1Yxh5j1G9c/I9VVpeAS5SDHGcVGmQDmz4T
         VEBcArkYtKmVn+LfKusV09Vmy64xKWYWscW9RYTeFQOTFGsZxWNUYH/jcOW6QODbvrlC
         5hVQGhxTsQV/HG99qqMKNu87Xa/NElPyp2AldQ2pVfCvsuKFgc1LbYQkQd3Q42VDqW90
         4MC3yxKKZ3Vx2sJnAcD6KhL6n2VeF+UzInYTc8ZPi0hh5uLyRSDyfuHRKVrMTiN8miVJ
         ezbw==
X-Gm-Message-State: AJIora+n2AOvcPXArDfuE+8YIN6LpKBUVq/FN7fI2D4uKoKvScRYMVcS
        BoXSpJKtRurYCWd1JHIDnhUAB5ZUN8o8Yb//WUo=
X-Google-Smtp-Source: AGRyM1thlr1wx3tNWOgTqSb+LfcRI9DpbpLJcE7Mm1Jj8QhbF8tPjEwhNX8pwgBS9xHXodTA61eMiwahhYDfUcb+YKs=
X-Received: by 2002:a05:651c:1691:b0:25d:8240:6b3a with SMTP id
 bd17-20020a05651c169100b0025d82406b3amr5020152ljb.305.1657831978184; Thu, 14
 Jul 2022 13:52:58 -0700 (PDT)
MIME-Version: 1.0
References: <1657774452-4497-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1657774452-4497-1-git-send-email-quic_zijuhu@quicinc.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 14 Jul 2022 13:52:46 -0700
Message-ID: <CABBYNZJG8uKv-270u1P4NTr-gML5=uR2Syhjs=x4LMhJOnqSxA@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: hci_sync: Remove redundant func definition
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zijun,

On Wed, Jul 13, 2022 at 9:54 PM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>
> both hci_request.c and hci_sync.c have the same definition
> for disconnected_accept_list_entries(), so remove a redundant
> copy.
>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  net/bluetooth/hci_request.c |  2 +-
>  net/bluetooth/hci_request.h |  2 ++
>  net/bluetooth/hci_sync.c    | 18 ------------------
>  3 files changed, 3 insertions(+), 19 deletions(-)

We are actually deprecating hci_request functions in favor of hci_sync
ones so this is going in the opposite direction.

> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 635cc5fb451e..38e6c66a3327 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -1784,7 +1784,7 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
>         return 0;
>  }
>
> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
> +bool disconnected_accept_list_entries(struct hci_dev *hdev)
>  {
>         struct bdaddr_list *b;
>
> diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
> index 7f8df258e295..e80b500878d9 100644
> --- a/net/bluetooth/hci_request.h
> +++ b/net/bluetooth/hci_request.h
> @@ -120,6 +120,8 @@ void __hci_req_update_scan(struct hci_request *req);
>  int hci_update_random_address(struct hci_request *req, bool require_privacy,
>                               bool use_rpa, u8 *own_addr_type);
>
> +bool disconnected_accept_list_entries(struct hci_dev *hdev);
> +
>  int hci_abort_conn(struct hci_conn *conn, u8 reason);
>  void __hci_abort_conn(struct hci_request *req, struct hci_conn *conn,
>                       u8 reason);
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 212b0cdb25f5..99ffac6c5e8c 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -2419,24 +2419,6 @@ int hci_write_fast_connectable_sync(struct hci_dev *hdev, bool enable)
>         return err;
>  }
>
> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
> -{
> -       struct bdaddr_list *b;
> -
> -       list_for_each_entry(b, &hdev->accept_list, list) {
> -               struct hci_conn *conn;
> -
> -               conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
> -               if (!conn)
> -                       return true;
> -
> -               if (conn->state != BT_CONNECTED && conn->state != BT_CONFIG)
> -                       return true;
> -       }
> -
> -       return false;
> -}
> -
>  static int hci_write_scan_enable_sync(struct hci_dev *hdev, u8 val)
>  {
>         return __hci_cmd_sync_status(hdev, HCI_OP_WRITE_SCAN_ENABLE,
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>


-- 
Luiz Augusto von Dentz

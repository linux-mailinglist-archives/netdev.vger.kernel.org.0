Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5077D578E1C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbiGRXMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiGRXMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:12:54 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AF333368;
        Mon, 18 Jul 2022 16:12:53 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bp17so21967115lfb.3;
        Mon, 18 Jul 2022 16:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tdCumMkGDtxwvFkZJRFbFv4L/guo6vY9nBfv53e1qHk=;
        b=MNb/r7HdgU2ylim64tzSUsoIlfAL0CGlCiXdIER51EOlv6vZH4GRJUpKxmmlSR2Fs+
         wf12WcjpU3KyyeETxz+SkWM6281RSoWRgl3/IsQyVQPEfrxw5HL3Regb2CvOP8wG5Kia
         KCidYinJq2cxB2kqyWcs8bJ3ahPsNrbtrBqguxNuyyCoC3M/u+xKy9IekY2tQC9hTWYG
         9f510gstrcizEFqkjLuvGu5GSAk0+I3gWuwA6+OGDIofmyLO7E/uPBXCOc6ZoyX0Y117
         bhkPnnE2Gloh5/NAfZL8yxfcKPevhQiDx6Vj7yVnewVzAo9Wva49XQXhKad1jhWZ0AID
         qxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tdCumMkGDtxwvFkZJRFbFv4L/guo6vY9nBfv53e1qHk=;
        b=rLDQsZDoEgqqkpN3ZThrPipCGqdTngttrxhmM37qpSL1CmrTvlPUbKo4tLXGzILtZ5
         4bTKl5/e61u8IIveNR6STe2PVBAz7pV8a/3qFaVBHtkHQ2HXgbGWygl8oZClMIwBv3WR
         +6ygr0WvDGCbRwCYydL4bdYXFgxCpITrC9Eplze+u2/WMxCf3cuEznY1KUrShUMdKYMR
         4rpS+t5VWmqQK3ewzTKeSfmyPvOuUeYcphb5MN2IvthRFQ0yt/0Fsr2O3r1zOe0OXiz1
         YSRVIlSXHRosddodLUTo20/EuAezM4OS3u6ikevn3diDszw7qTEm0hwXg8VBuWc+RvTq
         OPog==
X-Gm-Message-State: AJIora8cqsbD431PKKk9eBKzjW24TX5hgNzKDEwBR5E1uXxgdIcXtCbQ
        ixHN3I2FvVv2cWNmdZeL5yTomFI7YWNhiX7NS2gDu311R+MUqw==
X-Google-Smtp-Source: AGRyM1u/UX/2/zEXz6/lD8zuEp0We7LzyP9lhw5gFziM+I+EVpupn0uSaExp9ad9Jm+RiNlqrZrWSE08W6orK5vu2AI=
X-Received: by 2002:a05:6512:2621:b0:47f:d228:bdeb with SMTP id
 bt33-20020a056512262100b0047fd228bdebmr14931135lfb.121.1658185971888; Mon, 18
 Jul 2022 16:12:51 -0700 (PDT)
MIME-Version: 1.0
References: <1657871102-26907-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1657871102-26907-1-git-send-email-quic_zijuhu@quicinc.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 18 Jul 2022 16:12:40 -0700
Message-ID: <CABBYNZ+YcrGn09hxB9t7rn1ccY4xtv1WCLQrOLvyUXdQNA_usw@mail.gmail.com>
Subject: Re: [PATCH v4] Bluetooth: hci_sync: Remove redundant func definition
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zijun,

On Fri, Jul 15, 2022 at 12:45 AM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>
> both hci_request.c and hci_sync.c have the same definition for
> disconnected_accept_list_entries(), so remove a redundant copy.
>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
> v3->v4
>  -use 75 characters per line for Linux commit message bodies
> v2->v3
>  -remove table char to solve gitlint checking failure
> v1->v2
>  -remove the func copy within hci_request.c instead of hci_sync.c
>  net/bluetooth/hci_request.c | 18 ------------------
>  net/bluetooth/hci_request.h |  2 ++
>  net/bluetooth/hci_sync.c    |  2 +-
>  3 files changed, 3 insertions(+), 19 deletions(-)
>
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 635cc5fb451e..edec0447aaa7 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -1784,24 +1784,6 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
>         return 0;
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
>  void __hci_req_update_scan(struct hci_request *req)
>  {
>         struct hci_dev *hdev = req->hdev;
> diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
> index 7f8df258e295..e80b500878d9 100644
> --- a/net/bluetooth/hci_request.h
> +++ b/net/bluetooth/hci_request.h
> @@ -120,6 +120,8 @@ void __hci_req_update_scan(struct hci_request *req);
>  int hci_update_random_address(struct hci_request *req, bool require_privacy,
>                               bool use_rpa, u8 *own_addr_type);
>
> +bool disconnected_accept_list_entries(struct hci_dev *hdev);

I rather not add anything to hci_request.h since we want to deprecate
its functions, in fact we might as well try to start removing the code
paths that attempt to access things like
disconnected_accept_list_entries since I think most of the code is
already in place in hci_sync.c things like __hci_req_update_scan if it
is no longer used anywhere else.

>  int hci_abort_conn(struct hci_conn *conn, u8 reason);
>  void __hci_abort_conn(struct hci_request *req, struct hci_conn *conn,
>                       u8 reason);
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 212b0cdb25f5..48a262f0ae49 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -2419,7 +2419,7 @@ int hci_write_fast_connectable_sync(struct hci_dev *hdev, bool enable)
>         return err;
>  }
>
> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
> +bool disconnected_accept_list_entries(struct hci_dev *hdev)
>  {
>         struct bdaddr_list *b;
>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>


-- 
Luiz Augusto von Dentz

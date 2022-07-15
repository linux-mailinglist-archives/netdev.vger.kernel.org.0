Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D69F575A21
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 06:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbiGOEDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 00:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiGOEDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 00:03:50 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EACDF86;
        Thu, 14 Jul 2022 21:03:49 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bp17so5950668lfb.3;
        Thu, 14 Jul 2022 21:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ujVXyns3rNmS/Ee8BcP+uYwQE6ICtpjGNYjLOoQ+tU8=;
        b=Ox1HJcwTb7MthahIQENHD5tBkuboDbyGAQTfg2UqO2VuubsvBgg5sIkz6V6ZdqDiqX
         NAvLcXwP4V2wIC1udQK7uDh5L/FyRvfOAnLHieyYna7G/hIKCgU/NL6M76tn+7eiA6vh
         2nbkVimNjFi8qo4Y0SeoSWJ6RoiLZ9LYWmwrCA8BP9ZWAmENsUlfdPUMxGlHQzG4Cpwm
         vNRu3EVCOgPei8EW9FUUBwX5DhSyj0LRPvEO2EQbu4k6PQtWp+cTPQcvv78QMG+OsSpy
         8nQE75BwybEqIuUBmpOctAAydx6k3vp0jBb3bj1TFuxJo8ZhuaxeM6uHcQ2ekDE1hmo5
         2Onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ujVXyns3rNmS/Ee8BcP+uYwQE6ICtpjGNYjLOoQ+tU8=;
        b=AtyJVc5XTfvRl+tAUAgkTREdhg7fvIPWGQxvTpHZBr0PrkxBFwFyB9LEnfwNIXZ91J
         LqTVK7Hwgg0OczbywtoHf0r1kL8wpDyryWKE3alcns29Kq+NTdlTzNp3rI9b4rZPiZrN
         3uTUt9AqyDessKPAb/Gp7AWNvNQr6g9VDJBRvE/nPwoJ22Mh1jYJWWEVoquZza59dO9q
         JxRVgqxOetH0aX0BOM7XSm4hJblev+zx3ntFoAyFqBVf52rHdtt60ukra4YwSAKOMimJ
         S6iAhekv0Sj9/WMqGrcmCy2V5F7hdXBoLB8NBZKnAD2hnEslO9USPgz7c3HCjJtT+HUF
         aO0w==
X-Gm-Message-State: AJIora9VDBdczIHVbhho7VXH6mxdWD4eWdokGcPVOVJziuNSKSc8/54V
        wXeoCPR8tBa12KMAiwLyrWd/tLiloKPe+d7r4+Za9cvjVAqk6A==
X-Google-Smtp-Source: AGRyM1u/NWI2p+FhH48FvrLKcDj3y/n3k05FggqhijpfU1pAkK23Kq3D0cyYziiIU/ffLUDx8UAoVatnsNyoQTdFWaA=
X-Received: by 2002:a05:6512:3409:b0:489:c549:4693 with SMTP id
 i9-20020a056512340900b00489c5494693mr6571084lfr.26.1657857827176; Thu, 14 Jul
 2022 21:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <1657774452-4497-1-git-send-email-quic_zijuhu@quicinc.com>
 <CABBYNZJG8uKv-270u1P4NTr-gML5=uR2Syhjs=x4LMhJOnqSxA@mail.gmail.com> <2cb4f711-5e7c-6fc7-263f-0ed6437f0edb@quicinc.com>
In-Reply-To: <2cb4f711-5e7c-6fc7-263f-0ed6437f0edb@quicinc.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 14 Jul 2022 21:03:35 -0700
Message-ID: <CABBYNZJso0QxYhnuaYxu0SYimm7vGvUOPGmuRAYf8LnnHOYxRQ@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: hci_sync: Remove redundant func definition
To:     quic_zijuhu <quic_zijuhu@quicinc.com>
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

Hi Quic_zijuhu,

On Thu, Jul 14, 2022 at 7:12 PM quic_zijuhu <quic_zijuhu@quicinc.com> wrote:
>
> On 7/15/2022 4:52 AM, Luiz Augusto von Dentz wrote:
> > Hi Zijun,
> >
> > On Wed, Jul 13, 2022 at 9:54 PM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
> >>
> >> both hci_request.c and hci_sync.c have the same definition
> >> for disconnected_accept_list_entries(), so remove a redundant
> >> copy.
> >>
> >> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> >> ---
> >>  net/bluetooth/hci_request.c |  2 +-
> >>  net/bluetooth/hci_request.h |  2 ++
> >>  net/bluetooth/hci_sync.c    | 18 ------------------
> >>  3 files changed, 3 insertions(+), 19 deletions(-)
> >
> > We are actually deprecating hci_request functions in favor of hci_sync
> > ones so this is going in the opposite direction.
> >
> should remove disconnected_accept_list_entries() definition within hci_request.c instead of
> hci_sync.c, right?

Correct

> >> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> >> index 635cc5fb451e..38e6c66a3327 100644
> >> --- a/net/bluetooth/hci_request.c
> >> +++ b/net/bluetooth/hci_request.c
> >> @@ -1784,7 +1784,7 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
> >>         return 0;
> >>  }
> >>
> >> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
> >> +bool disconnected_accept_list_entries(struct hci_dev *hdev)
> >>  {
> >>         struct bdaddr_list *b;
> >>
> >> diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
> >> index 7f8df258e295..e80b500878d9 100644
> >> --- a/net/bluetooth/hci_request.h
> >> +++ b/net/bluetooth/hci_request.h
> >> @@ -120,6 +120,8 @@ void __hci_req_update_scan(struct hci_request *req);
> >>  int hci_update_random_address(struct hci_request *req, bool require_privacy,
> >>                               bool use_rpa, u8 *own_addr_type);
> >>
> >> +bool disconnected_accept_list_entries(struct hci_dev *hdev);
> >> +
> >>  int hci_abort_conn(struct hci_conn *conn, u8 reason);
> >>  void __hci_abort_conn(struct hci_request *req, struct hci_conn *conn,
> >>                       u8 reason);
> >> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> >> index 212b0cdb25f5..99ffac6c5e8c 100644
> >> --- a/net/bluetooth/hci_sync.c
> >> +++ b/net/bluetooth/hci_sync.c
> >> @@ -2419,24 +2419,6 @@ int hci_write_fast_connectable_sync(struct hci_dev *hdev, bool enable)
> >>         return err;
> >>  }
> >>
> >> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
> >> -{
> >> -       struct bdaddr_list *b;
> >> -
> >> -       list_for_each_entry(b, &hdev->accept_list, list) {
> >> -               struct hci_conn *conn;
> >> -
> >> -               conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
> >> -               if (!conn)
> >> -                       return true;
> >> -
> >> -               if (conn->state != BT_CONNECTED && conn->state != BT_CONFIG)
> >> -                       return true;
> >> -       }
> >> -
> >> -       return false;
> >> -}
> >> -
> >>  static int hci_write_scan_enable_sync(struct hci_dev *hdev, u8 val)
> >>  {
> >>         return __hci_cmd_sync_status(hdev, HCI_OP_WRITE_SCAN_ENABLE,
> >> --
> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
> >>
> >
> >
>


-- 
Luiz Augusto von Dentz

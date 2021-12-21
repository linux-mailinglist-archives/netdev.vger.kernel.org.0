Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668E747C8ED
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbhLUV4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhLUV4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:56:49 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51542C061574;
        Tue, 21 Dec 2021 13:56:49 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id d10so613952ybn.0;
        Tue, 21 Dec 2021 13:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nH5deYnY1F+nFd2Y1Uyf515q7YwKeWK3mKwSxQWbEyc=;
        b=b1kd8BudFlrruJSAJZ5gb3m3crA+JNARA6Iw+Mvqs+ksg5BPcU8ZCxuPE+Y6kDVNvM
         cVX1Ili0M6zSt2zF8l/ZqqBZR0ZROyA78zYdfr0DGKf1P4tWhUAdPpfdiiUex3jd6woh
         UUtSyko9ZW5SRC0H274qX11uPZZpyCJZLqBzgO0gshcoVtoHzNsaWnuIEN6DPzKIa3Dj
         6LnV6SEmtV5/baKo1MaSx2+q8DxKf/2vJRV2+GQK5NOTkS48MYEvcKFGK1L6EbnHlT33
         y7fLEu9rKjtVeyhCLo//wwERcJyaFWemz/Wk//PMEPO9ok4FK2ZWsLoMMk9VpU9XqJDv
         TjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nH5deYnY1F+nFd2Y1Uyf515q7YwKeWK3mKwSxQWbEyc=;
        b=KAkK9YQOsgiKj0udFYt7MqwMBhQYNdFzim1Ig22SaQ7ysLTkqZMSZocXCABDATf5V9
         SdXzLVwY9GKjXiimeOMxhL8/9kdX2/xuvqZrwIvtxSfTvPOUcUOVO0ONivv0ZdIrjUUG
         SyxwChw+/8z4fP2TtVgp+vIkXxjKfVc44OklT1g54DyEDwgUl/PsY14jsBmoQaSjHFfm
         oKm6qsxXauJbnN0ieAmC53j+H3T2P0TzSWAR0bFKyXOXIuKPjO55ZXh7/bj0r6P9sF+l
         mYQEVJz01QJT0i2mpuX5wmrVuPAdOUPvQobKiWezzpIVJFBJF8womUgJUlDjT2fpj9cM
         2VpQ==
X-Gm-Message-State: AOAM530CIHg85u6Fk7wAR2Rk+vMk9fInKN9UjcXw1bPGW+PK9Z6SfBja
        dsANJD/DiG9wUHAaKeOlv1nbVfPOK2k2Vuy3nNg=
X-Google-Smtp-Source: ABdhPJyWp+tcos8RglvIuOvmkPeM/jkjRDtdU6lOBCtRSyS0bLAiW5Ii0Op2ac9aMWD7PIcmQXv3XuyrZjK5cimrh7k=
X-Received: by 2002:a05:6902:722:: with SMTP id l2mr392530ybt.573.1640123808421;
 Tue, 21 Dec 2021 13:56:48 -0800 (PST)
MIME-Version: 1.0
References: <20211216044839.v9.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
 <202112171439.KaggScQN-lkp@intel.com>
In-Reply-To: <202112171439.KaggScQN-lkp@intel.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 21 Dec 2021 13:56:37 -0800
Message-ID: <CABBYNZ+hvtsA=i2mgJnuzR3B6Byku8t+wHBuSW3_5eG4KSHy-w@mail.gmail.com>
Subject: Re: [kbuild] Re: [PATCH v9 1/3] bluetooth: msft: Handle MSFT Monitor
 Device Event
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, Manish Mandlik <mmandlik@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Thu, Dec 16, 2021 at 11:18 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hi Manish,
>
> url:    https://github.com/0day-ci/linux/commits/Manish-Mandlik/bluetooth-msft-Handle-MSFT-Monitor-Device-Event/20211216-205227
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git  master
> config: i386-randconfig-m021-20211216 (https://download.01.org/0day-ci/archive/20211217/202112171439.KaggScQN-lkp@intel.com/config )
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> smatch warnings:
> net/bluetooth/msft.c:757 msft_vendor_evt() warn: inconsistent returns '&hdev->lock'.
>
> vim +757 net/bluetooth/msft.c
>
> 3e54c5890c87a30 Luiz Augusto von Dentz 2021-12-01  714  void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  715  {
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  716          struct msft_data *msft = hdev->msft_data;
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  717          u8 *evt_prefix;
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  718          u8 *evt;
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  719
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  720          if (!msft)
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  721                  return;
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  722
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  723          /* When the extension has defined an event prefix, check that it
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  724           * matches, and otherwise just return.
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  725           */
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  726          if (msft->evt_prefix_len > 0) {
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  727                  evt_prefix = msft_skb_pull(hdev, skb, 0, msft->evt_prefix_len);
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  728                  if (!evt_prefix)
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  729                          return;
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  730
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  731                  if (memcmp(evt_prefix, msft->evt_prefix, msft->evt_prefix_len))
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  732                          return;
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  733          }
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  734
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  735          /* Every event starts at least with an event code and the rest of
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  736           * the data is variable and depends on the event code.
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  737           */
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  738          if (skb->len < 1)
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  739                  return;
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  740
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  741          hci_dev_lock(hdev);
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  742
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  743          evt = msft_skb_pull(hdev, skb, 0, sizeof(*evt));
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  744          if (!evt)
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  745                  return;
>
> Missing hci_dev_unlock(hdev);
>
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  746
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  747          switch (*evt) {
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  748          case MSFT_EV_LE_MONITOR_DEVICE:
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  749                  msft_monitor_device_evt(hdev, skb);
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  750                  break;
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  751
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  752          default:
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  753                  bt_dev_dbg(hdev, "MSFT vendor event 0x%02x", *evt);
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  754                  break;
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  755          }
> e5af6a85decc8c1 Manish Mandlik         2021-12-16  756
> e5af6a85decc8c1 Manish Mandlik         2021-12-16 @757          hci_dev_unlock(hdev);
> 145373cb1b1fcdb Miao-chen Chou         2020-04-03  758  }
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> _______________________________________________
> kbuild mailing list -- kbuild@lists.01.org
> To unsubscribe send an email to kbuild-leave@lists.01.org

Are you working on fixing the above problems?


-- 
Luiz Augusto von Dentz

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4F287493
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgJHMyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbgJHMyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:54:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67E9C061755;
        Thu,  8 Oct 2020 05:54:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id g10so3918178pfc.8;
        Thu, 08 Oct 2020 05:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8meL6RsN+cQ5MfWybhWX8LZbSYR56saTZEuAfFrW37I=;
        b=MNxaefSDb5f3vIg4Lst3iWOgaZaMjjWpLJWXogXWWAxdWIhS3+NRWI0ioK2RBwjCVv
         qxU8ozWRvEirnoM2YCiD/ccN43hPzChWEm9P33DYUGNG2AG5kwZvUGpxKohpCWxOwh9A
         c31poOrXukG0LLjMG1XlkmC8YcDDHqndByu6Coz1/1ri3ZGZ09gIcknZjQLTNrAyBDOh
         ToEHDLdJuziD/NjDy0Lkol4zfcKLb7Hbcg9qHXN4H+j8rJhRJk/EpTZ64Mqv5fPoTd4v
         QSZNO/DzuYtoyp8q0gyO3gJowews5cBDW5FZbPvOuSeo86vSJmf33ILnnyi17ZY7koyF
         kJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8meL6RsN+cQ5MfWybhWX8LZbSYR56saTZEuAfFrW37I=;
        b=btgk9EljWOIGKfyBBm/wTP/ElF6AeqNGglFfDDmUbP6Je2bemTkHGAPpUA44Q+i3PV
         fkiTN0HiD9uP12yzNfO83Bru5CJ++vvCAXBlsGvVER4GgbfSIW7cgcclkVl6cQfLtuwi
         tI4PkL/HhEJjFTeQpyd5JXH3kts1qP8Fvx/7WKAFJJUYkzH0fYMDX7ayhciur6qANdUG
         7swaTmbyqaPb8SQnVelzqlw9mjy3k0zUzuAEkNZSOLOYZwTtmiQwNNjcZD5q4ZJoiqUL
         qmTtqyviOSOlgx3xXKgT1u1pk4fR6g+UT/3WYovlfnMZmuxrAM6k+Bzs+SBEKjZPvcD4
         KOGA==
X-Gm-Message-State: AOAM530t8ygtxHULSNLtOC/iTv0BeyouCkpqxL5z89hhSZhHKIUZwPud
        Iyf0ReVoFNmfhPCRmEmUhGQ=
X-Google-Smtp-Source: ABdhPJzzcHMuMTR79tIKe0/516uV2gJ/dDXiVrsaLzXkMhmuAv3nIFO7XUbuGe9s+jw9Iz2S77H1LA==
X-Received: by 2002:a63:29c8:: with SMTP id p191mr7188723pgp.45.1602161676335;
        Thu, 08 Oct 2020 05:54:36 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id a18sm6956102pgw.50.2020.10.08.05.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 05:54:35 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 8 Oct 2020 20:54:28 +0800
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201008125428.ppyqjefow4oepvxb@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <CA+FuTSdEK+0nBCd5KAYpbEECmSvjoMEgcEOtM+ZKFF4QQKuAfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+FuTSdEK+0nBCd5KAYpbEECmSvjoMEgcEOtM+ZKFF4QQKuAfw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 08:22:44AM -0400, Willem de Bruijn wrote:
>On Thu, Oct 8, 2020 at 7:58 AM Coiby Xu <coiby.xu@gmail.com> wrote:
>>
>> Initialize devlink health dump framework for the dlge driver so the
>> coredump could be done via devlink.
>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>
>> @@ -4556,6 +4559,13 @@ static int qlge_probe(struct pci_dev *pdev,
>>         struct ql_adapter *qdev = NULL;
>>         static int cards_found;
>>         int err = 0;
>> +       struct devlink *devlink;
>> +       struct qlge_devlink *ql_devlink;
>> +
>> +       devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_devlink));
>> +       if (!devlink)
>> +               return -ENOMEM;
>> +       ql_devlink = devlink_priv(devlink);
>>
>>         ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
>>                                  min(MAX_CPUS,
>
>need to goto devlink_free instead of return -ENOMEM here, too.
>
>> @@ -4614,6 +4624,16 @@ static int qlge_probe(struct pci_dev *pdev,
>>                 free_netdev(ndev);
>>                 return err;
>
>and here
>
Thank you for reviewing this work and the speedy feedback! I'll fix it
in v2.
>>         }
>> +
>> +       err = devlink_register(devlink, &pdev->dev);
>> +       if (err) {
>> +               goto devlink_free;
>> +       }
>> +
>> +       qlge_health_create_reporters(ql_devlink);
>> +       ql_devlink->qdev = qdev;
>> +       ql_devlink->ndev = ndev;
>> +       qdev->ql_devlink = ql_devlink;
>>         /* Start up the timer to trigger EEH if
>>          * the bus goes dead
>>          */
>> @@ -4624,6 +4644,10 @@ static int qlge_probe(struct pci_dev *pdev,
>>         atomic_set(&qdev->lb_count, 0);
>>         cards_found++;
>>         return 0;
>> +
>> +devlink_free:
>> +       devlink_free(devlink);
>> +       return err;
>>  }

--
Best regards,
Coiby

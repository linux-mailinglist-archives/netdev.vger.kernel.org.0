Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B2D51B7F5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiEEGdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiEEGdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:33:42 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D271A05D;
        Wed,  4 May 2022 23:30:04 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ef5380669cso38052897b3.9;
        Wed, 04 May 2022 23:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=hPg/kHUDyxMY3LkVNBXDy7g4FaARqDwC2Ys4u38uvGI=;
        b=Nm4Zz5nhKZ3HXeTj7BdPL1xu3o52ow/5uQwZaFOhdAcUzK/zag7Aj8mm1vQli0o6Iz
         Hz7QCpbrWBxWo7rRBSwjU+ykaehOWrLsjSWvwuds/xNLnzNXGJItRFHFduf70lsHimoZ
         khIrK/kIUZYwyRVDqVxtSYPVimSvCKKfA+YLSSn544yh/JR5TdSPCrxcathQbiwK3/hY
         DFbRmkUQGoV78dXRWs7ca+EtE0UW20+ThPogonlP/WVlAORWPAzV7E4DmVeAtxtcKAOj
         BiJ9kCIa4ltjnjRd+80t/lByJTNM68wldIpF9Y+Dcg8VC4TPC+cOsK3E6bz6hzRbwg7l
         2iqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hPg/kHUDyxMY3LkVNBXDy7g4FaARqDwC2Ys4u38uvGI=;
        b=Ez0hxVixKiHuXRrT4UTEOysPzSUkp+QB43Qi84t6ktgrGBn6dX9pZvndeCKxBY492/
         1HLvAjBuisQ6ILTImZDSaG9vwNaKsWhKrNXc71eDdCvdduhU6HYlkXCsNZ9HkJKCoj1W
         jQKIUYmcbfWstaFD64mqfdJ0fncoGdrougIq4dc5RdCbqFoAV6tnHoiLrDFmdOb4CLkK
         PKRpCzvlSyvVcx9lX+uwkX/dxOLD4iqcmZ+ISB3AlrAPvRkvx5ENdzMBiMOXkeVZ+z9t
         htqBhy0CD6ZvTL1hUU73t43WXJz9HbHiG+ioCwiNBFl0xXPKrzgZZLuuwC0e40K8sX9f
         mljw==
X-Gm-Message-State: AOAM531vlDWGAkXyhBVPlmHBCFPo12Q7UHFwd3mmy6MEDTlL34XFRFpj
        KYG0CRVi0nMeXQDPLrc/iEMo5Imz++5kSecu/Q4=
X-Google-Smtp-Source: ABdhPJzfiMmMi8049ryLbdTumFiEB2azt22RyodOw27TSrh1paFQRoNHRdA9rucfDC/0WVdKgBLZtWA8bqBV8pDTstE=
X-Received: by 2002:a81:2143:0:b0:2fb:1274:247e with SMTP id
 h64-20020a812143000000b002fb1274247emr5212506ywh.384.1651732203173; Wed, 04
 May 2022 23:30:03 -0700 (PDT)
MIME-Version: 1.0
From:   Gonsolo <gonsolo@gmail.com>
Date:   Thu, 5 May 2022 08:29:52 +0200
Message-ID: <CANL0fFQRBZiVcEM0OOxkLqiAKf=rFssGetrwN6vWj5SsxX__mA@mail.gmail.com>
Subject: Suspend/resume error with AWUS036ACM
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
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

Hi all.

After a resume I get the following error:

 +0,000007] UBSAN: invalid-load in
/build/linux-lowlatency-fSdu7c/linux-lowlatency-5.15.0/net/mac80211/status.c:1164:21
[  +0,000004] load of value 255 is not a valid value for type '_Bool'
[  +0,000004] CPU: 22 PID: 387 Comm: kworker/u256:5 Tainted: P
  OE     5.15.0-27-lowlatency #28-Ubuntu
[  +0,000004] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./X399 Phantom Gaming 6, BIOS P1.31 01/14/2021
[  +0,000003] Workqueue: phy0 mt76x02_mac_work [mt76x02_lib]
[  +0,000014] Call Trace:
[  +0,000003]  <TASK>
[  +0,000003]  show_stack+0x52/0x58
[  +0,000006]  dump_stack_lvl+0x4a/0x5f
[  +0,000007]  dump_stack+0x10/0x12
[  +0,000003]  ubsan_epilogue+0x9/0x45
[  +0,000002]  __ubsan_handle_load_invalid_value.cold+0x44/0x49
[  +0,000004]  ieee80211_tx_status_ext.cold+0x4e/0x5f [mac80211]
[  +0,000068]  mt76_tx_status_unlock+0x111/0x160 [mt76]
[  +0,000010]  mt76_tx_status_check+0x68/0x90 [mt76]
[  +0,000009]  mt76x02_mac_work+0x14b/0x240 [mt76x02_lib]
[  +0,000008]  process_one_work+0x222/0x3f0
[  +0,000006]  worker_thread+0x50/0x3f0
[  +0,000004]  ? process_one_work+0x3f0/0x3f0
[  +0,000004]  kthread+0x13b/0x160
[  +0,000003]  ? set_kthread_struct+0x50/0x50
[  +0,000004]  ret_from_fork+0x22/0x30
[  +0,000006]  </TASK>
[  +0,000001] ================================================================================

This is a stock Ubuntu Jammy lowlatency kernel (with Nvidia drivers).

I would be happy to provide all the needed information to resolve this.

I also want to note that the device is running quite unstable (lots of
deauthenticating, network lost, etc...).

Regards,
g

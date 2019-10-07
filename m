Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E834CEC86
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfJGTN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:13:57 -0400
Received: from mx5.ucr.edu ([138.23.62.67]:12874 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbfJGTN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 15:13:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570475636; x=1602011636;
  h=mime-version:from:date:message-id:subject:to;
  bh=dallgVAkyTK9hhgH9V6Aj3NUK6xmHY7JKRhH0QVlX3E=;
  b=aYvISMBIjVcAFDeNtCrBLzt3BIVgJX4neGnksVDZNgGUmsZA8BbwUWEm
   ioTOMFFVZz6LnhE1Gj/7TXqX5G0/YWMxR945uMTnjfwCkTi6azLOMdO6U
   6FHeJaamU38JY2UgBsWi75Zvrilrr0Zag6YS4tmtz1mZbAkyI+uTFJV3A
   zHF/Zy3/rX+I+tFxfat7qPW6r5eKK0uMpnMXd57LWm5FDP4NkWnS1FikC
   90goRmYiMARhpWHCUZG3akPUXQQ8abnneGO5xQfgT/5j8wgvmGsbBdRo/
   yHa4l3V09RPxRP9gX4kl/RTdVcwBk3jeAlkHP0XukRUEINwYdpitqkZce
   g==;
IronPort-SDR: KYfBi/h42sNAVwlXZqd2bU0Tm/tdH1OKNEJehfd27hZeWqjOpzmrH+uYD0T1VfhsfoeLBDiO3S
 TiAaDXfSbx6lFImRSd6xPMRZxFRokOfpCGL0FfnjMQyHb+mtaLPwQbdX2kuNWHZNPEWQkpU2pg
 oIVzboiECBSqR9IrxbX5EDhhKnfCpTrznnHmfMhuAbOi3bIgEfghnB8KljSyjA+VS5bvg9g81l
 +sGAX0Hv87VF3CPzuwwkKcer2mRBnenxcmQQHxvLgnhf2V/Q3fq662uxEkhFS4ndTAi2DGHgBP
 LwQ=
IronPort-PHdr: =?us-ascii?q?9a23=3Az614yBfKo6lg6paWLfNxQPnGlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc27YxKN2/xhgRfzUJnB7Loc0qyK6vumBDNLuMzY+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAi4oAnLtsQbg4RuJrsvxh?=
 =?us-ascii?q?fUv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/XrJgcJskq1UvBOhpwR+w4HKZoGVKOF+db7Zcd8DWG?=
 =?us-ascii?q?ZNQtpdWylHD4ihbYUAEvABMP5XoIf9qVUArgawCxewC+701j9EmmX70bEm3+?=
 =?us-ascii?q?g9EwzL2hErEdIUsHTTqdX4LKUdUeG0zanI0DXDaO5d1jT96IfScxAqvPaBXL?=
 =?us-ascii?q?JxcMrR00YvFh/JgkmepIH+IjOayv4Nv3KF4OV9SOKikmgqoBxyrDi33soglJ?=
 =?us-ascii?q?XFi4YPxl3H9Sh12ps5KNy6RUJhY9OoDJ1dvDyAOYRsWMMtWWRotT4/yr0BpJ?=
 =?us-ascii?q?G0YjAHyI8ixx7Dc/yHdJWI4g77WOaRPzh4gHVldaq6hxmo8EigzvTwVs260F?=
 =?us-ascii?q?pXtyZFnNvBumwX2xzc7ciHTfR9/kO/1jqVyw/T7eRELVg1lardNZEh3qY9mo?=
 =?us-ascii?q?QPvUnHBCP7m0X7gLWLekgl+OWk8ebqbqn+qp+ZLYB0iwX+Mqo0msy4BOQ1Kg?=
 =?us-ascii?q?gPXmmb+eum1b3v4VH1TbtRg/0rjqbZqorWKtoGqa6kGwNVyJos6w6jDze619?=
 =?us-ascii?q?QVhX8HI0xZeB2akYfpJUrDIO73DfihmVSgijRryO7cPr3nHJrNKmLPkLD7fb?=
 =?us-ascii?q?ZyuAZgz18RytBW4ZRZEfkrLej8Ehvzs9zRCBk0KEq+zvzoINR7yo4aH2mIB/?=
 =?us-ascii?q?ndeI7XtFaO++8ra8aWeYofsT39Y6wo4vvni2I0nRkSZ7Ss15IcaFi5GOhrJw?=
 =?us-ascii?q?OSZn+6xp8lDGwD9iE5QejqjxXWVSNYZn+0WOQ34Tw/CIWODIHfS4Tri7uEim?=
 =?us-ascii?q?PzP5tKa2QOLlGKDGegSISeVvMBcznadstglCEUSrmvSqcg0w2jsEnxzL8xaq?=
 =?us-ascii?q?L38ykcuNrd3dxyr7nQixg28hR/CMiQ2nyXSHt92GQSSGlylIB2oEk15k2OwK?=
 =?us-ascii?q?ZlmOcQQdxa5vYPXh03JJDB1PdSCtbuVwaHddCMHhLua8unDjgwSpoe2d4IeF?=
 =?us-ascii?q?pwGtPq2hnd3iWjArtTmKaKAoco/6Pa93n3O8t5jX3B0f9lx10nRNZfcHKnnK?=
 =?us-ascii?q?N7+hPIL5DGnl/flKuwc6kYminX+yPLy2eSsExGeBB/XL+DXn0FYEbS69Pj6Q?=
 =?us-ascii?q?eKS76oFKRiMQZbz8OGArVFZ8evjlhcQvrnftPEbCb5qWexFAuOjoqNZYyiL3?=
 =?us-ascii?q?cd3TTADlEsmBtV4H2ccwUyG3Hl60neATphBE+nWETq/qEqo2i8SEAcxBrMck?=
 =?us-ascii?q?Z7kbe550hGq+abTqYi36AEpSBpmTV9HR7pzsDWAtvY/1FJYa5GJ94x/QEUhi?=
 =?us-ascii?q?riqwVhM8n4fOhZjVkEflEy5hu22g=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FmAgANjptdh0anVdFmDhABBhKFd4R?=
 =?us-ascii?q?NjmCBbQWDJQGMUIEYijQBCAEBAQ4vAQGHHyM4EwIDCQEBBQEBAQEBBQQBAQI?=
 =?us-ascii?q?QAQEBCA0JCCmFQII6KQGDVRF8DwImAiQSAQUBIgEaGoMAggsFom2BAzyLJoE?=
 =?us-ascii?q?yhAsBAYRWAQkNgUgSeiiMDoIXgRGCZIUUgymCWASBOAEBAZUsllQBBgKCEBS?=
 =?us-ascii?q?MVIhEG4IqAZcUjiyZSw8jgUaBezMaJX8GZ4FPTxAUgWmNcQQBViSSHAEB?=
X-IPAS-Result: =?us-ascii?q?A2FmAgANjptdh0anVdFmDhABBhKFd4RNjmCBbQWDJQGMU?=
 =?us-ascii?q?IEYijQBCAEBAQ4vAQGHHyM4EwIDCQEBBQEBAQEBBQQBAQIQAQEBCA0JCCmFQ?=
 =?us-ascii?q?II6KQGDVRF8DwImAiQSAQUBIgEaGoMAggsFom2BAzyLJoEyhAsBAYRWAQkNg?=
 =?us-ascii?q?UgSeiiMDoIXgRGCZIUUgymCWASBOAEBAZUsllQBBgKCEBSMVIhEG4IqAZcUj?=
 =?us-ascii?q?iyZSw8jgUaBezMaJX8GZ4FPTxAUgWmNcQQBViSSHAEB?=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="81196793"
Received: from mail-lf1-f70.google.com ([209.85.167.70])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2019 12:13:56 -0700
Received: by mail-lf1-f70.google.com with SMTP id c83so1666194lfg.8
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 12:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PJAtcYhKUx1R52oEkTsXsXK1JI9Wj7XIccCM13DifW8=;
        b=s2CyXeomFOYfc+wKpt1m+aK4J9Jo5LYqnm+WWgxNeoSVPYsIqgxCbmNGzaE1Guh0Qe
         IwkcFkTeTAP/OYNhUs1vt8tCDjwP48Q/knaZWk50LPar93GDBK6YxrA0CWAapoG8DKaH
         adjbsPmKyaX7J8bAqjR6/qwl6b/Wc4CRnlXRIQClkW1kp3yT/H1EvYNZop6a3QGprcY4
         783L2DFq+WXcAln7GOdXn5kugMkb4BQdS23Q+XY1N3+JLLPy5txxvtFfMTQ1o6rKj+LM
         LQQdh4436wVIfkGAOO3Q8K/5ujtcEQeYYRK1tSHYYxGVV61gfsX3i/Y2Z0bMAbehEpHL
         09ag==
X-Gm-Message-State: APjAAAXbUBV6J8ZGG9SSVpflvk6rAsld+oCl2vv+o5BI9WT1UzDVoevX
        sQbfcbYVr7Ej22YhJHx3hZNFs82fONN0Sa6aCiYfmOdkpADfWnDtUUktptElSziqvSDB+zbVsjb
        RO2udj8EaX5njR2R4uoUqgajPGVk7ZkVouw==
X-Received: by 2002:a2e:a41b:: with SMTP id p27mr19601409ljn.104.1570475634275;
        Mon, 07 Oct 2019 12:13:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqybsfi5mH8tF9NrZD7sU22hacx7Zua94Z8/UMHxu/hlrhN5z+2JdKI5u1YfWM3R1sWLFJpjLuPHGGU6Fb/5yKU=
X-Received: by 2002:a2e:a41b:: with SMTP id p27mr19601397ljn.104.1570475634102;
 Mon, 07 Oct 2019 12:13:54 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Mon, 7 Oct 2019 12:14:37 -0700
Message-ID: <CABvMjLRtWPgMKR8t758DZ1AhynWC4LxG8bTVxiNGF4OJgtNsbg@mail.gmail.com>
Subject: Potential NULL pointer deference in iwlwifi
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Avigail Grinstein <avigail.grinstein@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:

drivers/net/wireless/intel/iwlwifi/mvm/power.c:

Inside function iwl_mvm_power_ps_disabled_iterator(),
iwl_mvm_vif_from_mac80211()
could return NULL,however, the return value of
iwl_mvm_vif_from_mac80211() is not
checked and get
used. This could potentially be unsafe.

-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A6AD1FDF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 07:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfJJFDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 01:03:12 -0400
Received: from mx1.ucr.edu ([138.23.248.2]:27467 "EHLO mx1.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfJJFDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 01:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570683792; x=1602219792;
  h=mime-version:from:date:message-id:subject:to;
  bh=JCsL3WIN73xzwLhXOrKo3QlppAA/heL7UqOSuoxaqtM=;
  b=rgyhBV/j+0LXoi29HyoqLKuYQRxNFx/MAs0ec1H4Y/fw4QWoZLNqfSmH
   etbQZr/7ikH0OlCo+0AiuJYa+iDf55BmyjZlMFYD7b9VNpdBEx7CzWCyc
   pKfMLw1pGTheqgBnW50HwcVgHyJbIQWfDX/vofNmY831CHGe+g03jldmc
   O+TuqTKkZRnO6GJaiPSSvVVIuTB8GYeQhCnBfrSWxOTv1IxbC01q9/Ttj
   Gmd1BlIhqFXfYQrBKk5LmmYjBCi4t4gqXtnGbRSi7pLuAzTdpmiWIOb+s
   pCi0hvHCjPCjv+Eibt80++RXwm4BJWRyFKWe9qS32GeY95SQopPfHzNWh
   A==;
IronPort-SDR: +c669c4Bcj6TFJBi76KvrAKA+YsuGeoM/LLF6+D6byPVZQ3omtbjO8Ormg3Rv2bIcKw7/btVQJ
 cEv1FVr3r0a+nmYNaxSt9SdglppbjtkTA8+zwwgGqBeuAue9l0DOec/eB2ASZbWqowEw3PvePY
 p6yya5sBkeUjjwgzUXW+nelVmjZ+ZRM4wc0kvzr/a32vl3cQSxg2FaC6rGtKQe+pn+CqjQh4oh
 b2G0Ke/S6Ty5m48hYp1qd9wcPQ5iUNUuIW9ARPM37Gbl2GWC60mFFxRskaeQag3xt+X3WixbV4
 2tU=
IronPort-PHdr: =?us-ascii?q?9a23=3A++nU5BVXzTjEbX2ofWoyfka3sL/V8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZRWDuqdThVPEFb/W9+hDw7KP9fy5Aipeu93Q6TgrS99lb1?=
 =?us-ascii?q?c9k8IYnggtUoauKHbQC7rUVRE8B9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUh?=
 =?us-ascii?q?rwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9IRmrowjdrMgbjZVtJqs11x?=
 =?us-ascii?q?fCv2dFdflRyW50P1yYggzy5t23/J5t8iRQv+wu+stdWqjkfKo2UKJVAi0+P2?=
 =?us-ascii?q?86+MPkux/DTRCS5nQHSWUZjgBIAwne4x7kWJr6rzb3ufB82CmeOs32UKw0VD?=
 =?us-ascii?q?G/5KplVBPklCEKPCMi/WrJlsJ/kr5UoBO5pxx+3YHUZp2VNOFjda/ZZN8WWH?=
 =?us-ascii?q?ZNUtpUWyFHH4iybZYAD/AZMOlXr4fzqVgAowagCwawH+7v1iNEi2Xq0aEmz+?=
 =?us-ascii?q?gsEwfL1xEgEdIUt3TUqc34O6UTUeG0zKnI0DLDZO5V1jf98ofIcw0qrPaMXL?=
 =?us-ascii?q?Nxccre00gvGx/ZgliesoHlIi+a1v4Xv2eF8uVgSPuihmg6oA9yujii3tkghp?=
 =?us-ascii?q?XNi44PyV3J9T91zJs0KNC6UkJ2Y8KoHZ1NvC+ALYR2WNktQ2RwtSY/zb0JpI?=
 =?us-ascii?q?C0cTARyJQi2x7fc/uHc5WU4h77VOaePzN4hHV9dbK6nRmy8EygxvT4Vsm6zV?=
 =?us-ascii?q?pGtyRFn9vQunwX2BzT7c+HSvR5/ki/wzqAywfT6uRcLUA1k6rUNYIhz6Yump?=
 =?us-ascii?q?YPtUnPBCz7lUXsgKOLd0gp+PKk5ub7brn+o5+TLY50igXwMqQ0ncy/BPw1Mw?=
 =?us-ascii?q?gPXmib4+u81aHv8VH3TbhRk/05jrPZvIrEKssGu661GxVV3Zo76xajEzem18?=
 =?us-ascii?q?wVnX8ZI1JZZR2IkZbpNkrQIPD3E/i/mU6gkDR1yPDcOL3uHJHNImLEkLf7cr?=
 =?us-ascii?q?Yuo3JbnSg0zdlZ4Z9PQpsMOv27Dk32tNXeCBIidQa52enPCdNh24dYUmWKVO?=
 =?us-ascii?q?vRHabXuFmV6+ZnDPORYYUcsza1f/Ug4vfokHI931AHYKyj1JAXQHG+AvliZU?=
 =?us-ascii?q?6eZCyoyvMcGm5ClQ0zSOztwAmGTDVSbnC1Gak76zU7D6qnC5vOQsamh7nXmG?=
 =?us-ascii?q?+aGIFbYihiC1aRAT/Xdp+JX/oXc2rGJs5njywbVLagY44nyRyq8gT9zuwjZs?=
 =?us-ascii?q?nd/ikV/azq0N89s+7NnBU13TdzA8mUznuKVWgymXkHEXt+lox2v01xgmzFmY?=
 =?us-ascii?q?15h/hVD5Ybs/9ATAo/HZLV0eF/D9f8RkTHc8vfDB6PXNSpCDA1Bv0rwtkVf0?=
 =?us-ascii?q?t8HZ32hw7C0COrB/kajb2NH4A586T03n7tKsI7wHHDgu1pr1AnR4NjL2C3iL?=
 =?us-ascii?q?Nk7ECHB4fIlgOVjau7e7kHxwbM8nuOySyFu0QOFEZ0UKPYTTUAZ1Hbqdni/W?=
 =?us-ascii?q?vcQLK0T7cqKA1MzYiFMKQOItvkkVlLWt/9N9nEJWG8gWG9AVCP3LzIJI7rfX?=
 =?us-ascii?q?gNmSbQEk4JlygN8nuccwszHCGspyTZFjM9O0joZhbd8Pt+tXTzfE89zknefl?=
 =?us-ascii?q?9h3rvtokU9mPeGDf4fw+RX628atzxoEQPljJrtAN2aql8kJf0EbA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2E1AwB/up5dgEanVdFlhlKETY5bhRc?=
 =?us-ascii?q?BmB0BCAEBAQ4vAQGHGCM4EwIDCQEBBQEBAQEBBQQBAQIQAQEJDQkIJ4VCgjo?=
 =?us-ascii?q?pAYNVEXwPAiYCJBIBBQEiATSFeKRCgQM8iyaBMoQMAYRYAQkNgUgSeiiMDoI?=
 =?us-ascii?q?XgRGDUIQogyqCXgSBOQEBAZUvllcBBgKCEBSMVIhFG4IqlxaOLZlPDyOBRoF?=
 =?us-ascii?q?7MxolfwZngU9PEBSPXgFWJJFLAQE?=
X-IPAS-Result: =?us-ascii?q?A2E1AwB/up5dgEanVdFlhlKETY5bhRcBmB0BCAEBAQ4vA?=
 =?us-ascii?q?QGHGCM4EwIDCQEBBQEBAQEBBQQBAQIQAQEJDQkIJ4VCgjopAYNVEXwPAiYCJ?=
 =?us-ascii?q?BIBBQEiATSFeKRCgQM8iyaBMoQMAYRYAQkNgUgSeiiMDoIXgRGDUIQogyqCX?=
 =?us-ascii?q?gSBOQEBAZUvllcBBgKCEBSMVIhFG4IqlxaOLZlPDyOBRoF7MxolfwZngU9PE?=
 =?us-ascii?q?BSPXgFWJJFLAQE?=
X-IronPort-AV: E=Sophos;i="5.67,278,1566889200"; 
   d="scan'208";a="13445193"
Received: from mail-lf1-f70.google.com ([209.85.167.70])
  by smtp1.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Oct 2019 22:03:11 -0700
Received: by mail-lf1-f70.google.com with SMTP id r3so1057085lfn.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 22:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6pAAPXZ1XbspBXsT/nVNYN754RlatzoTXF5DnMyqcQU=;
        b=Jt7SkL/RlSKOjm0sjlNEYADbvYi6j1geqAIcyww2O4jC1ZbPafIZvakrrrH3bPYgdR
         Rkni24NefwYCQl1uE6g8U0W9V8xSLA3jkr0NBvyzcFXLHlXU2gks+7uphoMqv1ATRLRW
         dWYrgqImPi0LYrGeW7yHoTTW2T2lyWCiPUTMTm/HlQBLLZBxnea9+et7+CNcoQquhnNL
         H3DCkrlMmhdkuWU3hXPzILK6czsjHfQG3T5DSMTrzwgmQedAN1e3OcCviHQc5KCcpNw0
         rhZAJXnCdAfWvAIdHC5fti6wgwJhjsmij6HKvMPTjN7/6tCAgd1KkX+CKta9bBPFrBO7
         xk6A==
X-Gm-Message-State: APjAAAUMIBbRCYHG5qdNQBMJz5Wrzf+QbMsJii2H6nPpLc6eI2YwLNVp
        w/vIv3vJnMpn49bQ2uSmYuSVhp1QXI0zdzZCqNWBUuV8Y/AuAPR3aQRI0oysi6iLsfinkvXY3oK
        2xYhKmiDcPIkbeiju50hci1CX+dhZGYYUDw==
X-Received: by 2002:a2e:9a4e:: with SMTP id k14mr4816404ljj.104.1570683789446;
        Wed, 09 Oct 2019 22:03:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyLbyF0nKrTc3N1NhrBYGj51/xn4jBAjuUiVfEPkbcB6vQTEAA65Ud8oPAk9dQ6WUgeoAyg9+sMf/8vTtEysGQ=
X-Received: by 2002:a2e:9a4e:: with SMTP id k14mr4816390ljj.104.1570683789247;
 Wed, 09 Oct 2019 22:03:09 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Wed, 9 Oct 2019 22:02:43 -0700
Message-ID: <CABvMjLThWpQYir0soRDE3W4S6q0S28RTxen8Y-2YAxbRczMCiA@mail.gmail.com>
Subject: Potential NULL pointer deference in iwlwifi: mvm
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Avigail Grinstein <avigail.grinstein@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:

drivers/net/wireless/intel/iwlwifi/mvm/power.c:

The function iwl_mvm_vif_from_mac80211() could return NULL,
but some callers in this file does not check the return value while
directly dereference it, which seems potentially unsafe.
Such callers include iwl_mvm_update_d0i3_power_mode(),
iwl_mvm_power_configure_uapsd(),
iwl_mvm_power_allow_uapsd(), etc.



-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside

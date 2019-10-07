Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F8CEE2C
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfJGVHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:07:35 -0400
Received: from mx2.ucr.edu ([138.23.62.3]:27834 "EHLO mx2.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbfJGVHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 17:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570482453; x=1602018453;
  h=mime-version:from:date:message-id:subject:to;
  bh=bY+sRheD73coXZxadpgSFqLWLuQ/U6qbrle3fNbHs8Y=;
  b=hL6SdCaRt98dBGIHkzuIPQCPrPUvr9Y4zj7WVcvv+kvMnMrlJ1Q8sCTo
   V7S9XmcFPR5SgkJlqAtSMxGwwGtf5wz+9a1haUGTY2ZmrBgUuXVBDXoq8
   UHUqIX5MRnUko30e/dmbamWicNvM4w1SDmSZQWhPIWkOB/DihZIXlK48K
   N2/cNOKyNouso9QndJaap0OlU5sNT4v07SBlrz4Alwk+2nJ37EHnBpxbM
   BB71jsxVyjkgYMHpF1f7XcnYFhOAfle6arYY4eEhNzF09O1kVCsmP4nBp
   CK+IAN4n3/FImCd03kLD1Mhfb3ZjlNOed8CvsGgTF+d1fWYebpeTwKkin
   A==;
IronPort-SDR: 5SP/ilQClqNAripOfr3DrGfvXp66FWLlw7uIMiTHaVTCPa17MZRp24OogZJuORCU11XISZwDRV
 IaQI6wkIq0TjraP35fxW7onxWZD/VJ0aweKovYos86FSkagUVXeV+lQQW40n3j7ZuDImRg93SL
 hFeNRzbSO9dJRFoCye/pFEI/81wlkO05c1Yl3o27sSWRR6m/QOA9TYx08MhulfZSUVB93Xc0FB
 1y2dHkraEoTnazzpRpSS1H0kKgthmFB15wtQ2eyP4YB7KcPeBFLZeCffAJnp/kzBZx/37fBzoY
 hpA=
IronPort-PHdr: =?us-ascii?q?9a23=3AYZa1TB9G/854Jf9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B21uscTK2v8tzYMVDF4r011RmVBN6dtq0P0raP+4nbGkU4qa6bt34DdJEeHz?=
 =?us-ascii?q?Qksu4x2zIaPcieFEfgJ+TrZSFpVO5LVVti4m3peRMNQJW2aFLduGC94iAPER?=
 =?us-ascii?q?vjKwV1Ov71GonPhMiryuy+4ZLebxhGiTanYb5/Lhq6oRjeu8ULnIBvNrs/xh?=
 =?us-ascii?q?zVr3VSZu9Y33loJVWdnxb94se/4ptu+DlOtvwi6sBNT7z0c7w3QrJEAjsmNX?=
 =?us-ascii?q?s15NDwuhnYUQSP/HocXX4InRdOHgPI8Qv1Xpb1siv9q+p9xCyXNtD4QLwoRT?=
 =?us-ascii?q?iv6bpgRQT2gykbKTE27GDXitRxjK1FphKhuwd/yJPQbI2MKfZyYr/RcdYcSG?=
 =?us-ascii?q?FcXMheSjZBD5uzYIUPAeQPPvtWoZfhqFYVsRuyGROhCP/zxjNUhHL727Ax3e?=
 =?us-ascii?q?Q7EQHB2QwtB9ABsHXVrdX1KacSVv2+w6rIzTrZbvNdxDDw6YjJcxAhu/6MXK?=
 =?us-ascii?q?58fdbfxEQ0CgPKkk+QpZb7MDyIy+QAqm6W5PdjW+K3k2MrtR19rzy1ysovio?=
 =?us-ascii?q?TFnJ8Zx1HG+CljwYs4Idu1Q1Nhb9G+CptfrSSaOpNzQsMlXm5npj43yqYDuZ?=
 =?us-ascii?q?6nZCgKz4knxwLHZ/yHbYeI5hXjWf6UIThihXJlfKuzhxK88US90+H8WMi53V?=
 =?us-ascii?q?JQoipKldnMsX8N1xjN5cSdVvR9+UKh1S6O1wDV9O5EPVg5mbTHJ5Ml2LI9lZ?=
 =?us-ascii?q?oevV7eEiL3mkj6lq6be0E89uit8evnY7HmppGGN49zjwHzKqQvm82/AesiMw?=
 =?us-ascii?q?gCQ3SX9Oqn2b3+4UL5Wq9GgeMrnanEqJzaP9gUpralAw9J1YYu8xC/ACm60N?=
 =?us-ascii?q?sFg3YHMklIeAyIj4f3IVHCOvP4Aumlg1Sqjjhrw+rKPrr7ApXCfTD/l+LDdL?=
 =?us-ascii?q?N07wZ8wQYyhetW45NRQuUDIOnbX0jzvcDREgJ/OAuxlaKvI9J72cshUGSASv?=
 =?us-ascii?q?uJMbLVrBmX7+QgKO6Ka6cavT/8L74u4Pu4yTcbmEUcNZGox5gQICS6H+5nC1?=
 =?us-ascii?q?+UenzxhtMAV3oR6E52SuH2hFCceSBcamz0XK8m4Dw/ToW8AsOLQoGrnazE3y?=
 =?us-ascii?q?qhGJBSTn5JB0rKEnrycYiAHfAWZ2baEM9ggyECHYGgQolpgQOutR7nzaNPJf?=
 =?us-ascii?q?GS5yYC85/vyY4xr8bTmBc95CE8NMOb3CnZRHpzmGwgTCRwwatl50Fx1wHQ/7?=
 =?us-ascii?q?J/hqlpFM5T+vQBYAczNNaI3v56AtGqAlnpY9yTDluqX4P1UnkKUtstzopWMA?=
 =?us-ascii?q?5GENK4g0WGhnLyDg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HFAgBUqJtdh0WnVdFmDoIQhBCETY5?=
 =?us-ascii?q?hhRcBhneFWYEYijQBCAEBAQ4vAQGHHyM3Bg4CAwkBAQUBAQEBAQUEAQECEAE?=
 =?us-ascii?q?BAQgNCQgphUCCOikBg1URfA8CJgIkEgEFASIBNIMAgguiSYEDPIsmgTKEDAG?=
 =?us-ascii?q?EVQEJDYFIEnoojA6CF4ERg1CHUYJYBIE4AQEBlSyWVAEGAoIQFIxUiEQbgio?=
 =?us-ascii?q?BlxSOLJlLDyOBRYF8MxolfwZngU9PEBSBaY1xBAFWJJIcAQE?=
X-IPAS-Result: =?us-ascii?q?A2HFAgBUqJtdh0WnVdFmDoIQhBCETY5hhRcBhneFWYEYi?=
 =?us-ascii?q?jQBCAEBAQ4vAQGHHyM3Bg4CAwkBAQUBAQEBAQUEAQECEAEBAQgNCQgphUCCO?=
 =?us-ascii?q?ikBg1URfA8CJgIkEgEFASIBNIMAgguiSYEDPIsmgTKEDAGEVQEJDYFIEnooj?=
 =?us-ascii?q?A6CF4ERg1CHUYJYBIE4AQEBlSyWVAEGAoIQFIxUiEQbgioBlxSOLJlLDyOBR?=
 =?us-ascii?q?YF8MxolfwZngU9PEBSBaY1xBAFWJJIcAQE?=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="13392708"
Received: from mail-lf1-f69.google.com ([209.85.167.69])
  by smtp2.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2019 14:07:33 -0700
Received: by mail-lf1-f69.google.com with SMTP id c13so1700975lfk.23
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 14:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QpIogHTFQ3PNntbyxY8PuVYh6DjinLK9PCtFfqPpljY=;
        b=navvVysRcUFaVAGqgdpj0IN/r9mTNFr35+0IZvEY9YcA82ijICWIUSDcpiEtbLjHQC
         NfKi8W3gNnxc7UzCWRkVCD928/YO/emMf5TONySYCW7WwANzftlTWBMrdDhwgVbLxh4M
         bq5SOePT34YftvglF3IRMjNixxRZPP8+yP9GEdSG0q3Ah3xtsfittGjOys7uNgkp9Ore
         fwTmSPpvv29179xYEBrc80YX9mp4WZx4CpLBRkvBwIQrtRvEpcZ78xDQvshFYpv5K7Y3
         pBMRqxnjNVfdMWCRajbQQLW5WylBMHHYNVWO8iRGWckpTRvNnv6WKv5G8EgW7eNO+1A7
         pFxw==
X-Gm-Message-State: APjAAAWrMVXBnLSkiuVTZAFDDBnA2qI88kaIeUlapgpCpM49VOlXMgjc
        wuBO38kl3kEyctidE8EIRoJYgoBIFBI2dKy0Dd0AgxPmijjmzYiL5BGPMUeyisBhDTHyHNbpD80
        /8b3oIsDGPkKA8nVHzH22Nj44T0soe0TaSw==
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr19683311ljk.92.1570482451462;
        Mon, 07 Oct 2019 14:07:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxsaH0jQUXUcxBHYc6wDRLiz7uWnqfB2f4Igx5phAG/R7tvZNQRLqqwJ8r8TZxhh4PC22EU4Ifczy46vVpcjnc=
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr19683288ljk.92.1570482451154;
 Mon, 07 Oct 2019 14:07:31 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Mon, 7 Oct 2019 14:08:14 -0700
Message-ID: <CABvMjLRuGnatUxBEMKpXWGNJnAjNMiCXQ7Ce88ejuuJJnENR+g@mail.gmail.com>
Subject: Potential NULL pointer deference in net: sched
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:

net/sched/sch_mq.c:
Inside function mq_dump_class(), mq_queue_get() could return NULL,
however, the return value of dev_queue is not checked  and get used.
This could potentially be unsafe.


-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1C1CB386
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 05:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387564AbfJDDf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 23:35:57 -0400
Received: from mx1.ucr.edu ([138.23.248.2]:61884 "EHLO mx1.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387504AbfJDDfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 23:35:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570160154; x=1601696154;
  h=mime-version:from:date:message-id:subject:to;
  bh=Z8VeGOGEm9LC9RfPoH1+Khc4hCaxDK2hry4bcLjvcEk=;
  b=AVQpkX/T6lVb4uC5CxPDpQVvRNeFI+dyzqqvvED1EzimwjXH1Sz49ugn
   2nreAzzVdCZR2HJ8rcEgsiSr4bRoWTydEM0nHiqpoOx8JQAy4elHvtZoY
   B+x/+oHLdTmPIcy5bBQCNOYiP9+WbIjhW/SQDhKnGDXkMEWEQb2UYOLVs
   +LVzVCLQlGMMeoFa1yJQeVyUcGHamYkCVFSkmqLSV2NhPZEx+wbiu8rrL
   vWe3FmrICFr6P9yMLyJMX8knx2qp7yOD9c9m1eE4YLyZMec30luPfbdmU
   /Ou/i9+oKaX4MG8Mv7rN54A9DNg85WyxX2x8J93+dMj96c8mfdzLQgwKj
   Q==;
IronPort-SDR: rSvKhK1eEgEKIbVZX8ZB07zdtc/fum/YCJw6WhTAViKm0DrH3MhkhZfLFy+L7xbthATkvVtX8j
 LtXUiyMj+twUlfImdNeZwMv2ObcBGg2kPEDwZHBb9DFDPe3+BIADOWcxd6bFxPAKztbPOZsB5L
 NTThhdfYtX7YR9rzMHBzCBkcQ72TdYpNisccvQbZvnY/CGDS3BfBq3OcIr3CW6tHbRFH9PKdXN
 Fk6nZk99qOBCEdvkVYcp5i6BG9U2HgCN9DJC0P5FXypBchwZn553UIPzL0bQad/wO+OOD36xGw
 f2U=
IronPort-PHdr: =?us-ascii?q?9a23=3AyEXtrRR/dAIh7sqUrA6I0lBWC9psv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa6zYhWN2/xhgRfzUJnB7Loc0qyK6vumBDRLucvJmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MRu7oR/Ru8UKjoduNqY8wQ?=
 =?us-ascii?q?bVr3VVfOhb2XlmLk+JkRbm4cew8p9j8yBOtP8k6sVNT6b0cbkmQLJBFDgpPH?=
 =?us-ascii?q?w768PttRnYUAuA/WAcXXkMkhpJGAfK8hf3VYrsvyTgt+p93C6aPdDqTb0xRD?=
 =?us-ascii?q?+v4btnRAPuhSwaLDMy7n3ZhdJsg6JauBKhpgJww4jIYIGOKfFyerrRcc4GSW?=
 =?us-ascii?q?ZdW8pcUTFKDIGhYIsVF+cOMuZWoYf+qVUTsxWxGRKhBP/zxjJSmnP6wbE23u?=
 =?us-ascii?q?YnHArb3AIgBdUOsHHModr3NacTUOC1zLTPzT7ebPxW2S3y6InVeR0mofCNXL?=
 =?us-ascii?q?JwftDQyUUzCw/IgE6dqZH5MDOPzOgCrXWU7/d5WO+plmUpqBlxryCxysswjo?=
 =?us-ascii?q?TFnIEYx1De+SlkwYs4J8e0RUxnbdOiDZBerTuVN5FsTcMnW2xovSE6xaAYtp?=
 =?us-ascii?q?OjZygKzYgnxwbYa/yab4iE+hLjW/iVITd/nH9lfaiwhxe28US5zu38WNS43E?=
 =?us-ascii?q?9EridHjtXArH8N1xvU6siITvty4F2t1iqI1wDW8u1EIEY0mrTHK5M53LI8ip?=
 =?us-ascii?q?4evV7AEyL2gkn6ka6be0c+9uWq9+jrerDmqYWdN49whAH+KKMumsmnDOU4Mw?=
 =?us-ascii?q?kOX3KU+eWg2LH/80D0W6hKgeEskqXDrp/VONkbqrajAwBJyoYj9wq/DzC+3d?=
 =?us-ascii?q?Qeg3YHME9KdwyZj4XyJVHOL+73De2lj1Svjjhr3fbGMaPlApnXKXjDirjhLv?=
 =?us-ascii?q?5B7BttyRE+y5ht549dDL5JdOPyQUL38s7YExY/PCS03u/4BdQ73YQbDybHOa?=
 =?us-ascii?q?adMaealFKI+utnd/KFYI4R/jPwK+Qsz/7zhGA0mBkWeqz/mdNdRHmmH/guGA?=
 =?us-ascii?q?PRRHvohtobWy9esgMgQenChFScXDtXYHiuGaQx+md/QISrEYvOWKizj7Gbmi?=
 =?us-ascii?q?S2BJtbYiZBEF/IWXPpcZiUHvQBciSfJud/nTEeE7usUYks0VeprgC+g4hnL/?=
 =?us-ascii?q?vJ/GUhtJvlnIxn5+zCiBcr3TdvSdmWySeAQ3wi2isjRzIw07Fi6Xd6zFjLha?=
 =?us-ascii?q?NjhPpXPddIoe5CSEE3OYOKnMJgDNWnawPTfsqOAGSmS9TuVSAjTtswm4dVS1?=
 =?us-ascii?q?t2AZOvgg2VjHniOKMci7HeXM98yanbxXWkYp8lk3s=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HfAgBSvZZdh0anVdFlDoVtM4RMjl+?=
 =?us-ascii?q?FFwGYGAEIAQEBDi8BAYcIIzgTAgMJAQEFAQEBAQEFBAEBAhABAQEIDQkIKYV?=
 =?us-ascii?q?AgjopAYNVEXwPAiYCJBIBBQEiATSDAIILoWWBAzyLJoEyhAwBhFkBCQ2BSBJ?=
 =?us-ascii?q?6KIwOgheDbnOHUYJYBIE3AQEBlSuWUgEGAoIRFAOMUYhEG4IqlxaOK5lKDyO?=
 =?us-ascii?q?BRoF7MxolfwZngU9PEBSBWw4JjWgEAVYkkXsBAQ?=
X-IPAS-Result: =?us-ascii?q?A2HfAgBSvZZdh0anVdFlDoVtM4RMjl+FFwGYGAEIAQEBD?=
 =?us-ascii?q?i8BAYcIIzgTAgMJAQEFAQEBAQEFBAEBAhABAQEIDQkIKYVAgjopAYNVEXwPA?=
 =?us-ascii?q?iYCJBIBBQEiATSDAIILoWWBAzyLJoEyhAwBhFkBCQ2BSBJ6KIwOgheDbnOHU?=
 =?us-ascii?q?YJYBIE3AQEBlSuWUgEGAoIRFAOMUYhEG4IqlxaOK5lKDyOBRoF7MxolfwZng?=
 =?us-ascii?q?U9PEBSBWw4JjWgEAVYkkXsBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,254,1566889200"; 
   d="scan'208";a="12052732"
Received: from mail-lf1-f70.google.com ([209.85.167.70])
  by smtp1.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Oct 2019 20:35:53 -0700
Received: by mail-lf1-f70.google.com with SMTP id c13so538673lfk.23
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 20:35:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NHPkNFk4ddcSKGzRQIl5S9NE3sI5owUIMgWAvgZYtmE=;
        b=Id8HIoihJr8GH2fvXLBBQRe7WXdtQw0tRrPd/+JywonzZoJOXXVa8fLvxeN7kYdyoy
         nBkMPowPwhYMmxfMOdcuLSh4ehSseICK9WESC9YKInchwDCYrELnLAmwpqjyz0BKs+L+
         FvQPL1eqb9rZ1YbPwn7Shxi9hukJxkGl3wuOe/KKjGaAay4t0IUFnO6BPkuHo9Gpuh3o
         I/Lru7sDIns1xF0CRpR+1sClylA9U9ITD1PPVNJYJDPR4ttRZK0jQJYhGr5buLA0ul+D
         yMk57ESiU2IKWaSolcdl+Fr1vuwtmclh9h1d7WqBCYuXv6S7cUuM+d/zDVvCFvs9aW3I
         KCYw==
X-Gm-Message-State: APjAAAV/nmqEJFabQRw21Bl0QID4X6zMPgCLeed8i0u/LYvmFRjDWonK
        bvwfofSGIhMwdvWFg1nLo1dkb7iK8p3CvcZ3jAEzniE5UvXwNZY+IS7pfE+LVfPLMmyzbiWJhLu
        g0S1GfKsyjsCkWE8UpAkz5dD+NhHfa3XqTw==
X-Received: by 2002:a2e:9753:: with SMTP id f19mr7976444ljj.197.1570160151922;
        Thu, 03 Oct 2019 20:35:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzavRFwyK4RgialwrG04QE2qj4cBa+T9m8wd7kE3DcN+LkDESOBcSAksIuOaOGx5op8dUGF43Cc7y62iJohxTk=
X-Received: by 2002:a2e:9753:: with SMTP id f19mr7976426ljj.197.1570160151696;
 Thu, 03 Oct 2019 20:35:51 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Thu, 3 Oct 2019 20:35:38 -0700
Message-ID: <CABvMjLTiwHQ7cpUCYXJFHfHk+syeE5uQe=3waUGhJSVc5Udb1g@mail.gmail.com>
Subject: Potential uninitialized variables in subsys net: hisilicon
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:

drivers/net/ethernet/hisilicon/hip04_eth.c:

In function hip04_reset_ppe(), variable "val" could be uninitialized
if regmap_read() returns -EINVAL. However, "val" is used to decide
the control flow, which is potentially unsafe.

Also, we cannot simply return -EINVAL in hip04_reset_ppe() because
the return type is void.

Thanks for your time to check this case.

-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
